`include "Inner_Prod.v"
`timescale 1ns/1ps
module Inner_Prod_tb;

real CYCLE=1000;

// Input signals
reg clk;
reg valid_in;
reg [7:0] A_input;
reg [7:0] B_input;
reg rst;
// Output signals
wire valid_out;
wire [18:0] C_out;

// other
reg [18:0] correct_data;
reg error_occur;
integer i, j, k;
reg [7:0] A_seq [0:7];
reg [7:0] B_seq [0:7];
// Instantiate the Unit Under Test (UUT)
Inner_Prod uut (
                .rst(rst),
                .clk(clk),
                .valid_in(valid_in),
                .A(A_input),
                .B(B_input),
                .valid_out(valid_out),
                .C(C_out));

initial clk = 0;
always #(CYCLE/2.0) clk = ~clk;

initial begin
    // Setup the signal dump file.
    $dumpfile("Inner_Prod.vcd"); // Set the name of the dump file.
    $dumpvars;                   // Save all signals to the dump file.

    // Display the signal values whenever there is a change.
    //$monitor("valid_in = %b,A = %d,B = %d,valid_out = %b,C = %d",
    //            valid_in, A_input, B_input, valid_out, C_out);

    // Initialize the input signals
    

    error_occur = 0;
    A_input = 0;
    B_input = 0;
    valid_in = 0;
    clk = 0;
    rst = 0;
    @(negedge clk); //Initialize reset
    rst = 1;
    @(negedge clk); //Initialize reset
    rst = 0;
    //valid_out and C should be zero after reset
    //You should make sure that when valid_out high , C contains correct data.

    if (valid_out !== 0) begin
        $display("Error: C or valid_out should be reset");
        error_occur = 1;
    end
    @(negedge clk);

    for(k=0; k<10; k=k+1) begin

        testcase_generate;

        valid_in = 1;
        for (i = 0 ; i < 8 ; i = i + 1) begin
            A_input = A_seq[i];
            B_input = B_seq[i];
            @(negedge clk); //input before posedge event
        end
        valid_in = 0;
        A_input = 0;
        B_input = 0;
        @(negedge clk);//It should take only one clock cycle to compute the inner-product and send the result to port C.
                    //Please write some testing code for this error case;
        $display("Correct = %d , C = %d",correct_data,C_out);
        if (C_out !== correct_data && valid_out === 1) begin
            $display("Error:result failed");
            error_occur = 1;
        end

        @(negedge clk);//Raising the valid_out signal by "only" one clock cycle
                    //Please write some testing code for this error case;
        if (error_occur === 0) begin
            $display("=========================");
            $display("Congratulations!!!");
            $display("=========================");
        end
    end
    $finish;
end



task testcase_generate; begin
    // You can try to use $random and for-loop to replace this section.

    A_seq[0] = {$random} %256;
    B_seq[0] = {$random} %256;

    A_seq[1] = {$random} %256;
    B_seq[1] = {$random} %256;

    A_seq[2] = {$random} %256;
    B_seq[2] = {$random} %256;

    A_seq[3] = {$random} %256;
    B_seq[3] = {$random} %256;

    A_seq[4] = {$random} %256;
    B_seq[4] = {$random} %256;

    A_seq[5] = {$random} %256;
    B_seq[5] = {$random} %256;

    A_seq[6] = {$random} %256;
    B_seq[6] = {$random} %256;

    A_seq[7] = {$random} %256;
    B_seq[7] = {$random} %256;

    correct_data = 19'b0;

    for(j=0; j<8; j=j+1) begin
        correct_data = A_seq[j] * B_seq[j] + correct_data;
    end
end endtask
endmodule


