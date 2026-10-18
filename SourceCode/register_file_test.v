`timescale 1ns / 1ps

// testbench for register_file (register_file.v)

module register_file_test;

	reg         clk, reset, reg_write;
	reg  [3:0]  read_reg_1, read_reg_2, write_reg;
	reg  [15:0] write_data;
	wire [15:0] read_data_1, read_data_2;

	// register file declieation
	register_file uut (
		.clk(clk), .reset(reset), .reg_write(reg_write),
		.read_reg_1(read_reg_1), .read_reg_2(read_reg_2),
		.write_reg(write_reg), .write_data(write_data),
		.read_data_1(read_data_1), .read_data_2(read_data_2)
	);

	// 10ns period clock - writes happen on the rising edge
	initial clk = 0;
	always #5 clk = ~clk;

	initial begin
		// reset the register
		reset = 1; reg_write = 0; write_reg = 0; write_data = 0;
		@(posedge clk);
		#1;
		reset = 0;
		
		// write ABCD to register 2, read it back on read_reg 1
		reg_write = 1;
		write_reg = 4'd2;
		write_data = 16'hABCD;
		@(posedge clk);
		#1;
		read_reg_1 = 4'd2;
		#1;
		if (read_data_1 !== 16'hABCD) $display("FAIL: R2 = %h expected ABCD", read_data_1);
		else $display("PASS: R2 = %h", read_data_1);
		
		// write DDDD to register 15, read it back on read_reg 2
		reg_write = 1;
		write_reg = 4'd15;
		write_data = 16'hDDDD;
		@(posedge clk);
		#1;
		read_reg_2 = 4'd15;
		#1;
		if (read_data_2 !== 16'hDDDD) $display("FAIL: R15 = %h expected DDDD", read_data_2);
		else $display("PASS: R15 = %h", read_data_2);
		$finish;
	end

endmodule
