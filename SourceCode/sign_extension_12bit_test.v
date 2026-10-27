`timescale 1ns / 1ps

module sign_extension_12bit_test;
      reg  [11:0] imm;
      wire [15:0] extend;
      
      sign_extension uut (.imm(imm), .extend(extend));
      
      initial begin
          // positve number should be filled with zeroes
          imm = 12'h222;
          #1;
          if (extend !== 16'h0222) $display("FAIL: extend = %h, expected 0222", extend);
		  else $display("PASS: extend = %h", extend);
		  
		  //negative number should be filled with ones
		  imm = 12'hF45;
          #1;
          if (extend !== 16'hFF45) $display("FAIL: extend = %h, expected FF45", extend);
		  else $display("PASS: extend = %h", extend);
		  
		  // 4th bit decides 
		  imm = 12'h802;
          #1;
          if (extend !== 16'hF802) $display("FAIL: extend = %h, expected F802", extend);
		  else $display("PASS: extend = %h", extend);
		  
		  // all zeros syay zero
		  imm = 12'h000;
          #1;
          if (extend !== 16'h0000) $display("FAIL: extend = %h, expected 0000", extend);
		  else $display("PASS: extend = %h", extend);
		  
		  $display ("sign_extension_12bit done");
	  end
    
endmodule
