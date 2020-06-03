module in_port(school_number, res);
    // 模拟一个 I/O 输入设备
    // 在当前设定场景中，输入为一个 32 位的数

    input [31: 0] school_number;
    // 拆位输入
    output  [31: 0]     res;
    // 扩展到 32 位输出

    wire    [31: 0]     res;
	
    assign res = school_number;

endmodule