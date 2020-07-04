`default_nettype none

module alu (
    input [31: 0] a,
    input [31: 0] b,
    input [3: 0] aluc, 
    
    output reg [31: 0] res, 
    output reg is_zero
);
    // input：两个操作数，一个表示运算类型的控制信号
    // output：运算结果，结果是否为零的标志位

    always @ (a or b or aluc) 
    begin                                           // event
        casex (aluc)
            4'b0000: res = a + b;                   // 0000 ADD
            4'b1000: res = (b[0] + b[1] + b[2] + b[3] + b[4] + b[5] + b[6] + b[7] + b[8] + 
                b[9] + b[10] + b[11] + b[12] + b[13] + b[14] + b[15] + b[16] + b[17] +
                b[18] + b[19] + b[20] + b[21] + b[22] + b[23] + b[24] + 
                b[25] + b[26] + b[27] + b[28] + b[29] + b[30] + b[31]);                   // 1000 COUNT 
            4'bx100: res = a - b;                   // x100 SUB
            4'bx001: res = a & b;                   // x001 AND
            4'bx101: res = a | b;                   // x101 OR
            4'bx010: res = a ^ b;                   // x010 XOR
            4'bx110: res = b << 16;                 // x110 LUI: imm << 16bit   
            4'b0011: res = b << a;                  // 0011 SLL: rd <- (rt << sa)
            4'b0111: res = b >> a;                  // 0111 SRL: rd <- (rt >> sa) (logical)
            4'b1111: res = $signed(b) >>> a;        // 1111 SRA: rd <- (rt >> sa) (arithmetic)
            default: res = 0;
        endcase
        
        if (res == 0)  
            is_zero = 1;
        else 
            is_zero = 0;         
    end      
endmodule 