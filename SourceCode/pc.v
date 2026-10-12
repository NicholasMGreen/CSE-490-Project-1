`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 03:27:39 PM
// Design Name: 
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc(
    input clk,
    input rst,
    input load,
    input [15:0] target,
    output reg [15:0] pc
    );
    
    always @(posedge clk) begin 
        if (rst)
            pc <= 16'd0;
        else if (load)
            pc <= target;
        else
            pc <= pc + 16'd2;
    end        
               
endmodule
