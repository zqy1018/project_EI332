module alu (a,b,aluc,s,z);
   input    [31:0]    a, b;
   input    [3:0]     aluc;
   output   [31:0]    s;
   output             z;
   reg      [31:0]    s;
   reg                z;
   always @ (a or b or aluc) 
      begin                                  // event
         casex (aluc)
            4'bx000: s = a + b;              //x000 ADD
            4'bx100: s = a - b;              //x100 SUB
            4'b0001: s = a & b;              //0001 AND
            4'b1001: 
               s = (a[0] ^ b[0]) +  
                  (a[1] ^ b[1]) +
                  (a[2] ^ b[2]) +
                  (a[3] ^ b[3]) +
                  (a[4] ^ b[4]) +
                  (a[5] ^ b[5]) +
                  (a[6] ^ b[6]) +
                  (a[7] ^ b[7]) +
                  (a[8] ^ b[8]) +
                  (a[9] ^ b[9]) +
                  (a[10] ^ b[10]) +
                  (a[11] ^ b[11]) +
                  (a[12] ^ b[12]) +
                  (a[13] ^ b[13]) +
                  (a[14] ^ b[14]) +
                  (a[15] ^ b[15]) +
                  (a[16] ^ b[16]) +
                  (a[17] ^ b[17]) +
                  (a[18] ^ b[18]) +
                  (a[19] ^ b[19]) +
                  (a[20] ^ b[20]) +
                  (a[21] ^ b[21]) +
                  (a[22] ^ b[22]) +
                  (a[23] ^ b[23]) +
                  (a[24] ^ b[24]) +
                  (a[25] ^ b[25]) +
                  (a[26] ^ b[26]) +
                  (a[27] ^ b[27]) +
                  (a[28] ^ b[28]) +
                  (a[29] ^ b[29]) +
                  (a[30] ^ b[30]) +
                  (a[31] ^ b[31]);            //1001 hamming distance
            4'bx101: s = a | b;              //x101 OR
            4'bx010: s = a ^ b;              //x010 XOR
            4'bx110: s = b << 16;            //x110 LUI: imm << 16bit   
            4'b0011: s = b << a;             //0011 SLL: rd <- (rt << sa)
            4'b0111: s = b >> a;             //0111 SRL: rd <- (rt >> sa) (logical)
            4'b1111: s = $signed(b) >>> a;   //1111 SRA: rd <- (rt >> sa) (arithmetic)
            default: s = 0;
         endcase
         if (s == 0)  
            z = 1;
         else 
            z = 0;         
      end      
endmodule 