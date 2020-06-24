module sc_cu (op, func, z, wmem, wreg, regrt, m2reg, aluc, shift,
              aluimm, pcsource, jal, sext);
   input  [5:0] op, func;
   input        z;
   output       wreg, regrt, jal, m2reg, shift, aluimm, sext, wmem;
   output [3:0] aluc;
   output [1:0] pcsource;
   wire r_type = ~|op;			// 或非运算，判断是否是 R 型指令
   wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
                  ~func[2] & ~func[1] & ~func[0];           // 100000
   wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
                  ~func[2] &  func[1] & ~func[0];           // 100010
      
   //  please complete the deleted code.
   
   wire i_and = r_type & func[5] & ~func[4] & ~func[3] & 
                  func[2] & ~func[1] & ~func[0];            // 100100
   wire i_or  = r_type & func[5] & ~func[4] & ~func[3] & 
                  func[2] & ~func[1] & func[0];             // 100101
   wire i_xor = r_type & func[5] & ~func[4] & ~func[3] & 
                  func[2] & func[1] & ~func[0];             // 100110
   wire i_sll = r_type & ~func[5] & ~func[4] & ~func[3] & 
                  ~func[2] & ~func[1] & ~func[0];           // 000000
   wire i_srl = r_type & ~func[5] & ~func[4] & ~func[3] & 
                  ~func[2] & func[1] & ~func[0];            // 000010
   wire i_sra = r_type & ~func[5] & ~func[4] & ~func[3] & 
                  ~func[2] & func[1] & func[0];             // 000011
   wire i_jr  = r_type & ~func[5] & ~func[4] & func[3] & 
                  ~func[2] & ~func[1] & ~func[0];           // 001000
                
   wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];   // 001000
   wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0];   // 001100
   
   wire i_ori  = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & op[0];      // 001101
   wire i_xori = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & ~op[0];      // 001110
   wire i_lw   = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];      // 100011
   wire i_sw   = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];       // 101011
   wire i_beq  = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];    // 000100
   wire i_bne  = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];     // 000101
   wire i_lui  = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & op[0];       // 001111
   wire i_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0];    // 000010
   wire i_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];     // 000011
   
  
   assign pcsource[1] = i_jr | i_j | i_jal;
   assign pcsource[0] = ( i_beq & z ) | (i_bne & ~z) | i_j | i_jal ;
   // 为 0：PC + 4
   // 为 1：选择转移地址
   // 为 2：选择寄存器地址
   // 为 3：选择跳转地址
   
   assign wreg = i_add | i_sub | i_and | i_or   | i_xor  |
                 i_sll | i_srl | i_sra | i_addi | i_andi |
                 i_ori | i_xori | i_lw | i_lui  | i_jal;
   // 为 1：写寄存器堆，否则不写
   
   assign aluc[3] = i_sra;
   assign aluc[2] = i_sub | i_or | i_srl | i_sra | i_ori | i_lui;
   assign aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_lui | i_beq | i_bne;
   assign aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori;
   // ALU 的控制信号，每种组合表示一种运算

   assign shift   = i_sll | i_srl | i_sra;
   // 为 1：选择移位位数（shift amount）
   // 为 0：选择寄存器堆中的值

   assign aluimm  = i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui;
   // 为 1：选择扩展后的立即数
   // 为 0：选择寄存器堆的数据

   assign sext    = i_addi | i_lw | i_sw | i_beq | i_bne;
   // 为 1：做带符号扩展
   // 为 0：做零扩展

   assign wmem    = i_sw;
   // 为 1：写存储器
   // 为 0：不写
   
   assign m2reg   = i_lw;
   // 为 1：选择从存储器中读出的数据
   // 为 0：选择 ALU 的运算结果
   
   assign regrt   = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui;
   // 为 1：选择 rt 作为寄存器堆写入目标
   // 为 0：选择 rd 作为寄存器堆写入目标
   
   assign jal     = i_jal;
   // 为 1：选择 PC + 4 作为写入寄存器堆的值
   // 为 0：选择 ALU 或者存储器数据作为写入寄存器堆的值

endmodule