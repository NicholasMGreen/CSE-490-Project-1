`timescale 1ns / 1ps

module sign_extension_12bit(
       input  [11:0]  imm,           // the 12-bit immediate from jump instruction
       output reg [15:0] extend    // sign-extended 16-bit version
    );
    // the imm tells you in the 12th bit whether its positive or negative 
    always @(*) begin
           if (imm[11] == 1'b1)
               begin    // negative number fill top 12 bits with 1s
                   extend = {4'hF, imm};
               end
           else
               begin    // positive number fill top 12 bits with 0s
                   extend = {4'h00, imm};
               end
       end
endmodule
