`timescale 1ns / 1ps

module testbench;

    // Inputs
    reg [3:0] rank0;
    reg [3:0] rank1;
    reg [3:0] rank2;
    reg [3:0] rank3;
    reg [3:0] rank4;

    // Output
    wire isStraight45678;
    wire is4, is5, is6, is7, is8;

    // Instantiate the Unit Under Test (UUT)
    checkStraight45678 uut (
        .isStraight45678(isStraight45678),
        .rank0(rank0), 
        .rank1(rank1), 
        .rank2(rank2), 
        .rank3(rank3), 
        .rank4(rank4),
        .is4(is4),
        .is5(is5),
        .is6(is6),
        .is7(is7),
        .is8(is8)
    );

    initial begin
        // Apply test cases
        // Test case 1: Straight 4-5-6-7-8
        rank0 = 4'd5; rank1 = 4'd5; rank2 = 4'd6; rank3 = 4'd8; rank4 = 4'd7;
        #10;
        $display(isStraight45678);
        $display(is4, is5, is6, is7, is8);

        // Test case 2: Not a straight (e.g., 6-7-8-9-11)
        rank0 = 4'd10; rank1 = 4'd7; rank2 = 4'd8; rank3 = 4'd9; rank4 = 4'd11;
        #10;
        $display(isStraight45678);
        $display(is4, is5, is6, is7, is8);

        // Add more test cases as needed

        $finish;
    end
      
endmodule
