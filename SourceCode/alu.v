module alu (
    input      [15:0] x,          // R[rs]
    input      [15:0] y,          // R[rt/rd] 
    input      [3:0]  opcode,       // 4 bit opcode
    input      [3:0]  func_code,    // 4 bit func code
    output reg [15:0] result,      // the result after ALU
    output            zero          // for branch, jump, I and J tbpe in general - will do it later
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
        //else 
            //begin                                //I-type or J-type ... will continue to work on that later
            // ... something here
            //end
    end

    assign zero = 1'd0;     //leave the zero here = 0 for now, need to fix when dealing with branching and stuff
    
endmodule
