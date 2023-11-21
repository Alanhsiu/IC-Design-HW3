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

	HA1 is_flush_gate(.O(isFlush), .A(all_same_bit0), .B(all_same_bit1));

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

	HA1 isSameRank_gate(.O(isSameRank), .A(isSameRank12), .B(isSameRank13));

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
    output isPair, isTwoPair, isThreeOfAKind, isFourOfAKind, isFullHouse
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
	HA1 ha1_two_pair_1(.O(two_pair[0]), .A(isSameRank01), .B(isSameRank23));
	HA1 ha1_two_pair_2(.O(two_pair[1]), .A(isSameRank01), .B(isSameRank24));
	HA1 ha1_two_pair_3(.O(two_pair[2]), .A(isSameRank01), .B(isSameRank34));
	HA1 ha1_two_pair_4(.O(two_pair[3]), .A(isSameRank02), .B(isSameRank13));
	HA1 ha1_two_pair_5(.O(two_pair[4]), .A(isSameRank02), .B(isSameRank14));
	HA1 ha1_two_pair_6(.O(two_pair[5]), .A(isSameRank02), .B(isSameRank34));
	HA1 ha1_two_pair_7(.O(two_pair[6]), .A(isSameRank03), .B(isSameRank12));
	HA1 ha1_two_pair_8(.O(two_pair[7]), .A(isSameRank03), .B(isSameRank14));
	HA1 ha1_two_pair_9(.O(two_pair[8]), .A(isSameRank03), .B(isSameRank24));
	HA1 ha1_two_pair_10(.O(two_pair[9]), .A(isSameRank04), .B(isSameRank12));
	HA1 ha1_two_pair_11(.O(two_pair[10]), .A(isSameRank04), .B(isSameRank13));
	HA1 ha1_two_pair_12(.O(two_pair[11]), .A(isSameRank04), .B(isSameRank23));
	HA1 ha1_two_pair_13(.O(two_pair[12]), .A(isSameRank12), .B(isSameRank34));
	HA1 ha1_two_pair_14(.O(two_pair[13]), .A(isSameRank13), .B(isSameRank24));
	HA1 ha1_two_pair_15(.O(two_pair[14]), .A(isSameRank14), .B(isSameRank23));

	wire temp1, temp2, temp3, temp4;
	// OR4 or4_two_pair_1(temp1, two_pair[0], two_pair[1], two_pair[2], two_pair[3]);
	// OR4 or4_two_pair_2(temp2, two_pair[4], two_pair[5], two_pair[6], two_pair[7]);
	// OR4 or4_two_pair_3(temp3, two_pair[8], two_pair[9], two_pair[10], two_pair[11]);
	// OR3 or3_two_pair(temp4, two_pair[12], two_pair[13], two_pair[14]);
	// OR4 or4_two_pair(existTwoPair, temp1, temp2, temp3, temp4);
	or or14(existTwoPair, two_pair[0], two_pair[1], two_pair[2], two_pair[3], two_pair[4], two_pair[5], two_pair[6], two_pair[7], two_pair[8], two_pair[9], two_pair[10], two_pair[11], two_pair[12], two_pair[13], two_pair[14]);

    // check if exist three of a kind
    wire or_three_1, or_three_2;
    OR4 or4_three_1(or_three_1, isSameRank012, isSameRank013, isSameRank014, isSameRank023);
    OR4 or4_three_2(or_three_2, isSameRank024, isSameRank034, isSameRank123, isSameRank124);
    OR4 orr_three_3(existThreeOfAKind, or_three_1, or_three_2, isSameRank134, isSameRank234);

    // four of a kind
    wire or_four_1;
    OR4 or4_four(or_four_1, isSameRank0123, isSameRank0124, isSameRank0134, isSameRank0234);
    OR2 or2_four(isFourOfAKind, or_four_1, isSameRank1234);

	// full house
	checkFullHouse fullHouse_gate(isFullHouse, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

	// three of a kind
	checkThreeOfAKind threeOfAKind_gate(isThreeOfAKind, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

    // two pairs
	checkTwoPairs twoPair_gate(isTwoPair, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

	// one pair
	checkOnlyOnePair onePair_gate(isPair, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

endmodule

module checkFullHouse(
	output isFullHouse,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire combination[9:0];
	wire isNotSameRank01, isNotSameRank02, isNotSameRank03, isNotSameRank04, isNotSameRank12, isNotSameRank13, isNotSameRank14, isNotSameRank23, isNotSameRank24, isNotSameRank34;

	// assign notSameRank
	IV notSameRank_gate0(isNotSameRank01, isSameRank01);
	IV notSameRank_gate1(isNotSameRank02, isSameRank02);
	IV notSameRank_gate2(isNotSameRank03, isSameRank03);
	IV notSameRank_gate3(isNotSameRank04, isSameRank04);
	IV notSameRank_gate4(isNotSameRank12, isSameRank12);
	IV notSameRank_gate5(isNotSameRank13, isSameRank13);
	IV notSameRank_gate6(isNotSameRank14, isSameRank14);
	IV notSameRank_gate7(isNotSameRank23, isSameRank23);
	IV notSameRank_gate8(isNotSameRank24, isSameRank24);
	IV notSameRank_gate9(isNotSameRank34, isSameRank34);

	// assign combination
	nor isNotSameRank_gate0(combination[0], isNotSameRank01, isNotSameRank02, isSameRank03, isSameRank04, isNotSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isNotSameRank34);
	nor isNotSameRank_gate1(combination[1], isNotSameRank01, isSameRank02, isNotSameRank03, isSameRank04, isSameRank12, isNotSameRank13, isSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate2(combination[2], isNotSameRank01, isSameRank02, isSameRank03, isNotSameRank04, isSameRank12, isSameRank13, isNotSameRank14, isNotSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate3(combination[3], isSameRank01, isNotSameRank02, isNotSameRank03, isSameRank04, isSameRank12, isSameRank13, isNotSameRank14, isNotSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate4(combination[4], isSameRank01, isNotSameRank02, isSameRank03, isNotSameRank04, isSameRank12, isNotSameRank13, isSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate5(combination[5], isSameRank01, isSameRank02, isNotSameRank03, isNotSameRank04, isNotSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isNotSameRank34);
	nor isNotSameRank_gate6(combination[6], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04, isNotSameRank12, isNotSameRank13, isSameRank14, isNotSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate7(combination[7], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04, isNotSameRank12, isSameRank13, isNotSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate8(combination[8], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04, isSameRank12, isNotSameRank13, isNotSameRank14, isSameRank23, isSameRank24, isNotSameRank34);
	nor isNotSameRank_gate9(combination[9], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isNotSameRank23, isNotSameRank24, isNotSameRank34);

	or or10_1(isFullHouse, combination[0], combination[1], combination[2], combination[3], combination[4], combination[5], combination[6], combination[7], combination[8], combination[9]);

endmodule

module checkThreeOfAKind(
	output isThreeOfAKind,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire combination[9:0];
	wire isNotSameRank01, isNotSameRank02, isNotSameRank03, isNotSameRank04, isNotSameRank12, isNotSameRank13, isNotSameRank14, isNotSameRank23, isNotSameRank24, isNotSameRank34;

	// assign notSameRank
	IV notSameRank_gate0(isNotSameRank01, isSameRank01);
	IV notSameRank_gate1(isNotSameRank02, isSameRank02);
	IV notSameRank_gate2(isNotSameRank03, isSameRank03);
	IV notSameRank_gate3(isNotSameRank04, isSameRank04);
	IV notSameRank_gate4(isNotSameRank12, isSameRank12);
	IV notSameRank_gate5(isNotSameRank13, isSameRank13);
	IV notSameRank_gate6(isNotSameRank14, isSameRank14);
	IV notSameRank_gate7(isNotSameRank23, isSameRank23);
	IV notSameRank_gate8(isNotSameRank24, isSameRank24);
	IV notSameRank_gate9(isNotSameRank34, isSameRank34);

	// assign combination
	nor isNotSameRank_gate0(combination[0], isNotSameRank01, isNotSameRank02, isSameRank03, isSameRank04, isNotSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate1(combination[1], isNotSameRank01, isSameRank02, isNotSameRank03, isSameRank04, isSameRank12, isNotSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate2(combination[2], isNotSameRank01, isSameRank02, isSameRank03, isNotSameRank04, isSameRank12, isSameRank13, isNotSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate3(combination[3], isSameRank01, isNotSameRank02, isNotSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isNotSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate4(combination[4], isSameRank01, isNotSameRank02, isSameRank03, isNotSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate5(combination[5], isSameRank01, isSameRank02, isNotSameRank03, isNotSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isNotSameRank34);
	nor isNotSameRank_gate6(combination[6], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isNotSameRank12, isNotSameRank13, isSameRank14, isNotSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate7(combination[7], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isNotSameRank12, isSameRank13, isNotSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate8(combination[8], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isNotSameRank13, isNotSameRank14, isSameRank23, isSameRank24, isNotSameRank34);
	nor isNotSameRank_gate9(combination[9], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isNotSameRank23, isNotSameRank24, isNotSameRank34);

	or or10_1(isThreeOfAKind, combination[0], combination[1], combination[2], combination[3], combination[4], combination[5], combination[6], combination[7], combination[8], combination[9]);

endmodule

module checkTwoPairs(
	output isTwoPairs,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire combination[14:0];
	wire isNotSameRank01, isNotSameRank02, isNotSameRank03, isNotSameRank04, isNotSameRank12, isNotSameRank13, isNotSameRank14, isNotSameRank23, isNotSameRank24, isNotSameRank34;

	// assign notSameRank
	IV notSameRank_gate0(isNotSameRank01, isSameRank01);
	IV notSameRank_gate1(isNotSameRank02, isSameRank02);
	IV notSameRank_gate2(isNotSameRank03, isSameRank03);
	IV notSameRank_gate3(isNotSameRank04, isSameRank04);
	IV notSameRank_gate4(isNotSameRank12, isSameRank12);
	IV notSameRank_gate5(isNotSameRank13, isSameRank13);
	IV notSameRank_gate6(isNotSameRank14, isSameRank14);
	IV notSameRank_gate7(isNotSameRank23, isSameRank23);
	IV notSameRank_gate8(isNotSameRank24, isSameRank24);
	IV notSameRank_gate9(isNotSameRank34, isSameRank34);

	// assign combination
	nor isNotSameRank_gate0(combination[0], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isNotSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate1(combination[1], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate2(combination[2], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isNotSameRank34);
	nor isNotSameRank_gate3(combination[3], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04, isSameRank12, isNotSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate4(combination[4], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isNotSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate5(combination[5], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isNotSameRank34);
	nor isNotSameRank_gate6(combination[6], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04, isNotSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate7(combination[7], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04, isSameRank12, isSameRank13, isNotSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate8(combination[8], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate9(combination[9], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04, isNotSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate10(combination[10], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04, isSameRank12, isNotSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate11(combination[11], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04, isSameRank12, isSameRank13, isSameRank14, isNotSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate12(combination[12], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isNotSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isNotSameRank34);
	nor isNotSameRank_gate13(combination[13], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isNotSameRank13, isSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate14(combination[14], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isNotSameRank14, isNotSameRank23, isSameRank24, isSameRank34);

	or or15_1(isTwoPairs, combination[0], combination[1], combination[2], combination[3], combination[4], combination[5], combination[6], combination[7], combination[8], combination[9], combination[10], combination[11], combination[12], combination[13], combination[14]);

endmodule

module checkOnlyOnePair(
	output isOnlyOnePair,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire combination[9:0];
	wire isNotSameRank01, isNotSameRank02, isNotSameRank03, isNotSameRank04, isNotSameRank12, isNotSameRank13, isNotSameRank14, isNotSameRank23, isNotSameRank24, isNotSameRank34;

	// assign notSameRank
	IV notSameRank_gate0(isNotSameRank01, isSameRank01);
	IV notSameRank_gate1(isNotSameRank02, isSameRank02);
	IV notSameRank_gate2(isNotSameRank03, isSameRank03);
	IV notSameRank_gate3(isNotSameRank04, isSameRank04);
	IV notSameRank_gate4(isNotSameRank12, isSameRank12);
	IV notSameRank_gate5(isNotSameRank13, isSameRank13);
	IV notSameRank_gate6(isNotSameRank14, isSameRank14);
	IV notSameRank_gate7(isNotSameRank23, isSameRank23);
	IV notSameRank_gate8(isNotSameRank24, isSameRank24);
	IV notSameRank_gate9(isNotSameRank34, isSameRank34);

	// assign combination
	nor isNotSameRank_gate0(combination[0], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate1(combination[1], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate2(combination[2], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate3(combination[3], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate4(combination[4], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isNotSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate5(combination[5], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isNotSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate6(combination[6], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isNotSameRank14, isSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate7(combination[7], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isNotSameRank23, isSameRank24, isSameRank34);
	nor isNotSameRank_gate8(combination[8], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isNotSameRank24, isSameRank34);
	nor isNotSameRank_gate9(combination[9], isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isNotSameRank34);

	or or10_1(isOnlyOnePair, combination[0], combination[1], combination[2], combination[3], combination[4], combination[5], combination[6], combination[7], combination[8], combination[9]);
	
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

	wire [3:0] rank[4:0];
	assign rank[0] = rank0;
	assign rank[1] = rank1;
	assign rank[2] = rank2;
	assign rank[3] = rank3;
	assign rank[4] = rank4;

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
	wire isPair, isTwoPair, isThreeOfAKind, isFourOfAKind, isFullHouse, isStraight, isStraightFlush;
	sameRankDetector sameRankDetector(
		.rank0(rank[0]), .rank1(rank[1]), .rank2(rank[2]), .rank3(rank[3]), .rank4(rank[4]),
		.isPair(isPair), .isTwoPair(isTwoPair), .isThreeOfAKind(isThreeOfAKind), .isFourOfAKind(isFourOfAKind), .isFullHouse(isFullHouse)
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

	HA1 straightFlush_gate(.O(isStraightFlush), .A(isFlush), .B(isStraight));
	HA1 flush_gate(.O(flush), .A(isFlush), .B(isNotStraight));
	HA1 straight_gate(.O(straight), .A(isStraight), .B(isNotFlush));

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

