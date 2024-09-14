`include "params_dizy.vh"

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
//
// Fully unrolled (15 rounds per clock cycle) implementation of DIZY.
module rounds_15#(
   parameter integer SIZE_STATE = `SIZE_STATE,
   parameter integer SIZE_KEY = `SIZE_KEY,
   parameter integer PERM_SIZE = `PERM_SIZE
) (
   input wire clk,
   input wire load,
   input wire next,
   input wire [SIZE_KEY-1:0] key, // also used as IV input
   output wire busy,
   output wire [SIZE_STATE-1:0] state_out
);

   localparam [17:0] RND_CONST = 18'b1000_11110101100100;

   // Internal nets
   //
   reg [SIZE_STATE-1:0] state;
   //
   wire [SIZE_STATE-1:0] rnd_in_xor_value [1:0];
   wire [SIZE_STATE-1:0] rnd_in [14:0];
   wire [SIZE_STATE-1:0] rnd_out [14:0];

   // Assign KEY/IV XOR
   //
   key_ext_unrolled #(
      .SIZE_STATE(SIZE_STATE),
      .SIZE_KEY(SIZE_KEY)
   ) key_ext_inst (
      .key(key),
      .rnd_cnt(3'b0),
      .key_ext_upper(rnd_in_xor_value[0]),
      .key_ext_lower(rnd_in_xor_value[1])
   );

   // Instantiate rounds
   genvar I_RND;
   generate
      for (I_RND=0; I_RND<15; I_RND=I_RND+1) begin: round
         round #(
            .SIZE_STATE(SIZE_STATE),
            .PERM_SIZE(PERM_SIZE)
         ) inst (
            .rnd_const(RND_CONST[17-I_RND-:4]),
            .in(rnd_in[I_RND]),
            .out(rnd_out[I_RND])
         );
      end
   endgenerate
   //
   assign rnd_in[0] = (load ? 0 : state) ^ rnd_in_xor_value[0];
   assign rnd_in[1] = rnd_out[0] ^ rnd_in_xor_value[1];
   assign rnd_in[2] = rnd_out[1];
   assign rnd_in[3] = rnd_out[2];
   assign rnd_in[4] = rnd_out[3];
   assign rnd_in[5] = rnd_out[4];
   assign rnd_in[6] = rnd_out[5];
   assign rnd_in[7] = rnd_out[6];
   assign rnd_in[8] = rnd_out[7];
   assign rnd_in[9] = rnd_out[8];
   assign rnd_in[10] = rnd_out[9];
   assign rnd_in[11] = rnd_out[10];
   assign rnd_in[12] = rnd_out[11];
   assign rnd_in[13] = rnd_out[12];
   assign rnd_in[14] = rnd_out[13];

   // Assign state
   //
   always @(posedge clk) begin
      if (load || next) begin
         state <= rnd_out[14];
      end
   end
   //
   assign busy = 1'b0;
   assign state_out = state;

endmodule