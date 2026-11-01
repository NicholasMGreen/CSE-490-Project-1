`timescale 1ns / 1ps

module sign_extension_test;
      reg  [3:0] imm;
      wire [15:0] extend;
      
      sign_extension uut (.imm(imm), .extend(extend));
      
      initial begin
          // positve number should be filled with zeroes
          imm = 4'h2;
          #1;
          if (extend !== 16'h0002) $display("FAIL: extend = %h, expected 0002", extend);
		  else $display("PASS: extend = %h", extend);
		  
		  //negative number should be filled with ones
		  imm = 4'hF;
          #1;
          if (extend !== 16'hFFFF) $display("FAIL: extend = %h, expected FFFF", extend);
		  else $display("PASS: extend = %h", extend);
		  
		  // 4th bit decides 
		  imm = 4'h8;
          #1;
          if (extend !== 16'hFFF8) $display("FAIL: extend = %h, expected FFF8", extend);
		  else $display("PASS: extend = %h", extend);
		  
		  // all zeros syay zero
		  imm = 4'h0;
          #1;
          if (extend !== 16'h0000) $display("FAIL: extend = %h, expected 0000", extend);
		  else $display("PASS: extend = %h", extend);
		  
		  $display ("sign_extension done");
	  end
    
endmodule
