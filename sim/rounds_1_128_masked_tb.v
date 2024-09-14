`timescale 1ns/1ps

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module rounds_1_128_masked_tb;

   // Clock parameters
   //
   localparam integer EDGE_PERIOD = 1;
   localparam integer CLK_PERIOD = 2*EDGE_PERIOD;

   // Local Parameter
   //
   localparam integer SIZE_STATE = 160;
   localparam integer SIZE_KEY = 128;
   localparam integer PERM_SIZE = 40;

   // DUT Inputs
   //
   reg clk = 1;
   reg load = 0;
   reg next = 0;
   reg [SIZE_KEY-1:0] key_a = 0;
   reg [SIZE_KEY-1:0] key_b = 0;
   wire [19:0] rand_bits;

   // DUT Outputs
   //
   wire busy;
   wire req_next_rand_bits;
   wire [SIZE_STATE-1:0] state_out_a;
   wire [SIZE_STATE-1:0] state_out_b;

   // DUT
   //
   rounds_1_masked #(
      .SIZE_STATE(SIZE_STATE),
      .SIZE_KEY(SIZE_KEY),
      .PERM_SIZE(PERM_SIZE)
   ) inst (
      .clk(clk),
      .load(load),
      .next(next),
      .key_a(key_a),
      .key_b(key_b),
      .rand_bits(rand_bits),
      .req_next_rand_bits(req_next_rand_bits),
      .busy(busy),
      .state_out_a(state_out_a),
      .state_out_b(state_out_b)
   );

   // Clock
   //
   always #EDGE_PERIOD clk=~clk;

   // Internal nets
   //
   reg [(3*15+5)*20-1:0] rand_bits_full = 1000'h9065e49c5924035e1d54cf14af08df4192caee166faa1da61f9155688c3c992cef1cea3fb054c09011f032aebe806e20ed92478ee73253addbbfff315c199c6e86ae3f32c56431b6ebbc7ceb562f1b75b4b3eef38027ccba769eb47a62e378f66157ce845e8ba18672f76611faefd0f2d1865d7c2c9de8a5ffd9a6bf0c;
   // Assign random bits
   //
   always @(posedge clk) begin
      if (req_next_rand_bits) begin
         rand_bits_full <= (rand_bits_full >> 20);
      end
   end
   //
   assign rand_bits = rand_bits_full[19:0];

   // Stimulus
   //
   initial begin
      next <= 1'b0;
      // Test 1 - Init Key
      key_a <= 128'ha000_0000_0000_0000_0000_0000_0000_0000 ^ 128'hd5e8a38490fd5a808a03edec3a5d400e;
      key_b <= 128'hd5e8a38490fd5a808a03edec3a5d400e;
      load <= 1'b1;
      #(CLK_PERIOD);
      load <= 1'b0;
      wait(busy);
      wait(~busy);
      $display("state_out_a ^ state_out_b. Actual: %h, expected: %h", state_out_a ^ state_out_b,
         160'h8359d6543d2dc1761ea7c000a100fd60cc10d1e0);
      // Test 2 - Wait, no change should happen
      #(20*CLK_PERIOD);
      // Test 3 - Init IV
      key_a <= 128'h5500_0000_0000_0000_0000_0000_0000_0000 ^ 128'hfb6618badd8f9da5dc0e1f96bd89d460;
      key_b <= 128'hfb6618badd8f9da5dc0e1f96bd89d460;
      next <= 1'b1;
      #(CLK_PERIOD);
      next <= 1'b0;
      wait(busy);
      wait(~busy);
      $display("state_out_a ^ state_out_b. Actual: %h, expected: %h", state_out_a ^ state_out_b,
         160'h46d7f8f268d8b53af45432e3bde3eea5a622061f);
      // Test 4 - Reinit key
      key_a <= 128'd0 ^ 128'h1e16b589aa13adc9e76299950ad4ec08;
      key_b <= 128'h1e16b589aa13adc9e76299950ad4ec08;
      #(5*CLK_PERIOD); // Wait extra, should stay at prev output
      load <= 1'b1;
      #(CLK_PERIOD);
      load <= 1'b0;
      wait(busy);
      wait(~busy);
      $display("state_out_a ^ state_out_b. Actual: %h, expected: %h", state_out_a ^ state_out_b,
         160'he15962b2ac912831f3b6cf25673d05bf590cdfc5);
      $stop;
   end

endmodule