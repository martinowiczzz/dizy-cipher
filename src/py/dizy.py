####################################################################################################
#
# Author: Martin Schmid
# Copyright (c) University of Passau
# Chair of Computer Engineering, Professorship for Secure Intelligent Systems
# 2024
#
####################################################################################################
# Utility functions
def get_bit(value: int, n: int) -> int:
    """Returns the n-th bit of the given integer."""
    return (value >> n) & 0b1

def mask_bits(value: int, n: int):
    """Mask the given value to n bits."""
    return value & (2**n - 1)

def get_group(i: int, group_size: int, no_groups:int, state: int):
    """Assume the state can be grouped into the given number of groups and group size.
    Returns the i-th group of grouped state where the 0'th group is around the MSBs."""
    assert i < no_groups, "Index should be within the number of groups."
    return mask_bits(state >> (no_groups - (i+1))*group_size, group_size)
####################################################################################################

from enum import Enum
class Variant(Enum):
    DIZY_80 = 0
    DIZY_128 = 1

    def get_state_size(self):
        return {
            Variant.DIZY_80: 120,
            Variant.DIZY_128: 160
        }[self]

    def get_key_size(self):
        return {
            Variant.DIZY_80: 80,
            Variant.DIZY_128: 128
        }[self]

####################################################################################################
# DIZY Functions
def lfsr_fun(lfsr_state: int) -> int:
    """Determine the new state of the LFSR."""
    new_val = get_bit(lfsr_state, 3) ^ get_bit(lfsr_state, 0)
    new_state = mask_bits((lfsr_state<<1) | new_val, 4)
    return new_state

def gen_round_constants() -> list[int]:
    """Generate the list of round constants."""
    lfsr_state = 0b1000
    NO_CONSTANTS = 15
    round_constants = []
    for _ in range(NO_CONSTANTS):
        round_constants.append(lfsr_state)
        lfsr_state = lfsr_fun(lfsr_state)
    return round_constants

def const_add(state: int, const: int, variant:Variant) -> int:
    """Add round constant to every group of 5 bits."""
    no_groups = variant.get_state_size()//5
    for i in range(no_groups): # LSB to MSB
        state = state ^ (const << i*5)
    return state

def sbox(group: int) -> int:
    SBOX = [0x00, 0x04, 0x0e, 0x09,
            0x0d, 0x0b, 0x1e, 0x1b,
            0x1c, 0x14, 0x13, 0x18,
            0x17, 0x1d, 0x05, 0x0c,
            0x0f, 0x11, 0x08, 0x15,
            0x03, 0x1f, 0x19, 0x06,
            0x10, 0x02, 0x16, 0x07,
            0x1a, 0x0a, 0x01, 0x12]
    return mask_bits(SBOX[group], 5)

def apply_sbox(state: int, variant:Variant) -> int:
    no_groups = variant.get_state_size()//5
    new_state = 0
    for i in range(no_groups): # LSB to MSB
        shamt = i*5
        group = mask_bits(state >> shamt, 5)
        mapped_group = sbox(group)
        new_state |= (mapped_group << shamt)
    return new_state

M_80 = [
    # Note: 16,8 are the correct indexes [doi.org/10.1109/TIFS.2024.3372200]
    {6,22},  {16,8},  {0,18},  {15}, {1},
    {7,27},  {20,13}, {2,23},  {21}, {11},
    {12,17}, {26,3},  {10,28}, {25}, {5},
    {2,27},  {21,9},  {11,24}, {16}, {0},
    {7,17},  {15,14}, {1,29},  {20}, {10},
    {12,25}, {22,4},  {5,19},  {26}, {6}
]

M_128 = [
    {22,2},  {35,8},  {16,28}, {10}, {31},
    {20,7},  {27,13}, {1,33},  {15}, {36},
    {25,12}, {32,18}, {6,38},  {0},  {21},
    {37,17}, {26,3},  {11,23}, {5},  {30},
    {27,17}, {30,9},  {0,24},  {11}, {35},
    {32,2},  {36,14}, {5,29},  {16}, {20},
    {37,7},  {21,19}, {10,34}, {1},  {25},
    {22,12}, {31,4},  {15,39}, {6},  {26}
]

def apply_matrix(state: int, variant: Variant) -> int:
    """Returns the result of applying the DIZY linear matrix on the given state."""
    mat, group_size = {
        Variant.DIZY_80: (M_80, 30),
        Variant.DIZY_128: (M_128, 40)
    }[variant]
    no_groups = variant.get_state_size()//group_size
    new_state = 0
    for i in range(no_groups):
        group = get_group(i, group_size, no_groups, state)
        for bit_idxs in mat: # MSB to LSB
            new_bit = 0
            for bit_idx in bit_idxs:
                new_bit ^= get_bit(group, group_size-1-bit_idx)
            new_state = (new_state << 1) | new_bit
    return new_state

def mix_groups(state: int, variant:Variant) -> int:
    NO_GROUPS = 8
    group_size = variant.get_state_size()//8
    new_state = 0
    for i in [0,4,1,5,2,6,3,7]:
        group = get_group(i, group_size, NO_GROUPS, state)
        new_state = (new_state << group_size) | group
    return new_state

