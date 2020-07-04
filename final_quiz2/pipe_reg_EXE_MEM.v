`default_nettype none

module pipe_reg_EXE_MEM(
    input clock, 
    input resetn, 
    input EXE_wreg, 
    input EXE_m2reg, 
    input EXE_wmem, 
    input [31: 0] EXE_alu, 
    input [31: 0] EXE_q2, 
    input [4: 0] EXE_write_reg_number, 

    output reg MEM_wreg, 
    output reg MEM_m2reg, 
    output reg MEM_wmem, 
    output reg [31: 0] MEM_alu, 
    output reg [31: 0] MEM_datain, 
    output reg [4: 0] MEM_write_reg_number
);
    // EXE/MEM 级流水线寄存器

    always @ (posedge clock or negedge resetn)
    begin
        if (resetn == 0) begin
            MEM_wreg <= 0;
            MEM_m2reg <= 0;
            MEM_wmem <= 0;
            MEM_alu <= 0;
            MEM_datain <= 0;
            MEM_write_reg_number <= 0;
        end else begin
            MEM_wreg <= EXE_wreg;
            MEM_m2reg <= EXE_m2reg;
            MEM_wmem <= EXE_wmem;
            MEM_alu <= EXE_alu;
            MEM_datain <= EXE_q2;
            MEM_write_reg_number <= EXE_write_reg_number;
        end 
    end

endmodule