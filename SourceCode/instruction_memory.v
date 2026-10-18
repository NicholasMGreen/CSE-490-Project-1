module instruction_memory(
    input  [15:0] pc_address,
    output [15:0] instr
);
    reg [15:0] mem [0:31];      // arrays with size of 32, each has 16 bits instruction, since tests only upto 64 bytes --> 64 bytes / 2 bytes (16 bits instruction) = 32 instructions
    
    integer i;
    initial begin
        // init each instruction = 0
        for (i = 0; i < 32; i = i + 1)
            mem[i] = 16'h0000;
            
        // load the program (line 1 -> mem[0], line 2 -> mem[1], ...)
        $readmemh("program.txt", mem);
    end

    // Since we have 32 index, we need to map pc to each location
    // 32 = 2^5 → need 5 bit from pc
    // 0x0 = 000 = index 0
    // 0x2 = 010 = index 1 (pc increase by 2 byte)
    // 0x4 = 100 = index 2
    // 0x6 = 110 = index 3
    // if we drop the last bit - bit 0 --> aligns with the index

    assign instr = mem[pc_address[5:1]];
    
    
endmodule