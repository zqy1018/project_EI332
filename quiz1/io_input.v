module io_input(addr, io_clk, io_read_data, in_port0);
    // TODO: 添加一个 reset 信号
    
    input   [31: 0]     addr;
    input               io_clk;
    input   [31: 0]     in_port0;

    output  [31: 0]     io_read_data;
    // 输出从 I/O 得到的数据

    reg     [31: 0]     in_reg0;
    reg     [31: 0]     io_read_data;
    // TODO: 尝试数组化

    initial
    begin
        in_reg0 <= 32'b0;
    end

    always @ (posedge io_clk)
    begin
        in_reg0 <= in_port0;
    end

    always @ (*)
    begin
        case (addr[7: 2])
            6'b100100:  io_read_data = in_reg0;
            // 读 90h 端口的时候选择这一输入
            default:    io_read_data = 32'b0;
        endcase
    end

endmodule