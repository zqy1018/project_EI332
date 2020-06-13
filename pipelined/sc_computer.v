`default_nettype none

module sc_computer(
    input resetn,
    input clock,
    input [4: 0] in_port0, 
    input [4: 0] in_port1, 
    
    output wire mem_clock,
    output wire [31: 0] out_port0, 
    output wire [31: 0] out_port1, 
    output wire [31: 0] out_port2,

    output wire [31: 0] output_pc, 
    output wire [31: 0] output_EXE_alu, 
    output wire [31: 0] output_MEM_alu, 
    output wire [31: 0] output_WB_alu, 
    output wire [31: 0] output_next_pc, 
    output wire [31: 0] output_inst, 
    output wire [31: 0] output_ins
    // TODO: 这部分用来观察的是不是可以直接删除？
);
    // 定义顶层模块 pipelined_computer，作为工程文件的顶层入口，如图 1-1 建立工程时指定。
    
    wire [31: 0] real_in_port0, real_in_port1;
    assign real_in_port0 = {27'b00000000000000000000000000, in_port0};
    assign real_in_port1 = {27'b00000000000000000000000000, in_port1};
    // 将原始输入经一定的转换后变为真正要用到的输入
    // 允许自定义

    wire [31: 0] raw_out_port0, raw_out_port1, raw_out_port2;
    assign out_port0 = raw_out_port0;
    assign out_port1 = raw_out_port1;
    assign out_port2 = raw_out_port2;
    // 将原始输出经一定的转换后输出
    // 允许自定义
   
    assign mem_clock = ~clock;
    // mem_clock 和 clock 同频率但反相
   
    wire [31: 0] pc, EXE_alu, MEM_alu, WB_alu;
    assign output_pc = pc;
    assign output_EXE_alu = EXE_alu;
    assign output_MEM_alu = MEM_alu;
    assign output_WB_alu = WB_alu;
    // 构建用于输出、观察的信号
    // TODO: 找出这些的作用。

    wire [31: 0] branch_target, jump_target, pc_plus_4, next_pc, inst, inst_stored;
    // 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。IF 取指令阶段。
    assign output_next_pc = next_pc;
    assign output_ins = inst;
    assign output_inst = inst_stored;
    // 模块用于仿真输出的观察信号。缺省为 wire 型。为了便于观察内部关键信号，将其接到
    // 输出管脚。不输出也一样，只是仿真时候要从内部信号里去寻找。

    wire [31: 0] ID_pc_plus_4, ID_q1, ID_q2, ID_imm, ID_shift_amount;
    // 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。ID 指令译码阶段。
    wire [31: 0] EXE_pc_plus_4, EXE_q1, EXE_q2, EXE_imm, EXE_shift_amount;
    // 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。EXE 指令运算阶段。
    wire [31: 0] MEM_datain, MEM_mem_out;
    // 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。MEM 访问数据阶段。
    wire [31: 0] WB_mem_out, WB_data_in;
    // 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。WB 回写寄存器阶段。
    wire [4: 0] EXE_original_write_reg_number, EXE_write_reg_number, ID_write_reg_number, MEM_write_reg_number, WB_write_reg_number;
    // 模块间互联，通过流水线寄存器传递结果寄存器号的信号线。
    wire [4: 0] ID_rs, ID_rt, EXE_rs, EXE_rt;
    // 模块间互联，通过流水线寄存器传递 rs、rt 寄存器号的信号线。
    wire [3: 0] ID_aluc,EXE_aluc;
    // ID 阶段向 EXE 阶段通过流水线寄存器传递的 aluc 控制信号。
    wire [1: 0] pcsource;
    // CU 模块向 IF 阶段模块传递的 PC 选择信号，2 bit。
    wire wpcir;
    // CU 模块发出的控制流水线停顿的控制信号，使 PC 和 IF/ID 流水线寄存器保持不变。
    // 认为低电平有效。
    wire ID_wreg, ID_m2reg, ID_wmem, ID_aluimm, ID_shift, ID_jal;
    // ID 阶段产生，需往后续流水级传播的信号。
    wire EXE_wreg, EXE_m2reg, EXE_wmem, EXE_aluimm, EXE_shift, EXE_jal;
    // 来自于 ID/EXE 流水线寄存器，EXE 阶段使用，或需要往后续流水级传播的信号。
    wire MEM_wreg, MEM_m2reg, MEM_wmem; 
    // 来自于 EXE/MEM 流水线寄存器，MEM 阶段使用，或需要往后续流水级传播的信号。
    wire WB_wreg, WB_m2reg; 
    // 来自于 MEM/WB 流水线寄存器，WB 阶段使用的信号。
    wire EXE_bubble, ID_bubble;
    // 模块间互联，通过流水线寄存器传递的流水线冒险处理 bubble 控制信号线
   
    pipe_reg_PC prog_cnt(
        .clock(clock), 
        .resetn(resetn), 
        .wpcir(wpcir), 
        .next_pc(next_pc), 

        .pc(pc)
    );
    // 程序计数器模块，是最前面一级 IF 流水段的输入。
    pipe_stage_IF IF_stage(
        .pcsource(pcsource), 
        .branch_target(branch_target), 
        .ID_q1(ID_q1), 
        .jump_target(jump_target), 
        .mem_clock(mem_clock), 
        .pc(pc), 

        .pc_plus_4(pc_plus_4), 
        .next_pc(next_pc), 
        .inst(inst)
    );
    // IF 取指令模块，注意其中包含的指令同步 ROM 存储器的同步信号，
    // 即输入给该模块的 mem_clock 信号，模块内定义为 rom_clk。
    // 实验中可采用系统 clock 的反相信号作为 mem_clock（亦即 rom_clock）,
    // 即留给信号半个节拍的传输时间。
    pipe_reg_IF_ID IF_ID_reg(
        .clock(clock), 
        .resetn(resetn), 
        .pc_plus_4(pc_plus_4), 
        .inst(inst), 
        .wpcir(wpcir), 

        .ID_pc_plus_4(ID_pc_plus_4), 
        .inst_stored(inst_stored)
    );
    // IF/ID 流水线寄存器模块，起承接 IF 阶段和 ID 阶段的流水任务。
    // 在 clock 上升沿时，将 IF 阶段需传递给 ID 阶段的信息（PC + 4 和指令），
    // 锁存在 IF/ID 流水线寄存器中，并呈现在 ID 阶段。
    pipe_stage_ID ID_stage(
        .resetn(resetn), 
        .mem_clock(mem_clock),          // 用于寄存器堆
        .ID_pc_plus_4(ID_pc_plus_4), 
        .inst_stored(inst_stored), 
        .WB_data_in(WB_data_in), 
        .WB_wreg(WB_wreg), 
        .WB_write_reg_number(WB_write_reg_number), 
        .EXE_wreg(EXE_wreg), 
        .MEM_wreg(MEM_wreg), 
        .MEM_write_reg_number(MEM_write_reg_number), 
        .EXE_write_reg_number(EXE_write_reg_number), 
        .EXE_m2reg(EXE_m2reg), 
        .MEM_m2reg(MEM_m2reg), 
        .EXE_alu(EXE_alu), 
        .MEM_alu(MEM_alu), 
        .MEM_mem_out(MEM_mem_out), 
        .EXE_bubble(EXE_bubble),

        .ID_rs(ID_rs),
        .ID_rt(ID_rt), 
        .ID_write_reg_number(ID_write_reg_number), 
        .ID_q1(ID_q1), 
        .ID_q2(ID_q2), 
        .ID_imm(ID_imm), 
        .ID_shift_amount(ID_shift_amount), 
        .branch_target(branch_target), 
        .jump_target(jump_target), 
        .ID_wreg(ID_wreg), 
        .ID_m2reg(ID_m2reg), 
        .ID_wmem(ID_wmem), 
        .ID_aluc(ID_aluc), 
        .ID_aluimm(ID_aluimm), 
        .ID_shift(ID_shift), 
        .ID_jal(ID_jal), 
        .pcsource(pcsource), 
        .wpcir(wpcir), 
        .ID_bubble(ID_bubble)
    ); 
    // ID 指令译码模块。注意其中包含控制器 CU、寄存器堆、及多个多路器等。
    // 其中的寄存器堆，会在系统 clock 的下沿进行寄存器写入，也就是给信号从 WB 阶段
    // 传输过来留有半个 clock 的延迟时间，亦即确保信号稳定。
    // 该阶段 CU 产生的、要传播到流水线后级的信号较多。
    pipe_reg_ID_EXE ID_EXE_reg(
        .clock(clock), 
        .resetn(resetn), 
        .ID_rs(ID_rs), 
        .ID_rt(ID_rt), 
        .ID_wreg(ID_wreg), 
        .ID_m2reg(ID_m2reg), 
        .ID_wmem(ID_wmem), 
        .ID_aluc(ID_aluc), 
        .ID_aluimm(ID_aluimm), 
        .ID_q1(ID_q1), 
        .ID_q2(ID_q2), 
        .ID_imm(ID_imm),
        .ID_shift_amount(ID_shift_amount), 
        .ID_write_reg_number(ID_write_reg_number), 
        .ID_shift(ID_shift), 
        .ID_jal(ID_jal), 
        .ID_pc_plus_4(ID_pc_plus_4), 
        .ID_bubble(ID_bubble),

        .EXE_rs(EXE_rs), 
        .EXE_rt(EXE_rt), 
        .EXE_wreg(EXE_wreg), 
        .EXE_m2reg(EXE_m2reg), 
        .EXE_wmem(EXE_wmem), 
        .EXE_aluc(EXE_aluc), 
        .EXE_aluimm(EXE_aluimm), 
        .EXE_q1(EXE_q1), 
        .EXE_q2(EXE_q2),
        .EXE_imm(EXE_imm),
        .EXE_shift_amount(EXE_shift_amount), 
        .EXE_original_write_reg_number(EXE_original_write_reg_number), 
        .EXE_shift(EXE_shift), 
        .EXE_jal(EXE_jal), 
        .EXE_pc_plus_4(EXE_pc_plus_4),
        .EXE_bubble(EXE_bubble)
    );
    // ID/EXE 流水线寄存器模块，起承接 ID 阶段和 EXE 阶段的流水任务。
    // 在 clock 上升沿时，将 ID 阶段需传递给 EXE 阶段的信息，锁存在 ID/EXE 流水线
    // 寄存器中，并呈现在 EXE 阶段。
    pipe_stage_EXE EXE_stage(
        .EXE_original_write_reg_number(EXE_original_write_reg_number), 
        .EXE_pc_plus_4(EXE_pc_plus_4), 
        .EXE_q1(EXE_q1), 
        .EXE_q2(EXE_q2), 
        .EXE_shift_amount(EXE_shift_amount), 
        .EXE_aluc(EXE_aluc), 
        .EXE_aluimm(EXE_aluimm), 
        .EXE_imm(EXE_imm), 
        .EXE_shift(EXE_shift), 
        .EXE_jal(EXE_jal), 

        .EXE_write_reg_number(EXE_write_reg_number), 
        .EXE_alu(EXE_alu)
    ); 
    // EXE 运算模块。其中包含 ALU 及多个多路器等。
    pipe_reg_EXE_MEM EXE_MEM_reg(
        .clock(clock), 
        .resetn(resetn), 
        .EXE_wreg(EXE_wreg), 
        .EXE_m2reg(EXE_m2reg), 
        .EXE_wmem(EXE_wmem), 
        .EXE_alu(EXE_alu), 
        .EXE_q2(EXE_q2), 
        .EXE_write_reg_number(EXE_write_reg_number), 

        .MEM_wreg(MEM_wreg), 
        .MEM_m2reg(MEM_m2reg), 
        .MEM_wmem(MEM_wmem), 
        .MEM_alu(MEM_alu), 
        .MEM_datain(MEM_datain), 
        .MEM_write_reg_number(MEM_write_reg_number)
    );
    // EXE/MEM 流水线寄存器模块，起承接 EXE 阶段和 MEM 阶段的流水任务。
    // 在 clock 上升沿时，将 EXE 阶段需传递给 MEM 阶段的信息，锁存在 EXE/MEM
    // 流水线寄存器中，并呈现在 MEM 阶段。
    pipe_stage_MEM MEM_stage(
        .mem_clock(mem_clock), 
        .resetn(resetn), 
        .MEM_wmem(MEM_wmem),
        .MEM_datain(MEM_datain), 
        .MEM_alu(MEM_alu), 
        .real_in_port0(real_in_port0),
        .real_in_port1(real_in_port1), 

        .MEM_mem_out(MEM_mem_out), 
        .raw_out_port0(raw_out_port0),  
        .raw_out_port1(raw_out_port1),  
        .raw_out_port2(raw_out_port2)
    );
    // MEM 数据存取模块。其中包含对数据同步 RAM 的读写访问。
    // 输入给该同步 RAM 的 mem_clock 信号，模块内定义为 ram_clk。
    // 实验中可采用系统 clock 的反相信号作为 mem_clock 信号（亦即 ram_clk）,
    // 即留给信号半个节拍的传输时间，然后在 mem_clock 上沿时，读输出、或写输入。
    pipe_reg_MEM_WB MEM_WB_reg(
        .clock(clock), 
        .resetn(resetn),
        .MEM_wreg(MEM_wreg), 
        .MEM_m2reg(MEM_m2reg), 
        .MEM_mem_out(MEM_mem_out), 
        .MEM_alu(MEM_alu), 
        .MEM_write_reg_number(MEM_write_reg_number), 

        .WB_wreg(WB_wreg), 
        .WB_m2reg(WB_m2reg), 
        .WB_mem_out(WB_mem_out), 
        .WB_alu(WB_alu), 
        .WB_write_reg_number(WB_write_reg_number)
    );        
    // MEM/WB 流水线寄存器模块，起承接 MEM 阶段和 WB 阶段的流水任务。
    // 在 clock 上升沿时，将 MEM 阶段需传递给 WB 阶段的信息，锁存在 MEM/WB
    // 流水线寄存器中，并呈现在 WB 阶段。
    mux2x32 WB_stage(
        .a0(WB_alu), 
        .a1(WB_mem_out), 
        .sel(WB_m2reg), 
        .y(WB_data_in)
    ); 
    // WB 写回阶段模块。
    // 该阶段的逻辑功能部件只包含一个多路器，所以可以仅用一个多路器的实例即可实现该部分。

endmodule
