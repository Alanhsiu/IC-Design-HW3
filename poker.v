/***********************
IC Design HW3 - Poker Hand Type Detector
In this homework, you are asked to design a gate-level combinational circuit 
that finds the type of the given hands of five given playing cards. The inputs of this 
circuit are five 6-bit digital values, denoted as i0, i1, i2, i3, i4. The 2 MSBs in the 
6-bits indicate their suits. 0, 1, 2, and 3 refer to spades, hearts, diamonds, and clubs, 
respectively. While the remaining 4 bits are their ranks. Ace, Jack, Queen, and 
King are represented by 1, 11, 12, and 13, respectively. The output of the circuit, 
denoted as type, is a 4-bit unsigned number. 

Types and the corresponding output:

1000: straight flush
0111: four of a kind
0110: full house
0101: flush
0100: straight
0011: three of a kind
0010: two pairs
0001: one pair
0000: high card
************************/


`timescale 1ns/1ps

module flushDetector(
    input [1:0] suit0, suit1, suit2, suit3, suit4,
    output isFlush
);

    wire same_suit_bit0_01, same_suit_bit0_02, same_suit_bit0_03, same_suit_bit0_04;
	wire same_suit_bit1_01, same_suit_bit1_02, same_suit_bit1_03, same_suit_bit1_04;
    wire all_same_bit0, all_same_bit1;

    // compare the first bit of suit
    EN compare_suit_bit0_01(same_suit_bit0_01, suit0[0], suit1[0]);
    EN compare_suit_bit0_02(same_suit_bit0_02, suit0[0], suit2[0]);
    EN compare_suit_bit0_03(same_suit_bit0_03, suit0[0], suit3[0]);
    EN compare_suit_bit0_04(same_suit_bit0_04, suit0[0], suit4[0]);
    AN4 all_first_bits_same(all_same_bit0, same_suit_bit0_01, same_suit_bit0_02, same_suit_bit0_03, same_suit_bit0_04);

    // compare the second bit of suit
    EN compare_suit_bit1_01(same_suit_bit1_01, suit0[1], suit1[1]);
    EN compare_suit_bit1_02(same_suit_bit1_02, suit0[1], suit2[1]);
    EN compare_suit_bit1_03(same_suit_bit1_03, suit0[1], suit3[1]);
    EN compare_suit_bit1_04(same_suit_bit1_04, suit0[1], suit4[1]);
    AN4 all_second_bits_same(all_same_bit1, same_suit_bit1_01, same_suit_bit1_02, same_suit_bit1_03, same_suit_bit1_04);

    AN2 is_flush_gate(isFlush, all_same_bit0, all_same_bit1);

endmodule

module sameRankComparator2(
    output isSameRank,
    input [3:0] rank1,
    input [3:0] rank2
);

    wire [3:0] diff;

    // compare each bit of rank
    EO compare_bit0(diff[0], rank1[0], rank2[0]);
    EO compare_bit1(diff[1], rank1[1], rank2[1]);
    EO compare_bit2(diff[2], rank1[2], rank2[2]);
    EO compare_bit3(diff[3], rank1[3], rank2[3]);

    NR4 check_all_bits_same(isSameRank, diff[0], diff[1], diff[2], diff[3]);

endmodule

module sameRankComparator3(
	output isSameRank,
	input [3:0] rank1,
	input [3:0] rank2,
	input [3:0] rank3
);

	wire isSameRank12, isSameRank13;

	sameRankComparator2 compare_rank12(isSameRank12, rank1, rank2);
	sameRankComparator2 compare_rank13(isSameRank13, rank1, rank3);

	AN2 isSameRank_gate(isSameRank, isSameRank12, isSameRank13);

endmodule

module sameRankComparator4(
	output isSameRank,
	input [3:0] rank1,
	input [3:0] rank2,
	input [3:0] rank3,
	input [3:0] rank4
);

	wire isSameRank12, isSameRank23, isSameRank34;

	sameRankComparator2 compare_rank12(isSameRank12, rank1, rank2);
	sameRankComparator2 compare_rank23(isSameRank23, rank2, rank3);
	sameRankComparator2 compare_rank34(isSameRank34, rank3, rank4);

	AN3 isSameRank_gate(isSameRank, isSameRank12, isSameRank23, isSameRank34);

endmodule

module sameRankDetector(
    input [3:0] rank0, rank1, rank2, rank3, rank4,
    output existThreeOfAKind, isPair, isTwoPair, isThreeOfAKind, isFourOfAKind, isFullHouse
);

	wire notExistThreeOfAKind;
	wire notFourOfAKind, notFullHouse, notThreeOfAKind, notTwoPair, notOnePair;
    wire isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34;
    wire isSameRank012, isSameRank013, isSameRank014, isSameRank023, isSameRank024, isSameRank034, isSameRank123, isSameRank124, isSameRank134, isSameRank234;
    wire isSameRank0123, isSameRank0124, isSameRank0134, isSameRank0234, isSameRank1234;

	// assign notGate
	IV notExistThreeOfAKind_gate(notExistThreeOfAKind, existThreeOfAKind);
	IV notFourOfAKind_gate(notFourOfAKind, isFourOfAKind);
	IV notFullHouse_gate(notFullHouse, isFullHouse);
	IV notThreeOfAKind_gate(notThreeOfAKind, isThreeOfAKind);
	IV notTwoPair_gate(notTwoPair, isTwoPair);
	IV notOnePair_gate(notOnePair, isPair);

    // any two ranks
    sameRankComparator2 compare01(isSameRank01, rank0, rank1);
    sameRankComparator2 compare02(isSameRank02, rank0, rank2);
    sameRankComparator2 compare03(isSameRank03, rank0, rank3);
	sameRankComparator2 compare04(isSameRank04, rank0, rank4);
	sameRankComparator2 compare12(isSameRank12, rank1, rank2);
	sameRankComparator2 compare13(isSameRank13, rank1, rank3);
	sameRankComparator2 compare14(isSameRank14, rank1, rank4);
	sameRankComparator2 compare23(isSameRank23, rank2, rank3);
	sameRankComparator2 compare24(isSameRank24, rank2, rank4);
	sameRankComparator2 compare34(isSameRank34, rank3, rank4);
    
    // any three ranks
    sameRankComparator3 compare012(isSameRank012, rank0, rank1, rank2);
    sameRankComparator3 compare013(isSameRank013, rank0, rank1, rank3);
    sameRankComparator3 compare014(isSameRank014, rank0, rank1, rank4);
	sameRankComparator3 compare023(isSameRank023, rank0, rank2, rank3);
	sameRankComparator3 compare024(isSameRank024, rank0, rank2, rank4);
	sameRankComparator3 compare034(isSameRank034, rank0, rank3, rank4);
	sameRankComparator3 compare123(isSameRank123, rank1, rank2, rank3);
	sameRankComparator3 compare124(isSameRank124, rank1, rank2, rank4);
	sameRankComparator3 compare134(isSameRank134, rank1, rank3, rank4);
	sameRankComparator3 compare234(isSameRank234, rank2, rank3, rank4);

    // any four ranks
	sameRankComparator4 compare0123(isSameRank0123, rank0, rank1, rank2, rank3);
	sameRankComparator4 compare0124(isSameRank0124, rank0, rank1, rank2, rank4);
	sameRankComparator4 compare0134(isSameRank0134, rank0, rank1, rank3, rank4);
	sameRankComparator4 compare0234(isSameRank0234, rank0, rank2, rank3, rank4);
	sameRankComparator4 compare1234(isSameRank1234, rank1, rank2, rank3, rank4);


    // four of a kind
    wire or_four_1;
    OR4 or4_four(or_four_1, isSameRank0123, isSameRank0124, isSameRank0134, isSameRank0234);
    OR2 or2_four(isFourOfAKind, or_four_1, isSameRank1234);

    // check if exist two pairs
	wire two_pair[14:0];
	AN2 and2_two_pair_1(two_pair[0], isSameRank01, isSameRank23);
	AN2 and2_two_pair_2(two_pair[1], isSameRank01, isSameRank24);
	AN2 and2_two_pair_3(two_pair[2], isSameRank01, isSameRank34);
	AN2 and2_two_pair_4(two_pair[3], isSameRank02, isSameRank13);
	AN2 and2_two_pair_5(two_pair[4], isSameRank02, isSameRank14);
	AN2 and2_two_pair_6(two_pair[5], isSameRank02, isSameRank34);
	AN2 and2_two_pair_7(two_pair[6], isSameRank03, isSameRank12);
	AN2 and2_two_pair_8(two_pair[7], isSameRank03, isSameRank14);
	AN2 and2_two_pair_9(two_pair[8], isSameRank03, isSameRank24);
	AN2 and2_two_pair_10(two_pair[9], isSameRank04, isSameRank12);
	AN2 and2_two_pair_11(two_pair[10], isSameRank04, isSameRank13);
	AN2 and2_two_pair_12(two_pair[11], isSameRank04, isSameRank23);
	AN2 and2_two_pair_13(two_pair[12], isSameRank12, isSameRank34);
	AN2 and2_two_pair_14(two_pair[13], isSameRank13, isSameRank24);
	AN2 and2_two_pair_15(two_pair[14], isSameRank14, isSameRank23);

	wire temp1, temp2, temp3, temp4;
	OR4 or4_two_pair_1(temp1, two_pair[0], two_pair[1], two_pair[2], two_pair[3]);
	OR4 or4_two_pair_2(temp2, two_pair[4], two_pair[5], two_pair[6], two_pair[7]);
	OR4 or4_two_pair_3(temp3, two_pair[8], two_pair[9], two_pair[10], two_pair[11]);
	OR3 or3_two_pair(temp4, two_pair[12], two_pair[13], two_pair[14]);
	OR4 or4_two_pair(isExistTwoPair, temp1, temp2, temp3, temp4);


    // check if exist three of a kind
    wire or_three_1, or_three_2;
    OR4 or4_three_1(or_three_1, isSameRank012, isSameRank013, isSameRank014, isSameRank023);
    OR4 or4_three_2(or_three_2, isSameRank024, isSameRank034, isSameRank123, isSameRank124);
    OR4 orr_three_3(existThreeOfAKind, or_three_1, or_three_2, isSameRank134, isSameRank234);

	// check if exist any pair
    wire isAnyPair, or_pair_1, or_pair_2;
    OR4 or4_pair_1(or_pair_1, isSameRank01, isSameRank02, isSameRank03, isSameRank04);
    OR4 or4_pair_2(or_pair_2, isSameRank12, isSameRank13, isSameRank14, isSameRank23);
    OR4 isAnyPair_gate(isAnyPair, or_pair_1, or_pair_2, isSameRank24, isSameRank34);

	// full house
	AN2 isFullHouse_gate(isFullHouse, isExistTwoPair, existThreeOfAKind);

	// three of a kind
	AN3 threeOfAKind_gate(isThreeOfAKind, existThreeOfAKind, notFourOfAKind, notFullHouse); 

    // two pairs
	AN4 twoPair_gate(isTwoPair, isExistTwoPair, notThreeOfAKind, notFourOfAKind, notFullHouse);

	// one pair
	AN4 onePair_gate(isPair, isAnyPair, notTwoPair, notExistThreeOfAKind, notFourOfAKind);

endmodule

module subtractor(
	output [3:0] diff,
	input [3:0] minuend,
	input [3:0] subtrahend
);

	wire [3:0] subtrahend_complement;
	
	// get the complement of subtrahend
	IV subtrahend_complement_gate1(subtrahend_complement[0], subtrahend[0]);
	IV subtrahend_complement_gate2(subtrahend_complement[1], subtrahend[1]);
	IV subtrahend_complement_gate3(subtrahend_complement[2], subtrahend[2]);
	IV subtrahend_complement_gate4(subtrahend_complement[3], subtrahend[3]);

	// use FA1 to get the difference
	wire CO1, CO2, CO3, CO4;
	FA1 fa1_1(CO1, diff[0], minuend[0], subtrahend_complement[0], 1'b1); // 2's complement
 	FA1 fa1_2(CO2, diff[1], minuend[1], subtrahend_complement[1], CO1);
	FA1 fa1_3(CO3, diff[2], minuend[2], subtrahend_complement[2], CO2);
	FA1 fa1_4(CO4, diff[3], minuend[3], subtrahend_complement[3], CO3);

endmodule

module rankComparator2(
	output isRank1BiggerOrEqual,
	input [3:0] rank1,
	input [3:0] rank2
);

	wire [3:0] diff;
	subtractor subtractor1(diff, rank1, rank2);

	// check if rank1 is bigger than or equal to rank2
	IV isRank1BiggerOrEqual_gate(isRank1BiggerOrEqual, diff[3]);
	
endmodule

module checkIfLargerbyOne(
	output isLargerbyOne,
	input [3:0] rank1,
	input [3:0] rank2
);

	// add 1 to rank1
	wire [3:0] rank1_plus_1;
	wire CO1, CO2, CO3, CO4;
	FA1 fa1_gate(CO1, rank1_plus_1[0], rank1[0], 1'b1, 1'b0);
	FA1 fa2_gate(CO2, rank1_plus_1[1], rank1[1], 1'b0, CO1);
	FA1 fa3_gate(CO3, rank1_plus_1[2], rank1[2], 1'b0, CO2);
	FA1 fa4_gate(CO4, rank1_plus_1[3], rank1[3], 1'b0, CO3);

	// check if rank1_plus_1 is equal to rank2
	sameRankComparator2 compare_rank(isLargerbyOne, rank1_plus_1, rank2);

endmodule

module sortbyRank(
    input [3:0] rank0, rank1, rank2, rank3, rank4,
    output reg [3:0] sorted_rank0, sorted_rank1, sorted_rank2, sorted_rank3, sorted_rank4
);

    reg [3:0] sorted_rank[4:0];
    reg [3:0] temp;



	// use generate for
	reg [3:0] rank[4:0];

	always @(*)
	begin
		rank[0] = rank0;
		rank[1] = rank1;
		rank[2] = rank2;
		rank[3] = rank3;
		rank[4] = rank4;
	end

	// use generate for to generate compareResult
	wire compareResult[4:0][4:0];

	genvar r1, r2;
	generate
		for (r1 = 0; r1 < 5; r1 = r1 + 1)
		begin
			for (r2 = 0; r2 < 5; r2 = r2 + 1)
			begin
				if (r1 == r2)
				begin
					assign compareResult[r1][r2] = 1'b0;
				end
				else
				begin
					rankComparator2 compare_rank(compareResult[r1][r2], rank[r1], rank[r2]);
				end
			end
		end
	endgenerate

	
	// rankComparator2 compare_rank01(compareResult[0][0], rank0, rank1);
	// rankComparator2 compare_rank02(compareResult[0][1], rank0, rank2);
	// rankComparator2 compare_rank03(compareResult[0][2], rank0, rank3);
	// rankComparator2 compare_rank04(compareResult[0][3], rank0, rank4);
	// rankComparator2 compare_rank10(compareResult[1][0], rank1, rank0);
	// rankComparator2 compare_rank12(compareResult[1][1], rank1, rank2);
	// rankComparator2 compare_rank13(compareResult[1][2], rank1, rank3);
	// rankComparator2 compare_rank14(compareResult[1][3], rank1, rank4);
	// rankComparator2 compare_rank20(compareResult[2][0], rank2, rank0);
	// rankComparator2 compare_rank21(compareResult[2][1], rank2, rank1);
	// rankComparator2 compare_rank23(compareResult[2][2], rank2, rank3);
	// rankComparator2 compare_rank24(compareResult[2][3], rank2, rank4);
	// rankComparator2 compare_rank30(compareResult[3][0], rank3, rank0);
	// rankComparator2 compare_rank31(compareResult[3][1], rank3, rank1);
	// rankComparator2 compare_rank32(compareResult[3][2], rank3, rank2);
	// rankComparator2 compare_rank34(compareResult[3][3], rank3, rank4);
	// rankComparator2 compare_rank40(compareResult[4][0], rank4, rank0);
	// rankComparator2 compare_rank41(compareResult[4][1], rank4, rank1);
	// rankComparator2 compare_rank42(compareResult[4][2], rank4, rank2);
	// rankComparator2 compare_rank43(compareResult[4][3], rank4, rank3);

	


	// if compareResult[i] has 4 1's, then rank[i] is the largest
	wire isRank0Has4Ones, isRank1Has4Ones, isRank2Has4Ones, isRank3Has4Ones, isRank4Has4Ones;
	AN4 isRank0Has4Ones_gate(isRank0Has4Ones, compareResult[0][0], compareResult[0][1], compareResult[0][2], compareResult[0][3]);
	AN4 isRank1Has4Ones_gate(isRank1Has4Ones, compareResult[1][0], compareResult[1][1], compareResult[1][2], compareResult[1][3]);
	AN4 isRank2Has4Ones_gate(isRank2Has4Ones, compareResult[2][0], compareResult[2][1], compareResult[2][2], compareResult[2][3]);
	AN4 isRank3Has4Ones_gate(isRank3Has4Ones, compareResult[3][0], compareResult[3][1], compareResult[3][2], compareResult[3][3]);
	AN4 isRank4Has4Ones_gate(isRank4Has4Ones, compareResult[4][0], compareResult[4][1], compareResult[4][2], compareResult[4][3]);

	// if compareResult[i] has 3 1's, then rank[i] is the second largest
	wire isRank0Has3Ones, isRank1Has3Ones, isRank2Has3Ones, isRank3Has3Ones, isRank4Has3Ones;

	wire temp01, temp02, temp03, temp04, temp11, temp12, temp13, temp14, temp21, temp22, temp23, temp24, temp31, temp32, temp33, temp34, temp41, temp42, temp43, temp44;
	AN3 isRank0Has3Ones1_gate(temp01, compareResult[0][0], compareResult[0][1], compareResult[0][2]);
	AN3 isRank0Has3Ones2_gate(temp02, compareResult[0][0], compareResult[0][1], compareResult[0][3]);
	AN3 isRank0Has3Ones3_gate(temp03, compareResult[0][0], compareResult[0][2], compareResult[0][3]);
	AN3 isRank0Has3Ones4_gate(temp04, compareResult[0][1], compareResult[0][2], compareResult[0][3]);
	AN4 isRank0Has3Ones_gate(isRank0Has3Ones, temp01, temp02, temp03, temp04);

	AN3 isRank1Has3Ones1_gate(temp11, compareResult[1][0], compareResult[1][1], compareResult[1][2]);
	AN3 isRank1Has3Ones2_gate(temp12, compareResult[1][0], compareResult[1][1], compareResult[1][3]);
	AN3 isRank1Has3Ones3_gate(temp13, compareResult[1][0], compareResult[1][2], compareResult[1][3]);
	AN3 isRank1Has3Ones4_gate(temp14, compareResult[1][1], compareResult[1][2], compareResult[1][3]);
	AN4 isRank1Has3Ones_gate(isRank1Has3Ones, temp11, temp12, temp13, temp14);

	AN3 isRank2Has3Ones1_gate(temp21, compareResult[2][0], compareResult[2][1], compareResult[2][2]);
	AN3 isRank2Has3Ones2_gate(temp22, compareResult[2][0], compareResult[2][1], compareResult[2][3]);
	AN3 isRank2Has3Ones3_gate(temp23, compareResult[2][0], compareResult[2][2], compareResult[2][3]);
	AN3 isRank2Has3Ones4_gate(temp24, compareResult[2][1], compareResult[2][2], compareResult[2][3]);
	AN4 isRank2Has3Ones_gate(isRank2Has3Ones, temp21, temp22, temp23, temp24);

	AN3 isRank3Has3Ones1_gate(temp31, compareResult[3][0], compareResult[3][1], compareResult[3][2]);
	AN3 isRank3Has3Ones2_gate(temp32, compareResult[3][0], compareResult[3][1], compareResult[3][3]);
	AN3 isRank3Has3Ones3_gate(temp33, compareResult[3][0], compareResult[3][2], compareResult[3][3]);
	AN3 isRank3Has3Ones4_gate(temp34, compareResult[3][1], compareResult[3][2], compareResult[3][3]);
	AN4 isRank3Has3Ones_gate(isRank3Has3Ones, temp31, temp32, temp33, temp34);

	AN3 isRank4Has3Ones1_gate(temp41, compareResult[4][0], compareResult[4][1], compareResult[4][2]);
	AN3 isRank4Has3Ones2_gate(temp42, compareResult[4][0], compareResult[4][1], compareResult[4][3]);
	AN3 isRank4Has3Ones3_gate(temp43, compareResult[4][0], compareResult[4][2], compareResult[4][3]);
	AN3 isRank4Has3Ones4_gate(temp44, compareResult[4][1], compareResult[4][2], compareResult[4][3]);
	AN4 isRank4Has3Ones_gate(isRank4Has3Ones, temp41, temp42, temp43, temp44);


	// assign sorted_rank
	
    integer i, j;
	reg compare;

    always @(*)
    begin
        sorted_rank[0] = rank0;
        sorted_rank[1] = rank1;
        sorted_rank[2] = rank2;
        sorted_rank[3] = rank3;
        sorted_rank[4] = rank4;

        // sort from small to large
        for (i = 0; i < 4; i = i + 1)
        begin
            for (j = 0; j < 4 - i; j = j + 1)
            begin
                if (sorted_rank[j] > sorted_rank[j + 1])
                begin
                    temp = sorted_rank[j];
                    sorted_rank[j] = sorted_rank[j + 1];
                    sorted_rank[j + 1] = temp;
                end
            end
        end

        sorted_rank0 = sorted_rank[0];
        sorted_rank1 = sorted_rank[1];
        sorted_rank2 = sorted_rank[2];
        sorted_rank3 = sorted_rank[3];
        sorted_rank4 = sorted_rank[4];
    end

endmodule


module straightDetector(
	input [3:0] rank0, rank1, rank2, rank3, rank4,
	output isStraight
);
	
	wire [3:0] sorted_rank0, sorted_rank1, sorted_rank2, sorted_rank3, sorted_rank4;
	reg temp, isRank1BiggerOrEqual;

	integer i;
	integer j;

	// if exist three of a kind, then it is not straight
	wire existThreeOfAKind, notExistThreeOfAKind;
	sameRankDetector sameRankDetector(
		.rank0(rank0), .rank1(rank1), .rank2(rank2), .rank3(rank3), .rank4(rank4),
		.existThreeOfAKind(existThreeOfAKind)
	);
	assign notExistThreeOfAKind = ~existThreeOfAKind;

	// sort by rank
	sortbyRank sortbyRank(
		.rank0(rank0), .rank1(rank1), .rank2(rank2), .rank3(rank3), .rank4(rank4),
		.sorted_rank0(sorted_rank0), .sorted_rank1(sorted_rank1), .sorted_rank2(sorted_rank2), .sorted_rank3(sorted_rank3), .sorted_rank4(sorted_rank4)
	);

	// check if it is straight
	wire isLargerbyOne01, isLargerbyOne12, isLargerbyOne23, isLargerbyOne34;
	checkIfLargerbyOne compare01(isLargerbyOne01, sorted_rank0, sorted_rank1);
	checkIfLargerbyOne compare12(isLargerbyOne12, sorted_rank1, sorted_rank2);
	checkIfLargerbyOne compare23(isLargerbyOne23, sorted_rank2, sorted_rank3);
	checkIfLargerbyOne compare34(isLargerbyOne34, sorted_rank3, sorted_rank4);

	// special case: A, 10, J, Q, K
	// if sorted_rank0 = 1, sorted_rank1 = 10, sorted_rank2 = 11, sorted_rank3 = 12, sorted_rank4 = 13
	// then isLargerbyOne01 = 0, isLargerbyOne12 = 1, isLargerbyOne23 = 1, isLargerbyOne34 = 1
	wire isSpecialCase;
	assign isSpecialCase = (sorted_rank4 - sorted_rank0 == 4'b1100);

	wire lastThreeCompare;
	wire considerSpecialCase;
	EO considerSpecialCase_gate(considerSpecialCase, isSpecialCase, isLargerbyOne01);
	AN3 lastThreeCompare_gate(lastThreeCompare, isLargerbyOne12, isLargerbyOne23, isLargerbyOne34);

	AN3 isStraight_gate(isStraight, considerSpecialCase, lastThreeCompare, notExistThreeOfAKind);

endmodule

module poker(type, i0, i1, i2, i3, i4);
    // DO NOT CHANGE!
    input  [5:0] i0, i1, i2, i3, i4;
    output [3:0] type;
    //---------------------------------------------------

    wire [1:0] suit[4:0]; // a 2-bit vector for each card
    wire [3:0] rank[4:0]; // a 4-bit vector for each card

    // Splitting input into suits and ranks
    assign suit[0] = i0[5:4]; assign rank[0] = i0[3:0];
    assign suit[1] = i1[5:4]; assign rank[1] = i1[3:0];
    assign suit[2] = i2[5:4]; assign rank[2] = i2[3:0];
    assign suit[3] = i3[5:4]; assign rank[3] = i3[3:0];
    assign suit[4] = i4[5:4]; assign rank[4] = i4[3:0];        

	// flush detector
	wire isFlush;
	flushDetector flushDetector(
		.suit0(suit[0]), .suit1(suit[1]), .suit2(suit[2]), .suit3(suit[3]), .suit4(suit[4]),
		.isFlush(isFlush)
	);

	// same rank detector
	wire existThreeOfAKind, isPair, isTwoPair, isThreeOfAKind, isFourOfAKind, isFullHouse;
	sameRankDetector sameRankDetector(
		.rank0(rank[0]), .rank1(rank[1]), .rank2(rank[2]), .rank3(rank[3]), .rank4(rank[4]),
		.existThreeOfAKind(existThreeOfAKind), .isPair(isPair), .isTwoPair(isTwoPair), .isThreeOfAKind(isThreeOfAKind), .isFourOfAKind(isFourOfAKind), .isFullHouse(isFullHouse)
	);

	// straight detector
	wire isStraight;
	straightDetector straightDetector(
		.rank0(rank[0]), .rank1(rank[1]), .rank2(rank[2]), .rank3(rank[3]), .rank4(rank[4]),
		.isStraight(isStraight)
	);

	// type determination
	wire highCard, onePair, twoPairs, threeOfAKind, straight, flush, fullHouse, fourOfAKind, straightFlush;
	wire notStraightFlush, notFourOfAKind, notFullHouse, notFlush, notStraight, notThreeOfAKind, notTwoPairs, notOnePair, notHighCard;

	IV notStraightFlush_gate(notStraightFlush, straightFlush);
	IV notFourOfAKind_gate(notFourOfAKind, fourOfAKind);
	IV notFullHouse_gate(notFullHouse, fullHouse);
	IV notFlush_gate(notFlush, flush);
	IV notStraight_gate(notStraight, straight);
	IV notThreeOfAKind_gate(notThreeOfAKind, threeOfAKind);
	IV notTwoPairs_gate(notTwoPairs, twoPairs);
	IV notOnePair_gate(notOnePair, onePair);
	IV notHighCard_gate(notHighCard, highCard);

	AN2 straightFlush_gate(straightFlush, isFlush, isStraight);
	assign fourOfAKind = isFourOfAKind;
	assign fullHouse = isFullHouse;
	AN2 flush_gate(flush, isFlush, notStraightFlush);
	AN2 straight_gate(straight, isStraight, notStraightFlush);
	assign threeOfAKind = isThreeOfAKind;
	assign twoPair = isTwoPair;
	assign onePair = isPair;

	assign type[3] = straightFlush;
	OR4 type_2(type[2], fourOfAKind, fullHouse, flush, straight); // four of a kind, full house, flush, straight
	OR4 type_1(type[1], fourOfAKind, fullHouse, threeOfAKind, twoPair); // four of a kind, full house, three of a kind, two pairs
	OR4 type_0(type[0], fourOfAKind, flush, threeOfAKind, onePair); // four of a kind, flush, three of a kind, one pair

	// assign type[3] = fourOfAKind;
	// assign type[2] = fourOfAKind;
	// assign type[1] = fourOfAKind;
	// assign type[0] = fourOfAKind;
	
	// 1000: straight flush
	// 0111: four of a kind
	// 0110: full house
	// 0101: flush
	// 0100: straight
	// 0011: three of a kind
	// 0010: two pairs
	// 0001: one pair
	// 0000: high card
endmodule