module wiring(
    input clk,
    input reset
);

    output [15:0] pc_out;        // PC -> instruction memory
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
        .memto_reg (memto_reg)
    );
    
    // memto_reg mux: lw writes memory data or its an ALU result
    mux2 call_wb_mux (
        .in0 (alu_result),      // normal path
        .in1 (dm_read_data),    // lw path
        .sel (memto_reg),
        .out (write_back)
    );
    
    // Register file: read rs and rt/rd, write result back into rt/rd
    register_file call_rf (
        .clk         (clk),
        .reset       (reset),
        .reg_write   (reg_write),
        .read_reg_1  (rs),
        .read_reg_2  (rt_rd),
        .write_reg   (rt_rd),
        .write_data  (write_back),   // R-type: ALU result goes straight back
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
        .load (pc_load),       
        .target (branch_target),        
        .pc (pc_out)
    );
    
    // branch/jump databath
    assign pc_plus2 = pc_out + 16'd2; //base of the banch/jump accounts for the instruction itself
    // mux in the draw.io diagram chossing between 12bit jump and 4bit branch
    mux2 call_offset_mux (
       .in0 (imm_ext),
       .in1 (jump_imm),
       .sel (jump),
       .out (offset)
    );
    assign branch_target = pc_plus2 + (offset << 1);
    
    //instatiate the 12bit sign extension
    sign_extension_12bit call_sign_ext12 (
       .imm (instr[11:0]),     // jmp address field
       .extend (jump_imm)
    );
    
    // branch condition  beq (0100) takes the branch on zero=1, bne (0101) takes it on zero=0
    reg branch_ok;
    always @(*) begin
        branch_ok = 1'b0;              // default 
        if (opcode == 4'b0100)              // beq take when equal
            branch_ok = alu_zero;
        else                                // bne take when not equal
            branch_ok = ~alu_zero;     //flips all bits 
    end
    assign pc_load = jump | (branch & branch_ok);
    
endmodule
