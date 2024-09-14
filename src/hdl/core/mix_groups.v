`include "params_dizy.vh"

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module mix_groups#(
   parameter integer SIZE_STATE = `SIZE_STATE
) (
   input wire [SIZE_STATE-1:0] in,
   output wire [SIZE_STATE-1:0] out
);

localparam integer GROUP_SIZE = SIZE_STATE/8;

// Assign output
//
assign out = {
   in[8*GROUP_SIZE-1:7*GROUP_SIZE],
   in[4*GROUP_SIZE-1:3*GROUP_SIZE],
   in[7*GROUP_SIZE-1:6*GROUP_SIZE],
   in[3*GROUP_SIZE-1:2*GROUP_SIZE],
   in[6*GROUP_SIZE-1:5*GROUP_SIZE],
   in[2*GROUP_SIZE-1:1*GROUP_SIZE],
   in[5*GROUP_SIZE-1:4*GROUP_SIZE],
   in[1*GROUP_SIZE-1:0*GROUP_SIZE]
};

endmodule