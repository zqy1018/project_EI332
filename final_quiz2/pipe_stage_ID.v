`default_nettype none

module pipe_stage_ID(
    input mem_clock, 
    input resetn, 
    input [31: 0] ID_pc_plus_4, 
    input [31: 0] inst_stored, 
    input [31: 0] WB_data_in, 
    input WB_wreg,
    input EXE_wreg,
    input MEM_wreg, 
    input EXE_m2reg, 
    input MEM_m2reg, 
    input [4: 0] EXE_write_reg_number,
    input [4: 0] MEM_write_reg_number,
    input [4: 0] WB_write_reg_number,
    input [31: 0] EXE_alu, 
    input [31: 0] MEM_alu, 
    input [31: 0] MEM_mem_out,
    input EXE_bubble, 

    output wire wpcir,
    output wire ID_wreg, 
    output wire ID_wmem, 
    output wire [3: 0] ID_aluc, 
    output wire ID_m2reg, 
    output wire ID_aluimm,
    output wire ID_shift, 
    output wire ID_jal, 
    output wire [31: 0] ID_q1, 
    output wire [31: 0] ID_q2, 
    output wire [31: 0] ID_imm, 
    output wire [31: 0] ID_shift_amount, 
    output wire [1: 0] pcsource, 
    output wire [4: 0] ID_write_reg_number, 
    output wire [31: 0] branch_target, 
    output wire [31: 0] jump_target, 
    output wire [4: 0] ID_rs, 
    output wire [4: 0] ID_rt, 
    output wire ID_bubble
);
    // ID 阶段

    assign ID_rs = inst_stored[25: 21];
    assign ID_rt = inst_stored[20: 16];
    assign ID_shift_amount = {27'b0, inst_stored[10: 6]};

    wire signed_bit, sext;
    assign signed_bit = (sext & inst_stored[15]); 
    assign ID_imm = {{16{signed_bit}}, inst_stored[15: 0]};
    // 处理符号扩展

    wire rsrtequ;
    wire [31: 0] branch_offset;
    assign rsrtequ = (ID_q1 == ID_q2);
    assign branch_offset = {{13{signed_bit}}, inst_stored[15: 0], 2'b0};
    assign branch_target = ID_pc_plus_4 + branch_offset;
    // 判断 rs、rt 的值是否相等，并计算分支地址

    assign jump_target = {ID_pc_plus_4[31: 28], inst_stored[25: 0], 2'b0};
    // 计算跳转地址

    wire regrt;
    mux2x5 write_reg_number_mux(
        .a0(inst_stored[15: 11]),       // rd
        .a1(inst_stored[20: 16]),       // rt
        .s(regrt), 

        .y(ID_write_reg_number)
    );
    // 确定本条指令要写入的寄存器号

    wire [31: 0] q1, q2;
    wire [1: 0] fwd_q1_sel, fwd_q2_sel;
    regfile register_file(
        .reg_n1(inst_stored[25: 21]), 
        .reg_n2(inst_stored[20: 16]), 
        .d(WB_data_in),
        .write_reg_number(WB_write_reg_number),
        .write_enable(WB_wreg), 
        .clk(mem_clock), 
        .clrn(resetn), 

        .q1(q1), 
        .q2(q2)
    );
    mux4x32 fwd_mux1(q1, EXE_alu, MEM_alu, MEM_mem_out, fwd_q1_sel, ID_q1);
    mux4x32 fwd_mux2(q2, EXE_alu, MEM_alu, MEM_mem_out, fwd_q2_sel, ID_q2);
    // 采用直通，对 ID_q1，ID_q2 选择！
    
    sc_cu control_unit(
        .op(inst_stored[31: 26]), 
        .func(inst_stored[5: 0]), 
        .is_zero(rsrtequ),
        .EXE_bubble(EXE_bubble),
        .EXE_write_reg_number(EXE_write_reg_number), 
        .ID_rs(inst_stored[25: 21]), 
        .ID_rt(inst_stored[20: 16]),
        .EXE_wreg(EXE_wreg), 
        .EXE_m2reg(EXE_m2reg),

        .wmem(ID_wmem), 
        .wreg(ID_wreg), 
        .aluc(ID_aluc), 
        .m2reg(ID_m2reg),
        .aluimm(ID_aluimm), 
        .sext(sext), 
        .jal(ID_jal), 
        .shift(ID_shift),
        .pcsource(pcsource), 
        .regrt(regrt), 
        .ID_bubble(ID_bubble),
        .wpcir(wpcir)
    );
    // 利用原有的 sc_cu 模块
    // bubble 均为低电平有效

    pipe_fwd_controller pfc(
        .EXE_wreg(EXE_wreg), 
        .MEM_wreg(MEM_wreg), 
        .EXE_m2reg(EXE_m2reg), 
        .MEM_m2reg(MEM_m2reg), 
        .ID_rs(inst_stored[25: 21]), 
        .ID_rt(inst_stored[20: 16]),
        .EXE_write_reg_number(EXE_write_reg_number), 
        .MEM_write_reg_number(MEM_write_reg_number),
        
        .fwd_q1_sel(fwd_q1_sel), 
        .fwd_q2_sel(fwd_q2_sel)
    );

endmodule