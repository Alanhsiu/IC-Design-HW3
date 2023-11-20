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
    output existOnePair, isPair, isTwoPair, isThreeOfAKind, isFourOfAKind, isFullHouse
);

	wire existTwoPair, existThreeOfAKind, notExistThreeOfAKind;
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
	OR4 or4_two_pair(existTwoPair, temp1, temp2, temp3, temp4);


    // check if exist three of a kind
    wire or_three_1, or_three_2;
    OR4 or4_three_1(or_three_1, isSameRank012, isSameRank013, isSameRank014, isSameRank023);
    OR4 or4_three_2(or_three_2, isSameRank024, isSameRank034, isSameRank123, isSameRank124);
    OR4 orr_three_3(existThreeOfAKind, or_three_1, or_three_2, isSameRank134, isSameRank234);

	// check if exist any pair
    wire or_pair_1, or_pair_2;
    OR4 or4_pair_1(or_pair_1, isSameRank01, isSameRank02, isSameRank03, isSameRank04);
    OR4 or4_pair_2(or_pair_2, isSameRank12, isSameRank13, isSameRank14, isSameRank23);
    OR4 isAnyPair_gate(existOnePair, or_pair_1, or_pair_2, isSameRank24, isSameRank34);

	// full house
	AN2 isFullHouse_gate(isFullHouse, existTwoPair, existThreeOfAKind);

	// three of a kind
	AN3 threeOfAKind_gate(isThreeOfAKind, existThreeOfAKind, notFourOfAKind, notFullHouse); 

    // two pairs
	AN4 twoPair_gate(isTwoPair, existTwoPair, notThreeOfAKind, notFourOfAKind, notFullHouse);

	// one pair
	AN4 onePair_gate(isPair, existOnePair, notTwoPair, notExistThreeOfAKind, notFourOfAKind);

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

