# DIZY Cipher Implementation

This repository provides a Python and Verilog implementation of the DIZY cipher.

## Directory Structure
- `sim/tb`: Verilog testbench files for all implemented variants
- `src/py`: Python reference implementation (for development purposes)
- `src/hdl/util`: Verilog modules for gates/blocks used in designs
- `src/hdl/core`: Verilog modules composing a single round in DIZY-80/128
- `src/hdl/rounds_1.v`: Top module for a round-based implementation of DIZY-80/128 (1 round per clock cycle)
- `src/hdl/rounds_1_masked.v`: Top module for a masked round-based implementation of DIZY-80/128 (6 clock cycles per round)
- `src/hdl/rounds_3.v`: Top module for a partially-unrolled implementation of DIZY-80/128 (3 rounds per clock cycle)
- `src/hdl/rounds_5.v`: Top module for a partially-unrolled implementation of DIZY-80/128 (5 rounds per clock cycle)
- `src/hdl/rounds_15.v`: Top module for a partially-unrolled implementation of DIZY-80/128 (15 rounds per clock cycle)
- `src/hdl/params.vh`: Default module parameters. Modify to switch between DIZY-80 and DIZY-128

## Module: rounds_*.v
This module can be used as a top module to instantiate DIZY. The number in the filename describes the number of rounds executed per clock cycle. Further `_masked` denotes a masked variant. To use the stream cipher, execute the following steps:
1. Set the `key` input to the desired key and pulse `load` for one clock cycle. Wait until `busy` is low.
2. Set the `key` input to the desired IV and pulse `next` for one clock cycle. Wait until `busy` is low. Now the cipher is initialized and the first valid output can be read.
3. For every state update, set the `key` input to 0 pulse `next` for one clock cycle. Wait until `busy` is low and then read the output.

### Parameters
| Name          | Expected Values | Description |
|---------------|-----------------|--------------|
| `SIZE_STATE`  | 120, 160        | Set to 120 for DIZY-80 and 160 for DIZY-128. |
| `SIZE_KEY`    | 80, 128         | Set to 80 for DIZY-80 and 128 for DIZY-128.  |
| `PERM_SIZE`   | 30, 40          | Set to 30 for DIZY-80 and 40 for DIZY-128.   |

### Inputs/Outputs
| Name        | Width         | Description |
|-------------|---------------|-------------|
| `clk`       | 1             |             |
| `load`      | 1             | Initializes the stream cipher in two steps. |
| `next`      | 1             | Invokes a state update to produce a new output. |
| `key`       | `SIZE_KEY`    | Key/IV input when initializing the cipher and must be set to 0 for all subsequent iterations. |
| `busy`      | 1             | Indicates that the computation is running. When this signal goes low, the output is valid. |
| `state_out` | `SIZE_STATE`  | Currently held state. |

### Dependencies
Requires the modules `core/key_ext.v` for rounds_1 else `core/key_ext_unrolled.v`, `core/mix_groups.v`, `core/perm.v`, `core/round.v`, `core/sbox.v`, and the header `params_dizy.vh`.

## Module: rounds_1_masked.v
This module implements an iterative, first-order DOM masked version of DIZY-80/128. It's usage is identical to `rounds_*.v`, with Boolean masked key input and state output. Randomness has to be provided externally.

### Inputs/Outputs
| Name        | Width         | Description |
|-------------|---------------|-------------|
| `clk`       | 1             |             |
| `load`      | 1             | Initializes the stream cipher in two steps. |
| `next`      | 1             | Invokes a state update to produce a new output. |
| `key_a`     | `SIZE_KEY`    | Share A of Key/IV input when initializing the cipher and must be set to 0 for all subsequent iterations. |
| `key_b`     | `SIZE_KEY`    | Share B of Key/IV input when initializing the cipher and must be set to 0 for all subsequent iterations. |
| `rand_bits` | 20            | Fresh random bits required during computation. New bits have to be provided at a pulse of `req_next_rand_bits`. Requires 20 bits per round, *i.e.*, 300 bits per state update. |
| `req_next_rand_bits` | 1    | Indicates that new random bits have to be provided. |
| `busy`      | 1             | Indicates that the computation is running. When this signal goes low, the output is valid. |
| `state_out_a` | `SIZE_STATE`  | Share A of currently held state. |
| `state_out_b` | `SIZE_STATE`  | Share B of currently held state. |

### Dependencies
Requires the modules `core/key_ext.v`, `core/mix_groups.v`, `core/perm.v`, `core/round_masked.v`, `core/sbox_masked.v`, `util/dom_and_xor.v`, and the header `params_dizy.vh`.

## Module: rand_source.v
This module can be used as a randomness source for the masked DIZY-128 implementation. It attaches to the DIZY cipher, stores its previous 320-bit output and returns it in groups of 20 bits on request. For the very first invocation, a hardcoded 320-bit value can be provided through the module parameters.

## References
- Original cipher paper: https://doi.org/10.1109/TIFS.2023.3287412\
- Correction of a typo in the paper: https://doi.org/10.1109/TIFS.2024.3372200
- DOM-masked AND-XOR gate: https://eprint.iacr.org/2023/1914.pdf

## Authors
[Martin Schmid](https://www.fim.uni-passau.de/technische-informatik/lehrstuhlteam/wissenschaftliche-mitarbeiter/martin-schmid), [Elif Bilge Kavun](https://www.fim.uni-passau.de/en/secint)
