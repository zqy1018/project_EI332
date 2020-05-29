`default_nettype none

module mux2x32 (
    input [31: 0] a0,
    input [31: 0] a1,
    input sel,
    output wire [31: 0] y
);
    // 32 位的二路多选器
   
    assign y = (sel ? a1 : a0);
   
endmodule