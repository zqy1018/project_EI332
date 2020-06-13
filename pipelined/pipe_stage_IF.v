`default_nettype none

module pipe_stage_IF(
    input [1: 0] pcsource, 
    input [31: 0] branch_target, 
    input [31: 0] ID_q1, 
    input [31: 0] jump_target, 
    input mem_clock,
    input [31: 0] pc, 

    output wire [31: 0] pc_plus_4, 
    output wire [31: 0] next_pc,
    output wire [31: 0] inst 
);
    // 取指令阶段

    assign pc_plus_4 = pc + 4;

    mux4x32 next_pc_mux(pc_plus_4, branch_target, ID_q1, jump_target, pcsource, next_pc);
    // 为 0：PC + 4
    // 为 1：选择转移地址（beq, bne）
    // 为 2：选择寄存器地址（jr）
    // 为 3：选择跳转地址（j, jal）

    lpm_rom_irom irom (pc[7: 2], mem_clock, inst); 
    // 实际上只用了 8 位地址？
    // WARNING：不要擅自修改

endmodule