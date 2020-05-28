`default_nettype none

module io_input_mux(
    input [31: 0] a0, 
    input [31: 0] a1, 
    input [5: 0] addr, 
    output reg [31: 0] y
);
    // 一个输出长度为 32 位的多选器

    always
    begin
        case (addr)
            6'b100000: y = a0;
            6'b100001: y = a1;
            default: y = 32'h0;
        endcase
    end

endmodule