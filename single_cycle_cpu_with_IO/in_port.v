module in_port(sw0, sw1, sw2, sw3, sw4, res);
    // 模拟一个 I/O 输入设备
    // 在当前设定场景中，输入为 5 个 bit

    input               sw0, sw1, sw2, sw3, sw4;
    // 拆位输入
    output  [31: 0]     res;
    // 扩展到 32 位输出

    wire    [31: 0]     res;
	
    assign res[0] = sw0;
    assign res[1] = sw1;
    assign res[2] = sw2;
    assign res[3] = sw3;
    assign res[4] = sw4;
    assign res[31: 5] = 27'b0;

endmodule