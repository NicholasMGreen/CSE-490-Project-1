`timescale 1ns / 1ps

module control_unit_test;

	reg  [3:0] opcode;
	reg  [3:0] func_code;
	wire       reg_write;
	wire       mem_read;
	wire       mem_write;
	wire       branch;

	// control unit decleration
	control_unit uut (
		.opcode(opcode), .func_code(func_code),
		.reg_write(reg_write), .mem_read(mem_read),
		.mem_write(mem_write), .branch(branch)
	);

	initial begin
		 // test 1: R-type add
         func_code = 4'b0000; opcode = 4'b0000;
         #1;
         if (reg_write !== 1'b1) $display("FAIL: reg_write = %b, expected 1", reg_write);
         else $display("PASS: reg_write = 1");
         if (branch !== 1'b0) $display("FAIL: branch = %b, expected 0", branch);
         else $display("PASS: branch not taken");
         if (mem_read !== 1'b0) $display("FAIL: mem_read = %b, expected 0", mem_read);
         else $display("PASS: memory read rejected", mem_read);
         if (mem_write !== 1'b0) $display("FAIL: mem_write = %b, expected 0", mem_write);
         else $display("PASS: memory write rejected", mem_write);
         
         // test 2: R-type sub
         func_code = 4'b0001; opcode = 4'b0000;
         #1;
         if (reg_write !== 1'b1) $display("FAIL: reg_write = %b, expected 1", reg_write);
         else $display("PASS: reg_write = 1");
         if (branch !== 1'b0) $display("FAIL: branch = %b, expected 0", branch);
         else $display("PASS: branch not taken");
         if (mem_read !== 1'b0) $display("FAIL: mem_read = %b, expected 0", mem_read);
         else $display("PASS: memory read rejected", mem_read);
         if (mem_write !== 1'b0) $display("FAIL: mem_write = %b, expected 0", mem_write);
         else $display("PASS: memory write rejected", mem_write);
         
         // test 3: R-type sll
         func_code = 4'b0010; opcode = 4'b0000;
         #1;
         if (reg_write !== 1'b1) $display("FAIL: reg_write = %b, expected 1", reg_write);
         else $display("PASS: reg_write = 1");
         if (branch !== 1'b0) $display("FAIL: branch = %b, expected 0", branch);
         else $display("PASS: branch not taken");
         if (mem_read !== 1'b0) $display("FAIL: mem_read = %b, expected 0", mem_read);
         else $display("PASS: memory read rejected", mem_read);
         if (mem_write !== 1'b0) $display("FAIL: mem_write = %b, expected 0", mem_write);
         else $display("PASS: memory write rejected", mem_write);
         
         // test 4: R-type and
         func_code = 4'b0011; opcode = 4'b0000;
         #1;
         if (reg_write !== 1'b1) $display("FAIL: reg_write = %b, expected 1", reg_write);
         else $display("PASS: reg_write = 1");
         if (branch !== 1'b0) $display("FAIL: branch = %b, expected 0", branch);
         else $display("PASS: branch not taken");
         if (mem_read !== 1'b0) $display("FAIL: mem_read = %b, expected 0", mem_read);
         else $display("PASS: memory read rejected", mem_read);
         if (mem_write !== 1'b0) $display("FAIL: mem_write = %b, expected 0", mem_write);
         else $display("PASS: memory write rejected", mem_write);
         
		$finish;
	end

endmodule
