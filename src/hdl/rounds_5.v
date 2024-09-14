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
// Partially unrolled (5 rounds per clock cycle) implementation of DIZY.
module rounds_5#(
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

   // Internal nets
   //
   reg [SIZE_STATE-1:0] state;
   reg [7:0] rnd_const_lfsr;
   //
   reg [1:0] rnd_cnt;
   reg i_busy;
   //
   wire [SIZE_STATE-1:0] rnd_in_xor_value [1:0];
   wire [SIZE_STATE-1:0] rnd_in [4:0];
   wire [SIZE_STATE-1:0] rnd_out [4:0];

   // Assign KEY/IV XOR
   //
   key_ext_unrolled #(
      .SIZE_STATE(SIZE_STATE),
      .SIZE_KEY(SIZE_KEY)
   ) key_ext_inst (
      .key(key),
      .rnd_cnt({1'b0,rnd_cnt}),
      .key_ext_upper(rnd_in_xor_value[0]),
      .key_ext_lower(rnd_in_xor_value[1])
   );

   // Generate round constants
   //
   always @(posedge clk) begin
      if (load || next || i_busy) begin
         rnd_const_lfsr <= {
            rnd_const_lfsr[2:0],
            rnd_const_lfsr[3]^rnd_const_lfsr[0],
            rnd_const_lfsr[3]^rnd_const_lfsr[0]^rnd_const_lfsr[2],
            rnd_const_lfsr[3]^rnd_const_lfsr[0]^rnd_const_lfsr[2]^rnd_const_lfsr[1],
            rnd_const_lfsr[3]^rnd_const_lfsr[2]^rnd_const_lfsr[1],
            rnd_const_lfsr[0]^rnd_const_lfsr[2]^rnd_const_lfsr[1]
         };
      end else begin
         rnd_const_lfsr <= 8'b1000_1111;
      end
   end

   // Instantiate rounds
   genvar I_RND;
   generate
      for (I_RND=0; I_RND<5; I_RND=I_RND+1) begin: round
         round #(
            .SIZE_STATE(SIZE_STATE),
            .PERM_SIZE(PERM_SIZE)
         ) inst (
            .rnd_const(rnd_const_lfsr[7-I_RND-:4]),
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

   // Assign state
   //
   always @(posedge clk) begin
      if (load || next) begin
         state <= rnd_out[4];
         rnd_cnt <= 1;
         i_busy <= 1;
      end else if (i_busy) begin
         state <= rnd_out[4];
         if (rnd_cnt == 2'h2) begin
            rnd_cnt <= 0;
            i_busy <= 0;
         end else begin
            rnd_cnt <= rnd_cnt+1;
         end
      end else begin
         rnd_cnt <= 0;
      end
   end
   //
   assign busy = i_busy;
   assign state_out = state;

endmodule