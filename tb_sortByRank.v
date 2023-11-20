`timescale 1ns / 1ps

module tb_sortByRank();

    // Inputs
    reg [3:0] rank0, rank1, rank2, rank3, rank4;

    // Outputs
    wire [3:0] sorted_rank0, sorted_rank1, sorted_rank2, sorted_rank3, sorted_rank4;

    // Instantiate the Unit Under Test (UUT)
    sortByRank uut (
        .rank0(rank0), 
        .rank1(rank1), 
        .rank2(rank2), 
        .rank3(rank3), 
        .rank4(rank4), 
        .sorted_rank0(sorted_rank0), 
        .sorted_rank1(sorted_rank1), 
        .sorted_rank2(sorted_rank2), 
        .sorted_rank3(sorted_rank3), 
        .sorted_rank4(sorted_rank4)
    );

    initial begin
        // Initialize Inputs
        rank0 = 0;
        rank1 = 0;
        rank2 = 0;
        rank3 = 0;
        rank4 = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        rank0 = 4; rank1 = 2; rank2 = 5; rank3 = 1; rank4 = 3;
        #10; // Wait for the sorting to complete

        // print the sorted ranks
        $display("Sorted Ranks: %d %d %d %d %d", sorted_rank0, sorted_rank1, sorted_rank2, sorted_rank3, sorted_rank4);
        
        // Check if the sorting is correct
        if (sorted_rank0 <= sorted_rank1 && sorted_rank1 <= sorted_rank2 && sorted_rank2 <= sorted_rank3 && sorted_rank3 <= sorted_rank4)
            $display("Test Passed: Sorting is correct.");
        else
            $display("Test Failed: Sorting is incorrect.");

        // Finish the simulation
        $finish;
    end
      
endmodule
