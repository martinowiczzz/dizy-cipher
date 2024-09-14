`timescale 1ns/1ps

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module rounds_tb;

   // Unrollment parameter. Uncomment the required option.
   `define ROUNDS_1
   //`define ROUNDS_3
   //`define ROUNDS_5
   //`define ROUNDS_15

   // Clock parameters
   //
   localparam integer EDGE_PERIOD = 1;
   localparam integer CLK_PERIOD = 2*EDGE_PERIOD;

   // DUT Inputs
   //
   reg clk = 1;
   reg load = 0;
   reg next = 0;
   reg [`SIZE_KEY-1:0] dut_key = 0;

   // DUT Outputs
   //
   wire busy;
   wire [`SIZE_STATE-1:0] dut_out;

   // DUT
   //
   `ifdef ROUNDS_1
      rounds_1
   `elsif ROUNDS_3
      rounds_3
   `elsif ROUNDS_5
      rounds_5
   `elsif ROUNDS_15
      rounds_15
   `endif #(
         .SIZE_STATE(`SIZE_STATE),
         .SIZE_KEY(`SIZE_KEY),
         .PERM_SIZE(`PERM_SIZE)
      ) inst (
         .clk(clk),
         .load(load),
         .next(next),
         .key(dut_key),
         .busy(busy),
         .state_out(dut_out)
      );

   // Clock
   //
   always #EDGE_PERIOD clk=~clk;

   // Stimulus
   //
   `ifdef DIZY_80
      initial begin
         // Test 1 - Init Key
         dut_key <= 80'ha000_0000_0000_0000_0000;
         load <= 1'b1;
         #(CLK_PERIOD);
         load <= 1'b0;
         #(CLK_PERIOD);
         wait(~busy);
         $display("dut_out. Actual: %h, expected: %h", dut_out,
            120'h9def229257d3f5755a638d9bb507c0);
         // Test 2 - Wait, no change should happen
         #(20*CLK_PERIOD);
         // Test 3 - Init IV
         dut_key <= 80'h5500_0000_0000_0000_0000;
         next <= 1'b1;
         #(CLK_PERIOD);
         next <= 1'b0;
         #(CLK_PERIOD);
         wait(~busy);
         $display("dut_out. Actual: %h, expected: %h", dut_out,
            120'h3c8cea27286beecc381f33f5435a21);
         // Test 4 - Reinit key
         dut_key <= 80'd0;
         #(5*CLK_PERIOD); // Wait extra, should stay at prev output
         load <= 1'b1;
         #(CLK_PERIOD);
         load <= 1'b0;
         #(CLK_PERIOD);
         wait(~busy);
         $display("dut_out. Actual: %h, expected: %h", dut_out,
            120'h516f9e0fd4b5b090f6a20ce13e7c46);
         $stop;
      end
   `else
      initial begin
         // Test 1 - Init Key
         dut_key <= 128'ha000_0000_0000_0000_0000_0000_0000_0000;
         load <= 1'b1;
         #(CLK_PERIOD);
         load <= 1'b0;
         #(CLK_PERIOD);
         wait(~busy);
         $display("dut_out. Actual: %h, expected: %h", dut_out,
            160'h8359d6543d2dc1761ea7c000a100fd60cc10d1e0);
         // Test 2 - Wait, no change should happen
         #(20*CLK_PERIOD);
         // Test 3 - Init IV
         dut_key <= 128'h5500_0000_0000_0000_0000_0000_0000_0000;
         next <= 1'b1;
         #(CLK_PERIOD);
         next <= 1'b0;
         #(CLK_PERIOD);
         wait(~busy);
         $display("dut_out. Actual: %h, expected: %h", dut_out,
            160'h46d7f8f268d8b53af45432e3bde3eea5a622061f);
         // Test 4 - Reinit key
         dut_key <= 128'd0;
         #(5*CLK_PERIOD); // Wait extra, should stay at prev output
         load <= 1'b1;
         #(CLK_PERIOD);
         load <= 1'b0;
         #(CLK_PERIOD);
         wait(~busy);
         $display("dut_out. Actual: %h, expected: %h", dut_out,
            160'he15962b2ac912831f3b6cf25673d05bf590cdfc5);
         $stop;
      end
   `endif

endmodule