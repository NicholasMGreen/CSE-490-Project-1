`timescale 1ns / 1ps

// testbench for instruction_memory (instruction_memory.v)
// NOTE: the im loads its contents from program.txt ($readmemh) at time 0,
// so these tests depend on what program.txt contains.
// tests to write: instr at address 0, a few addresses in the middle,
// past the end of the 32 instructions (should read 0), and bit-0 of the
// address being ignored (addr 2 vs 3 should give the same instr)

module instruction_memory_test;

	reg  [15:0] pc_address;
	wire [15:0] instr;

	// instruction memory decleration
	instruction_memory uut (.pc_address(pc_address), .instr(instr));

	initial begin
		// fetch data from address 0 / mem 0
		pc_address = 16'h0000;
		#1;
		if (instr !== 16'h0210) $display("FAIL: instr = %h expected 0210", instr);
		else $display("PASS: instr = %h", instr);
		
		// fetch data from address 2 / mem 1
		pc_address = 16'h0002;
		#1;
		if (instr !== 16'h0341) $display("FAIL: instr = %h expected 0341", instr);
		else $display("PASS: instr = %h", instr);
		
		// fetch data from address 4 / mem 2
		pc_address = 16'h0004;
		#1;
		if (instr !== 16'h0562) $display("FAIL: instr = %h expected 0562", instr);
		else $display("PASS: instr = %h", instr);
		
		// fetch data from address 6 / mem 3
		pc_address = 16'h0006;
		#1;
		if (instr !== 16'h0873) $display("FAIL: instr = %h expected 0873", instr);
		else $display("PASS: instr = %h", instr);
		$finish;
	end

endmodule
