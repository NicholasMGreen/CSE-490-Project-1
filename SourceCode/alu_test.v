`timescale 1ns / 1ps

// testbench for the alu (alu.v)
// tests for: add, sub, sll, and

module alu_test;

	reg  [15:0] x;         // R[rs]
	reg  [15:0] y;         // R[rt/rd]
	reg  [3:0]  opcode;
	reg  [3:0]  func_code;
	wire [15:0] alu_res;
	wire        zero;      // not tested yet

	alu uut (.x(x), .y(y), .opcode(opcode), .func_code(func_code), .alu_res(alu_res), .zero(zero));

	initial begin
		// add 2 + 7 
		x = 2; y = 7; opcode = 4'b0000; func_code = 4'b0000;
		#1;
		if (alu_res !== 16'd9) $display("FAIL: alu = %h, expected 9",alu_res);
		else $display("PASS: alu = %h",alu_res);
		
		// sub 2 - 7 = -5
		x = 2; y = 7; opcode = 4'b0000; func_code = 4'b0001;
		#1;
		if (alu_res !== 16'hFFFB) $display("FAIL: alu = %h, expected FFFB or -5",alu_res);
		else $display("PASS: alu = %h or -5",alu_res);
		
		//  x = 16'd4; y = 16'h005A; (value 0x5A shifted left 4)
		x = 16'd4; y = 16'h005A; opcode = 4'b0000; func_code = 4'b0010;
		#1;
		if (alu_res !== 16'h05A0) $display("FAIL: alu = %h, expected 05A0",alu_res);
		else $display("PASS: alu = %h",alu_res);
		
		// and 3&2 = 10b or 2d
		x = 3; y = 2; opcode = 4'b0000; func_code = 4'b0011;
		#1;
		if (alu_res !== 16'd2) $display("FAIL: alu = %h, expected 2",alu_res);
		else $display("PASS: alu = %h",alu_res);
		
		$finish;
	end

endmodule
