//==================================================================================================
//
// Author: Martin Schmid
// Copyright (c) University of Passau
// Chair of Computer Engineering, Professorship for Secure Intelligent Systems
// 2024
//
//==================================================================================================
module sbox_masked(
    input wire clk,
    input wire [4:0] in_a,
    input wire [4:0] in_b,
    input wire [19:0] z,
    output wire [4:0] out_a,
    output wire [4:0] out_b
);

// Internal nets
//
wire i_f0_a [6:0];
wire i_f0_b [6:0];
//
wire i_f1_a [5:0];
wire i_f1_b [5:0];
//
wire i_f2_a [6:0];
wire i_f2_b [6:0];
//
wire i_f3_a [6:0];
wire i_f3_b [6:0];
//
wire i_f4_a [1:0];
wire i_f4_b [1:0];

// f0
//
// x0x1 + x2
dom_and_xor u_f0_1(
    .clk(clk),
    .x_a({in_a[0], in_a[1], in_a[2]}),
    .x_b({in_b[0], in_b[1], in_b[2]}),
    .z(z[0]),
    .y_a(i_f0_a[0]),
    .y_b(i_f0_b[0])
);
//
// ... + x1x2
dom_and_xor u_f0_2(
    .clk(clk),
    .x_a({in_a[1], in_a[2], i_f0_a[0]}),
    .x_b({in_b[1], in_b[2], i_f0_b[0]}),
    .z(z[1]),
    .y_a(i_f0_a[1]),
    .y_b(i_f0_b[1])
);
//
// ... + x1x3
dom_and_xor u_f0_3(
    .clk(clk),
    .x_a({in_a[1], in_a[3], i_f0_a[1]}),
    .x_b({in_b[1], in_b[3], i_f0_b[1]}),
    .z(z[2]),
    .y_a(i_f0_a[2]),
    .y_b(i_f0_b[2])
);
//
// ... + x1x4
dom_and_xor u_f0_4(
    .clk(clk),
    .x_a({in_a[1], in_a[4], i_f0_a[2]}),
    .x_b({in_b[1], in_b[4], i_f0_b[2]}),
    .z(z[3]),
    .y_a(i_f0_a[3]),
    .y_b(i_f0_b[3])
);
//
// ... + x2x4
dom_and_xor u_f0_5(
    .clk(clk),
    .x_a({in_a[2], in_a[4], i_f0_a[3]}),
    .x_b({in_b[2], in_b[4], i_f0_b[3]}),
    .z(z[4]),
    .y_a(i_f0_a[4]),
    .y_b(i_f0_b[4])
);
//
// ... + x3x4
dom_and_xor u_f0_6(
    .clk(clk),
    .x_a({in_a[3], in_a[4], i_f0_a[4]}),
    .x_b({in_b[3], in_b[4], i_f0_b[4]}),
    .z(z[5]),
    .y_a(i_f0_a[5]),
    .y_b(i_f0_b[5])
);
//
// ... + x4
assign i_f0_a[6] = i_f0_a[5] ^ in_a[4];
assign i_f0_b[6] = i_f0_b[5] ^ in_b[4];
//
// Output
assign out_a[0] = i_f0_a[6];
assign out_b[0] = i_f0_b[6];


// f1
//
// x0x1 + x1
dom_and_xor u_f1_1(
    .clk(clk),
    .x_a({in_a[0], in_a[1], in_a[1]}),
    .x_b({in_b[0], in_b[1], in_b[1]}),
    .z(z[6]),
    .y_a(i_f1_a[0]),
    .y_b(i_f1_b[0])
);
//
// ... + x0x2
dom_and_xor u_f1_2(
    .clk(clk),
    .x_a({in_a[0], in_a[2], i_f1_a[0]}),
    .x_b({in_b[0], in_b[2], i_f1_b[0]}),
    .z(z[7]),
    .y_a(i_f1_a[1]),
    .y_b(i_f1_b[1])
);
//
// ... + x2x3
dom_and_xor u_f1_3(
    .clk(clk),
    .x_a({in_a[2], in_a[3], i_f1_a[1]}),
    .x_b({in_b[2], in_b[3], i_f1_b[1]}),
    .z(z[8]),
    .y_a(i_f1_a[2]),
    .y_b(i_f1_b[2])
);
//
// ... + x0x4
dom_and_xor u_f1_4(
    .clk(clk),
    .x_a({in_a[0], in_a[4], i_f1_a[2]}),
    .x_b({in_b[0], in_b[4], i_f1_b[2]}),
    .z(z[9]),
    .y_a(i_f1_a[3]),
    .y_b(i_f1_b[3])
);
//
// ... + x3x4
dom_and_xor u_f1_5(
    .clk(clk),
    .x_a({in_a[3], in_a[4], i_f1_a[3]}),
    .x_b({in_b[3], in_b[4], i_f1_b[3]}),
    .z(z[10]),
    .y_a(i_f1_a[4]),
    .y_b(i_f1_b[4])
);
//
// ... + x4
assign i_f1_a[5] = i_f1_a[4] ^ in_a[4];
assign i_f1_b[5] = i_f1_b[4] ^ in_b[4];
//
// Output
assign out_a[1] = i_f1_a[5];
assign out_b[1] = i_f1_b[5];


