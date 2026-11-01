module control_unit(
    input  [3:0] opcode,      // instr [15:12]
    input  [3:0] func_code,   // instr [3:0], add, sub, sll, and 
    output reg   reg_write,   // 1 = write to register  
    output reg   mem_read,    // 1 = data memory read for lw
    output reg   mem_write,   // 1 = data memory write for sw
    output reg   branch,       // 1 = beq/bne
    output reg   jump,         // 1 = jmp for PC
    output reg   alu_src,        // alu_scr = 0 --> R type with  rs and rt/rd, alu_src = 1 --> I type - using imm for addi
    output reg   memto_reg    // write data that is coming from memory for lw
);

    always @(*) begin
        // initilize everything off
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        alu_src    = 1'b0;
        memto_reg  = 1'b0;

        if (opcode == 4'b0000)
            begin         // R-type add, sub, sll, and
                reg_write = 1'b1;  // result goes to rt/rd
            end
        else  if (opcode == 4'b0011)       // for I-type addi
            begin
                reg_write = 1'b1;
                alu_src = 1'b1;     //choosing immediate value
            end
         else if (opcode == 4'b0001)    // for lw
            begin
                reg_write = 1'b1;
                mem_read = 1'b1;
                memto_reg = 1'b1;
                alu_src = 1'b1;    // ALU needs the immediate calculating offset
            end
         else if (opcode == 4'b0010)    // for sw
            begin
                mem_write = 1'b1;
                alu_src = 1'b1;    // address = R[rs] + imm too
            end
         else if (opcode == 4'b0100)    // for beq
            begin
                branch = 1'b1;     // take when ALU zero flag is 1 
            end
         else if (opcode == 4'b0101)    // for bne
            begin
                branch = 1'b1;     // take when ALU zero flag is 0 
            end
         else if (opcode == 4'b0110)    // for jmp
            begin
                jump = 1'b1;       
            end
    end

endmodule
