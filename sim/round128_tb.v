`timescale 1ns/1ps

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module round128_tb;

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
   reg [SIZE_STATE-1:0] in = 0;

   // DUT Outputs
   //
   wire [SIZE_STATE-1:0] dut_out [RNDS-1:0];

   // DUT
   //
   genvar I_RND;
   generate
      for (I_RND=0; I_RND<RNDS; I_RND=I_RND+1) begin: dut
         round #(
            .SIZE_STATE(SIZE_STATE),
            .PERM_SIZE(PERM_SIZE)
         ) inst (
            .rnd_const(RND_CONST[(I_RND+1)*4-1:I_RND*4]),
            .in(I_RND == 0 ? in : dut_out[I_RND-1]),
            .out(dut_out[I_RND])
         );
      end
   endgenerate

   // Stimulus
   //
   initial begin
      // Test 1
      in <= 160'd0;
      #1;
      $display("dut_out[0]. Actual: %h, expected: %h", dut_out[0],
         160'h7bdef7bdef7bdef7bdef7bdef7bdef7bdef7bdef);
      $display("dut_out[1]. Actual: %h, expected: %h", dut_out[1],
         160'h06300063006318c6318c06300063006318c6318c);
      $display("dut_out[2]. Actual: %h, expected: %h", dut_out[2],
         160'h4472044720e5adce5adc2f7ac2f7ac1294b1294b);
      $display("dut_out[3]. Actual: %h, expected: %h", dut_out[3],
         160'h61f2a14d2f4c8f3cbbe41038f5f823a633c3e073);
      $display("dut_out[4]. Actual: %h, expected: %h", dut_out[4],
         160'h982af5517077ef30b16ebeeec33dbd9ad5e5861c);
      $display("dut_out[5]. Actual: %h, expected: %h", dut_out[5],
         160'hac038a81aa623ec49d9e8912a637b0c1999708d3);
      $display("dut_out[6]. Actual: %h, expected: %h", dut_out[6],
         160'h34d58acece29db335bcc203a48b3e3f9336c5057);
      $display("dut_out[7]. Actual: %h, expected: %h", dut_out[7],
         160'hcd45d2910f66e04293a17271abdee97d47321bd4);
      $display("dut_out[8]. Actual: %h, expected: %h", dut_out[8],
         160'h1d94d0f9febe24a7914990645b7bc4342947db0b);
      $display("dut_out[9]. Actual: %h, expected: %h", dut_out[9],
         160'h8fc4c697270befb062a9855e277869471510035d);
      $display("dut_out[10]. Actual: %h, expected: %h", dut_out[10],
         160'hc5b35b846257615e3c60b147f791af64d58475a5);
      $display("dut_out[11]. Actual: %h, expected: %h", dut_out[11],
         160'hdc01286d76b60a5132315b0f292036583dd3c2a0);
      $display("dut_out[12]. Actual: %h, expected: %h", dut_out[12],
         160'h1829c0b21d8c1d92a14a76b736e31baa4956d148);
      $display("dut_out[13]. Actual: %h, expected: %h", dut_out[13],
         160'h9e02421bebbf28ae103cfe4e55a037c96b2d81af);
      $display("dut_out[14]. Actual: %h, expected: %h", dut_out[14],
         160'he15962b2ac912831f3b6cf25673d05bf590cdfc5);
      $stop;
   end

endmodule