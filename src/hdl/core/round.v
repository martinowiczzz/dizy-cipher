`include "params_dizy.vh"

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module round#(
   parameter integer SIZE_STATE = `SIZE_STATE,
   parameter integer PERM_SIZE = `PERM_SIZE
) (
   input wire [3:0] rnd_const,
   input wire [SIZE_STATE-1:0] in,
   output wire [SIZE_STATE-1:0] out
);

// Local parameters
//
localparam integer N_GRPS_SBOX = SIZE_STATE/5;
localparam integer N_GRPS_PERM = SIZE_STATE/PERM_SIZE;

// Internal nets
//
wire [SIZE_STATE-1:0] i_state [4:0];

// Base state
//
assign i_state[0] = in;

// Add round constant
//
wire [SIZE_STATE-1:0] rnd_const_ext = {N_GRPS_SBOX{1'b0, rnd_const}};
assign i_state[1] = i_state[0] ^ rnd_const_ext;

// Apply sbox
//
genvar I_SBOX;
generate
   for (I_SBOX=0; I_SBOX<N_GRPS_SBOX; I_SBOX=I_SBOX+1) begin: sbox
      sbox inst (
         .in (i_state[1][(I_SBOX+1)*5-1:I_SBOX*5]),
         .out(i_state[2][(I_SBOX+1)*5-1:I_SBOX*5])
      );
   end
endgenerate

// Apply permute
//
genvar I_PERM;
generate
   for (I_PERM=0; I_PERM<N_GRPS_PERM; I_PERM=I_PERM+1) begin: perm
      perm #(
         .PERM_SIZE(PERM_SIZE)
      ) inst (
         .in (i_state[2][(I_PERM+1)*PERM_SIZE-1:I_PERM*PERM_SIZE]),
         .out(i_state[3][(I_PERM+1)*PERM_SIZE-1:I_PERM*PERM_SIZE])
      );
   end
endgenerate

// Apply mix groups
//
mix_groups #(
   .SIZE_STATE(SIZE_STATE)
) inst (
   .in(i_state[3]),
   .out(i_state[4])
);

// Assign output
//
assign out = i_state[4];

endmodule