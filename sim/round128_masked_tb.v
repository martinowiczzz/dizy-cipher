`timescale 1ns/1ps

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module round128_masked_tb;

   // Clock parameters
   //
   localparam integer EDGE_PERIOD = 1;
   localparam integer CLK_PERIOD = 2*EDGE_PERIOD;

   // Local Parameter
   //
   localparam integer SIZE_STATE = 160;
   localparam integer PERM_SIZE = 40;
   localparam integer RNDS = 15;
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


   // DUT Inputs
   //
   reg clk = 1;
   reg start = 0;
   reg [RNDS*20-1:0] rand_bits = 300'h15e051490c6af89bcc4733924c6d31d2bad18a8a70bcd8d30ce11ada1018b8a6506e99c6c9a;
   reg [SIZE_STATE-1:0] rnd_in_a = 0;
   reg [SIZE_STATE-1:0] rnd_in_b = 0;

   // DUT Outputs
   //
   wire [SIZE_STATE-1:0] rnd_out_a [RNDS-1:0];
   wire [SIZE_STATE-1:0] rnd_out_b [RNDS-1:0];
   wire ready;

   // Clock
   //
   always #EDGE_PERIOD clk=~clk;

   // DUT
   //
   genvar I_RND;
   generate
      for (I_RND=0; I_RND<RNDS; I_RND=I_RND+1) begin: dut
         round_masked #(
            .SIZE_STATE(SIZE_STATE),
            .PERM_SIZE(PERM_SIZE)
         ) inst (
            .clk(clk),
            .start(start),
            .rnd_const(RND_CONST[(I_RND+1)*4-1:I_RND*4]),
            .in_a(I_RND == 0 ? rnd_in_a : rnd_out_a[I_RND-1]),
            .in_b(I_RND == 0 ? rnd_in_b : rnd_out_b[I_RND-1]),
            .rand_bits(rand_bits[(I_RND+1)*20-1:I_RND*20]),
            .ready(ready),
            .out_a(rnd_out_a[I_RND]),
            .out_b(rnd_out_b[I_RND])
         );
      end
   endgenerate

   // Stimulus
   //
   initial begin
      // Test 1
      rnd_in_a <= 160'h0 ^ 160'h4f822868169a816bef66f516c67c13de0ecf65e2; // rnd_in ^ r
      rnd_in_b <= 160'h4f822868169a816bef66f516c67c13de0ecf65e2; // r
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[0] ^ rnd_out_b[0]. Actual: %h, expected: %h", rnd_out_a[0] ^ rnd_out_b[0], 160'h7bdef7bdef7bdef7bdef7bdef7bdef7bdef7bdef);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[1] ^ rnd_out_b[1]. Actual: %h, expected: %h", rnd_out_a[1] ^ rnd_out_b[1], 160'h06300063006318c6318c06300063006318c6318c);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[2] ^ rnd_out_b[2]. Actual: %h, expected: %h", rnd_out_a[2] ^ rnd_out_b[2], 160'h4472044720e5adce5adc2f7ac2f7ac1294b1294b);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[3] ^ rnd_out_b[3]. Actual: %h, expected: %h", rnd_out_a[3] ^ rnd_out_b[3], 160'h61f2a14d2f4c8f3cbbe41038f5f823a633c3e073);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[4] ^ rnd_out_b[4]. Actual: %h, expected: %h", rnd_out_a[4] ^ rnd_out_b[4], 160'h982af5517077ef30b16ebeeec33dbd9ad5e5861c);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[5] ^ rnd_out_b[5]. Actual: %h, expected: %h", rnd_out_a[5] ^ rnd_out_b[5], 160'hac038a81aa623ec49d9e8912a637b0c1999708d3);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[6] ^ rnd_out_b[6]. Actual: %h, expected: %h", rnd_out_a[6] ^ rnd_out_b[6], 160'h34d58acece29db335bcc203a48b3e3f9336c5057);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[7] ^ rnd_out_b[7]. Actual: %h, expected: %h", rnd_out_a[7] ^ rnd_out_b[7], 160'hcd45d2910f66e04293a17271abdee97d47321bd4);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[8] ^ rnd_out_b[8]. Actual: %h, expected: %h", rnd_out_a[8] ^ rnd_out_b[8], 160'h1d94d0f9febe24a7914990645b7bc4342947db0b);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[9] ^ rnd_out_b[9]. Actual: %h, expected: %h", rnd_out_a[9] ^ rnd_out_b[9], 160'h8fc4c697270befb062a9855e277869471510035d);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[10] ^ rnd_out_b[10]. Actual: %h, expected: %h", rnd_out_a[10] ^ rnd_out_b[10], 160'hc5b35b846257615e3c60b147f791af64d58475a5);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[11] ^ rnd_out_b[11]. Actual: %h, expected: %h", rnd_out_a[11] ^ rnd_out_b[11], 160'hdc01286d76b60a5132315b0f292036583dd3c2a0);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[12] ^ rnd_out_b[12]. Actual: %h, expected: %h", rnd_out_a[12] ^ rnd_out_b[12], 160'h1829c0b21d8c1d92a14a76b736e31baa4956d148);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[13] ^ rnd_out_b[13]. Actual: %h, expected: %h", rnd_out_a[13] ^ rnd_out_b[13], 160'h9e02421bebbf28ae103cfe4e55a037c96b2d81af);
      start <= 1'b1;
      #(CLK_PERIOD);
      start <= 1'b0;
      wait(ready);
      wait(~ready);
      $display("rnd_out_a[14] ^ rnd_out_b[14]. Actual: %h, expected: %h", rnd_out_a[14] ^ rnd_out_b[14], 160'he15962b2ac912831f3b6cf25673d05bf590cdfc5);
      #(CLK_PERIOD);
      $stop;
   end

endmodule