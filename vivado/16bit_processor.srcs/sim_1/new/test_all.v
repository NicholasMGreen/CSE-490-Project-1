`timescale 1ns / 1ps


module test_all;
      reg clk, reset;
      wire [15:0] pc_out;

      // datapath that runs on boeard
      wiring uut (
         .clk (clk),
         .reset (reset),
         .pc_out (pc_out)
      );

      always #5 clk = ~clk;   // 10ns period


      initial begin
         clk = 0;
         reset = 1;
         @(posedge clk); #1;      
         reset = 0;  //initialize and clear everything out

         repeat (200) begin       // 200 is just arbitrary the program.txt is about 100 instructions
            @(posedge clk); #1;
            if (pc_out >= 16'h0074) begin
               $display("FAIL: check failed, PC stuck at %h", pc_out);
            end
         end

         if (pc_out == 16'h0072)
            $display("PASS: all 10 instructions verifie");
         else if (pc_out < 16'h0074)
            $display("FAIL: program did not finish - PC at %h outside proper range", pc_out);
         $display("All Test done");
         $finish;
      end
endmodule
