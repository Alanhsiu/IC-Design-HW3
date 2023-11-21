`timescale 1ns / 1ps

module testbench;

    // Inputs
    reg isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34;

    // Output
    wire isTwoPairs;

    // Instantiate the Unit Under Test (UUT)
    checkTwoPairs uut (
        .isTwoPairs(isTwoPairs),
        .isSameRank01(isSameRank01), 
        .isSameRank02(isSameRank02), 
        .isSameRank03(isSameRank03), 
        .isSameRank04(isSameRank04), 
        .isSameRank12(isSameRank12), 
        .isSameRank13(isSameRank13), 
        .isSameRank14(isSameRank14), 
        .isSameRank23(isSameRank23), 
        .isSameRank24(isSameRank24), 
        .isSameRank34(isSameRank34)
    );

    initial begin
        // Initialize Inputs
        isSameRank01 = 0;
        isSameRank02 = 0;
        isSameRank03 = 0;
        isSameRank04 = 0;
        isSameRank12 = 0;
        isSameRank13 = 0;
        isSameRank14 = 0;
        isSameRank23 = 0;
        isSameRank24 = 0;
        isSameRank34 = 0;

        isSameRank01 = 1; isSameRank02 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank01 = 0; isSameRank02 = 0;

        isSameRank03 = 1; isSameRank04 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank03 = 0; isSameRank04 = 0;

        isSameRank12 = 1; isSameRank13 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank12 = 0; isSameRank13 = 0;

        isSameRank14 = 1; isSameRank23 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank14 = 0; isSameRank23 = 0;

        isSameRank24 = 1; isSameRank34 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank24 = 0; isSameRank34 = 0;

        isSameRank01 = 1; isSameRank23 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank01 = 0; isSameRank23 = 0;

        isSameRank02 = 1; isSameRank34 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank02 = 0; isSameRank34 = 0;

        isSameRank03 = 1; isSameRank14 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank03 = 0; isSameRank14 = 0;

        isSameRank04 = 1; isSameRank12 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank04 = 0; isSameRank12 = 0;

        isSameRank12 = 1; isSameRank34 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank12 = 0; isSameRank34 = 0;

        isSameRank13 = 1; isSameRank24 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank13 = 0; isSameRank24 = 0;

        isSameRank14 = 1; isSameRank23 = 1;
        #10;
        $display("isTwoPairs = %d", isTwoPairs);
        isSameRank14 = 0; isSameRank23 = 0;





        // Add more test cases to cover different scenarios

        $finish;
    end
      
endmodule
