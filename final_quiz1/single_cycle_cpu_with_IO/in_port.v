`default_nettype none

module in_port(
    input sw0, 
    input sw1, 
    input sw2, 
    input sw3, 
    input sw4,
    output wire [31: 0] res
);
    // 模拟一个 I/O 输入设备
    // 在当前设定场景中，输入为 5 个 bit

    assign res[0] = sw0;
    assign res[1] = sw1;
    assign res[2] = sw2;
    assign res[3] = sw3;
    assign res[4] = sw4;
    assign res[31: 5] = 27'b0;

endmodule