`timescale 1ns / 1ps

// testbench for the program counter (pc.v)

// note cant use hyphens in module names
module pc_test;

	reg clk, reset, load;
	reg [15:0] target;
	wire [15:0] pc;

	pc uut (.clk(clk), .reset(reset), .load(load), .target(target), .pc(pc));

	// 10ns period clock
	initial clk = 0;
	always #5 clk = ~clk;

	initial begin
		// hold reset, pc should stay 0
		reset = 1; load = 0; target = 0;
		@(posedge clk); #1;
		if (pc !== 16'd0) $display("FAIL: pc = %h after reset, expected 0", pc);
		else $display("PASS: pc = %h after reset", pc);

		// let it count up by 2
		reset = 0;
		@(posedge clk); #1;
		if (pc !== 16'd2) $display("FAIL: pc = %h, expected 2", pc);
		else $display("PASS: pc = 2");
		@(posedge clk); #1;
		if (pc !== 16'd4) $display("FAIL: pc = %h, expected 4", pc);
		else $display("PASS: pc = 4");
		@(posedge clk); #1;
		if (pc !== 16'd6) $display("FAIL: pc = %h, expected 6", pc);
		else $display("PASS: pc = 6");

		// load a target
		load = 1; target = 16'd40;
		@(posedge clk); #1;
		if (pc !== 16'd40) $display("FAIL: pc = %h, expected 40", pc);
		else $display("PASS: pc = 40");

		// stop loading, should keep counting from 40
		load = 0;
		@(posedge clk); #1;
		if (pc !== 16'd42) $display("FAIL: pc = %h, expected 42", pc);
		else $display("PASS: pc = 42");
		@(posedge clk); #1;
		if (pc !== 16'd44) $display("FAIL: pc = %h, expected 44", pc);
		else $display("PASS: pc = 44");

		// odd target should load exactly as given
		load = 1; target = 16'd21;
		@(posedge clk); #1;
		if (pc !== 16'd21) $display("FAIL: pc = %h, expected 21", pc);
		else $display("PASS: pc = 21");

		// and keep counting from there
		load = 0;
		@(posedge clk); #1;
		if (pc !== 16'd23) $display("FAIL: pc = %h, expected 23", pc);
		else $display("PASS: pc = 23");

		$display("pc testbench done");
		$finish;
	end

endmodule
