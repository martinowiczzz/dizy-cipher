`include "params_dizy.vh"

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module perm#(
   parameter integer PERM_SIZE = `PERM_SIZE
) (
   input wire [PERM_SIZE-1:0] in,
   output wire [PERM_SIZE-1:0] out
);

generate
   if (PERM_SIZE == 30) begin
      assign out = {
         in[29-6]  ^ in[29-22],
         in[29-16] ^ in[29-8],
         in[29-0]  ^ in[29-18],
         in[29-15],
         in[29-1],
         in[29-7]  ^ in[29-27],
         in[29-20] ^ in[29-13],
         in[29-2]  ^ in[29-23],
         in[29-21],
         in[29-11],
         in[29-12] ^ in[29-17],
         in[29-26] ^ in[29-3],
         in[29-10] ^ in[29-28],
         in[29-25],
         in[29-5],
         in[29-2]  ^ in[29-27],
         in[29-21] ^ in[29-9],
         in[29-11] ^ in[29-24],
         in[29-16],
         in[29-0],
         in[29-7]  ^ in[29-17],
         in[29-15] ^ in[29-14],
         in[29-1]  ^ in[29-29],
         in[29-20],
         in[29-10],
         in[29-12] ^ in[29-25],
         in[29-22] ^ in[29-4],
         in[29-5]  ^ in[29-19],
         in[29-26],
         in[29-6]
      };
   end
   if (PERM_SIZE == 40) begin
      assign out = {
         in[39-22] ^ in[39-2],
         in[39-35] ^ in[39-8],
         in[39-16] ^ in[39-28],
         in[39-10],
         in[39-31],
         in[39-20] ^ in[39-7],
         in[39-27] ^ in[39-13],
         in[39-1]  ^ in[39-33],
         in[39-15],
         in[39-36],
         in[39-25] ^ in[39-12],
         in[39-32] ^ in[39-18],
         in[39-6]  ^ in[39-38],
         in[39-0],
         in[39-21],
         in[39-37] ^ in[39-17],
         in[39-26] ^ in[39-3],
         in[39-11] ^ in[39-23],
         in[39-5],
         in[39-30],
         in[39-27] ^ in[39-17],
         in[39-30] ^ in[39-9],
         in[39-0]  ^ in[39-24],
         in[39-11],
         in[39-35],
         in[39-32] ^ in[39-2],
         in[39-36] ^ in[39-14],
         in[39-5]  ^ in[39-29],
         in[39-16],
         in[39-20],
         in[39-37] ^ in[39-7],
         in[39-21] ^ in[39-19],
         in[39-10] ^ in[39-34],
         in[39-1],
         in[39-25],
         in[39-22] ^ in[39-12],
         in[39-31] ^ in[39-4],
         in[39-15] ^ in[39-39],
         in[39-6],
         in[39-26]
      };
   end
endgenerate

endmodule