`default_nettype none

module io_input(
    input [31: 0] addr, 
    input io_clk, 
    input resetn, 
    input [31: 0] in_port0, 
    input [31: 0] in_port1, 
    
    output wire [31: 0] io_read_data
);
    // I/O 输入部分

    io_input_mux io_input_mux2x32(
        .a0(in_reg0), 
        .a1(in_reg1), 
        .addr(addr[7: 2]), 
        .y(io_read_data)
    );

    reg [31: 0] in_reg0, in_reg1;

    always @ (posedge io_clk or negedge resetn)
    begin
        if (resetn == 0) begin
            in_reg0 <= 0;
            in_reg1 <= 0;
        end else begin
            in_reg0 <= in_port0;
            in_reg1 <= in_port1;
        end
    end

endmodule