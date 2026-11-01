module data_memory(
    input         clk,
    input         mem_read,
    input         mem_write,
    input  [15:0] address, // from ALU result by computing R[rs] + imm
    input  [15:0] write_data, // R[rt/rd] for sw
    output reg [15:0] read_data   // goes to memto_reg mux for lw
);
    reg [7:0] mem [0:255];  // memory is addressed by 1 byte (8 bits), in 6.2.5 recommended 256 bytes --> 256/1 = 256
    
    integer i;
    initial begin
        // init each byte = 0
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 8'h00;
    end
    
    // read: big-endian
    always @(*) begin
        if (mem_read == 1'b1)
            begin
                read_data[15:8] = mem[address[7:0]]; // high byte at the lower address
                read_data[7:0]  = mem[address[7:0] + 8'd1];   // low byte at the next address
            end
        else
            begin
                read_data = 16'd0;  // not lw --> output 0
            end
    end
    
    // write: on clock edge, big-endian
    always @(posedge clk) begin
        if (mem_write) begin
            mem[address[7:0]] <= write_data[15:8];
            mem[address[7:0] + 8'd1] <= write_data[7:0];
        end
    end
endmodule