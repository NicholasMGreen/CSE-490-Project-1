module control_unit(
    input  [3:0] opcode,      // instr [15:12]
    input  [3:0] func_code,   // instr [3:0], add, sub, sll, and 
    output reg   reg_write,   // 1 = register file 
    output reg   mem_read,    // 1 = data memory read for lw
    output reg   mem_write,   // 1 = data memory write for sw
    output reg   branch       // 1 = beq/bne
    // note: the ALU takes opcode/func_code straight from the instruction,
    // so the control unit does not feed the ALU in this design
);

    always @(*) begin
        // initilize everything off
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;

        if (opcode == 4'b0000)
            begin         // R-type add, sub, sll, and
                reg_write = 1'b1;  // result goes to rt/rd
            end
        else         // for I-type and J-type
            begin
                // ...
            end
    end

endmodule
