module register_file(
    input clk,
    input reset,
    input [3:0] read_reg_1,   // instruction bit [7..4] - address for rs
    input [3:0] read_reg_2,   // instruction bit [11..8] - address for rt/rd
    input [3:0] write_reg,    // instruction bit [11.8] - address for rt/rd
    input [15:0] write_data,   // data need to put into the write_reg
    output [15:0] read_data_1, // R[rs] - value of register rs
    output [15:0] read_data_2  // R[rt/rd]
);

    read_data_1 = ... register[read_reg_1]; // find the register rs --> put the value R[rs] into read_data_1
    read_data_2 = ... register[read_reg_2]; // get register rt/rd --> put R[rt/td] in read_data-2
    
    always @(pose clk) begin
        if (reset) begin
            // ... something here
            // maybe need to write data (put value - write_data- into reg(write_reg))
        end
    end
endmodule