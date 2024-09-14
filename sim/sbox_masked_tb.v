`timescale 1ns/1ps

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module sbox_masked_tb;

// Clock parameters
//
localparam integer EDGE_PERIOD = 1;
localparam integer CLK_PERIOD = 2*EDGE_PERIOD;

// DUT Inputs
//
reg clk = 1;
reg [4:0] in_a = 0;
reg [4:0] in_b = 0;
reg [19:0] z = 0;

// DUT Outputs
//
wire [4:0] out_a;
wire [4:0] out_b;

sbox_masked dut (
    .clk(clk),
    .in_a(in_a),
    .in_b(in_b),
    .z(z),
    .out_a(out_a),
    .out_b(out_b)
);

// Clock
//
always #EDGE_PERIOD clk=~clk;

// Stimulus
//
initial begin
    in_a <= (5'b01101 ^ 5'b01001); // SBOX(5'b01101)
    in_b <= 5'b01001;
    z <= 0;
    #(6*CLK_PERIOD);
    $display("out_a ^ out_b. Actual: %b, expected: %b", out_a ^ out_b,
        5'b11101);
    z <= {19{1'b1}};
    #(6*CLK_PERIOD);
    $display("out_a ^ out_b. Actual: %b, expected: %b", out_a ^ out_b,
        5'b11101);
    in_a <= (5'b11101 ^ 5'b10111); // SBOX(5'b11101)
    in_b <= 5'b10111;
    z <= 0;
    #(6*CLK_PERIOD);
    $display("out_a ^ out_b. Actual: %b, expected: %b", out_a ^ out_b,
        5'b01010);
    in_a <= 5'b01101; // SBOX(5'b01110)
    in_b <= 5'b00011;
    //z <= 20'b00000110111010011001;
    z <= 20'd0;
    #(6*CLK_PERIOD);
    $display("out_a ^ out_b. Actual: %b, expected: %b", out_a ^ out_b,
        5'b00101);
    $stop;
end

endmodule