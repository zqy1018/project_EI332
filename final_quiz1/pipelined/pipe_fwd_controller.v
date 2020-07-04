`default_nettype none

module pipe_fwd_controller(
    input EXE_wreg,
    input MEM_wreg, 
    input EXE_m2reg, 
    input MEM_m2reg, 
    input [4: 0] ID_rs, 
    input [4: 0] ID_rt, 
    input [4: 0] EXE_write_reg_number, 
    input [4: 0] MEM_write_reg_number, 

    output reg [1: 0] fwd_q1_sel, 
    output reg [1: 0] fwd_q2_sel
);
    // 直通处理器

    always @ (*)
    begin
        fwd_q1_sel = 2'b00;
        if (EXE_wreg && (EXE_m2reg == 0) && 
            (EXE_write_reg_number != 0) && (EXE_write_reg_number == ID_rs))
            fwd_q1_sel = 2'b01;
        else if (MEM_wreg && 
            (MEM_write_reg_number != 0) && (MEM_write_reg_number == ID_rs)) 
            fwd_q1_sel = {1'b1, MEM_m2reg};
        
        fwd_q2_sel = 2'b00;
        if (EXE_wreg && (EXE_m2reg == 0) && 
            (EXE_write_reg_number != 0) && (EXE_write_reg_number == ID_rt))
            fwd_q2_sel = 2'b01;
        else if (MEM_wreg && 
            (MEM_write_reg_number != 0) && (MEM_write_reg_number == ID_rt)) 
            fwd_q2_sel = {1'b1, MEM_m2reg};
    end

endmodule