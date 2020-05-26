module io_input(addr, io_clk, io_read_data, in_port0, in_port1);
    // TODO: 添加一个 reset 信号
    
    input   [31: 0]     addr;
    input               io_clk;
    input   [31: 0]     in_port0, in_port1;

    output  [31: 0]     io_read_data;
    // 输出从 I/O 得到的数据

    reg     [31: 0]     in_reg0;
    reg     [31: 0]     in_reg1;
    // TODO: 尝试数组化

    io_input_mux        io_input_mux2x32(in_reg0, in_reg1, addr[7: 2], io_read_data);

    initial
    begin
        in_reg0 <= 32'b0;
        in_reg1 <= 32'b0;
    end

    always @ (posedge io_clk)
    begin
        in_reg0[31: 5] <= 27'b0;
        in_reg1[31: 5] <= 27'b0;
        in_reg0[4: 0] <= in_port0[4: 0];
        in_reg1[4: 0] <= in_port1[4: 0];
    end

endmodule