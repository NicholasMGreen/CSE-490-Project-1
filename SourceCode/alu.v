module alu (
    input      [15:0] x,          // R[rs]
    input      [15:0] y,          // R[rt/rd] or sign-extended imm (for addi function). Choosing from the mux
    input      [3:0]  opcode,       // 4 bit opcode
    input      [3:0]  func_code,    // 4 bit func code
    output reg [15:0] result,      // the result after ALU
    output            zero          // for branch, jump, I and J type in general - will do it later
);
    always @(*) begin
        result = 16'd0;
        if (opcode == 4'b0000) 
            begin              //R-type
                case (func_code)
                    4'b0000: result = x + y;         // add
                    4'b0001: result = x - y;         // sub: rs - rt
                    4'b0010: result = y << x;        // sll: rt << rs
                    4'b0011: result = x & y;         // and
                    default: result = 16'd0;
                endcase
            end
        else if (opcode == 4'b0011)      // addi
            begin
                result = x + y;          // R[rs] + signext(imm), y comes from the mux
            end
	else if (opcode == 4'b0001 || opcode == 4'b0010)	//lw or sw
		begin
			result = x + y;
		end
	else if (opcode == 4'b0100 || opcode ==  4'b0101)
		begin
			result = x - y;
		end

    end

    assign zero = (result == 16'd0);   // zero = 1 when R[rs] == R[rt/rd]

    
endmodule
