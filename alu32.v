module alu32(sum,a,b,zout,overflow,gin);//ALU operation according to the ALU control line values
output [31:0] sum;
input [31:0] a,b; 
input [2:0] gin;//ALU control line
reg [31:0] sum;
reg [31:0] less;
output zout;
output overflow;
reg zout;
always @(a or b or gin)
overflow = 0;
begin
    case(gin)
    3'b010: begin sum=a+b;         //ALU control line=010, ADD
    //overflow detection
    if(a[31]==b[31] && sum[31]!=a[31]) begin
        overflow=1;
            end
        end

    3'b110: begin sum=a+1+(~b);    //ALU control line=110, SUB
    //overflow detection
    if(a[31]!=b[31] && sum[31]!=a[31]) begin
        overflow=1;
            end
        end

    3'b111: begin less=a+1+(~b);    //ALU control line=111, set on less than
            if (less[31]) sum=1;
            else sum=0;
          end
    3'b000: sum=a & b;    //ALU control line=000, AND
    3'b001: sum=a|b;        //ALU control line=001, OR
    default: sum=31'bx;
    endcase
zout=~(|sum);
end
endmodule