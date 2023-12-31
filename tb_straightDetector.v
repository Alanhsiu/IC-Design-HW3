`timescale 1ns / 1ps

module straightDetector_tb;

    // Inputs
    reg [3:0] rank0;
    reg [3:0] rank1;
    reg [3:0] rank2;
    reg [3:0] rank3;
    reg [3:0] rank4;

    // Output
	wire isStraight, isStraightA2345, isStraight23456, isStraight34567, isStraight45678, isStraight56789, isStraight678910, isStraight78910J, isStraight8910JQ, isStraight910JQK, isStraight10JQKA;

    // Instantiate the Unit Under Test (UUT)
    straightDetector uut (
        .rank0(rank0), 
        .rank1(rank1), 
        .rank2(rank2), 
        .rank3(rank3), 
        .rank4(rank4), 
        .isStraight(isStraight),
        .isStraightA2345(isStraightA2345),
        .isStraight23456(isStraight23456),
        .isStraight34567(isStraight34567),
        .isStraight45678(isStraight45678),
        .isStraight56789(isStraight56789),
        .isStraight678910(isStraight678910),
        .isStraight78910J(isStraight78910J),
        .isStraight8910JQ(isStraight8910JQ),
        .isStraight910JQK(isStraight910JQK),
        .isStraight10JQKA(isStraight10JQKA)
    );

    initial begin
        // Initialize Inputs
        rank0 = 0;
        rank1 = 0;
        rank2 = 0;
        rank3 = 0;
        rank4 = 0;

        // Wait for 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        // Example test case: Not a straight (random cards)
        rank0 = 4;
        rank1 = 7;
        rank2 = 1;
        rank3 = 12;
        rank4 = 0;
        #10; // Wait for 10ns
        $display("isStraight = %d", isStraight);
        $display(isStraightA2345, isStraight23456, isStraight34567, isStraight45678, isStraight56789, isStraight678910, isStraight78910J, isStraight8910JQ, isStraight910JQK, isStraight10JQKA);


        // Example test case: A straight (5, 6, 7, 8, 9)
        rank0 = 7;
        rank1 = 6;
        rank2 = 5;
        rank3 = 8;
        rank4 = 9;
        #10; // Wait for 10ns
        $display("isStraight = %d", isStraight);
        $display(isStraightA2345, isStraight23456, isStraight34567, isStraight45678, isStraight56789, isStraight678910, isStraight78910J, isStraight8910JQ, isStraight910JQK, isStraight10JQKA);

        // Example test case: Not a straight (pair present)
        rank0 = 5;
        rank1 = 5;
        rank2 = 6;
        rank3 = 8;
        rank4 = 7;
        #10; // Wait for 10ns
        $display("isStraight = %d", isStraight);
        $display(isStraightA2345, isStraight23456, isStraight34567, isStraight45678, isStraight56789, isStraight678910, isStraight78910J, isStraight8910JQ, isStraight910JQK, isStraight10JQKA);


        // Example test case: A straight (10, J, Q, K, A)
        rank0 = 1;
        rank1 = 11;
        rank2 = 12;
        rank3 = 13;
        rank4 = 10;
        #10; // Wait for 10ns
        $display("isStraight = %d", isStraight);
        $display(isStraightA2345, isStraight23456, isStraight34567, isStraight45678, isStraight56789, isStraight678910, isStraight78910J, isStraight8910JQ, isStraight910JQK, isStraight10JQKA);


        // Add more test cases as needed
    end
      
endmodule
