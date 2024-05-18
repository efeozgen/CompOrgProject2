module status_register (
    input clk,
    input reset,
    input zero,
    input negative,
    input overflow,
    output reg Z,
    output reg N,
    output reg V
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Z <= 0;
        N <= 0;
        V <= 0;
    end else begin
        Z <= zero;
        N <= negative;
        V <= overflow;
    end
end

endmodule
module ALU (
    input [31:0] a, b,
    input [2:0] alu_control,
    output reg [31:0] result,
    output reg zero,
    output reg negative,
    output reg overflow
);

always @(*) begin
    overflow = 0;
    zero = 0;
    negative = 0;
    case (alu_control)
        3'b010: begin // ADD
            result = a + b;
            // Overflow detection for addition
            if ((a[31] == b[31]) && (result[31] != a[31])) begin
                overflow = 1;
            end
        end
        3'b110: begin // SUB
            result = a - b;
            // Overflow detection for subtraction
            if ((a[31] != b[31]) && (result[31] != a[31])) begin
                overflow = 1;
            end
        end
        3'b000: result = a & b; // AND
        3'b001: result = a | b; // OR
        3'b111: result = (a < b) ? 1 : 0; // SLT
        default: result = 0;
    endcase
    zero = (result == 0);
    negative = result[31];
end

endmodule