module checkIfLargerbyOne( // check if rank1 is larger than rank2 by 1
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

module checkIfDiffByOne1( // check if abs(rank1 - rank2) = 1
	output isDiffByOne,
	input [3:0] rank1,
	input [3:0] rank2
);

	wire [3:0] diff;
	subtractor subtractor1(diff, rank1, rank2);

	wire isLargerbyOne12, isLargerbyOne21;
	checkIfLargerbyOne compare12(isLargerbyOne12, rank1, rank2);
	checkIfLargerbyOne compare21(isLargerbyOne21, rank2, rank1);

	OR2 isDiffByOne_gate(isDiffByOne, isLargerbyOne12, isLargerbyOne21);

endmodule

module checkIfDiffByOne(
    output isDiffByOne,
    input [3:0] rank1,
    input [3:0] rank2
);

    // expand all the possibilities, (1,2), (2,1), (2,3), (3,2), (3,4), (4,3), (4,5), (5,4), (5,6), (6,5), (6,7), (7,6), (7,8), (8,7), (8,9), (9,8), (9,10), (10,9), (10,11), (11,10), (11,12), (12,11), (12,13), (13,12), total 24 cases
	wire isDiffByOne_12, isDiffByOne_21, isDiffByOne_23, isDiffByOne_32, isDiffByOne_34, isDiffByOne_43, isDiffByOne_45, isDiffByOne_54, isDiffByOne_56, isDiffByOne_65, isDiffByOne_67, isDiffByOne_76, isDiffByOne_78, isDiffByOne_87, isDiffByOne_89, isDiffByOne_98, isDiffByOne_910, isDiffByOne_109, isDiffByOne_1011, isDiffByOne_1110, isDiffByOne_1112, isDiffByOne_1211, isDiffByOne_1213, isDiffByOne_1312;
	// assign isDiffByOne_12 = (rank1==1 && rank2==2);
	// assign isDiffByOne_21 = (rank1==2 && rank2==1);
	// assign isDiffByOne_23 = (rank1==2 && rank2==3);
	// assign isDiffByOne_32 = (rank1==3 && rank2==2);
	// assign isDiffByOne_34 = (rank1==3 && rank2==4);
	// assign isDiffByOne_43 = (rank1==4 && rank2==3);
	// assign isDiffByOne_45 = (rank1==4 && rank2==5);
	// assign isDiffByOne_54 = (rank1==5 && rank2==4);
	// assign isDiffByOne_56 = (rank1==5 && rank2==6);
	// assign isDiffByOne_65 = (rank1==6 && rank2==5);
	// assign isDiffByOne_67 = (rank1==6 && rank2==7);
	// assign isDiffByOne_76 = (rank1==7 && rank2==6);
	// assign isDiffByOne_78 = (rank1==7 && rank2==8);
	// assign isDiffByOne_87 = (rank1==8 && rank2==7);
	// assign isDiffByOne_89 = (rank1==8 && rank2==9);
	// assign isDiffByOne_98 = (rank1==9 && rank2==8);
	// assign isDiffByOne_910 = (rank1==9 && rank2==10);
	// assign isDiffByOne_109 = (rank1==10 && rank2==9);
	// assign isDiffByOne_1011 = (rank1==10 && rank2==11);
	// assign isDiffByOne_1110 = (rank1==11 && rank2==10);
	// assign isDiffByOne_1112 = (rank1==11 && rank2==12);
	// assign isDiffByOne_1211 = (rank1==12 && rank2==11);
	// assign isDiffByOne_1213 = (rank1==12 && rank2==13);
	// assign isDiffByOne_1312 = (rank1==13 && rank2==12);

	wire isRank1[12:0];
	wire isRank2[12:0];
	wire isDifferByOne[12:0][12:0];

	genvar i, j;
	generate
		for (i = 0; i < 13; i = i + 1)
		begin
			sameRankComparator2 isSameRank1(isRank1[i], rank1, i+1);
			sameRankComparator2 isSameRank2(isRank2[i], rank2, i+1);
			for (j = 0; j < 13; j = j + 1)
			begin
				if(i-j==1 || j-i==1)
				begin
					AN2 isDifferByOne_gate(isDifferByOne[i][j], isRank1[i], isRank2[j]);
				end
				else
				begin
					assign isDifferByOne[i][j] = 1'b0;
				end
			end
		end
	endgenerate


	// or or24_gate(isDiffByOne, isDiffByOne_12, isDiffByOne_21, isDiffByOne_23, isDiffByOne_32, isDiffByOne_34, isDiffByOne_43, isDiffByOne_45, isDiffByOne_54, isDiffByOne_56, isDiffByOne_65, isDiffByOne_67, isDiffByOne_76, isDiffByOne_78, isDiffByOne_87, isDiffByOne_89, isDiffByOne_98, isDiffByOne_910, isDiffByOne_109, isDiffByOne_1011, isDiffByOne_1110, isDiffByOne_1112, isDiffByOne_1211, isDiffByOne_1213, isDiffByOne_1312);
	// wire temp1, temp2, temp3, temp4, temp5, temp6, temp7;
	// OR4 or4_1(temp1, isDiffByOne_12, isDiffByOne_21, isDiffByOne_23, isDiffByOne_32);
	// OR4 or4_2(temp2, isDiffByOne_34, isDiffByOne_43, isDiffByOne_45, isDiffByOne_54);
	// OR4 or4_3(temp3, isDiffByOne_56, isDiffByOne_65, isDiffByOne_67, isDiffByOne_76);
	// OR4 or4_4(temp4, isDiffByOne_78, isDiffByOne_87, isDiffByOne_89, isDiffByOne_98);
	// OR4 or4_5(temp5, isDiffByOne_910, isDiffByOne_109, isDiffByOne_1011, isDiffByOne_1110);
	// OR4 or4_6(temp6, isDiffByOne_1112, isDiffByOne_1211, isDiffByOne_1213, isDiffByOne_1312);
	// OR4 or4_7(temp7, temp1, temp2, temp3, temp4);
	// OR3 or3_1(isDiffByOne, temp5, temp6, temp7);

	wire temp[9:0];
	
	OR4 or4_1(temp[0], isDifferByOne[0][1], isDifferByOne[1][0], isDifferByOne[1][2], isDifferByOne[2][1]);
	OR4 or4_2(temp[1], isDifferByOne[2][3], isDifferByOne[3][2], isDifferByOne[3][4], isDifferByOne[4][3]);
	OR4 or4_3(temp[2], isDifferByOne[4][5], isDifferByOne[5][4], isDifferByOne[5][6], isDifferByOne[6][5]);
	OR4 or4_4(temp[3], isDifferByOne[6][7], isDifferByOne[7][6], isDifferByOne[7][8], isDifferByOne[8][7]);
	OR4 or4_5(temp[4], isDifferByOne[8][9], isDifferByOne[9][8], isDifferByOne[9][10], isDifferByOne[10][9]);
	OR4 or4_6(temp[5], isDifferByOne[10][11], isDifferByOne[11][10], isDifferByOne[11][12], isDifferByOne[12][11]);
	// or or7_1(isDiffByOne, temp[0], temp[1], temp[2], temp[3], temp[4], temp[5]);
	OR2 or2_1(temp[6], temp[0], temp[1]);
	OR2 or2_2(temp[7], temp[2], temp[3]);
	OR2 or2_3(temp[8], temp[4], temp[5]);
	OR3 or3_1(isDiffByOne, temp[6], temp[7], temp[8]);
	
endmodule


module straightDetector(
	input [3:0] rank0, rank1, rank2, rank3, rank4,
	output isStraight
);

	// if exist one pair, then it is not straight
	wire existOnePair, notExistOnePair;
	sameRankDetector sameRankDetector(
		.rank0(rank0), .rank1(rank1), .rank2(rank2), .rank3(rank3), .rank4(rank4),
		.existOnePair(existOnePair)
	);
	IV notExistOnePair_gate(notExistOnePair, existOnePair);

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

	wire pair[9:0];
	
	checkIfDiffByOne check01(pair[0], rank[0], rank[1]);
	checkIfDiffByOne check02(pair[1], rank[0], rank[2]);
	checkIfDiffByOne check03(pair[2], rank[0], rank[3]);
	checkIfDiffByOne check04(pair[3], rank[0], rank[4]);
	checkIfDiffByOne check12(pair[4], rank[1], rank[2]);
	checkIfDiffByOne check13(pair[5], rank[1], rank[3]);
	checkIfDiffByOne check14(pair[6], rank[1], rank[4]);
	checkIfDiffByOne check23(pair[7], rank[2], rank[3]);
	checkIfDiffByOne check24(pair[8], rank[2], rank[4]);
	checkIfDiffByOne check34(pair[9], rank[3], rank[4]);

	
	wire [3:0] pairCount = pair[0] + pair[1] + pair[2] + pair[3] + pair[4] + pair[5] + pair[6] + pair[7] + pair[8] + pair[9];
	wire isPairCount4;

	sameRankComparator2 compare_rank(isPairCount4, pairCount, 4'b0100);

	wire isSpecialCase; // (10, J, Q, K, A)
	wire is10JQKA[4:0];

	// check if it is special case
	wire specialCase[4:0][4:0];
	
	genvar i, j;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs10 checkIfRankIs10(specialCase[i][0], rank[i]);
			checkIfRankIsJ checkIfRankIsJ(specialCase[i][1], rank[i]);
			checkIfRankIsQ checkIfRankIsQ(specialCase[i][2], rank[i]);
			checkIfRankIsK checkIfRankIsK(specialCase[i][3], rank[i]);
			checkIfRankIsA checkIfRankIsA(specialCase[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is10JQKA[0], specialCase[0][0], specialCase[1][0], specialCase[2][0], specialCase[3][0], specialCase[4][0]);
	OR5 or5_2(is10JQKA[1], specialCase[0][1], specialCase[1][1], specialCase[2][1], specialCase[3][1], specialCase[4][1]);
	OR5 or5_3(is10JQKA[2], specialCase[0][2], specialCase[1][2], specialCase[2][2], specialCase[3][2], specialCase[4][2]);
	OR5 or5_4(is10JQKA[3], specialCase[0][3], specialCase[1][3], specialCase[2][3], specialCase[3][3], specialCase[4][3]);
	OR5 or5_5(is10JQKA[4], specialCase[0][4], specialCase[1][4], specialCase[2][4], specialCase[3][4], specialCase[4][4]);
	AN5 and5_1(isSpecialCase, is10JQKA[0], is10JQKA[1], is10JQKA[2], is10JQKA[3], is10JQKA[4]);
	
	wire possibleStraight;
	OR2 or2_1(possibleStraight, isPairCount4, isSpecialCase);

	AN2 isStraight_gate(isStraight, possibleStraight, notExistOnePair);

endmodule

module OR5(
	output out,
	input in0, in1, in2, in3, in4
);

	wire temp;
	OR3 or3_1(temp, in0, in1, in2);
	OR3 or3_2(out, temp, in3, in4);

endmodule

module AN5(
	output out,
	input in0, in1, in2, in3, in4
);

	wire temp;
	AN3 an3_1(temp, in0, in1, in2);
	AN3 an3_2(out, temp, in3, in4);

endmodule

module checkIfRankIs10(
	output isRank10,
	input [3:0] rank
);

	wire [3:0] rank10;
	assign rank10 = 4'b1010;

	sameRankComparator2 compare_rank(isRank10, rank, rank10);

endmodule

module checkIfRankIsJ(
	output isRankJ,
	input [3:0] rank
);

	wire [3:0] rankJ;
	assign rankJ = 4'b1011;

	sameRankComparator2 compare_rank(isRankJ, rank, rankJ);

endmodule

module checkIfRankIsQ(
	output isRankQ,
	input [3:0] rank
);

	wire [3:0] rankQ;
	assign rankQ = 4'b1100;

	sameRankComparator2 compare_rank(isRankQ, rank, rankQ);

endmodule

module checkIfRankIsK(
	output isRankK,
	input [3:0] rank
);

	wire [3:0] rankK;
	assign rankK = 4'b1101;

	sameRankComparator2 compare_rank(isRankK, rank, rankK);

endmodule

module checkIfRankIsA(
	output isRankA,
	input [3:0] rank
);

	wire [3:0] rankA;
	assign rankA = 4'b0001;

	sameRankComparator2 compare_rank(isRankA, rank, rankA);

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
	wire existOnePair, isPair, isTwoPair, isThreeOfAKind, isFourOfAKind, isFullHouse;
	sameRankDetector sameRankDetector(
		.rank0(rank[0]), .rank1(rank[1]), .rank2(rank[2]), .rank3(rank[3]), .rank4(rank[4]),
		.existOnePair(existOnePair), .isPair(isPair), .isTwoPair(isTwoPair), .isThreeOfAKind(isThreeOfAKind), .isFourOfAKind(isFourOfAKind), .isFullHouse(isFullHouse)
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

endmodule