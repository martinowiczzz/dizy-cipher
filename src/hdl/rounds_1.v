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
// Round-based (1 round per clock cycle) implementation of DIZY.
// The key input must be set to the key in the first state update, the IV in the second state update
// and to 0 for all subsequent updates.
module rounds_1#(
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
reg [3:0] rnd_const_lfsr = 4'b1000;
//
wire final_round;
reg [3:0] rnd_cnt;
reg i_busy;
reg [3:0] rnd_const;
//
wire [SIZE_STATE-1:0] rnd_in_xor_value;
wire [SIZE_STATE-1:0] rnd_in;
wire [SIZE_STATE-1:0] rnd_out;

// Assign KEY/IV XOR
//
key_ext #(
   .SIZE_STATE(SIZE_STATE),
   .SIZE_KEY(SIZE_KEY)
) key_ext_inst (
   .key(key),
   .rnd_cnt(rnd_cnt),
   .key_ext(rnd_in_xor_value)
);
//
assign rnd_in = (load ? 0 : state) ^ rnd_in_xor_value;

// Generate round constants
//
always @(posedge clk) begin
   if (load || next || i_busy) begin
      rnd_const_lfsr <= {
         rnd_const_lfsr[2:0],
         rnd_const_lfsr[3]^rnd_const_lfsr[0]
      };
   end else begin
      rnd_const_lfsr <= 4'b1000;
   end
end

// Round
//
round #(
   .SIZE_STATE(SIZE_STATE),
   .PERM_SIZE(PERM_SIZE)
) rnd_inst (
   .rnd_const(rnd_const_lfsr),
   .in(rnd_in),
   .out(rnd_out)
);

// Control
//
always @(posedge clk) begin
   if (load || next) begin
      state <= rnd_out;
      rnd_cnt <= 1;
      i_busy <= 1;
   end else if (i_busy) begin
      state <= rnd_out;
      if (final_round) begin
         rnd_cnt <= 0;
         i_busy <= 0;
      end else begin
         rnd_cnt <= rnd_cnt + 1;
      end
   end else begin
      rnd_cnt <= 0;
   end
end
//
assign final_round = (rnd_cnt == 4'he);
assign busy = i_busy;
assign state_out = state;

endmodule