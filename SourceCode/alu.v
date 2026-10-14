module alu (
    input      [15:0] x,          // R[rs]
    input      [15:0] y,          // R[rt/rd] 
    input      [3:0]  opcode,       // 4 bit opcode
    input      [3:0]  func_code,    // 4 bit func code
    output reg [15:0] alu_res,      // the result after ALU
    output            zero          // for branch, jump, I and J type in general - will do it later
);
    always @(*) begin
        if (opcode == 4'b0000) 
            begin              // R-type
                case (func_code)
                    4'b0000: alu_res = x + y;         // add
                    4'b0001: alu_res = x - y;         // sub: rs - rt
                    4'b0010: alu_res = y << x;        // sll: rt << rs
                    4'b0011: alu_res = x & y;         // and
                    default: alu_res = 16'd0;
                endcase
            end
        else 
            begin                                // I-type or J-type ... will continue to work on that later
            // ... something here
            end
    end
endmodule