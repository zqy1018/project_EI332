module io_input_mux(a0, a1, addr, y);
    // 一个输出长度为 32 位的多选器

    input   [31: 0]     a0, a1;
    input   [5: 0]      addr;

    output  [31: 0]     y;

    reg     [31: 0]     y;

    always
    begin
        case (addr)
            6'b100000:  y = a0;
            6'b100001:  y = a1;
            default:    y = 32'h0;
        endcase
    end

endmodule