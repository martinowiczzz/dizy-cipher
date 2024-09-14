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
(* KEEP_HIERARCHY = "yes" *)
module rounds_1_masked#(
   parameter integer SIZE_STATE = `SIZE_STATE,
   parameter integer SIZE_KEY = `SIZE_KEY,
   parameter integer PERM_SIZE = `PERM_SIZE
) (
   input wire clk,
   input wire load,
   input wire next,
   input wire [SIZE_KEY-1:0] key_a, // also used as IV input
   input wire [SIZE_KEY-1:0] key_b,
   input wire [19:0] rand_bits,
   output req_next_rand_bits,
   output wire busy,
   output wire [SIZE_STATE-1:0] state_out_a,
   output wire [SIZE_STATE-1:0] state_out_b
);

// Local Params
localparam [59:0] RND_CONST = {
   4'b0100, // RND 15
   4'b0010,
   4'b1001,
   4'b1100,
   4'b0110,
   4'b1011,
   4'b0101,
   4'b1010,
   4'b1101,
   4'b1110,
   4'b1111,
   4'b0111,
   4'b0011,
   4'b0001, // RND 2
   4'b1000 // RND 1
};

reg [SIZE_STATE-1:0] state_a;
reg [SIZE_STATE-1:0] state_b;

reg [3:0] rnd_cnt;
reg i_busy;
reg [3:0] rnd_const;
wire last_round;

wire [SIZE_STATE-1:0] rnd_in_xor_value_a;
wire [SIZE_STATE-1:0] rnd_in_a;
wire [SIZE_STATE-1:0] rnd_out_a;

wire [SIZE_STATE-1:0] rnd_in_xor_value_b;
wire [SIZE_STATE-1:0] rnd_in_b;
wire [SIZE_STATE-1:0] rnd_out_b;

reg rnd_start;
wire rnd_ready;

// Assign KEY/IV XOR
//
key_ext #(
   .SIZE_STATE(SIZE_STATE),
   .SIZE_KEY(SIZE_KEY)
) key_ext_inst_a (
   .key(key_a),
   .rnd_cnt(rnd_cnt),
   .key_ext(rnd_in_xor_value_a)
);
key_ext #(
   .SIZE_STATE(SIZE_STATE),
   .SIZE_KEY(SIZE_KEY)
) key_ext_inst_b (
   .key(key_b),
   .rnd_cnt(rnd_cnt),
   .key_ext(rnd_in_xor_value_b)
);
//
assign rnd_in_a = state_a ^ rnd_in_xor_value_a;
assign rnd_in_b = state_b ^ rnd_in_xor_value_b;

// Round
//
round_masked #(
   .SIZE_STATE(SIZE_STATE),
   .PERM_SIZE(PERM_SIZE)
) rnd_inst (
   .clk(clk),
   .start(rnd_start),
   .rnd_const(rnd_const),
   .in_a(rnd_in_a),
   .in_b(rnd_in_b),
   .rand_bits(rand_bits),
   .ready(rnd_ready),
   .out_a(rnd_out_a),
   .out_b(rnd_out_b)
);

// Control
//
always @(posedge clk) begin
   if (load || next) begin
      if (load) begin
         state_a <= 0;
         state_b <= 0;
      end
      rnd_cnt <= 0;
      i_busy <= 1;
      rnd_const <= RND_CONST[3:0];
   end else if (rnd_ready && i_busy) begin
      state_a <= rnd_out_a;
      state_b <= rnd_out_b;
      if (last_round) begin
         rnd_cnt <= 0;
         i_busy <= 0;
      end else begin
         rnd_const <= RND_CONST[(rnd_cnt+1)*4 +: 4];
         rnd_cnt <= rnd_cnt + 1;
      end
   end
   rnd_start <= load || next || (rnd_ready && !last_round && i_busy);
end
//
assign req_next_rand_bits = load || next || (rnd_ready && !last_round && i_busy);
assign last_round = (rnd_cnt == 4'he);
assign busy = i_busy;
assign state_out_a = state_a;
assign state_out_b = state_b;

endmodule