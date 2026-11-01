module instruction_memory(
    input  [15:0] pc_address,
    output [15:0] instr
);
    reg [15:0] mem [0:127];      // arrays with size of 128, each has 16 bits instruction--> 128 * 2 bytes (16 bits instruction) = 256 bytes in memory (6.2.5 recommend)
    
    integer i;
    initial begin
        // init each instruction = 0
        for (i = 0; i < 128; i = i + 1)
            mem[i] = 16'h0000;
            
        // load the program (line 1 -> mem[0], line 2 -> mem[1], ...)
        $readmemh("program.txt", mem);
    end

    // Since we have 128 index, we need to map pc to each location
    // 128 = 2^7 → need 7 bit from pc
    // 0x0 = 000 = index 0
    // 0x2 = 010 = index 1 (pc increase by 2 byte)
    // 0x4 = 100 = index 2
    // 0x6 = 110 = index 3 ...
    // if we drop the last bit - bit 0 --> aligns with the index

    assign instr = mem[pc_address[7:1]];
    
    
endmodule