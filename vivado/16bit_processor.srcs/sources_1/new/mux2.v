
module mux2(
    input  [15:0] in0,
    input  [15:0] in1,
    input sel,
    output reg [15:0] out
);
    always @(*) begin
        if (sel == 1'b0)
            out = in0;
        else
            out = in1;
    end
endmodule