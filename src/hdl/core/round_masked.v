`include "params_dizy.vh"

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module round_masked#(
   parameter integer SIZE_STATE = `SIZE_STATE,
   parameter integer PERM_SIZE = `PERM_SIZE
) (
   input wire clk,
   input wire start,
   input wire [3:0] rnd_const,
   input wire [SIZE_STATE-1:0] in_a,
   input wire [SIZE_STATE-1:0] in_b,
   input wire [19:0] rand_bits,
   output wire ready,
   output wire [SIZE_STATE-1:0] out_a,
   output wire [SIZE_STATE-1:0] out_b
);

// Local parameters
//
localparam integer N_GRPS_SBOX = SIZE_STATE/5;
localparam integer N_GRPS_PERM = SIZE_STATE/PERM_SIZE;

// Internal nets
//
wire [SIZE_STATE-1:0] i_state_a [4:0];
wire [SIZE_STATE-1:0] i_state_b [4:0];
reg [3:0] ready_cnt;

// Base state
//
assign i_state_a[0] = in_a;
assign i_state_b[0] = in_b;

// Ready signal
//
always @(posedge clk) begin
   if (start) begin
      ready_cnt <= 4'b1010;
   end else if (ready_cnt[3]) begin
      ready_cnt <= ready_cnt + 1;
   end
end
//
assign ready = &ready_cnt[2:0];

// Add round constant
//
wire [SIZE_STATE-1:0] rnd_const_ext = {N_GRPS_SBOX{1'b0, rnd_const}};
assign i_state_a[1] = i_state_a[0] ^ rnd_const_ext;
assign i_state_b[1] = i_state_b[0];

// Apply sbox
//
genvar I_SBOX;
generate
   for (I_SBOX=0; I_SBOX<N_GRPS_SBOX; I_SBOX=I_SBOX+1) begin: sbox
      sbox_masked inst (
         .clk(clk),
         .in_a(i_state_a[1][(I_SBOX+1)*5-1:I_SBOX*5]),
         .in_b(i_state_b[1][(I_SBOX+1)*5-1:I_SBOX*5]),
         .z(rand_bits),
         .out_a(i_state_a[2][(I_SBOX+1)*5-1:I_SBOX*5]),
         .out_b(i_state_b[2][(I_SBOX+1)*5-1:I_SBOX*5])
      );
   end
endgenerate

// Apply permute
//
genvar I_PERM;
generate
   for (I_PERM=0; I_PERM<N_GRPS_PERM; I_PERM=I_PERM+1) begin: perm
      // Shares A
      perm #(
         .PERM_SIZE(PERM_SIZE)
      ) inst_a (
         .in (i_state_a[2][(I_PERM+1)*PERM_SIZE-1:I_PERM*PERM_SIZE]),
         .out(i_state_a[3][(I_PERM+1)*PERM_SIZE-1:I_PERM*PERM_SIZE])
      );
      // Shares B
      perm #(
         .PERM_SIZE(PERM_SIZE)
      ) inst_b (
         .in (i_state_b[2][(I_PERM+1)*PERM_SIZE-1:I_PERM*PERM_SIZE]),
         .out(i_state_b[3][(I_PERM+1)*PERM_SIZE-1:I_PERM*PERM_SIZE])
      );
   end
endgenerate

// Apply mix groups
//
// Shares A
mix_groups #(
   .SIZE_STATE(SIZE_STATE)
) mix_groups_inst_a (
   .in(i_state_a[3]),
   .out(i_state_a[4])
);
// Shares B
mix_groups #(
   .SIZE_STATE(SIZE_STATE)
) mix_groups_inst_b (
   .in(i_state_b[3]),
   .out(i_state_b[4])
);

// Assign output
//
assign out_a = i_state_a[4];
assign out_b = i_state_b[4];

endmodule
