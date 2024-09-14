//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module sbox(
   input wire [4:0] in,
   output wire [4:0] out
);

// Internal nets
//
reg [4:0] i_out;

// LUT SBOX
//
always @* begin
   case (in)
      5'b00000: i_out = 5'b00000;
      5'b00001: i_out = 5'b00100;
      5'b00010: i_out = 5'b01110;
      5'b00011: i_out = 5'b01001;
      5'b00100: i_out = 5'b01101;
      5'b00101: i_out = 5'b01011;
      5'b00110: i_out = 5'b11110;
      5'b00111: i_out = 5'b11011;
      5'b01000: i_out = 5'b11100;
      5'b01001: i_out = 5'b10100;
      5'b01010: i_out = 5'b10011;
      5'b01011: i_out = 5'b11000;
      5'b01100: i_out = 5'b10111;
      5'b01101: i_out = 5'b11101;
      5'b01110: i_out = 5'b00101;
      5'b01111: i_out = 5'b01100;
      5'b10000: i_out = 5'b01111;
      5'b10001: i_out = 5'b10001;
      5'b10010: i_out = 5'b01000;
      5'b10011: i_out = 5'b10101;
      5'b10100: i_out = 5'b00011;
      5'b10101: i_out = 5'b11111;
      5'b10110: i_out = 5'b11001;
      5'b10111: i_out = 5'b00110;
      5'b11000: i_out = 5'b10000;
      5'b11001: i_out = 5'b00010;
      5'b11010: i_out = 5'b10110;
      5'b11011: i_out = 5'b00111;
      5'b11100: i_out = 5'b11010;
      5'b11101: i_out = 5'b01010;
      5'b11110: i_out = 5'b00001;
      5'b11111: i_out = 5'b10010;
      default: i_out = 5'b00000;
   endcase
end
//
assign out = i_out;

endmodule