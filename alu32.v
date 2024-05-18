module alu32(
    output [31:0] sum,
    input [31:0] a, b, 
    input [2:0] gin,
    output zout
);
    reg [31:0] sum;
    reg [31:0] less;
    reg zout;
    always @(a or b or gin) begin
        case(gin)
            3'b010: sum = a + b;                // ADD
            3'b110: sum = a + 1 + (~b);         // SUB
            3'b111: begin                       // SLT
                less = a + 1 + (~b);
                if (less[31]) sum = 1;
                else sum = 0;
            end
            3'b000: sum = a & b;                // AND
            3'b001: sum = a | b;                // OR
            default: sum = 31'bx;
        endcase
        zout = ~(|sum);
    end
endmodule
