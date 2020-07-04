`default_nettype none

module pipe_reg_ID_EXE(
    input clock, 
    input resetn, 
    input [4: 0] ID_rs, 
    input [4: 0] ID_rt, 
    input [4: 0] ID_write_reg_number, 
    input [31: 0] ID_q1, 
    input [31: 0] ID_q2, 
    input [31: 0] ID_imm, 
    input [31: 0] ID_shift_amount, 
    input [31: 0] ID_pc_plus_4, 
    input ID_wreg, 
    input ID_m2reg, 
    input ID_wmem, 
    input [3: 0] ID_aluc, 
    input ID_aluimm, 
    input ID_jal, 
    input ID_shift, 
    input ID_bubble,

    output reg [31: 0] EXE_pc_plus_4, 
    output reg [4: 0] EXE_rs, 
    output reg [4: 0] EXE_rt,
    output reg [31: 0] EXE_q1, 
    output reg [31: 0] EXE_q2,
    output reg [31: 0] EXE_imm, 
    output reg [31: 0] EXE_shift_amount, 
    output reg EXE_wreg, 
    output reg EXE_m2reg, 
    output reg EXE_wmem, 
    output reg [3: 0] EXE_aluc, 
    output reg EXE_aluimm, 
    output reg EXE_shift, 
    output reg EXE_jal,
    output reg [4: 0] EXE_original_write_reg_number, 
    output reg EXE_bubble
);
    // ID/EXE 级流水线寄存器

    always @ (posedge clock or negedge resetn)
    begin
        if (resetn == 0) begin
            EXE_pc_plus_4 <= 0;
            EXE_rs <= 0;
            EXE_rt <= 0;
            EXE_q1 <= 0;
            EXE_q2 <= 0;
            EXE_imm <= 0;
            EXE_shift_amount <= 0;
            EXE_wreg <= 0;
            EXE_m2reg <= 0;
            EXE_wmem <= 0;
            EXE_aluc <= 0;
            EXE_aluimm <= 0;
            EXE_shift <= 0;
            EXE_jal <= 0;
            EXE_original_write_reg_number <= 0;
            EXE_bubble <= 0;
        end else begin
            EXE_pc_plus_4 <= ID_pc_plus_4;
            EXE_rs <= ID_rs;
            EXE_rt <= ID_rt;
            EXE_q1 <= ID_q1;
            EXE_q2 <= ID_q2;
            EXE_imm <= ID_imm;
            EXE_shift_amount <= ID_shift_amount;
            EXE_wreg <= ID_wreg;
            EXE_m2reg <= ID_m2reg;
            EXE_wmem <= ID_wmem;
            EXE_aluc <= ID_aluc;
            EXE_aluimm <= ID_aluimm;
            EXE_shift <= ID_shift;
            EXE_jal <= ID_jal;
            EXE_original_write_reg_number <= ID_write_reg_number;
            EXE_bubble <= ID_bubble;
        end 
    end

endmodule