// f2
//
// x1x2 + x3
dom_and_xor u_f2_1(
    .clk(clk),
    .x_a({in_a[1], in_a[2], in_a[3]}),
    .x_b({in_b[1], in_b[2], in_b[3]}),
    .z(z[11]),
    .y_a(i_f2_a[0]),
    .y_b(i_f2_b[0])
);
//
// ... + x0x3
dom_and_xor u_f2_2(
    .clk(clk),
    .x_a({in_a[0], in_a[3], i_f2_a[0]}),
    .x_b({in_b[0], in_b[3], i_f2_b[0]}),
    .z(z[12]),
    .y_a(i_f2_a[1]),
    .y_b(i_f2_b[1])
);
//
// ... + x2x3
dom_and_xor u_f2_3(
    .clk(clk),
    .x_a({in_a[2], in_a[3], i_f2_a[1]}),
    .x_b({in_b[2], in_b[3], i_f2_b[1]}),
    .z(z[13]),
    .y_a(i_f2_a[2]),
    .y_b(i_f2_b[2])
);
// ... + x0
assign i_f2_a[3] = i_f2_a[2] ^ in_a[0];
assign i_f2_b[3] = i_f2_b[2] ^ in_b[0];
// ... + x1
assign i_f2_a[4] = i_f2_a[3] ^ in_a[1];
assign i_f2_b[4] = i_f2_b[3] ^ in_b[1];
// ... + x2
assign i_f2_a[5] = i_f2_a[4] ^ in_a[2];
assign i_f2_b[5] = i_f2_b[4] ^ in_b[2];
// ... + x4
assign i_f2_a[6] = i_f2_a[5] ^ in_a[4];
assign i_f2_b[6] = i_f2_b[5] ^ in_b[4];
//
// Output
assign out_a[2] = i_f2_a[6];
assign out_b[2] = i_f2_b[6];


// f3
//
// x1x2 + x3
dom_and_xor u_f3_1(
    .clk(clk),
    .x_a({in_a[1], in_a[2], in_a[3]}),
    .x_b({in_b[1], in_b[2], in_b[3]}),
    .z(z[14]),
    .y_a(i_f3_a[0]),
    .y_b(i_f3_b[0])
);
//
// ... + x0x3
dom_and_xor u_f3_2(
    .clk(clk),
    .x_a({in_a[0], in_a[3], i_f3_a[0]}),
    .x_b({in_b[0], in_b[3], i_f3_b[0]}),
    .z(z[15]),
    .y_a(i_f3_a[1]),
    .y_b(i_f3_b[1])
);
//
// ... + x0x4
dom_and_xor u_f3_3(
    .clk(clk),
    .x_a({in_a[0], in_a[4], i_f3_a[1]}),
    .x_b({in_b[0], in_b[4], i_f3_b[1]}),
    .z(z[16]),
    .y_a(i_f3_a[2]),
    .y_b(i_f3_b[2])
);
// ... + x1x4
dom_and_xor u_f3_4(
    .clk(clk),
    .x_a({in_a[1], in_a[4], i_f3_a[2]}),
    .x_b({in_b[1], in_b[4], i_f3_b[2]}),
    .z(z[17]),
    .y_a(i_f3_a[3]),
    .y_b(i_f3_b[3])
);
// ... + x1
assign i_f3_a[4] = i_f3_a[3] ^ in_a[1];
assign i_f3_b[4] = i_f3_b[3] ^ in_b[1];
// ... + x2
assign i_f3_a[5] = i_f3_a[4] ^ in_a[2];
assign i_f3_b[5] = i_f3_b[4] ^ in_b[2];
// ... + x4
assign i_f3_a[6] = i_f3_a[5] ^ in_a[4];
assign i_f3_b[6] = i_f3_b[5] ^ in_b[4];
//
// Output
assign out_a[3] = i_f3_a[6];
assign out_b[3] = i_f3_b[6];


// f4
//
// x1x2 + x3
dom_and_xor u_f4_1(
    .clk(clk),
    .x_a({in_a[1], in_a[2], in_a[3]}),
    .x_b({in_b[1], in_b[2], in_b[3]}),
    .z(z[18]),
    .y_a(i_f4_a[0]),
    .y_b(i_f4_b[0])
);
//
// ... + x0x4
dom_and_xor u_f4_2(
    .clk(clk),
    .x_a({in_a[0], in_a[4], i_f4_a[0]}),
    .x_b({in_b[0], in_b[4], i_f4_b[0]}),
    .z(z[19]),
    .y_a(i_f4_a[1]),
    .y_b(i_f4_b[1])
);
//
// Output
assign out_a[4] = i_f4_a[1];
assign out_b[4] = i_f4_b[1];

endmodule