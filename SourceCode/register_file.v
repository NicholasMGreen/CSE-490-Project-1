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
    reg [15:0] register [0:15];   // declare 16 registers, each ahs 16 bits

    assign read_data_1 = register[read_reg_1]; // find the register rs --> put the value R[rs] into read_data_1
    assign read_data_2 = register[read_reg_2]; // get register rt/rd --> put R[rt/td] in read_data-2
    
    
    integer i;
    always @(posedge clk) begin   
        if (reset) begin
            // clears every register when reset
            for (i = 0; i < 16; i = i + 1)
                register[i] <= 16'd0;
        end
        else if (reg_write) begin
            // write when enabled (currently true for all R-type), but for I-type and J it depends
            register[write_reg] <= write_data;
        end
    end

endmodule
