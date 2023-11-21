`timescale 1ns/1ps

module flushDetector(
    input [1:0] suit0, suit1, suit2, suit3, suit4,
    output isFlush
);

	wire same_suit_bit0 [3:0];
	wire same_suit_bit1 [3:0];
	wire all_same_bit0, all_same_bit1;

	// compare the first bit of suit
	EO compare_suit_bit0_01(same_suit_bit0[0], suit0[0], suit1[0]);
	EO compare_suit_bit0_02(same_suit_bit0[1], suit1[0], suit2[0]);
	EO compare_suit_bit0_03(same_suit_bit0[2], suit2[0], suit3[0]);
	EO compare_suit_bit0_04(same_suit_bit0[3], suit3[0], suit4[0]);
	NR4 all_first_bits_same(all_same_bit0, same_suit_bit0[0], same_suit_bit0[1], same_suit_bit0[2], same_suit_bit0[3]);

	// compare the second bit of suit
	EO compare_suit_bit1_01(same_suit_bit1[0], suit0[1], suit1[1]);
	EO compare_suit_bit1_02(same_suit_bit1[1], suit1[1], suit2[1]);
	EO compare_suit_bit1_03(same_suit_bit1[2], suit2[1], suit3[1]);
	EO compare_suit_bit1_04(same_suit_bit1[3], suit3[1], suit4[1]);
	NR4 all_second_bits_same(all_same_bit1, same_suit_bit1[0], same_suit_bit1[1], same_suit_bit1[2], same_suit_bit1[3]);

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
	wire notFourOfAKind, notFullHouse, notThreeOfAKind, notTwoPair;
    wire isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34;
    wire isSameRank012, isSameRank013, isSameRank014, isSameRank023, isSameRank024, isSameRank034, isSameRank123, isSameRank124, isSameRank134, isSameRank234;
    wire isSameRank0123, isSameRank0124, isSameRank0134, isSameRank0234, isSameRank1234;

	// assign notGate
	IV notExistThreeOfAKind_gate(notExistThreeOfAKind, existThreeOfAKind);
	IV notFourOfAKind_gate(notFourOfAKind, isFourOfAKind);
	IV notFullHouse_gate(notFullHouse, isFullHouse);
	IV notThreeOfAKind_gate(notThreeOfAKind, isThreeOfAKind);
	IV notTwoPair_gate(notTwoPair, isTwoPair);

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
	
    // four of a kind
    wire or_four_1;
    OR4 or4_four(or_four_1, isSameRank0123, isSameRank0124, isSameRank0134, isSameRank0234);
    OR2 or2_four(isFourOfAKind, or_four_1, isSameRank1234);

	// full house
	AN2 isFullHouse_gate(isFullHouse, existTwoPair, existThreeOfAKind);

	// three of a kind
	AN3 threeOfAKind_gate(isThreeOfAKind, existThreeOfAKind, notFourOfAKind, notFullHouse); 

    // two pairs
	AN4 twoPair_gate(isTwoPair, existTwoPair, notThreeOfAKind, notFourOfAKind, notFullHouse);

	// one pair
	AN4 onePair_gate(isPair, existOnePair, notTwoPair, notExistThreeOfAKind, notFourOfAKind);

	// wire sumOfPair;
	// assign sumOfPair = isSameRank01 + isSameRank02 + isSameRank03 + isSameRank04 + isSameRank12 + isSameRank13 + isSameRank14 + isSameRank23 + isSameRank24 + isSameRank34;
	// assign isPair = (sumOfPair == 1) ? 1'b1 : 1'b0;
	// assign isTwoPair = (sumOfPair == 2) ? 1'b1 : 1'b0;
	// assign isThreeOfAKind = (sumOfPair == 3) ? 1'b1 : 1'b0;
	// assign isFullHouse = (sumOfPair == 4) ? 1'b1 : 1'b0;
	// assign isFourOfAKind = (sumOfPair == 6) ? 1'b1 : 1'b0;

endmodule

module checkIfDiffByOne(
    output isDiffByOne,
    input [3:0] rank1,
    input [3:0] rank2
);

    // expand all the possibilities, (1,2), (2,1), (2,3), (3,2), (3,4), (4,3), (4,5), (5,4), (5,6), (6,5), (6,7), (7,6), (7,8), (8,7), (8,9), (9,8), (9,10), (10,9), (10,11), (11,10), (11,12), (12,11), (12,13), (13,12), total 24 cases

	wire isRank1[12:0];
	wire isRank2[12:0];
	wire isDifferByOne[12:0][12:0];
	wire isNotDiffByOne[12:0][12:0];

	genvar i, j;
	generate
		for (i = 0; i < 13; i = i + 1)
		begin
			sameRankComparator2 isSameRank1(isRank1[i], rank1, i+1);
			sameRankComparator2 isSameRank2(isRank2[i], rank2, i+1);
			for (j = 0; j < 13; j = j + 1)
			begin
				IV notDiffByOne_gate(isNotDiffByOne[i][j], isDifferByOne[i][j]);
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

	wire temp[9:0];
	
	ND4 nd4_1(temp[0], isNotDiffByOne[0][1], isNotDiffByOne[1][0], isNotDiffByOne[1][2], isNotDiffByOne[2][1]);
	ND4 nd4_2(temp[1], isNotDiffByOne[2][3], isNotDiffByOne[3][2], isNotDiffByOne[3][4], isNotDiffByOne[4][3]);
	ND4 nd4_3(temp[2], isNotDiffByOne[4][5], isNotDiffByOne[5][4], isNotDiffByOne[5][6], isNotDiffByOne[6][5]);
	ND4 nd4_4(temp[3], isNotDiffByOne[6][7], isNotDiffByOne[7][6], isNotDiffByOne[7][8], isNotDiffByOne[8][7]);
	ND4 nd4_5(temp[4], isNotDiffByOne[8][9], isNotDiffByOne[9][8], isNotDiffByOne[9][10], isNotDiffByOne[10][9]);
	ND4 nd4_6(temp[5], isNotDiffByOne[10][11], isNotDiffByOne[11][10], isNotDiffByOne[11][12], isNotDiffByOne[12][11]);
	NR2 nr2_1(temp[6], temp[0], temp[1]);
	NR2 nr2_2(temp[7], temp[2], temp[3]);
	NR2 nr2_3(temp[8], temp[4], temp[5]);
	ND3 nd3_1(isDiffByOne, temp[6], temp[7], temp[8]);
	
	// or or7_1(isDiffByOne, temp[0], temp[1], temp[2], temp[3], temp[4], temp[5]);
	
endmodule

module isPairCount4(
	output isPairCount4,
	input pair0, pair1, pair2, pair3, pair4, pair5, pair6, pair7, pair8, pair9
);



	wire [3:0] pairCount = pair0 + pair1 + pair2 + pair3 + pair4 + pair5 + pair6 + pair7 + pair8 + pair9;
	sameRankComparator2 compare_rank(isPairCount4, pairCount, 4'b0100);

	// wire pair[9:0];
	// assign pair[0] = pair0;
	// assign pair[1] = pair1;
	// assign pair[2] = pair2;
	// assign pair[3] = pair3;
	// assign pair[4] = pair4;
	// assign pair[5] = pair5;
	// assign pair[6] = pair6;
	// assign pair[7] = pair7;
	// assign pair[8] = pair8;
	// assign pair[9] = pair9;

	// // check if there are 4 pairs 

	// wire [255:0] level1;
	// wire [63:0]  level2;
	// wire [15:0]  level3;
	// wire [3:0]   level4;

	// genvar i, j, k, l;

	// generate
	// 	for (i = 0; i < 7; i = i + 1) begin : loop_i
	// 		for (j = i + 1; j < 8; j = j + 1) begin : loop_j
	// 			for (k = j + 1; k < 9; k = k + 1) begin : loop_k
	// 				for (l = k + 1; l < 10; l = l + 1) begin : loop_l
	// 					// m = 56i + 21j + 6k + l -36
    //                 	assign level1[56*i + 21*j + 6*k + l -36] = pair[i] & pair[j] & pair[k] & pair[l];
	// 				end
	// 			end
	// 		end
	// 	end
	// endgenerate

	// generate 
	// 	for (i = 210; i < 255; i = i + 1) begin : loop_n1
	// 		assign level1[i] = 1'b0;
	// 	end
	// endgenerate

	// or isPairCount4_gate(isPairCount4, level1[0], level1[1], level1[2], level1[3], level1[4], level1[5], level1[6], level1[7], level1[8], level1[9], level1[10], level1[11], level1[12], level1[13], level1[14], level1[15], level1[16], level1[17], level1[18], level1[19], level1[20], level1[21], level1[22], level1[23], level1[24], level1[25], level1[26], level1[27], level1[28], level1[29], level1[30], level1[31], level1[32], level1[33], level1[34], level1[35], level1[36], level1[37], level1[38], level1[39], level1[40], level1[41], level1[42], level1[43], level1[44], level1[45], level1[46], level1[47], level1[48], level1[49], level1[50], level1[51], level1[52], level1[53], level1[54], level1[55], level1[56], level1[57], level1[58], level1[59], level1[60], level1[61], level1[62], level1[63], level1[64], level1[65], level1[66], level1[67], level1[68], level1[69], level1[70], level1[71], level1[72], level1[73], level1[74], level1[75], level1[76], level1[77], level1[78], level1[79], level1[80], level1[81], level1[82], level1[83], level1[84], level1[85], level1[86], level1[87], level1[88], level1[89], level1[90], level1[91], level1[92], level1[93], level1[94], level1[95], level1[96], level1[97], level1[98], level1[99], level1[100], level1[101], level1[102], level1[103], level1[104], level1[105], level1[106], level1[107], level1[108], level1[109], level1[110], level1[111], level1[112], level1[113], level1[114], level1[115], level1[116], level1[117], level1[118], level1[119], level1[120], level1[121], level1[122], level1[123], level1[124], level1[125], level1[126], level1[127], level1[128], level1[129], level1[130], level1[131], level1[132], level1[133], level1[134], level1[135], level1[136], level1[137], level1[138], level1[139], level1[140], level1[141], level1[142], level1[143], level1[144], level1[145], level1[146], level1[147], level1[148], level1[149], level1[150], level1[151], level1[152], level1[153], level1[154], level1[155], level1[156], level1[157], level1[158], level1[159], level1[160], level1[161], level1[162], level1[163], level1[164], level1[165], level1[166], level1[167], level1[168], level1[169], level1[170], level1[171], level1[172], level1[173], level1[174], level1[175], level1[176], level1[177], level1[178], level1[179], level1[180], level1[181], level1[182], level1[183], level1[184], level1[185], level1[186], level1[187], level1[188], level1[189], level1[190], level1[191], level1[192], level1[193], level1[194], level1[195], level1[196], level1[197], level1[198], level1[199], level1[200], level1[201], level1[202], level1[203], level1[204], level1[205], level1[206], level1[207], level1[208], level1[209], level1[210], level1[211], level1[212], level1[213], level1[214], level1[215], level1[216], level1[217], level1[218], level1[219], level1[220], level1[221], level1[222], level1[223], level1[224], level1[225], level1[226], level1[227], level1[228], level1[229], level1[230], level1[231], level1[232], level1[233], level1[234], level1[235], level1[236], level1[237], level1[238], level1[239], level1[240], level1[241], level1[242], level1[243], level1[244], level1[245], level1[246], level1[247], level1[248], level1[249], level1[250], level1[251], level1[252], level1[253], level1[254], level1[255]);

	// generate
	// 	for (i = 0; i < 63; i = i + 1) begin : loop_n2
	// 		assign level2[i] = level1[i*4] | level1[i*4+1] | level1[i*4+2] | level1[i*4+3];
	// 	end
	// endgenerate

	// generate
	// 	for (i = 0; i < 15; i = i + 1) begin : loop_n3
	// 		assign level3[i] = level2[i*4] | level2[i*4+1] | level2[i*4+2] | level2[i*4+3];
	// 	end
	// endgenerate

	// generate
	// 	for (i = 0; i < 3; i = i + 1) begin : loop_n4
	// 		assign level4[i] = level3[i*4] | level3[i*4+1] | level3[i*4+2] | level3[i*4+3];
	// 	end
	// endgenerate

	// assign isPairCount4 = level4[0] | level4[1] | level4[2] | level4[3];

endmodule

module checkStraightA2345(
	output isStraightA2345,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire isA2345[4:0];
	wire recordA2345[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIsA checkIfRankIsA(recordA2345[i][0], rank[i]);
			checkIfRankIs2 checkIfRankIs2(recordA2345[i][1], rank[i]);
			checkIfRankIs3 checkIfRankIs3(recordA2345[i][2], rank[i]);
			checkIfRankIs4 checkIfRankIs4(recordA2345[i][3], rank[i]);
			checkIfRankIs5 checkIfRankIs5(recordA2345[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(isA2345[0], recordA2345[0][0], recordA2345[1][0], recordA2345[2][0], recordA2345[3][0], recordA2345[4][0]);
	OR5 or5_2(isA2345[1], recordA2345[0][1], recordA2345[1][1], recordA2345[2][1], recordA2345[3][1], recordA2345[4][1]);
	OR5 or5_3(isA2345[2], recordA2345[0][2], recordA2345[1][2], recordA2345[2][2], recordA2345[3][2], recordA2345[4][2]);
	OR5 or5_4(isA2345[3], recordA2345[0][3], recordA2345[1][3], recordA2345[2][3], recordA2345[3][3], recordA2345[4][3]);
	OR5 or5_5(isA2345[4], recordA2345[0][4], recordA2345[1][4], recordA2345[2][4], recordA2345[3][4], recordA2345[4][4]);
	AN5 and5_1(isStraightA2345, isA2345[0], isA2345[1], isA2345[2], isA2345[3], isA2345[4]);

endmodule

module checkStraight23456(
	output isStraight23456,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is23456[4:0];
	wire record23456[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs2 checkIfRankIs2(record23456[i][0], rank[i]);
			checkIfRankIs3 checkIfRankIs3(record23456[i][1], rank[i]);
			checkIfRankIs4 checkIfRankIs4(record23456[i][2], rank[i]);
			checkIfRankIs5 checkIfRankIs5(record23456[i][3], rank[i]);
			checkIfRankIs6 checkIfRankIs6(record23456[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is23456[0], record23456[0][0], record23456[1][0], record23456[2][0], record23456[3][0], record23456[4][0]);
	OR5 or5_2(is23456[1], record23456[0][1], record23456[1][1], record23456[2][1], record23456[3][1], record23456[4][1]);
	OR5 or5_3(is23456[2], record23456[0][2], record23456[1][2], record23456[2][2], record23456[3][2], record23456[4][2]);
	OR5 or5_4(is23456[3], record23456[0][3], record23456[1][3], record23456[2][3], record23456[3][3], record23456[4][3]);
	OR5 or5_5(is23456[4], record23456[0][4], record23456[1][4], record23456[2][4], record23456[3][4], record23456[4][4]);
	AN5 and5_1(isStraight23456, is23456[0], is23456[1], is23456[2], is23456[3], is23456[4]);

endmodule

module checkStraight34567(
	output isStraight34567,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is34567[4:0];
	wire record34567[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs3 checkIfRankIs3(record34567[i][0], rank[i]);
			checkIfRankIs4 checkIfRankIs4(record34567[i][1], rank[i]);
			checkIfRankIs5 checkIfRankIs5(record34567[i][2], rank[i]);
			checkIfRankIs6 checkIfRankIs6(record34567[i][3], rank[i]);
			checkIfRankIs7 checkIfRankIs7(record34567[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is34567[0], record34567[0][0], record34567[1][0], record34567[2][0], record34567[3][0], record34567[4][0]);
	OR5 or5_2(is34567[1], record34567[0][1], record34567[1][1], record34567[2][1], record34567[3][1], record34567[4][1]);
	OR5 or5_3(is34567[2], record34567[0][2], record34567[1][2], record34567[2][2], record34567[3][2], record34567[4][2]);
	OR5 or5_4(is34567[3], record34567[0][3], record34567[1][3], record34567[2][3], record34567[3][3], record34567[4][3]);
	OR5 or5_5(is34567[4], record34567[0][4], record34567[1][4], record34567[2][4], record34567[3][4], record34567[4][4]);
	AN5 and5_1(isStraight34567, is34567[0], is34567[1], is34567[2], is34567[3], is34567[4]);

endmodule

module checkStraight45678(
	output isStraight45678,
	input [3:0] rank0, rank1, rank2, rank3, rank4,
	output is4, is5, is6, is7, is8
);

	wire is45678[4:0];
	wire record45678[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

	assign is4 = is45678[0];
	assign is5 = is45678[1];
	assign is6 = is45678[2];
	assign is7 = is45678[3];
	assign is8 = is45678[4];

	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs4 checkIfRankIs4(record45678[i][0], rank[i]);
			checkIfRankIs5 checkIfRankIs5(record45678[i][1], rank[i]);
			checkIfRankIs6 checkIfRankIs6(record45678[i][2], rank[i]);
			checkIfRankIs7 checkIfRankIs7(record45678[i][3], rank[i]);
			checkIfRankIs8 checkIfRankIs8(record45678[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is45678[0], record45678[0][0], record45678[1][0], record45678[2][0], record45678[3][0], record45678[4][0]);
	OR5 or5_2(is45678[1], record45678[0][1], record45678[1][1], record45678[2][1], record45678[3][1], record45678[4][1]);
	OR5 or5_3(is45678[2], record45678[0][2], record45678[1][2], record45678[2][2], record45678[3][2], record45678[4][2]);
	OR5 or5_4(is45678[3], record45678[0][3], record45678[1][3], record45678[2][3], record45678[3][3], record45678[4][3]);
	OR5 or5_5(is45678[4], record45678[0][4], record45678[1][4], record45678[2][4], record45678[3][4], record45678[4][4]);
	AN5 and5_1(isStraight45678, is45678[0], is45678[1], is45678[2], is45678[3], is45678[4]);

endmodule

module checkStraight56789(
	output isStraight56789,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is56789[4:0];
	wire record56789[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

	genvar i, j;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs5 checkIfRankIs5(record56789[i][0], rank[i]);
			checkIfRankIs6 checkIfRankIs6(record56789[i][1], rank[i]);
			checkIfRankIs7 checkIfRankIs7(record56789[i][2], rank[i]);
			checkIfRankIs8 checkIfRankIs8(record56789[i][3], rank[i]);
			checkIfRankIs9 checkIfRankIs9(record56789[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is56789[0], record56789[0][0], record56789[1][0], record56789[2][0], record56789[3][0], record56789[4][0]);
	OR5 or5_2(is56789[1], record56789[0][1], record56789[1][1], record56789[2][1], record56789[3][1], record56789[4][1]);
	OR5 or5_3(is56789[2], record56789[0][2], record56789[1][2], record56789[2][2], record56789[3][2], record56789[4][2]);
	OR5 or5_4(is56789[3], record56789[0][3], record56789[1][3], record56789[2][3], record56789[3][3], record56789[4][3]);
	OR5 or5_5(is56789[4], record56789[0][4], record56789[1][4], record56789[2][4], record56789[3][4], record56789[4][4]);
	AN5 and5_1(isStraight56789, is56789[0], is56789[1], is56789[2], is56789[3], is56789[4]);

endmodule

module checkStraight678910(
	output isStraight678910,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is678910[4:0];
	wire record678910[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

	genvar i, j;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs6 checkIfRankIs6(record678910[i][0], rank[i]);
			checkIfRankIs7 checkIfRankIs7(record678910[i][1], rank[i]);
			checkIfRankIs8 checkIfRankIs8(record678910[i][2], rank[i]);
			checkIfRankIs9 checkIfRankIs9(record678910[i][3], rank[i]);
			checkIfRankIs10 checkIfRankIs10(record678910[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is678910[0], record678910[0][0], record678910[1][0], record678910[2][0], record678910[3][0], record678910[4][0]);
	OR5 or5_2(is678910[1], record678910[0][1], record678910[1][1], record678910[2][1], record678910[3][1], record678910[4][1]);
	OR5 or5_3(is678910[2], record678910[0][2], record678910[1][2], record678910[2][2], record678910[3][2], record678910[4][2]);
	OR5 or5_4(is678910[3], record678910[0][3], record678910[1][3], record678910[2][3], record678910[3][3], record678910[4][3]);
	OR5 or5_5(is678910[4], record678910[0][4], record678910[1][4], record678910[2][4], record678910[3][4], record678910[4][4]);
	AN5 and5_1(isStraight678910, is678910[0], is678910[1], is678910[2], is678910[3], is678910[4]);

endmodule

module checkStraight78910J(
	output isStraight78910J,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is78910J[4:0];
	wire record78910J[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

	genvar i, j;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs7 checkIfRankIs7(record78910J[i][0], rank[i]);
			checkIfRankIs8 checkIfRankIs8(record78910J[i][1], rank[i]);
			checkIfRankIs9 checkIfRankIs9(record78910J[i][2], rank[i]);
			checkIfRankIs10 checkIfRankIs10(record78910J[i][3], rank[i]);
			checkIfRankIsJ checkIfRankIsJ(record78910J[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is78910J[0], record78910J[0][0], record78910J[1][0], record78910J[2][0], record78910J[3][0], record78910J[4][0]);
	OR5 or5_2(is78910J[1], record78910J[0][1], record78910J[1][1], record78910J[2][1], record78910J[3][1], record78910J[4][1]);
	OR5 or5_3(is78910J[2], record78910J[0][2], record78910J[1][2], record78910J[2][2], record78910J[3][2], record78910J[4][2]);
	OR5 or5_4(is78910J[3], record78910J[0][3], record78910J[1][3], record78910J[2][3], record78910J[3][3], record78910J[4][3]);
	OR5 or5_5(is78910J[4], record78910J[0][4], record78910J[1][4], record78910J[2][4], record78910J[3][4], record78910J[4][4]);
	AN5 and5_1(isStraight78910J, is78910J[0], is78910J[1], is78910J[2], is78910J[3], is78910J[4]);

endmodule

module checkStraight8910JQ(
	output isStraight8910JQ,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is8910JQ[4:0];
	wire record8910JQ[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;
	
	genvar i, j;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs8 checkIfRankIs8(record8910JQ[i][0], rank[i]);
			checkIfRankIs9 checkIfRankIs9(record8910JQ[i][1], rank[i]);
			checkIfRankIs10 checkIfRankIs10(record8910JQ[i][2], rank[i]);
			checkIfRankIsJ checkIfRankIsJ(record8910JQ[i][3], rank[i]);
			checkIfRankIsQ checkIfRankIsQ(record8910JQ[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is8910JQ[0], record8910JQ[0][0], record8910JQ[1][0], record8910JQ[2][0], record8910JQ[3][0], record8910JQ[4][0]);
	OR5 or5_2(is8910JQ[1], record8910JQ[0][1], record8910JQ[1][1], record8910JQ[2][1], record8910JQ[3][1], record8910JQ[4][1]);
	OR5 or5_3(is8910JQ[2], record8910JQ[0][2], record8910JQ[1][2], record8910JQ[2][2], record8910JQ[3][2], record8910JQ[4][2]);
	OR5 or5_4(is8910JQ[3], record8910JQ[0][3], record8910JQ[1][3], record8910JQ[2][3], record8910JQ[3][3], record8910JQ[4][3]);
	OR5 or5_5(is8910JQ[4], record8910JQ[0][4], record8910JQ[1][4], record8910JQ[2][4], record8910JQ[3][4], record8910JQ[4][4]);
	AN5 and5_1(isStraight8910JQ, is8910JQ[0], is8910JQ[1], is8910JQ[2], is8910JQ[3], is8910JQ[4]);

endmodule

module checkStraight910JQK(
	output isStraight910JQK,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is910JQK[4:0];
	wire record910JQK[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;
	
	genvar i, j;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs9 checkIfRankIs9(record910JQK[i][0], rank[i]);
			checkIfRankIs10 checkIfRankIs10(record910JQK[i][1], rank[i]);
			checkIfRankIsJ checkIfRankIsJ(record910JQK[i][2], rank[i]);
			checkIfRankIsQ checkIfRankIsQ(record910JQK[i][3], rank[i]);
			checkIfRankIsK checkIfRankIsK(record910JQK[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is910JQK[0], record910JQK[0][0], record910JQK[1][0], record910JQK[2][0], record910JQK[3][0], record910JQK[4][0]);
	OR5 or5_2(is910JQK[1], record910JQK[0][1], record910JQK[1][1], record910JQK[2][1], record910JQK[3][1], record910JQK[4][1]);
	OR5 or5_3(is910JQK[2], record910JQK[0][2], record910JQK[1][2], record910JQK[2][2], record910JQK[3][2], record910JQK[4][2]);
	OR5 or5_4(is910JQK[3], record910JQK[0][3], record910JQK[1][3], record910JQK[2][3], record910JQK[3][3], record910JQK[4][3]);
	OR5 or5_5(is910JQK[4], record910JQK[0][4], record910JQK[1][4], record910JQK[2][4], record910JQK[3][4], record910JQK[4][4]);
	AN5 and5_1(isStraight910JQK, is910JQK[0], is910JQK[1], is910JQK[2], is910JQK[3], is910JQK[4]);

endmodule

module checkStraight10JQKA(
	output isStraight10JQKA,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is10JQKA[4:0];
	wire record10JQKA[4:0][4:0];

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;
	
	genvar i;
	generate
		for (i = 0; i < 5; i = i + 1)
		begin
			checkIfRankIs10 checkIfRankIs10(record10JQKA[i][0], rank[i]);
			checkIfRankIsJ checkIfRankIsJ(record10JQKA[i][1], rank[i]);
			checkIfRankIsQ checkIfRankIsQ(record10JQKA[i][2], rank[i]);
			checkIfRankIsK checkIfRankIsK(record10JQKA[i][3], rank[i]);
			checkIfRankIsA checkIfRankIsA(record10JQKA[i][4], rank[i]);
		end
	endgenerate

	OR5 or5_1(is10JQKA[0], record10JQKA[0][0], record10JQKA[1][0], record10JQKA[2][0], record10JQKA[3][0], record10JQKA[4][0]);
	OR5 or5_2(is10JQKA[1], record10JQKA[0][1], record10JQKA[1][1], record10JQKA[2][1], record10JQKA[3][1], record10JQKA[4][1]);
	OR5 or5_3(is10JQKA[2], record10JQKA[0][2], record10JQKA[1][2], record10JQKA[2][2], record10JQKA[3][2], record10JQKA[4][2]);
	OR5 or5_4(is10JQKA[3], record10JQKA[0][3], record10JQKA[1][3], record10JQKA[2][3], record10JQKA[3][3], record10JQKA[4][3]);
	OR5 or5_5(is10JQKA[4], record10JQKA[0][4], record10JQKA[1][4], record10JQKA[2][4], record10JQKA[3][4], record10JQKA[4][4]);
	AN5 and5_1(isStraight10JQKA, is10JQKA[0], is10JQKA[1], is10JQKA[2], is10JQKA[3], is10JQKA[4]);

endmodule

module straightDetector(
	input [3:0] rank0, rank1, rank2, rank3, rank4,
	output isStraight, isStraightA2345, isStraight23456, isStraight34567, isStraight45678, isStraight56789, isStraight678910, isStraight78910J, isStraight8910JQ, isStraight910JQK, isStraight10JQKA
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

	wire isPairCount4;
	wire pair0, pair1, pair2, pair3, pair4, pair5, pair6, pair7, pair8, pair9;
	assign pair0 = pair[0];
	assign pair1 = pair[1];
	assign pair2 = pair[2];
	assign pair3 = pair[3];
	assign pair4 = pair[4];
	assign pair5 = pair[5];
	assign pair6 = pair[6];
	assign pair7 = pair[7];
	assign pair8 = pair[8];
	assign pair9 = pair[9];

	isPairCount4 isPairCount4_gate(isPairCount4, pair0, pair1, pair2, pair3, pair4, pair5, pair6, pair7, pair8, pair9);

	wire isStraightA2345;  // (A, 2, 3, 4, 5)
	wire isStraight23456;  // (2, 3, 4, 5, 6)
	wire isStraight34567;  // (3, 4, 5, 6, 7)
	wire isStraight45678;  // (4, 5, 6, 7, 8)
	wire isStraight56789;  // (5, 6, 7, 8, 9)
	wire isStraight678910; // (6, 7, 8, 9, 10)
	wire isStraight78910J; // (7, 8, 9, 10, J)
	wire isStraight8910JQ; // (8, 9, 10, J, Q)
	wire isStraight910JQK; // (9, 10, J, Q, K)
	wire isStraight10JQKA; // (10, J, Q, K, A)
	
	checkStraightA2345 checkStraightA2345(isStraightA2345, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight23456 checkStraight23456(isStraight23456, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight34567 checkStraight34567(isStraight34567, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight45678 checkStraight45678(isStraight45678, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight56789 checkStraight56789(isStraight56789, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight678910 checkStraight678910(isStraight678910, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight78910J checkStraight78910J(isStraight78910J, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight8910JQ checkStraight8910JQ(isStraight8910JQ, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight910JQK checkStraight910JQK(isStraight910JQK, rank[0], rank[1], rank[2], rank[3], rank[4]);
	checkStraight10JQKA checkStraight10JQKA(isStraight10JQKA, rank[0], rank[1], rank[2], rank[3], rank[4]);

	or or_1(isStraight, isStraightA2345, isStraight23456, isStraight34567, isStraight45678, isStraight56789, isStraight678910, isStraight78910J, isStraight8910JQ, isStraight910JQK, isStraight10JQKA);

	// wire possibleStraight;
	// // OR2 or2_1(possibleStraight, isPairCount4, isStraight10JQKA);
	// or or_1(possibleStraight, isPairCount4, isStraight10JQKA);

	// AN2 isStraight_gate(isStraight, possibleStraight, notExistOnePair);

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
	wire existOnePair, isPair, isTwoPair, isThreeOfAKind, isFourOfAKind, isFullHouse, isStraight, isStraightFlush;
	sameRankDetector sameRankDetector(
		.rank0(rank[0]), .rank1(rank[1]), .rank2(rank[2]), .rank3(rank[3]), .rank4(rank[4]),
		.existOnePair(existOnePair), .isPair(isPair), .isTwoPair(isTwoPair), .isThreeOfAKind(isThreeOfAKind), .isFourOfAKind(isFourOfAKind), .isFullHouse(isFullHouse)
	);

	// straight detector
	straightDetector straightDetector(
		.rank0(rank[0]), .rank1(rank[1]), .rank2(rank[2]), .rank3(rank[3]), .rank4(rank[4]),
		.isStraight(isStraight)
	);

	// type determination
	wire straight, flush;

	IV notFlush_gate(isNotFlush, isFlush);
	IV notStraight_gate(isNotStraight, isStraight);

	AN2 straightFlush_gate(isStraightFlush, isFlush, isStraight);
	AN2 flush_gate(flush, isFlush, isNotStraight);
	AN2 straight_gate(straight, isStraight, isNotFlush);

	assign type[3] = isStraightFlush;
	OR4 type_2(type[2], isFourOfAKind, isFullHouse, flush, straight); // four of a kind, full house, flush, straight
	OR4 type_1(type[1], isFourOfAKind, isFullHouse, isThreeOfAKind, isTwoPair); // four of a kind, full house, three of a kind, two pairs
	OR4 type_0(type[0], isFourOfAKind, flush, isThreeOfAKind, isPair); // four of a kind, flush, three of a kind, one pair

endmodule

/* 
	stright flush:     1000
	four of a kind:    0111
	full house:        0110
	flush:             0101
	straight:          0100
	three of a kind:   0011
	two pairs:         0010
	one pair:          0001
	high card:         0000
*/
module checkIfRankIsA( // 4'b0001
	output isRankA,
	input [3:0] rank
);

	wire notFourth_bit;
	IV notFourth_bit_gate(notFourth_bit, rank[0]);
	NR4 isRankA_gate(isRankA, rank[3], rank[2], rank[1], notFourth_bit);

endmodule

module checkIfRankIs2( // 4'b0010
	output isRank2,
	input [3:0] rank
);

	wire notThird_bit;
	IV notThird_bit_gate(notThird_bit, rank[1]);
	NR4 isRank2_gate(isRank2, rank[3], rank[2], notThird_bit, rank[0]);

endmodule

module checkIfRankIs3( // 4'b0011
	output isRank3,
	input [3:0] rank
);

	wire notThird_bit, notFourth_bit;
	IV notThird_bit_gate(notThird_bit, rank[1]);
	IV notFourth_bit_gate(notFourth_bit, rank[0]);
	NR4 isRank3_gate(isRank3, rank[3], rank[2], notThird_bit, notFourth_bit);

endmodule

module checkIfRankIs4( // 4'b0100
	output isRank4,
	input [3:0] rank
);

	wire notSecond_bit;;
	IV notSecond_bit_gate(notSecond_bit, rank[2]);
	NR4 isRank4_gate(isRank4, rank[3], notSecond_bit, rank[1], rank[0]);

endmodule

module checkIfRankIs5( // 4'b0101
	output isRank5,
	input [3:0] rank
);

	wire notSecond_bit, notFourth_bit;
	IV notSecond_bit_gate(notSecond_bit, rank[2]);
	IV notFourth_bit_gate(notFourth_bit, rank[0]);
	NR4 isRank5_gate(isRank5, rank[3], notSecond_bit, rank[1], notFourth_bit);

endmodule

module checkIfRankIs6( // 4'b0110
	output isRank6,
	input [3:0] rank
);

	wire notSecond_bit, notThird_bit;
	IV notSecond_bit_gate(notSecond_bit, rank[2]);
	IV notThird_bit_gate(notThird_bit, rank[1]);
	NR4 isRank6_gate(isRank6, rank[3], notSecond_bit, notThird_bit, rank[0]);

endmodule

module checkIfRankIs7( // 4'b0111
	output isRank7,
	input [3:0] rank
);

	wire notSecond_bit, notThird_bit, notFourth_bit;
	IV notSecond_bit_gate(notSecond_bit, rank[2]);
	IV notThird_bit_gate(notThird_bit, rank[1]);
	IV notFourth_bit_gate(notFourth_bit, rank[0]);
	NR4 isRank7_gate(isRank7, rank[3], notSecond_bit, notThird_bit, notFourth_bit);

endmodule

module checkIfRankIs8( // 4'b1000
	output isRank8,
	input [3:0] rank
);

	wire notFirst_bit;
	IV notFirst_bit_gate(notFirst_bit, rank[3]);
	NR4 isRank8_gate(isRank8, notFirst_bit, rank[2], rank[1], rank[0]);

endmodule

module checkIfRankIs9( // 4'b1001
	output isRank9,
	input [3:0] rank
);

	wire notFirst_bit, notFourth_bit;
	IV notFirst_bit_gate(notFirst_bit, rank[3]);
	IV notFourth_bit_gate(notFourth_bit, rank[0]);
	NR4 isRank9_gate(isRank9, notFirst_bit, rank[2], rank[1], notFourth_bit);

endmodule

module checkIfRankIs10( // 4'b1010
	output isRank10,
	input [3:0] rank
);

	wire notFirst_bit, notThird_bit;
	IV notFirst_bit_gate(notFirst_bit, rank[3]);
	IV notThird_bit_gate(notThird_bit, rank[1]);
	NR4 isRank10_gate(isRank10, notFirst_bit, rank[2], notThird_bit, rank[0]);

endmodule

module checkIfRankIsJ( // 4'b1011
	output isRankJ,
	input [3:0] rank
);

	wire notFirst_bit, notThird_bit, notFourth_bit;
	IV notFirst_bit_gate(notFirst_bit, rank[3]);
	IV notThird_bit_gate(notThird_bit, rank[1]);
	IV notFourth_bit_gate(notFourth_bit, rank[0]);
	NR4 isRankJ_gate(isRankJ, notFirst_bit, rank[2], notThird_bit, notFourth_bit);

endmodule

module checkIfRankIsQ( // 4'b1100
	output isRankQ,
	input [3:0] rank
);

	wire notFirst_bit, notSecond_bit;
	IV notFirst_bit_gate(notFirst_bit, rank[3]);
	IV notSecond_bit_gate(notSecond_bit, rank[2]);
	NR4 isRankQ_gate(isRankQ, notFirst_bit, notSecond_bit, rank[1], rank[0]);

endmodule

module checkIfRankIsK( // 4'b1101	
	output isRankK,
	input [3:0] rank
);

	wire notFirst_bit, notSecond_bit, notFourth_bit;
	IV notFirst_bit_gate(notFirst_bit, rank[3]);
	IV notSecond_bit_gate(notSecond_bit, rank[2]);
	IV notFourth_bit_gate(notFourth_bit, rank[0]);
	NR4 isRankK_gate(isRankK, notFirst_bit, notSecond_bit, rank[1], notFourth_bit);

endmodule

