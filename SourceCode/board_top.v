   `timescale 1ns / 1ps
   // board_top - press btnC once: all tests run
   // green LD15 = pass
   // red LD14   = fail
   // press btnC again anytime to restart 

   module board_top(
       input clk,          // 100 MHz board clock
       input btnC,         // the one button: press = run all the tests
       output [15:0] led
   );

       // must match program.txt fail 0x74
       localparam FAIL_BASE = 16'h0074;
       wire [15:0] cpu_pc;                  // current program address from the processor
       wire fail = (cpu_pc >= FAIL_BASE);   // red condition: PC trapped in a fail loop

       // sync btnC into the clock domain + rising edge detect.
       reg btn_sync_0, btn_sync_1, btn_prev;
       always @(posedge clk) begin
           // synchronize button to 100MHz clock
           btn_sync_0   <= btnC;
           btn_sync_1   <= btn_sync_0;
           btn_prev <= btn_sync_1;
       end
       wire start_press = btn_sync_1 & ~btn_prev;      // one pulse per press

       // clock divider: one instruction every 0.8 s -> ~30 s for the whole run
       reg [26:0] div_counter;
       wire tick = (div_counter == 27'd80_000_000);
       always @(posedge clk) begin
           if (tick)
               div_counter <= 27'd0;
           else
               div_counter <= div_counter + 1;
       end

       // start latch + reset phase: the PC/RF reset is synchronous, so the
       // first 3 ticks run with reset held to actually clear PC and registers
       reg running, rst_phase;
       reg [1:0] rst_cnt;
       always @(posedge clk) begin
           if (start_press) begin
               running   <= 1'b1;
               rst_phase <= 1'b1;
               rst_cnt   <= 2'd0;
           end
           else if (rst_phase) begin
               if (tick) begin                     // count TICKS, not 100 MHz cycles
                   rst_cnt <= rst_cnt + 1;
                   if (rst_cnt == 2'd2)
                       rst_phase <= 1'b0;        // 3 ticks with reset held, then go
               end
           end
       end

       // the processor - one instruction per tick once started
       wire step_clk = (running | rst_phase) & tick & clk;

       wiring my_cpu (
           .clk (step_clk),
           .reset (rst_phase),
           .pc_out (cpu_pc)
       );

       // display
       assign led[7:0]  = cpu_pc[7:0];       // program address
       assign led[14]   = fail;              // red: a check failed
       assign led[15]   = ~fail;             // green: on until something fails
       assign led[13:8] = 6'b0;

   endmodule