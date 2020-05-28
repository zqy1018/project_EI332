`default_nettype none

module io_input(
    input [31: 0] addr, 
    input io_clk, 
    input [31: 0] in_port0, in_port1, 
    output wire [31: 0] io_read_data, 
    output reg [31: 0] in_reg0, 
    output reg [31: 0] in_reg1
);
    // I/O 输入部分
    // TODO: 添加一个 reset 信号
    // TODO: 尝试数组化

    io_input_mux io_input_mux2x32(
        .a0(in_reg0), 
        .a1(in_reg1), 
        .addr(addr[7: 2]), 
        .y(io_read_data)
    );

    initial
    begin
        in_reg0 <= 32'b0;
        in_reg1 <= 32'b0;
    end

    always @ (posedge io_clk)
    begin
        in_reg0[31: 5] <= 27'b0;
        in_reg1[31: 5] <= 27'b0;
        // TODO: 但这么做似乎没用
        in_reg0[4: 0] <= in_port0[4: 0];
        in_reg1[4: 0] <= in_port1[4: 0];
    end

endmodule