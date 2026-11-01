`timescale 1ns / 1ps

module wiring_test;

    reg clk;
    reg reset;
    integer i;
    
    //declerationn of wire
    wiring uut (.clk(clk), .reset(reset));
    
    // 10ns clock period
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        //clear all registers
        reset = 1;
        @(posedge clk);
        #1;   // without this their is a race condition that will faill the whole testbench 
        reset = 0;
        
        // addi $s1, $s0, 5    -> R1 = 0005
        @(posedge clk);
        #1;
        if (uut.call_rf.register[1] !== 16'h0005) $display("FAIL: R1 = %h, expected 0005", uut.call_rf.register[1]);
        else $display("PASS: R1 = %h", uut.call_rf.register[1]);
        
        // addi $s2, $s1, -2   -> R2 = 0003
        @(posedge clk);
        #1;
        if (uut.call_rf.register[2] !== 16'h0003) $display("FAIL: R2 = %h, expected 0003", uut.call_rf.register[2]);
        else $display("PASS: R2 = %h", uut.call_rf.register[2]);
        
        // addi $s3, $s0, 7    -> R3 = 0007
        @(posedge clk);
        #1;
        if (uut.call_rf.register[3] !== 16'h0007) $display("FAIL: R3 = %h, expected 0007", uut.call_rf.register[3]);
        else $display("PASS: R3 = %h", uut.call_rf.register[3]);
        
        // add  $s2, $s1       -> R2 = 0008
        @(posedge clk);
        #1;
        if (uut.call_rf.register[2] !== 16'h0008) $display("FAIL: R2 = %h, expected 0008", uut.call_rf.register[2]);
        else $display("PASS: R2 = %h", uut.call_rf.register[2]);
        
        // sub  $s3, $s1       -> R3 = FFFE
        @(posedge clk);
        #1;
        if (uut.call_rf.register[3] !== 16'hFFFE) $display("FAIL: R3 = %h, expected FFFE", uut.call_rf.register[3]);
        else $display("PASS: R3 = %h", uut.call_rf.register[3]);
        
        // sll  $s1, $s2       -> R1 = 0500
        @(posedge clk);
        #1;
        if (uut.call_rf.register[1] !== 16'h0500) $display("FAIL: R1 = %h, expected 0500", uut.call_rf.register[1]);
        else $display("PASS: R1 = %h", uut.call_rf.register[1]);
        
        // and  $s3, $s1       -> R3 = 0500
        @(posedge clk);
        #1;
        if (uut.call_rf.register[3] !== 16'h0500) $display("FAIL: R3 = %h, expected 0500", uut.call_rf.register[3]);
        else $display("PASS: R3 = %h", uut.call_rf.register[3]);
         
        // PC
        @(posedge clk);
        #1;
        if (uut.pc_out !== 16'h0010) $display("FAIL: pc_out = %h, expected 0010", uut.pc_out);
        else $display("PASS: pc_out = %h", uut.pc_out);
        
        $finish;
    end    
endmodule
