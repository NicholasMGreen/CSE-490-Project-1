run 10 ns
puts "t=10ns pc=[get_value -radix hex /uut/pc_out] instr=[get_value -radix hex /uut/instr] regW=[get_value /uut/reg_write]"
run 10 ns
puts "t=20ns pc=[get_value -radix hex /uut/pc_out] instr=[get_value -radix hex /uut/instr] R1=[get_value -radix hex /uut/call_rf/register\[1\]]"
exit
