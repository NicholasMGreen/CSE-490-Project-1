module pc(
  input wire clk, rst, en,           
  input wire [15:0] next_pc,         
  output reg [15:0] pc
);

