`default_nettype none

module pipe_stage_EXE(
    input [4: 0] EXE_original_write_reg_number,
    input [31: 0] EXE_pc_plus_4,
    input [31: 0] EXE_q1, 
    input [31: 0] EXE_q2, 
    input [31: 0] EXE_imm, 
    input [31: 0] EXE_shift_amount, 
    input [3: 0] EXE_aluc, 
    input EXE_aluimm, 
    input EXE_shift,
    input EXE_jal, 

    output wire [4: 0] EXE_write_reg_number, 
    output wire [31: 0] EXE_alu
);
    // EXE 级

    wire [31: 0] alua, alub, alu_res, is_zero;
    mux2x32 alu_a(EXE_q1, EXE_shift_amount, EXE_shift, alua);
    mux2x32 alu_b(EXE_q2, EXE_imm, EXE_aluimm, alub);
    alu al_unit(
        .a(alua),
        .b(alub),
        .aluc(EXE_aluc),
        .res(alu_res),
        .is_zero(is_zero)
    );
    // 进行 ALU 组合运算

    // wire [31: 0] EXE_pc_plus_8;
    // assign EXE_pc_plus_8 = EXE_pc_plus_4 + 4;
    mux2x32 link(alu_res, EXE_pc_plus_4, EXE_jal, EXE_alu);
    // 选择正确的输出
    // 使用 + 8 是有一个延迟槽。这里为了让仿真结果和图对比，不使用延迟槽。

    assign EXE_write_reg_number = EXE_original_write_reg_number | {5{EXE_jal}};
    // 如果是 jal 指令，需要改变写的目标    

endmodule