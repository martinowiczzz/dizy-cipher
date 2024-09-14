`timescale 1ns/1ps

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module round80_tb;

   // Local Parameter
   //
   localparam integer SIZE_STATE = 120;
   localparam integer PERM_SIZE = 30;
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
      in <= 120'd0;
      #1;
      $display("dut_out[0]. Actual: %h, expected: %h", dut_out[0],
         120'h7bdef7bdef7bdef7bdef7bdef7bdef);
      $display("dut_out[1]. Actual: %h, expected: %h", dut_out[1],
         120'h810102018ca3194810102018ca3194);
      $display("dut_out[2]. Actual: %h, expected: %h", dut_out[2],
         120'hf2f3e5e6365c6cb4b88971144ca899);
      $display("dut_out[3]. Actual: %h, expected: %h", dut_out[3],
         120'he7130ee59e651c27c27f343e345e0d);
      $display("dut_out[4]. Actual: %h, expected: %h", dut_out[4],
         120'h17ff40cebd71a78ac76b08798932ee);
      $display("dut_out[5]. Actual: %h, expected: %h", dut_out[5],
         120'h91a34fd6313393254a7d6d64cf3aa5);
      $display("dut_out[6]. Actual: %h, expected: %h", dut_out[6],
         120'h82de106da1a8f9828d6c45965ccf66);
      $display("dut_out[7]. Actual: %h, expected: %h", dut_out[7],
         120'h7455f93e768698eb8ab4649bf793e1);
      $display("dut_out[8]. Actual: %h, expected: %h", dut_out[8],
         120'hd94cb8d5b8470d99c7fd075b73056e);
      $display("dut_out[9]. Actual: %h, expected: %h", dut_out[9],
         120'h8e78692f9b82ed28fe3b2c62e75433);
      $display("dut_out[10]. Actual: %h, expected: %h", dut_out[10],
         120'h462e4f70853381030f1258f756a1e3);
      $display("dut_out[11]. Actual: %h, expected: %h", dut_out[11],
         120'h1f99430050d774fcc360b02eff3a16);
      $display("dut_out[12]. Actual: %h, expected: %h", dut_out[12],
         120'h82d4bcebf8813d8ce356e5eaf70b09);
      $display("dut_out[13]. Actual: %h, expected: %h", dut_out[13],
         120'h9d4ec20c0d612ba3bfe085fcea636f);
      $display("dut_out[14]. Actual: %h, expected: %h", dut_out[14],
         120'h516f9e0fd4b5b090f6a20ce13e7c46);
      $stop;
   end

endmodule