module alu32(sum, a, b, gin,0, zout, N, V);
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
      3'b010: 
	begin 
	sum <= a + b; // ADD
        V = (a[31] == b[31]) && (sum[31] != a[31]); // Check for overflow
	end
      3'b110: 
	begin
	sum <= a + 1'b1 + (~b); // SUB
        V <= (a[31] != b[31]) && (sum[31] == a[31]); // Check for overflow
        end
      3'b111: 
	begin // Set on less than
        less <= a + 1'b1 + (~b);
        if (less[31]) begin
          sum <= 32'b1;
          N <= 1; // Set negative flag if result is negative
        end else begin
          sum <= 32'b0;
          N <= 0;
        end
      end
      3'b000: 
	begin
	sum <= a & b; // AND
        N <= sum[31]; // Negative flag based on MSB of result
        V <= 0;
	end // No overflow for AND
      3'b001: 
	begin
	sum <= a | b; // OR
        N <= sum[31]; // Negative flag based on MSB of result
        V <= 0; // No overflow for OR
	end
      default: sum <= 32'bx;
    endcase
    zout <= ~(|sum);
  end
endmodule

