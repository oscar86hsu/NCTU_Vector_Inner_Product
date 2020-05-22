module Inner_Prod(input clk, 
                  input rst,
                  input valid_in,
                  input unsigned [7:0] A,
                  input unsigned [7:0] B,
                  output valid_out,
                  output unsigned [18:0] C);

reg unsigned [18:0] C;
reg valid_out;
integer i = 0;

always @(rst) begin
  valid_out = 0;
  C = 19'b0;
  i = 0;
end

always @(posedge clk) begin
  if (i > 0) begin
    i = i + 1;
  end
  if (valid_in) begin
    if (i === 0) begin
      i = 1;
    end
    C = (A * B) + C;
  end
  if (i === 9) begin
    valid_out = 1;
  end
  if (i === 10) begin
    valid_out = 0;
    C = 19'b0;
    i = 0;
  end
end

endmodule