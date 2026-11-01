`timescale 1ns / 1ps

module pc(
    input clk,
    input reset, //starts the pc at 0, hardware could have floped ot a drffernt address
    input load, //input shift ammount yes or no
    input [15:0] target, //shift ammount can be positive or negative 16 bit 
    output reg [15:0] pc
    );
    
    always @(posedge clk) begin 
        if (reset)
            pc <= 16'd0;
        else if (load)
            pc <= target;
        else
            pc <= pc + 16'd2;
    end        
               
endmodule
