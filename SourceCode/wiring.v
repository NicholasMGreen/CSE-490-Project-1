module wiring(
    input clk,
    input reset
);

    wire [15:0] pc_out;        // PC -> instruction memory
    wire [15:0] instr;         // instruction memory -> everything below
    
    // instruction field
    wire [3:0] opcode    = instr[15:12];
    wire [3:0] rt_rd     = instr[11:8];
    wire [3:0] rs        = instr[7:4];
    wire [3:0] func_code = instr[3:0];
    
    // control signals
    wire reg_write, mem_read, mem_write, branch;
    
    // data path
    wire [15:0] read_data_1;   // R[rs]    -> ALU x
    wire [15:0] read_data_2;   // R[rt/rd] -> ALU y
    wire [15:0] alu_result;    // ALU      -> register write data
    wire        alu_zero;
    
    
    // Instruction memory: intput the PC address in --> getting output as 16-bit instruction 
    instruction_memory call_instr_mem (
        .pc_address (pc_out),
        .instr      (instr)
    );
    
    // Control unit: input the opcode and function code, output with the control signals
    control_unit call_ctrl_u (
        .opcode    (opcode),
        .func_code (func_code),
        .reg_write (reg_write),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .branch    (branch)
    );
    
    // Register file: read rs and rt/rd, write result back into rt/rd
    register_file call_rf (
        .clk         (clk),
        .reset       (reset),
        .reg_write   (reg_write),
        .read_reg_1  (rs),
        .read_reg_2  (rt_rd),
        .write_reg   (rt_rd),
        .write_data  (alu_result),   // R-type: ALU result goes straight back
        .read_data_1 (read_data_1),
        .read_data_2 (read_data_2)
    );
    
    // ALU: x = R[rs], y = R[rt/rd]
    alu call_alu (
        .x         (read_data_1),
        .y         (read_data_2),    // later: mux between this and sign-extended imm
        .opcode    (opcode),
        .func_code (func_code),
        .result    (alu_result),
        .zero      (alu_zero)
    );
    
    // PC 
    pc call_pc (
        .clk    (clk),
        .reset    (reset),
        .load   (1'b0),        // currently not use yet during R-type (no branches yet)
        .target (16'd0),        // currently not use yet during R-tpe
        .pc     (pc_out)
    );
 
endmodule