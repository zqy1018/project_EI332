module io_output(addr, datain, write_io_enable, io_clk, out_port0);
    // TODO: 添加一个 reset 信号
    input   [31: 0]     addr, datain;
    input               write_io_enable, io_clk;

    output  [31: 0]     out_port0;
    // 三个输出端口

    reg     [31: 0]     out_port0;
    // TODO: 尝试数组化

    always @ (posedge io_clk)
    begin
        if (write_io_enable == 1)
            case (addr[7: 2])
                6'b100000: out_port0 = datain;
            endcase
    end

endmodule