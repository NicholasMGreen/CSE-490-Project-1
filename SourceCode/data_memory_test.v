`timescale 1ns / 1ps

module data_memory_test;
      reg clk;
      reg mem_read, mem_write;
      reg [15:0] address, write_data;
      wire [15:0] read_data;
      
      data_memory uut (.clk(clk), .mem_read(mem_read), .mem_write(mem_write), .address(address), .write_data(write_data), .read_data(read_data));
      
      always #5 clk = ~clk;
      
      initial begin 
           // zero out
           clk = 0;
           mem_read = 0;
           mem_write = 0;
           address = 16'h0000; write_data = 16'h0000;
           #1;
           
           // write AABB to to address 0x10 - will test on the read side
           mem_write = 1;
           write_data = 16'hAABB;
           address = 16'h0010;
           @(posedge clk);
           #1;
           mem_write = 0;
           
           //read the AABB
           mem_read = 1;
           #1;
           if (read_data !== 16'hAABB) $display("FAIL: data = %h, expected AABB", read_data);
		   else $display("PASS: data = %h", read_data);
		   
		   //check byte order if read on address 0x11 sould get BB
		   address = 16'h0011;
		   #1;
		   if (read_data !== 16'hBB00) $display("FAIL: data = %h, expected BB00", read_data);
		   else $display("PASS: data = %h", read_data);
		  
		   //write a second word at a diffrent address 
		   mem_read = 0;
		   mem_write = 1;
           write_data = 16'h4321;
           address = 16'h0040;
           @(posedge clk);
           #1;
           mem_write = 0;
           
           //read 4321 at address 64
           mem_read = 1;
           #1;
           if (read_data !== 16'h4321) $display("FAIL: data = %h, expected 4321", read_data);
		   else $display("PASS: data = %h", read_data);
		   
		   //chack if the new write broak the old write
		   address = 16'h0010;
		   #1;
		   if (read_data !== 16'hAABB) $display("FAIL: data = %h, expected AABB", read_data);
		   else $display("PASS: data = %h", read_data);
	   end
endmodule