def round(state: int, round_constant: int, variant: Variant) -> int:
    global debug
    if debug: print(f"State in:         {state_to_str(state, variant)}")
    state = const_add(state, round_constant, variant)
    if debug: print(f"State const add:  {state_to_str(state, variant)}")
    state = apply_sbox(state, variant)
    if debug: print(f"State sbox:       {state_to_str(state, variant)}")
    state = apply_matrix(state, variant)
    if debug: print(f"State perm:       {state_to_str(state, variant)}")
    state = mix_groups(state, variant)
    if debug: print(f"State mix groups: {state_to_str(state, variant)}")
    return state

def state_to_str(state: int, variant: Variant):
    if (variant == Variant.DIZY_80):
        return f"0x{state:0>30x}"
    else:
        return f"0x{state:0>40x}"

def xor_key_part(state: int, key_part: int, key_part_size: int, variant:Variant) -> int:
    """Group state into groups of 5, XOR the two MSBs in the most significant groups with two
    corresponding key-bits each for the specified length."""
    no_groups = key_part_size//2
    for i in range(no_groups): # MSB to LSB
        key_shamt = key_part_size-(i+1)*2
        key_msbs = mask_bits(key_part >> key_shamt, 2)
        state_align_shamt = variant.get_state_size()-(i+1)*5+3
        state = state ^ (key_msbs << state_align_shamt)
    return state

def init(key: int, iv: int, variant: Variant, single_iteration=False) -> int:
    """Returns the initial state based on the key and iv. If single_iteration, return before applying the IV."""
    global debug
    state = 0
    round_constants = gen_round_constants()
    key_added = False
    for value in [key, iv]:
        UPPER_SIZE, LOWER_SIZE = {
            Variant.DIZY_80: (48, 32),
            Variant.DIZY_128: (64, 64)
        }[variant]
        for i in range(15):
            if (i==0):
                if debug:
                    print(f"====== INITIALIZE: Adding upper {'IV' if key_added else 'key'} ======")
                if debug: print(f"State initial: {state_to_str(state, variant)}")
                upper = (value >> LOWER_SIZE)
                state = xor_key_part(state, upper, UPPER_SIZE, variant)
                if debug: print(f"State after:   {state_to_str(state, variant)}")
            elif (i==1):
                if debug:
                    print(f"====== INITIALIZE: Adding lower {'IV' if key_added else 'key'} ======")
                if debug: print(f"State initial: {state_to_str(state, variant)}")
                lower = mask_bits(value, LOWER_SIZE)
                state = xor_key_part(state, lower, UPPER_SIZE, variant)
                if debug: print(f"State after:   {state_to_str(state, variant)}")
            if debug: print(f"====== INITIALIZE: Round {i+1} ======")
            state = round(state, round_constants[i], variant)
        if debug: print(f"State after 15 rounds init: {state_to_str(state, variant)}")
        key_added = True
        if single_iteration:
            break
    return state


##############################################################
# Test functions

def execute_dizy(key: int, iv: int, variant: Variant):
    "Execute DIZY with test vectors from the reference implementation"
    global debug
    print(f"========== INITIALIZATION ==========")
    state = init(key, iv, variant)
    print(f"Finial initialization state: {state_to_str(state, variant)}")
    print(f"========== UPDATE STATE ==========")
    round_constants = gen_round_constants()
    for i in range(15):
        if debug: print(f"====== UPDATE STATE: Round {i+1} ======")
        state = round(state, round_constants[i],variant)
    print(f"Next state: {state_to_str(state, variant)}")

def print_round_constants():
    # Round constants prints
    print(f"======== ROUND CONSTANTS ========")
    const = gen_round_constants()
    i=1
    for c in const:
        print(f"Round {i:2d}: {c:2d} = {c:0>4b}")
        i=i+1


def run_official_tv():
    OFFICIAL_TV = {
        Variant.DIZY_80: (0xa000_0000_0000_0000_0000, 0x5500_0000_0000_0000_0000),
        Variant.DIZY_128: (0xa000_0000_0000_0000_0000_0000_0000_0000,
                        0x5500_0000_0000_0000_0000_0000_0000_0000)
    }
    # DIZY 80:
    #   After key init:   0x9def229257d3f5755a638d9bb507c0
    #   After IV  init:   0x3c8cea27286beecc381f33f5435a21
    #   After next state: 0x57f9de44d5bd9fcc69547f665b374c
    # DIZY 120:
    #   After key init:   0x8359d6543d2dc1761ea7c000a100fd60cc10d1e0
    #   After IV  init:   0x46d7f8f268d8b53af45432e3bde3eea5a622061f
    #   After next state: 0x3025582f15fec209af17382d481b97c055dce2bb

    # Configuration
    variant = Variant.DIZY_128
    key, iv = OFFICIAL_TV[variant]
    execute_dizy(key, iv, variant)


debug = False
if __name__ == '__main__':
    run_official_tv()
