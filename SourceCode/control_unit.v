module control_unit(
    input  [3:0] opcode,      // instr [15:12]
    input  [3:0] func_code,   // instr [3:0], add, sub, sll, and 
    output reg   reg_write,   // 1 = write to register  
    output reg   mem_read,    // 1 = data memory read for lw
    output reg   mem_write,   // 1 = data memory write for sw
    output reg   branch,       // 1 = beq/bne
    output reg   alu_src        // alu_scr = 0 --> R type with  rs and rt/rd, alu_src = 1 --> I type - using imm for addi
);

    always @(*) begin
        // initilize everything off
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;
        alu_src    = 1'b0;

        if (opcode == 4'b0000)
            begin         // R-type add, sub, sll, and
                reg_write = 1'b1;  // result goes to rt/rd
            end
        else  if (opcode == 4'b0011)       // for I-type addi
            begin
                reg_write = 1'b1;
                alu_src = 1'b1;     //choosing immediate value
            end
        // else for other I types and J type
    end

endmodule
