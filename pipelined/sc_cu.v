`default_nettype none

module sc_cu (
    input [5: 0] op, 
    input [5: 0] func, 
    input is_zero, 
    input EXE_bubble, 
    input EXE_wreg,
    input EXE_m2reg, 
    input [4: 0] ID_rs, 
    input [4: 0] ID_rt, 
    input [4: 0] EXE_write_reg_number, 
    input MEM_wreg, 
    input MEM_m2reg, 
    input [4: 0] MEM_write_reg_number, 

    output wire wmem,
    output wire wreg, 
    output wire m2reg, 
    output wire [3: 0] aluc, 
    output wire shift, 
    output wire aluimm, 
    output wire sext,
    output wire regrt, 
    output wire jal, 
    output wire [1: 0] pcsource, 
    output wire ID_bubble, 
    output wire wpcir, 
    output reg [1: 0] fwd_q1_sel, 
    output reg [1: 0] fwd_q2_sel
);
    // 控制单元。采用组合逻辑的方式产生控制信号（共 10 个）。

    wire r_type; 
    // 是否是 R 型指令
    
    assign r_type = ~|op;			
    // 或非运算，如果全是 0 就是 R 型指令
    
    wire i_add, i_sub, i_and, i_or, i_xor, i_sll, i_srl, i_sra, i_jr, i_addi;
    wire i_andi, i_ori, i_xori, i_lw, i_sw, i_beq, i_bne, i_lui, i_j , i_jal;
    // 目前实现的 20 条指令。允许额外添加。
    
    assign i_add = r_type && (func == 6'b100000);           // 100000
    assign i_sub = r_type && (func == 6'b100010);           // 100010
    assign i_and = r_type && (func == 6'b100100);           // 100100
    assign i_or  = r_type && (func == 6'b100101);           // 100101
    assign i_xor = r_type && (func == 6'b100110);           // 100110
    assign i_sll = r_type && (func == 6'b000000);           // 000000
    assign i_srl = r_type && (func == 6'b000010);           // 000010
    assign i_sra = r_type && (func == 6'b000011);           // 000011
    assign i_jr  = r_type && (func == 6'b001000);           // 001000
    // 以上为 R 型指令。

    assign i_addi = (op == 6'b001000);      // 001000
    assign i_andi = (op == 6'b001100);      // 001100
    assign i_ori  = (op == 6'b001101);      // 001101
    assign i_xori = (op == 6'b001110);      // 001110
    assign i_lui  = (op == 6'b001111);      // 001111
    assign i_lw   = (op == 6'b100011);      // 100011
    assign i_sw   = (op == 6'b101011);      // 101011
    assign i_beq  = (op == 6'b000100);      // 000100
    assign i_bne  = (op == 6'b000101);      // 000101
    // 以上为 I 型指令。

    assign i_j    = (op == 6'b000010);      // 000010
    assign i_jal  = (op == 6'b000011);      // 000011
    // 以上为 J 型指令。
    
    wire rs_read_reg, rt_read_reg;
    assign rs_read_reg = i_add | i_sub | i_and | i_or | i_xor | i_jr |
                         i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_beq | i_bne;
    // 为 1：本条指令读取 rs 寄存器
    assign rt_read_reg = i_add | i_sub | i_and | i_or | i_xor | i_sll | i_srl | i_sra | 
                         i_sw | i_beq | i_bne;
    // 为 1：本条指令读取 rt 寄存器
    assign wpcir = ~(EXE_wreg & EXE_m2reg & (EXE_write_reg_number != 0) &
            ((rs_read_reg & (EXE_write_reg_number == ID_rs)) |
             (rt_read_reg & (EXE_write_reg_number == ID_rt))));
    // 具有这种特征的都需要停下。
    // 目前只有 lw 导致的停顿。后面可能会有别的
    
    wire stall;
    assign stall = wpcir & ~EXE_bubble;
    assign ID_bubble = (pcsource != 2'b00);

    assign pcsource[0] = (( i_beq & is_zero ) | (i_bne & ~is_zero) | i_j | i_jal) & stall;
    assign pcsource[1] = (i_jr | i_j | i_jal) & stall;
    // 为 0：PC + 4
    // 为 1：选择转移地址（beq, bne）
    // 为 2：选择寄存器地址（jr）
    // 为 3：选择跳转地址（j, jal）
    // 在 ID 阶段处理控制冒险
   
    assign wreg =  (i_add | i_sub | i_and | i_or   | i_xor  |
                    i_sll | i_srl | i_sra | i_addi | i_andi |
                    i_ori | i_xori | i_lw | i_lui  | i_jal) & stall;
    // 为 1：写寄存器堆，否则不写
   
    assign aluc[3] = i_sra & stall;
    assign aluc[2] = (i_sub | i_or | i_srl | i_sra | i_ori | i_lui) & stall;
    assign aluc[1] = (i_xor | i_sll | i_srl | i_sra | i_xori | i_lui) & stall;
    assign aluc[0] = (i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori) & stall;
    // ALU 的控制信号，每种组合表示一种运算

    assign shift   = (i_sll | i_srl | i_sra) & stall;
    // 为 1：选择移位位数（shift amount）
    // 为 0：选择寄存器堆中的值

    assign aluimm  = (i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui) & stall;
    // 为 1：选择扩展后的立即数
    // 为 0：选择寄存器堆的数据

    assign sext    = (i_addi | i_lw | i_sw | i_beq | i_bne) & stall;
    // 为 1：做带符号扩展
    // 为 0：做零扩展

    assign wmem    = i_sw & stall;
    // 为 1：写存储器
    // 为 0：不写
   
    assign m2reg   = i_lw & stall;
    // 为 1：选择从存储器中读出的数据
    // 为 0：选择 ALU 的运算结果
    
    assign regrt   = (i_addi | i_andi | i_ori | i_xori | i_lw | i_lui) & stall;
    // 为 1：选择 rt 作为寄存器堆写入目标
    // 为 0：选择 rd 作为寄存器堆写入目标
   
    assign jal     = i_jal & stall;
    // 为 1：选择 PC + 4 stall
    // 为 0：选择 ALU 或者存储器数据作为写入寄存器堆的值

    always @ (*)
    begin
        fwd_q1_sel = 2'b00;
        if (EXE_wreg && (EXE_m2reg == 0) && 
            (EXE_write_reg_number != 0) && (EXE_write_reg_number == ID_rs))
            fwd_q1_sel = 2'b01;
        else if (MEM_wreg && 
            (MEM_write_reg_number != 0) && (MEM_write_reg_number == ID_rs)) begin
            if (MEM_m2reg == 0)
                fwd_q1_sel = 2'b10;
            else
                fwd_q1_sel = 2'b11;
        end
        
        fwd_q2_sel = 2'b00;
        if (EXE_wreg && (EXE_m2reg == 0) && 
            (EXE_write_reg_number != 0) && (EXE_write_reg_number == ID_rt))
            fwd_q2_sel = 2'b01;
        else if (MEM_wreg && 
            (MEM_write_reg_number != 0) && (MEM_write_reg_number == ID_rt)) begin
            if (MEM_m2reg == 0)
                fwd_q2_sel = 2'b10;
            else
                fwd_q2_sel = 2'b11;
        end
    end

endmodule