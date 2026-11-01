`timescale 1ns / 1ps


module sign_extension(
       input  [3:0]  imm,           // the 4-bit immediate from instr[3:0]
       output reg [15:0] extend    // sign-extended 16-bit version
    );
    // the imm tells you in the 4th bit whether its positive or negative 
    always @(*) begin
           if (imm[3] == 1'b1)
               begin    // negative number fill top 12 bits with 1s
                   extend = {12'hFFF, imm};
               end
           else
               begin    // positive number fill top 12 bits with 0s
                   extend = {12'h000, imm};
               end
       end
endmodule
