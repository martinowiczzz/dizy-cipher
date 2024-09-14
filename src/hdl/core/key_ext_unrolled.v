`include "params_dizy.vh"

//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
//
// Extends the 80/128-bit key such that it can directly be applied to the 120/160-bit state in
// DIZY-80/128. Outputs the application of the upper and lower key half
// at the same time, to be used in unrolled implementations
module key_ext_unrolled#(
   parameter integer SIZE_STATE = `SIZE_STATE,
   parameter integer SIZE_KEY = `SIZE_KEY
) (
   input wire [SIZE_KEY-1:0] key,
   input wire [2:0] rnd_cnt,
   output wire [SIZE_STATE-1:0] key_ext_upper,
   output wire [SIZE_STATE-1:0] key_ext_lower
);

// Internal nets
//
reg [SIZE_STATE-1:0] i_key_ext_upper;
reg [SIZE_STATE-1:0] i_key_ext_lower;

// Extend key
//
`ifdef DIZY_80
always @* begin
   if (rnd_cnt == 0) begin
      i_key_ext_upper = {
         key[79:78], 3'd0,
         key[77:76], 3'd0,
         key[75:74], 3'd0,
         key[73:72], 3'd0,
         key[71:70], 3'd0,
         key[69:68], 3'd0,
         key[67:66], 3'd0,
         key[65:64], 3'd0,
         key[63:62], 3'd0,
         key[61:60], 3'd0,
         key[59:58], 3'd0,
         key[57:56], 3'd0,
         key[55:54], 3'd0,
         key[53:52], 3'd0,
         key[51:50], 3'd0,
         key[49:48], 3'd0,
         key[47:46], 3'd0,
         key[45:44], 3'd0,
         key[43:42], 3'd0,
         key[41:40], 3'd0,
         key[39:38], 3'd0,
         key[37:36], 3'd0,
         key[35:34], 3'd0,
         key[33:32], 3'd0
      };
      i_key_ext_lower = {
         key[31:30], 3'd0,
         key[29:28], 3'd0,
         key[27:26], 3'd0,
         key[25:24], 3'd0,
         key[23:22], 3'd0,
         key[21:20], 3'd0,
         key[19:18], 3'd0,
         key[17:16], 3'd0,
         key[15:14], 3'd0,
         key[13:12], 3'd0,
         key[11:10], 3'd0,
         key[9:8], 3'd0,
         key[7:6], 3'd0,
         key[5:4], 3'd0,
         key[3:2], 3'd0,
         key[1:0], 3'd0,
         40'd0
      };
   end else begin
      i_key_ext_upper = 0;
      i_key_ext_lower = 0;
   end
end
`else
always @* begin
   if (rnd_cnt == 0) begin
      i_key_ext_upper = {
         key[127:126], 3'd0,
         key[125:124], 3'd0,
         key[123:122], 3'd0,
         key[121:120], 3'd0,
         key[119:118], 3'd0,
         key[117:116], 3'd0,
         key[115:114], 3'd0,
         key[113:112], 3'd0,
         key[111:110], 3'd0,
         key[109:108], 3'd0,
         key[107:106], 3'd0,
         key[105:104], 3'd0,
         key[103:102], 3'd0,
         key[101:100], 3'd0,
         key[99:98], 3'd0,
         key[97:96], 3'd0,
         key[95:94], 3'd0,
         key[93:92], 3'd0,
         key[91:90], 3'd0,
         key[89:88], 3'd0,
         key[87:86], 3'd0,
         key[85:84], 3'd0,
         key[83:82], 3'd0,
         key[81:80], 3'd0,
         key[79:78], 3'd0,
         key[77:76], 3'd0,
         key[75:74], 3'd0,
         key[73:72], 3'd0,
         key[71:70], 3'd0,
         key[69:68], 3'd0,
         key[67:66], 3'd0,
         key[65:64], 3'd0
      };
      i_key_ext_lower = {
         key[63:62], 3'd0,
         key[61:60], 3'd0,
         key[59:58], 3'd0,
         key[57:56], 3'd0,
         key[55:54], 3'd0,
         key[53:52], 3'd0,
         key[51:50], 3'd0,
         key[49:48], 3'd0,
         key[47:46], 3'd0,
         key[45:44], 3'd0,
         key[43:42], 3'd0,
         key[41:40], 3'd0,
         key[39:38], 3'd0,
         key[37:36], 3'd0,
         key[35:34], 3'd0,
         key[33:32], 3'd0,
         key[31:30], 3'd0,
         key[29:28], 3'd0,
         key[27:26], 3'd0,
         key[25:24], 3'd0,
         key[23:22], 3'd0,
         key[21:20], 3'd0,
         key[19:18], 3'd0,
         key[17:16], 3'd0,
         key[15:14], 3'd0,
         key[13:12], 3'd0,
         key[11:10], 3'd0,
         key[9:8], 3'd0,
         key[7:6], 3'd0,
         key[5:4], 3'd0,
         key[3:2], 3'd0,
         key[1:0], 3'd0
      };
   end else begin
      i_key_ext_upper = 0;
      i_key_ext_lower = 0;
   end
end
`endif
//
assign key_ext_upper = i_key_ext_upper;
assign key_ext_lower = i_key_ext_lower;

endmodule