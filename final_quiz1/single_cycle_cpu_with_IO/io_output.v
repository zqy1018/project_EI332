`default_nettype none

module io_output(
    input [31: 0] addr, 
    input [31: 0] datain, 
    input write_io_enable, 
    input io_clk, 

    output reg [31: 0] out_port0
);
    // TODO: 添加一个 reset 信号
    // TODO: 尝试数组化

    always @ (posedge io_clk)
    begin
        if (write_io_enable == 1)
            case (addr[7: 2])
                6'b101010: out_port0 = datain;      // A8h
            endcase
    end

endmodule