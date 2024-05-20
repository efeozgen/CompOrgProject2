module alu32(sum, a, b, zout, N, V);
  output [31:0] sum;
  input [31:0] a, b;
  input [2:0] gin; // ALU control line
  reg [31:0] sum;
  reg [31:0] less;
  output zout;
  reg zout;
  output reg N;
  output reg V;

  always @(a or b or gin)
  begin
    case (gin)
      3'b010: sum = a + b; // ALU control line=010, ADD
        V = (a[31] == b[31]) && (sum[31] != a[31]); // Check for overflow in addition
      3'b110: sum = a + 1 + (~b); // ALU control line=110, SUB
        V = (a[31] != b[31]) && (sum[31] == a[31]); // Check for overflow in subtraction
      3'b111: begin // ALU control line=111, set on less than
        less = a + 1 + (~b);
        if (less[31]) begin
          sum = 1;
          N = 1; // Set negative flag if result is negative
        end else begin
          sum = 0;
          N = 0;
        end
      end
      3'b000: sum = a & b; // ALU control line=000, AND
        N = sum[31]; // Negative flag based on MSB of result
        V = 0; // No overflow for AND
      3'b001: sum = a | b; // ALU control line=001, OR
        N = sum[31]; // Negative flag based on MSB of result
        V = 0; // No overflow for OR
      default: sum = 31'bx;
    endcase
    zout = ~(|sum);
  end
endmodule

