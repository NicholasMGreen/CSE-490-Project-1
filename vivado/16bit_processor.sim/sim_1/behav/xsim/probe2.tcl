run 3 ns
puts "t=3ns  clk=[get_value /wiring_test/clk] reset=[get_value /wiring_test/reset] pc=[get_value -radix hex /uut/pc_out]"
run 4 ns
puts "t=7ns  clk=[get_value /wiring_test/clk] reset=[get_value /wiring_test/reset] pc=[get_value -radix hex /uut/pc_out]"
run 10 ns
puts "t=17ns clk=[get_value /wiring_test/clk] reset=[get_value /wiring_test/reset] pc=[get_value -radix hex /uut/pc_out] mem0=[get_value -radix hex /uut/call_instr_mem/mem\[0\]]"
exit
