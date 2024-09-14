//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
//
// Masked AND-XOR according to https://eprint.iacr.org/2023/1914.pdf
// Returns x[0]+(x[1]+1)*x[2] in two shares
// Requires 1-bit randomness in z.
module dom_and_xor(
   input wire clk,
   input wire [2:0] x_a,
   input wire [2:0] x_b,
   input wire z,
   output wire y_a,
   output wire y_b
);

// Internal nets
//
// Domain A
wire x_a1a2;
wire x_a1b2;
wire i_a1;
wire i_a2;
reg i_y_a1;
reg i_y_a2;
wire i_y_a;
//
// Domain B
wire x_b1a2;
wire x_b2b1;
wire i_b1;
wire i_b2;
reg i_y_b1;
reg i_y_b2;
wire i_y_b;

// Domain A
and u_a1(x_a1a2, x_a[1], x_a[2]);
and u_a2(x_a1b2, x_a[1], x_b[2]);
//
xor(i_a1, x_a1a2, x_a[0]);
xor(i_a2, x_a1b2, z);
//
always @(posedge clk) begin
   i_y_a1 <= i_a1;
   i_y_a2 <= i_a2;
end
//
xor(i_y_a, i_y_a1, i_y_a2);
//
assign y_a = i_y_a;

// Domain B
and u_b1(x_b1a2, x_a[2], x_b[1]);
and u_b2(x_b2b1, x_b[2], x_b[1]);
xor(i_b1, x_b1a2, z);
xor(i_b2, x_b2b1, x_b[0]);
//
always @(posedge clk) begin
   i_y_b1 <= i_b1;
   i_y_b2 <= i_b2;
end
//
xor(i_y_b, i_y_b1, i_y_b2);
//
assign y_b = i_y_b;

endmodule