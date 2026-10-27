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
    wire reg_write, mem_read, mem_write, branch, alu_src, jump, memto_reg;
    wire [15:0] dm_read_data;          // data memory output
    wire [15:0] write_back;            // memto_reg mux output
    wire [15:0] pc_plus2;              // PC + 2, branch/jump need to start with 2
    wire [15:0] offset;                // branch or jump shift ammount
    wire [15:0] branch_target;         // pc_plus2 + offset
    wire pc_load;                      //shif yes or no
    wire [15:0] jump_imm;          // 12-bit sign-extended jump immediate
    
    // data path
    wire [15:0] read_data_1;   // R[rs]    -> ALU x
    wire [15:0] read_data_2;   // R[rt/rd] -> ALU y
    wire [15:0] alu_result;    // ALU      -> register write data
    wire        alu_zero;

    wire [15:0] imm_ext;      // sign-extended instr[3:0]
    wire [15:0] alu_y;        // mux output from the alu_src-> ALU y
    
    
    // Instruction memory: intput the PC address in --> getting output as 16-bit instruction 
    instruction_memory call_instr_mem (
        .pc_address (pc_out),
        .instr      (instr)
    );
    
    // Data memory: R[rs] + imm
    data_memory call_data_mem (
        .clk (clk),
        .mem_read (mem_read),
        .mem_write (mem_write),
        .address (alu_result),
        .write_data (read_data_2),
        .read_data (dm_read_data)
    );
    
    // Control unit: input the opcode and function code, output with the control signals
    control_unit call_ctrl_u (
        .opcode (opcode),
        .func_code (func_code),
        .reg_write (reg_write),
        .mem_read (mem_read),
        .mem_write (mem_write),
        .branch (branch), 
        .alu_src (alu_src),         // choosing between immediate value (for addi func) or rt/rd (R-type
        .jump (jump),
        .momto_reg (memto_reg)
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

    // sign extend for 4 bits immediate value to 16 bits
    sign_extension call_sign_ext (
        .imm    (instr[3:0]),
        .extend (imm_ext)
    );

    // ALU source mux: 0 = R[rt/rd] (R-type), 1 = sign-extended imm (addi)
    mux2 call_alu_src_mux (
        .in0 (read_data_2), 
        .in1 (imm_ext), 
        .sel (alu_src),
        .out (alu_y)
    );
    
    // ALU: x = R[rs], y = alu_y (choosing between R[rt/rd] and imm)
    alu call_alu (
        .x (read_data_1),
        .y (alu_y    ),    // later: mux between this and sign-extended imm
        .opcode (opcode),
        .func_code (func_code),
        .result (alu_result),
        .zero (alu_zero)
    );
    
    // PC 
    pc call_pc (
        .clk (clk),
        .reset (reset),
        .load (1'b0),        // currently not use yet during R-type (no branches yet)
        .target (16'd0),        // currently not use yet during R-tpe
        .pc (pc_out)
    );
 
endmodule
