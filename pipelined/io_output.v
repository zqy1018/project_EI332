`default_nettype none

module io_output(
    input [31: 0] addr, 
    input [31: 0] datain, 
    input write_io_enable, 
    input io_clk, 
    input resetn, 

    output reg [31: 0] out_port0, 
    output reg [31: 0] out_port1, 
    output reg [31: 0] out_port2
);
    // TODO: 添加一个 reset 信号
    // TODO: 尝试数组化

    always @ (posedge io_clk or negedge resetn)
    begin
        if (resetn == 0) begin
            out_port0 <= 0;
            out_port1 <= 0;
            out_port2 <= 0;
        end else if (write_io_enable == 1)
            case (addr[7: 2])
                6'b100000: out_port0 = datain;
                6'b100001: out_port1 = datain;
                6'b100010: out_port2 = datain;
            endcase
    end

endmodule