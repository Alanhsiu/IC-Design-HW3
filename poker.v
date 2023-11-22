`timescale 1ns/1ps

module flushDetector(
    input [1:0] suit0, suit1, suit2, suit3, suit4,
    output isFlush, isNotFlush
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
	ND2 is_not_flush_gate(isNotFlush, all_same_bit0, all_same_bit1);

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

module sameRankDetector(
    input [3:0] rank0, rank1, rank2, rank3, rank4,
    output isNotOnlyOnePair, isNotTwoPairs, isNotThreeOfAKind, isNotFourOfAKind, isNotFullHouse
);

    wire isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34;
    wire isSameRank0123, isSameRank0124, isSameRank0134, isSameRank0234, isSameRank1234;

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

    // four of a kind
	checkFourOfAKind fourOfAKind_gate(isNotFourOfAKind, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

	// full house
	checkFullHouse fullHouse_gate(isNotFullHouse, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

	// three of a kind
	checkThreeOfAKind threeOfAKind_gate(isNotThreeOfAKind, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

    // two pairs
	checkTwoPairs twoPair_gate(isNotTwoPairs, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

	// one pair
	checkOnlyOnePair onePair_gate(isNotOnlyOnePair, isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34);

endmodule

module checkFourOfAKind(
	output isNotFourOfAKind,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire temp[5:0][3:0];
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
	NR4 isNotSameRank_gate0(temp[0][0], isNotSameRank01, isNotSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate1(temp[0][1], isNotSameRank12, isNotSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate2(temp[0][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate3(temp[0][3], temp[0][0], temp[0][1], temp[0][2]);

	NR4 isNotSameRank_gate4(temp[1][0], isNotSameRank01, isNotSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate5(temp[1][1], isNotSameRank12, isSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate6(temp[1][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate7(temp[1][3], temp[1][0], temp[1][1], temp[1][2]);

	NR4 isNotSameRank_gate8(temp[2][0], isNotSameRank01, isSameRank02, isNotSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate9(temp[2][1], isSameRank12, isNotSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate10(temp[2][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate11(temp[2][3], temp[2][0], temp[2][1], temp[2][2]);
	
	NR4 isNotSameRank_gate12(temp[3][0], isSameRank01, isNotSameRank02, isNotSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate13(temp[3][1], isSameRank12, isSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate14(temp[3][2], isNotSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate15(temp[3][3], temp[3][0], temp[3][1], temp[3][2]);

	NR4 isNotSameRank_gate16(temp[4][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate17(temp[4][1], isNotSameRank12, isNotSameRank13, isNotSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate18(temp[4][2], isNotSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate19(temp[4][3], temp[4][0], temp[4][1], temp[4][2]);

	ND4 isNotSameRank_gate20(temp[5][0], temp[0][3], temp[1][3], temp[2][3], temp[3][3]);
	IV  isNotSameRank_gate21(temp[5][1], temp[4][3]);
	NR2 isNotSameRank_gate22(isNotFourOfAKind, temp[5][0], temp[5][1]);

endmodule

module checkFullHouse(
	output isNotFullHouse,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire temp[10:0][3:0];
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
	NR4 isNotSameRank_gate0(temp[0][0], isNotSameRank01, isNotSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate1(temp[0][1], isNotSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate2(temp[0][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate3(temp[0][3], temp[0][0], temp[0][1], temp[0][2]);

	NR4 isNotSameRank_gate4(temp[1][0], isNotSameRank01, isSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate5(temp[1][1], isSameRank12, isNotSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate6(temp[1][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate7(temp[1][3], temp[1][0], temp[1][1], temp[1][2]);

	NR4 isNotSameRank_gate8(temp[2][0], isNotSameRank01, isSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate9(temp[2][1], isSameRank12, isSameRank13, isNotSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate10(temp[2][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate11(temp[2][3], temp[2][0], temp[2][1], temp[2][2]);

	NR4 isNotSameRank_gate12(temp[3][0], isSameRank01, isNotSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate13(temp[3][1], isSameRank12, isSameRank13, isNotSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate14(temp[3][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate15(temp[3][3], temp[3][0], temp[3][1], temp[3][2]);

	NR4 isNotSameRank_gate16(temp[4][0], isSameRank01, isNotSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate17(temp[4][1], isSameRank12, isNotSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate18(temp[4][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate19(temp[4][3], temp[4][0], temp[4][1], temp[4][2]);

	NR4 isNotSameRank_gate20(temp[5][0], isSameRank01, isSameRank02, isNotSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate21(temp[5][1], isNotSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate22(temp[5][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate23(temp[5][3], temp[5][0], temp[5][1], temp[5][2]);

	NR4 isNotSameRank_gate24(temp[6][0], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate25(temp[6][1], isNotSameRank12, isNotSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate26(temp[6][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate27(temp[6][3], temp[6][0], temp[6][1], temp[6][2]);

	NR4 isNotSameRank_gate28(temp[7][0], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate29(temp[7][1], isNotSameRank12, isSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate30(temp[7][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate31(temp[7][3], temp[7][0], temp[7][1], temp[7][2]);

	NR4 isNotSameRank_gate32(temp[8][0], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate33(temp[8][1], isSameRank12, isNotSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate34(temp[8][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate35(temp[8][3], temp[8][0], temp[8][1], temp[8][2]);

	NR4 isNotSameRank_gate36(temp[9][0], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate37(temp[9][1], isSameRank12, isSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate38(temp[9][2], isNotSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate39(temp[9][3], temp[9][0], temp[9][1], temp[9][2]);

	ND4 isNotSameRank_gate40(temp[10][0], temp[0][3], temp[1][3], temp[2][3], temp[3][3]);
	ND4 isNotSameRank_gate41(temp[10][1], temp[4][3], temp[5][3], temp[6][3], temp[7][3]);
	ND2 isNotSameRank_gate42(temp[10][2], temp[8][3], temp[9][3]);
	NR4 isNotSameRank_gate43(isNotFullHouse, temp[10][0], temp[10][1], temp[10][2], 1'b0);

endmodule

module checkThreeOfAKind(
	output isNotThreeOfAKind,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire temp[10:0][3:0];
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
	NR4 isNotSameRank_gate0(temp[0][0], isNotSameRank01, isNotSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate1(temp[0][1], isNotSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate2(temp[0][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate3(temp[0][3], temp[0][0], temp[0][1], temp[0][2]);

	NR4 isNotSameRank_gate4(temp[1][0], isNotSameRank01, isSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate5(temp[1][1], isSameRank12, isNotSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate6(temp[1][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate7(temp[1][3], temp[1][0], temp[1][1], temp[1][2]);

	NR4 isNotSameRank_gate8(temp[2][0], isNotSameRank01, isSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate9(temp[2][1], isSameRank12, isSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate10(temp[2][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate11(temp[2][3], temp[2][0], temp[2][1], temp[2][2]);

	NR4 isNotSameRank_gate12(temp[3][0], isSameRank01, isNotSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate13(temp[3][1], isSameRank12, isSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate14(temp[3][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate15(temp[3][3], temp[3][0], temp[3][1], temp[3][2]);

	NR4 isNotSameRank_gate16(temp[4][0], isSameRank01, isNotSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate17(temp[4][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate18(temp[4][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate19(temp[4][3], temp[4][0], temp[4][1], temp[4][2]);

	NR4 isNotSameRank_gate20(temp[5][0], isSameRank01, isSameRank02, isNotSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate21(temp[5][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate22(temp[5][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate23(temp[5][3], temp[5][0], temp[5][1], temp[5][2]);

	NR4 isNotSameRank_gate24(temp[6][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate25(temp[6][1], isNotSameRank12, isNotSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate26(temp[6][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate27(temp[6][3], temp[6][0], temp[6][1], temp[6][2]);

	NR4 isNotSameRank_gate28(temp[7][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate29(temp[7][1], isNotSameRank12, isSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate30(temp[7][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate31(temp[7][3], temp[7][0], temp[7][1], temp[7][2]);

	NR4 isNotSameRank_gate32(temp[8][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate33(temp[8][1], isSameRank12, isNotSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate34(temp[8][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate35(temp[8][3], temp[8][0], temp[8][1], temp[8][2]);

	NR4 isNotSameRank_gate36(temp[9][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate37(temp[9][1], isSameRank12, isSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate38(temp[9][2], isNotSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate39(temp[9][3], temp[9][0], temp[9][1], temp[9][2]);

	ND4 isNotSameRank_gate40(temp[10][0], temp[0][3], temp[1][3], temp[2][3], temp[3][3]);
	ND4 isNotSameRank_gate41(temp[10][1], temp[4][3], temp[5][3], temp[6][3], temp[7][3]);
	ND2 isNotSameRank_gate42(temp[10][2], temp[8][3], temp[9][3]);
	NR4 isNotSameRank_gate43(isNotThreeOfAKind, temp[10][0], temp[10][1], temp[10][2], 1'b0);

endmodule

module checkTwoPairs(
	output isNotTwoPairs,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire temp[15:0][3:0];
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
	NR4 isNotSameRank_gate0(temp[0][0], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate1(temp[0][1], isSameRank12, isSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate2(temp[0][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate3(temp[0][3], temp[0][0], temp[0][1], temp[0][2]);

	NR4 isNotSameRank_gate4(temp[1][0], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate5(temp[1][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate6(temp[1][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate7(temp[1][3], temp[1][0], temp[1][1], temp[1][2]);

	NR4 isNotSameRank_gate8(temp[2][0], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate9(temp[2][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate10(temp[2][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate11(temp[2][3], temp[2][0], temp[2][1], temp[2][2]);

	NR4 isNotSameRank_gate12(temp[3][0], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate13(temp[3][1], isSameRank12, isNotSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate14(temp[3][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate15(temp[3][3], temp[3][0], temp[3][1], temp[3][2]);

	NR4 isNotSameRank_gate16(temp[4][0], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate17(temp[4][1], isSameRank12, isSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate18(temp[4][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate19(temp[4][3], temp[4][0], temp[4][1], temp[4][2]);

	NR4 isNotSameRank_gate20(temp[5][0], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate21(temp[5][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate22(temp[5][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate23(temp[5][3], temp[5][0], temp[5][1], temp[5][2]);

	NR4 isNotSameRank_gate24(temp[6][0], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate25(temp[6][1], isNotSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate26(temp[6][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate27(temp[6][3], temp[6][0], temp[6][1], temp[6][2]);

	NR4 isNotSameRank_gate28(temp[7][0], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate29(temp[7][1], isSameRank12, isSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate30(temp[7][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate31(temp[7][3], temp[7][0], temp[7][1], temp[7][2]);

	NR4 isNotSameRank_gate32(temp[8][0], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate33(temp[8][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate34(temp[8][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate35(temp[8][3], temp[8][0], temp[8][1], temp[8][2]);

	NR4 isNotSameRank_gate36(temp[9][0], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate37(temp[9][1], isNotSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate38(temp[9][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate39(temp[9][3], temp[9][0], temp[9][1], temp[9][2]);

	NR4 isNotSameRank_gate40(temp[10][0], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate41(temp[10][1], isSameRank12, isNotSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate42(temp[10][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate43(temp[10][3], temp[10][0], temp[10][1], temp[10][2]);

	NR4 isNotSameRank_gate44(temp[11][0], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate45(temp[11][1], isSameRank12, isSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate46(temp[11][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate47(temp[11][3], temp[11][0], temp[11][1], temp[11][2]);

	NR4 isNotSameRank_gate48(temp[12][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate49(temp[12][1], isNotSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate50(temp[12][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate51(temp[12][3], temp[12][0], temp[12][1], temp[12][2]);

	NR4 isNotSameRank_gate52(temp[13][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate53(temp[13][1], isSameRank12, isNotSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate54(temp[13][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate55(temp[13][3], temp[13][0], temp[13][1], temp[13][2]);

	NR4 isNotSameRank_gate56(temp[14][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate57(temp[14][1], isSameRank12, isSameRank13, isNotSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate58(temp[14][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate59(temp[14][3], temp[14][0], temp[14][1], temp[14][2]);

	ND4 isNotSameRank_gate60(temp[15][0], temp[0][3], temp[1][3], temp[2][3], temp[3][3]);
	ND4 isNotSameRank_gate61(temp[15][1], temp[4][3], temp[5][3], temp[6][3], temp[7][3]);
	ND4 isNotSameRank_gate62(temp[15][2], temp[8][3], temp[9][3], temp[10][3], temp[11][3]);
	ND4 isNotSameRank_gate63(temp[15][3], temp[12][3], temp[13][3], temp[14][3], 1'b1);
	NR4 isNotSameRank_gate64(isNotTwoPairs, temp[15][0], temp[15][1], temp[15][2], temp[15][3]);

endmodule

module checkOnlyOnePair(
	output isNotOnlyOnePair,
	input isSameRank01, isSameRank02, isSameRank03, isSameRank04, isSameRank12, isSameRank13, isSameRank14, isSameRank23, isSameRank24, isSameRank34
);

	wire temp[10:0][3:0];
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
	NR4 isNotSameRank_gate0(temp[0][0], isNotSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate1(temp[0][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate2(temp[0][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate3(temp[0][3], temp[0][0], temp[0][1], temp[0][2]);

	NR4 isNotSameRank_gate4(temp[1][0], isSameRank01, isNotSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate5(temp[1][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate6(temp[1][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate7(temp[1][3], temp[1][0], temp[1][1], temp[1][2]);

	NR4 isNotSameRank_gate8(temp[2][0], isSameRank01, isSameRank02, isNotSameRank03, isSameRank04);
	NR4 isNotSameRank_gate9(temp[2][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate10(temp[2][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate11(temp[2][3], temp[2][0], temp[2][1], temp[2][2]);

	NR4 isNotSameRank_gate12(temp[3][0], isSameRank01, isSameRank02, isSameRank03, isNotSameRank04);
	NR4 isNotSameRank_gate13(temp[3][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate14(temp[3][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate15(temp[3][3], temp[3][0], temp[3][1], temp[3][2]);

	NR4 isNotSameRank_gate16(temp[4][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate17(temp[4][1], isNotSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate18(temp[4][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate19(temp[4][3], temp[4][0], temp[4][1], temp[4][2]);

	NR4 isNotSameRank_gate20(temp[5][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate21(temp[5][1], isSameRank12, isNotSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate22(temp[5][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate23(temp[5][3], temp[5][0], temp[5][1], temp[5][2]);

	NR4 isNotSameRank_gate24(temp[6][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate25(temp[6][1], isSameRank12, isSameRank13, isNotSameRank14, isSameRank23);
	NR2 isNotSameRank_gate26(temp[6][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate27(temp[6][3], temp[6][0], temp[6][1], temp[6][2]);

	NR4 isNotSameRank_gate28(temp[7][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate29(temp[7][1], isSameRank12, isSameRank13, isSameRank14, isNotSameRank23);
	NR2 isNotSameRank_gate30(temp[7][2], isSameRank24, isSameRank34);
	ND3 isNotSameRank_gate31(temp[7][3], temp[7][0], temp[7][1], temp[7][2]);

	NR4 isNotSameRank_gate32(temp[8][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate33(temp[8][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate34(temp[8][2], isNotSameRank24, isSameRank34);
	ND3 isNotSameRank_gate35(temp[8][3], temp[8][0], temp[8][1], temp[8][2]);

	NR4 isNotSameRank_gate36(temp[9][0], isSameRank01, isSameRank02, isSameRank03, isSameRank04);
	NR4 isNotSameRank_gate37(temp[9][1], isSameRank12, isSameRank13, isSameRank14, isSameRank23);
	NR2 isNotSameRank_gate38(temp[9][2], isSameRank24, isNotSameRank34);
	ND3 isNotSameRank_gate39(temp[9][3], temp[9][0], temp[9][1], temp[9][2]);

	ND4 isNotSameRank_gate40(temp[10][0], temp[0][3], temp[1][3], temp[2][3], temp[3][3]);
	ND4 isNotSameRank_gate41(temp[10][1], temp[4][3], temp[5][3], temp[6][3], temp[7][3]);
	ND2 isNotSameRank_gate42(temp[10][2], temp[8][3], temp[9][3]);
	NR4 isNotSameRank_gate43(isNotOnlyOnePair, temp[10][0], temp[10][1], temp[10][2], 1'b0);

endmodule

module straightDetector(
	input [3:0] rank0, rank1, rank2, rank3, rank4,
	output isStraight, isNotStraight
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

	wire temp[2:0];
	NR4 isStraight_gate0(temp[0], isStraightA2345, isStraight23456, isStraight34567, isStraight45678);
	NR4 isStraight_gate1(temp[1], isStraight56789, isStraight678910, isStraight78910J, isStraight8910JQ);
	NR2 isStraight_gate2(temp[2], isStraight910JQK, isStraight10JQKA);
	ND3 isStraight_gate3(isStraight, temp[0], temp[1], temp[2]);
	AN3 isNotStraight_gate4(isNotStraight, temp[0], temp[1], temp[2]);

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

	wire isFlush, isStraight;
	wire isNotFlush, isNotOnlyOnePair, isNotTwoPairs, isNotThreeOfAKind, isNotFourOfAKind, isNotFullHouse, isNotStraight, isNotStraightFlush;

	// flush detector
	flushDetector flushDetector(
		.suit0(suit[0]), .suit1(suit[1]), .suit2(suit[2]), .suit3(suit[3]), .suit4(suit[4]),
		.isFlush(isFlush), .isNotFlush(isNotFlush)
	);

	// same rank detector
	sameRankDetector sameRankDetector(
		.rank0(rank[0]), .rank1(rank[1]), .rank2(rank[2]), .rank3(rank[3]), .rank4(rank[4]),
		.isNotOnlyOnePair(isNotOnlyOnePair), .isNotTwoPairs(isNotTwoPairs), .isNotThreeOfAKind(isNotThreeOfAKind), .isNotFourOfAKind(isNotFourOfAKind), .isNotFullHouse(isNotFullHouse)
	);

	// straight detector
	straightDetector straightDetector(
		.rank0(rank[0]), .rank1(rank[1]), .rank2(rank[2]), .rank3(rank[3]), .rank4(rank[4]),
		.isStraight(isStraight), .isNotStraight(isNotStraight)
	);

	// type determination
	wire notStraight, notFlush;

	ND2 flush_gate(notFlush, isFlush, isNotStraight);
	ND2 straight_gate(notStraight, isStraight, isNotFlush);

	wire temp[2:0];
	AN2 temp_gate0(temp[2], isNotFourOfAKind, isNotFullHouse);
	AN3 temp_gate2(temp[0], isNotFourOfAKind, isNotThreeOfAKind, isNotOnlyOnePair);

	HA1 type_3(.O(type[3]), .A(isFlush), .B(isStraight));
	ND3 type_2(type[2], temp[2], notFlush, notStraight);  									 // four of a kind, full house, flush, straight
	ND4 type_1(type[1], isNotFourOfAKind, isNotFullHouse, isNotThreeOfAKind, isNotTwoPairs); // four of a kind, full house, three of a kind, two pairs
	ND2 type_0(type[0], temp[0], notFlush);  												 // four of a kind, flush, three of a kind, one pair

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


module checkStraightA2345(
	output isStraightA2345,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire isA2345[4:0][2:0];
	wire recordA2345[4:0][4:0];
	wire notRecordA2345[4:0][4:0];

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
			IV notRecordA2345_0(notRecordA2345[i][0], recordA2345[i][0]);
			IV notRecordA2345_1(notRecordA2345[i][1], recordA2345[i][1]);
			IV notRecordA2345_2(notRecordA2345[i][2], recordA2345[i][2]);
			IV notRecordA2345_3(notRecordA2345[i][3], recordA2345[i][3]);
			IV notRecordA2345_4(notRecordA2345[i][4], recordA2345[i][4]);
		end
	endgenerate

	NR4 nor4_1(isA2345[0][0], recordA2345[0][0], recordA2345[1][0], recordA2345[2][0], 1'b0);
	NR2 nor2_1(isA2345[0][1], recordA2345[3][0], recordA2345[4][0]);
	ND2 nand2_1(isA2345[0][2], isA2345[0][0], isA2345[0][1]);

	NR4 nor4_2(isA2345[1][0], recordA2345[0][1], recordA2345[1][1], recordA2345[2][1], 1'b0);
	NR2 nor2_2(isA2345[1][1], recordA2345[3][1], recordA2345[4][1]);
	ND2 nand2_2(isA2345[1][2], isA2345[1][0], isA2345[1][1]);

	NR4 nor4_3(isA2345[2][0], recordA2345[0][2], recordA2345[1][2], recordA2345[2][2], 1'b0);
	NR2 nor2_3(isA2345[2][1], recordA2345[3][2], recordA2345[4][2]);
	ND2 nand2_3(isA2345[2][2], isA2345[2][0], isA2345[2][1]);

	NR4 nor4_4(isA2345[3][0], recordA2345[0][3], recordA2345[1][3], recordA2345[2][3], 1'b0);
	NR2 nor2_4(isA2345[3][1], recordA2345[3][3], recordA2345[4][3]);
	ND2 nand2_4(isA2345[3][2], isA2345[3][0], isA2345[3][1]);

	NR4 nor4_5(isA2345[4][0], recordA2345[0][4], recordA2345[1][4], recordA2345[2][4], 1'b0);
	NR2 nor2_5(isA2345[4][1], recordA2345[3][4], recordA2345[4][4]);
	ND2 nand2_5(isA2345[4][2], isA2345[4][0], isA2345[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], isA2345[0][2], isA2345[1][2], isA2345[2][2]);
	ND2 nand2_6(temp[1], isA2345[3][2], isA2345[4][2]);
	NR2 nor_1(isStraightA2345, temp[0], temp[1]);

endmodule

module checkStraight23456(
	output isStraight23456,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is23456[4:0][2:0];
	wire record23456[4:0][4:0];
	wire notRecord23456[4:0][4:0];

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
			IV notRecord23456_0(notRecord23456[i][0], record23456[i][0]);
			IV notRecord23456_1(notRecord23456[i][1], record23456[i][1]);
			IV notRecord23456_2(notRecord23456[i][2], record23456[i][2]);
			IV notRecord23456_3(notRecord23456[i][3], record23456[i][3]);
			IV notRecord23456_4(notRecord23456[i][4], record23456[i][4]);
		end
	endgenerate

	NR4 nor4_1(is23456[0][0], record23456[0][0], record23456[1][0], record23456[2][0], 1'b0);
	NR2 nor2_1(is23456[0][1], record23456[3][0], record23456[4][0]);
	ND2 nand2_1(is23456[0][2], is23456[0][0], is23456[0][1]);

	NR4 nor4_2(is23456[1][0], record23456[0][1], record23456[1][1], record23456[2][1], 1'b0);
	NR2 nor2_2(is23456[1][1], record23456[3][1], record23456[4][1]);
	ND2 nand2_2(is23456[1][2], is23456[1][0], is23456[1][1]);

	NR4 nor4_3(is23456[2][0], record23456[0][2], record23456[1][2], record23456[2][2], 1'b0);
	NR2 nor2_3(is23456[2][1], record23456[3][2], record23456[4][2]);
	ND2 nand2_3(is23456[2][2], is23456[2][0], is23456[2][1]);

	NR4 nor4_4(is23456[3][0], record23456[0][3], record23456[1][3], record23456[2][3], 1'b0);
	NR2 nor2_4(is23456[3][1], record23456[3][3], record23456[4][3]);
	ND2 nand2_4(is23456[3][2], is23456[3][0], is23456[3][1]);

	NR4 nor4_5(is23456[4][0], record23456[0][4], record23456[1][4], record23456[2][4], 1'b0);
	NR2 nor2_5(is23456[4][1], record23456[3][4], record23456[4][4]);
	ND2 nand2_5(is23456[4][2], is23456[4][0], is23456[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is23456[0][2], is23456[1][2], is23456[2][2]);
	ND2 nand2_6(temp[1], is23456[3][2], is23456[4][2]);
	NR2 nor_1(isStraight23456, temp[0], temp[1]);

endmodule

module checkStraight34567(
	output isStraight34567,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is34567[4:0][2:0];
	wire record34567[4:0][4:0];
	wire notRecord34567[4:0][4:0];

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
			IV notRecord34567_0(notRecord34567[i][0], record34567[i][0]);
			IV notRecord34567_1(notRecord34567[i][1], record34567[i][1]);
			IV notRecord34567_2(notRecord34567[i][2], record34567[i][2]);
			IV notRecord34567_3(notRecord34567[i][3], record34567[i][3]);
			IV notRecord34567_4(notRecord34567[i][4], record34567[i][4]);
		end
	endgenerate

	NR4 nor4_1(is34567[0][0], record34567[0][0], record34567[1][0], record34567[2][0], 1'b0);
	NR2 nor2_1(is34567[0][1], record34567[3][0], record34567[4][0]);
	ND2 nand2_1(is34567[0][2], is34567[0][0], is34567[0][1]);

	NR4 nor4_2(is34567[1][0], record34567[0][1], record34567[1][1], record34567[2][1], 1'b0);
	NR2 nor2_2(is34567[1][1], record34567[3][1], record34567[4][1]);
	ND2 nand2_2(is34567[1][2], is34567[1][0], is34567[1][1]);

	NR4 nor4_3(is34567[2][0], record34567[0][2], record34567[1][2], record34567[2][2], 1'b0);
	NR2 nor2_3(is34567[2][1], record34567[3][2], record34567[4][2]);
	ND2 nand2_3(is34567[2][2], is34567[2][0], is34567[2][1]);

	NR4 nor4_4(is34567[3][0], record34567[0][3], record34567[1][3], record34567[2][3], 1'b0);
	NR2 nor2_4(is34567[3][1], record34567[3][3], record34567[4][3]);
	ND2 nand2_4(is34567[3][2], is34567[3][0], is34567[3][1]);

	NR4 nor4_5(is34567[4][0], record34567[0][4], record34567[1][4], record34567[2][4], 1'b0);
	NR2 nor2_5(is34567[4][1], record34567[3][4], record34567[4][4]);
	ND2 nand2_5(is34567[4][2], is34567[4][0], is34567[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is34567[0][2], is34567[1][2], is34567[2][2]);
	ND2 nand2_6(temp[1], is34567[3][2], is34567[4][2]);
	NR2 nor_1(isStraight34567, temp[0], temp[1]);

endmodule

module checkStraight45678(
	output isStraight45678,
	input [3:0] rank0, rank1, rank2, rank3, rank4,
	output is4, is5, is6, is7, is8
);

	wire is45678[4:0][2:0];
	wire record45678[4:0][4:0];
	wire notRecord45678[4:0][4:0];

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
			checkIfRankIs4 checkIfRankIs4(record45678[i][0], rank[i]);
			checkIfRankIs5 checkIfRankIs5(record45678[i][1], rank[i]);
			checkIfRankIs6 checkIfRankIs6(record45678[i][2], rank[i]);
			checkIfRankIs7 checkIfRankIs7(record45678[i][3], rank[i]);
			checkIfRankIs8 checkIfRankIs8(record45678[i][4], rank[i]);
			IV notRecord45678_0(notRecord45678[i][0], record45678[i][0]);
			IV notRecord45678_1(notRecord45678[i][1], record45678[i][1]);
			IV notRecord45678_2(notRecord45678[i][2], record45678[i][2]);
			IV notRecord45678_3(notRecord45678[i][3], record45678[i][3]);
			IV notRecord45678_4(notRecord45678[i][4], record45678[i][4]);
		end
	endgenerate

	NR4 nor4_1(is45678[0][0], record45678[0][0], record45678[1][0], record45678[2][0], 1'b0);
	NR2 nor2_1(is45678[0][1], record45678[3][0], record45678[4][0]);
	ND2 nand2_1(is45678[0][2], is45678[0][0], is45678[0][1]);

	NR4 nor4_2(is45678[1][0], record45678[0][1], record45678[1][1], record45678[2][1], 1'b0);
	NR2 nor2_2(is45678[1][1], record45678[3][1], record45678[4][1]);
	ND2 nand2_2(is45678[1][2], is45678[1][0], is45678[1][1]);

	NR4 nor4_3(is45678[2][0], record45678[0][2], record45678[1][2], record45678[2][2], 1'b0);
	NR2 nor2_3(is45678[2][1], record45678[3][2], record45678[4][2]);
	ND2 nand2_3(is45678[2][2], is45678[2][0], is45678[2][1]);

	NR4 nor4_4(is45678[3][0], record45678[0][3], record45678[1][3], record45678[2][3], 1'b0);
	NR2 nor2_4(is45678[3][1], record45678[3][3], record45678[4][3]);
	ND2 nand2_4(is45678[3][2], is45678[3][0], is45678[3][1]);

	NR4 nor4_5(is45678[4][0], record45678[0][4], record45678[1][4], record45678[2][4], 1'b0);
	NR2 nor2_5(is45678[4][1], record45678[3][4], record45678[4][4]);
	ND2 nand2_5(is45678[4][2], is45678[4][0], is45678[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is45678[0][2], is45678[1][2], is45678[2][2]);
	ND2 nand2_6(temp[1], is45678[3][2], is45678[4][2]);
	NR2 nor_1(isStraight45678, temp[0], temp[1]);

endmodule

module checkStraight56789(
	output isStraight56789,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is56789[4:0][2:0];
	wire record56789[4:0][4:0];
	wire notRecord56789[4:0][4:0];

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
			checkIfRankIs5 checkIfRankIs5(record56789[i][0], rank[i]);
			checkIfRankIs6 checkIfRankIs6(record56789[i][1], rank[i]);
			checkIfRankIs7 checkIfRankIs7(record56789[i][2], rank[i]);
			checkIfRankIs8 checkIfRankIs8(record56789[i][3], rank[i]);
			checkIfRankIs9 checkIfRankIs9(record56789[i][4], rank[i]);
			IV notRecord56789_0(notRecord56789[i][0], record56789[i][0]);
			IV notRecord56789_1(notRecord56789[i][1], record56789[i][1]);
			IV notRecord56789_2(notRecord56789[i][2], record56789[i][2]);
			IV notRecord56789_3(notRecord56789[i][3], record56789[i][3]);
			IV notRecord56789_4(notRecord56789[i][4], record56789[i][4]);
		end
	endgenerate

	NR4 nor4_1(is56789[0][0], record56789[0][0], record56789[1][0], record56789[2][0], 1'b0);
	NR2 nor2_1(is56789[0][1], record56789[3][0], record56789[4][0]);
	ND2 nand2_1(is56789[0][2], is56789[0][0], is56789[0][1]);

	NR4 nor4_2(is56789[1][0], record56789[0][1], record56789[1][1], record56789[2][1], 1'b0);
	NR2 nor2_2(is56789[1][1], record56789[3][1], record56789[4][1]);
	ND2 nand2_2(is56789[1][2], is56789[1][0], is56789[1][1]);

	NR4 nor4_3(is56789[2][0], record56789[0][2], record56789[1][2], record56789[2][2], 1'b0);
	NR2 nor2_3(is56789[2][1], record56789[3][2], record56789[4][2]);
	ND2 nand2_3(is56789[2][2], is56789[2][0], is56789[2][1]);

	NR4 nor4_4(is56789[3][0], record56789[0][3], record56789[1][3], record56789[2][3], 1'b0);
	NR2 nor2_4(is56789[3][1], record56789[3][3], record56789[4][3]);
	ND2 nand2_4(is56789[3][2], is56789[3][0], is56789[3][1]);

	NR4 nor4_5(is56789[4][0], record56789[0][4], record56789[1][4], record56789[2][4], 1'b0);
	NR2 nor2_5(is56789[4][1], record56789[3][4], record56789[4][4]);
	ND2 nand2_5(is56789[4][2], is56789[4][0], is56789[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is56789[0][2], is56789[1][2], is56789[2][2]);
	ND2 nand2_6(temp[1], is56789[3][2], is56789[4][2]);
	NR2 nor_1(isStraight56789, temp[0], temp[1]);

endmodule

module checkStraight678910(
	output isStraight678910,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is678910[4:0][2:0];
	wire record678910[4:0][4:0];
	wire notRecord678910[4:0][4:0];

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
			checkIfRankIs6 checkIfRankIs6(record678910[i][0], rank[i]);
			checkIfRankIs7 checkIfRankIs7(record678910[i][1], rank[i]);
			checkIfRankIs8 checkIfRankIs8(record678910[i][2], rank[i]);
			checkIfRankIs9 checkIfRankIs9(record678910[i][3], rank[i]);
			checkIfRankIs10 checkIfRankIs10(record678910[i][4], rank[i]);
			IV notRecord678910_0(notRecord678910[i][0], record678910[i][0]);
			IV notRecord678910_1(notRecord678910[i][1], record678910[i][1]);
			IV notRecord678910_2(notRecord678910[i][2], record678910[i][2]);
			IV notRecord678910_3(notRecord678910[i][3], record678910[i][3]);
			IV notRecord678910_4(notRecord678910[i][4], record678910[i][4]);
		end
	endgenerate

	NR4 nor4_1(is678910[0][0], record678910[0][0], record678910[1][0], record678910[2][0], 1'b0);
	NR2 nor2_1(is678910[0][1], record678910[3][0], record678910[4][0]);
	ND2 nand2_1(is678910[0][2], is678910[0][0], is678910[0][1]);

	NR4 nor4_2(is678910[1][0], record678910[0][1], record678910[1][1], record678910[2][1], 1'b0);
	NR2 nor2_2(is678910[1][1], record678910[3][1], record678910[4][1]);
	ND2 nand2_2(is678910[1][2], is678910[1][0], is678910[1][1]);

	NR4 nor4_3(is678910[2][0], record678910[0][2], record678910[1][2], record678910[2][2], 1'b0);
	NR2 nor2_3(is678910[2][1], record678910[3][2], record678910[4][2]);
	ND2 nand2_3(is678910[2][2], is678910[2][0], is678910[2][1]);

	NR4 nor4_4(is678910[3][0], record678910[0][3], record678910[1][3], record678910[2][3], 1'b0);
	NR2 nor2_4(is678910[3][1], record678910[3][3], record678910[4][3]);
	ND2 nand2_4(is678910[3][2], is678910[3][0], is678910[3][1]);

	NR4 nor4_5(is678910[4][0], record678910[0][4], record678910[1][4], record678910[2][4], 1'b0);
	NR2 nor2_5(is678910[4][1], record678910[3][4], record678910[4][4]);
	ND2 nand2_5(is678910[4][2], is678910[4][0], is678910[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is678910[0][2], is678910[1][2], is678910[2][2]);
	ND2 nand2_6(temp[1], is678910[3][2], is678910[4][2]);
	NR2 nor_1(isStraight678910, temp[0], temp[1]);

endmodule

module checkStraight78910J(
	output isStraight78910J,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is78910J[4:0][2:0];
	wire record78910J[4:0][4:0];
	wire notRecord78910J[4:0][4:0];

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
			checkIfRankIs7 checkIfRankIs7(record78910J[i][0], rank[i]);
			checkIfRankIs8 checkIfRankIs8(record78910J[i][1], rank[i]);
			checkIfRankIs9 checkIfRankIs9(record78910J[i][2], rank[i]);
			checkIfRankIs10 checkIfRankIs10(record78910J[i][3], rank[i]);
			checkIfRankIsJ checkIfRankIsJ(record78910J[i][4], rank[i]);
			IV notRecord78910J_0(notRecord78910J[i][0], record78910J[i][0]);
			IV notRecord78910J_1(notRecord78910J[i][1], record78910J[i][1]);
			IV notRecord78910J_2(notRecord78910J[i][2], record78910J[i][2]);
			IV notRecord78910J_3(notRecord78910J[i][3], record78910J[i][3]);
			IV notRecord78910J_4(notRecord78910J[i][4], record78910J[i][4]);
		end
	endgenerate

	NR4 nor4_1(is78910J[0][0], record78910J[0][0], record78910J[1][0], record78910J[2][0], 1'b0);
	NR2 nor2_1(is78910J[0][1], record78910J[3][0], record78910J[4][0]);
	ND2 nand2_1(is78910J[0][2], is78910J[0][0], is78910J[0][1]);

	NR4 nor4_2(is78910J[1][0], record78910J[0][1], record78910J[1][1], record78910J[2][1], 1'b0);
	NR2 nor2_2(is78910J[1][1], record78910J[3][1], record78910J[4][1]);
	ND2 nand2_2(is78910J[1][2], is78910J[1][0], is78910J[1][1]);

	NR4 nor4_3(is78910J[2][0], record78910J[0][2], record78910J[1][2], record78910J[2][2], 1'b0);
	NR2 nor2_3(is78910J[2][1], record78910J[3][2], record78910J[4][2]);
	ND2 nand2_3(is78910J[2][2], is78910J[2][0], is78910J[2][1]);

	NR4 nor4_4(is78910J[3][0], record78910J[0][3], record78910J[1][3], record78910J[2][3], 1'b0);
	NR2 nor2_4(is78910J[3][1], record78910J[3][3], record78910J[4][3]);
	ND2 nand2_4(is78910J[3][2], is78910J[3][0], is78910J[3][1]);

	NR4 nor4_5(is78910J[4][0], record78910J[0][4], record78910J[1][4], record78910J[2][4], 1'b0);
	NR2 nor2_5(is78910J[4][1], record78910J[3][4], record78910J[4][4]);
	ND2 nand2_5(is78910J[4][2], is78910J[4][0], is78910J[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is78910J[0][2], is78910J[1][2], is78910J[2][2]);
	ND2 nand2_6(temp[1], is78910J[3][2], is78910J[4][2]);
	NR2 nor_1(isStraight78910J, temp[0], temp[1]);

endmodule

module checkStraight8910JQ(
	output isStraight8910JQ,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is8910JQ[4:0][2:0];
	wire record8910JQ[4:0][4:0];
	wire notRecord8910JQ[4:0][4:0];

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
			checkIfRankIs8 checkIfRankIs8(record8910JQ[i][0], rank[i]);
			checkIfRankIs9 checkIfRankIs9(record8910JQ[i][1], rank[i]);
			checkIfRankIs10 checkIfRankIs10(record8910JQ[i][2], rank[i]);
			checkIfRankIsJ checkIfRankIsJ(record8910JQ[i][3], rank[i]);
			checkIfRankIsQ checkIfRankIsQ(record8910JQ[i][4], rank[i]);
			IV notRecord8910JQ_0(notRecord8910JQ[i][0], record8910JQ[i][0]);
			IV notRecord8910JQ_1(notRecord8910JQ[i][1], record8910JQ[i][1]);
			IV notRecord8910JQ_2(notRecord8910JQ[i][2], record8910JQ[i][2]);
			IV notRecord8910JQ_3(notRecord8910JQ[i][3], record8910JQ[i][3]);
			IV notRecord8910JQ_4(notRecord8910JQ[i][4], record8910JQ[i][4]);
		end
	endgenerate

	NR4 nor4_1(is8910JQ[0][0], record8910JQ[0][0], record8910JQ[1][0], record8910JQ[2][0], 1'b0);
	NR2 nor2_1(is8910JQ[0][1], record8910JQ[3][0], record8910JQ[4][0]);
	ND2 nand2_1(is8910JQ[0][2], is8910JQ[0][0], is8910JQ[0][1]);

	NR4 nor4_2(is8910JQ[1][0], record8910JQ[0][1], record8910JQ[1][1], record8910JQ[2][1], 1'b0);
	NR2 nor2_2(is8910JQ[1][1], record8910JQ[3][1], record8910JQ[4][1]);
	ND2 nand2_2(is8910JQ[1][2], is8910JQ[1][0], is8910JQ[1][1]);

	NR4 nor4_3(is8910JQ[2][0], record8910JQ[0][2], record8910JQ[1][2], record8910JQ[2][2], 1'b0);
	NR2 nor2_3(is8910JQ[2][1], record8910JQ[3][2], record8910JQ[4][2]);
	ND2 nand2_3(is8910JQ[2][2], is8910JQ[2][0], is8910JQ[2][1]);

	NR4 nor4_4(is8910JQ[3][0], record8910JQ[0][3], record8910JQ[1][3], record8910JQ[2][3], 1'b0);
	NR2 nor2_4(is8910JQ[3][1], record8910JQ[3][3], record8910JQ[4][3]);
	ND2 nand2_4(is8910JQ[3][2], is8910JQ[3][0], is8910JQ[3][1]);

	NR4 nor4_5(is8910JQ[4][0], record8910JQ[0][4], record8910JQ[1][4], record8910JQ[2][4], 1'b0);
	NR2 nor2_5(is8910JQ[4][1], record8910JQ[3][4], record8910JQ[4][4]);
	ND2 nand2_5(is8910JQ[4][2], is8910JQ[4][0], is8910JQ[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is8910JQ[0][2], is8910JQ[1][2], is8910JQ[2][2]);
	ND2 nand2_6(temp[1], is8910JQ[3][2], is8910JQ[4][2]);
	NR2 nor_1(isStraight8910JQ, temp[0], temp[1]);

endmodule

module checkStraight910JQK(
	output isStraight910JQK,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is910JQK[4:0][2:0];
	wire record910JQK[4:0][4:0];
	wire notRecord910JQK[4:0][4:0];

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
			checkIfRankIs9 checkIfRankIs9(record910JQK[i][0], rank[i]);
			checkIfRankIs10 checkIfRankIs10(record910JQK[i][1], rank[i]);
			checkIfRankIsJ checkIfRankIsJ(record910JQK[i][2], rank[i]);
			checkIfRankIsQ checkIfRankIsQ(record910JQK[i][3], rank[i]);
			checkIfRankIsK checkIfRankIsK(record910JQK[i][4], rank[i]);
			IV notRecord910JQK_0(notRecord910JQK[i][0], record910JQK[i][0]);
			IV notRecord910JQK_1(notRecord910JQK[i][1], record910JQK[i][1]);
			IV notRecord910JQK_2(notRecord910JQK[i][2], record910JQK[i][2]);
			IV notRecord910JQK_3(notRecord910JQK[i][3], record910JQK[i][3]);
			IV notRecord910JQK_4(notRecord910JQK[i][4], record910JQK[i][4]);
		end
	endgenerate

	NR4 nor4_1(is910JQK[0][0], record910JQK[0][0], record910JQK[1][0], record910JQK[2][0], 1'b0);
	NR2 nor2_1(is910JQK[0][1], record910JQK[3][0], record910JQK[4][0]);
	ND2 nand2_1(is910JQK[0][2], is910JQK[0][0], is910JQK[0][1]);

	NR4 nor4_2(is910JQK[1][0], record910JQK[0][1], record910JQK[1][1], record910JQK[2][1], 1'b0);
	NR2 nor2_2(is910JQK[1][1], record910JQK[3][1], record910JQK[4][1]);
	ND2 nand2_2(is910JQK[1][2], is910JQK[1][0], is910JQK[1][1]);

	NR4 nor4_3(is910JQK[2][0], record910JQK[0][2], record910JQK[1][2], record910JQK[2][2], 1'b0);
	NR2 nor2_3(is910JQK[2][1], record910JQK[3][2], record910JQK[4][2]);
	ND2 nand2_3(is910JQK[2][2], is910JQK[2][0], is910JQK[2][1]);

	NR4 nor4_4(is910JQK[3][0], record910JQK[0][3], record910JQK[1][3], record910JQK[2][3], 1'b0);
	NR2 nor2_4(is910JQK[3][1], record910JQK[3][3], record910JQK[4][3]);
	ND2 nand2_4(is910JQK[3][2], is910JQK[3][0], is910JQK[3][1]);

	NR4 nor4_5(is910JQK[4][0], record910JQK[0][4], record910JQK[1][4], record910JQK[2][4], 1'b0);
	NR2 nor2_5(is910JQK[4][1], record910JQK[3][4], record910JQK[4][4]);
	ND2 nand2_5(is910JQK[4][2], is910JQK[4][0], is910JQK[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is910JQK[0][2], is910JQK[1][2], is910JQK[2][2]);
	ND2 nand2_6(temp[1], is910JQK[3][2], is910JQK[4][2]);
	NR2 nor_1(isStraight910JQK, temp[0], temp[1]);

endmodule

module checkStraight10JQKA(
	output isStraight10JQKA,
	input [3:0] rank0, rank1, rank2, rank3, rank4
);

	wire is10JQKA[4:0][2:0];
	wire record10JQKA[4:0][4:0];
	wire notRecord10JQKA[4:0][4:0];

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
			IV notRecord10JQKA_0(notRecord10JQKA[i][0], record10JQKA[i][0]);
			IV notRecord10JQKA_1(notRecord10JQKA[i][1], record10JQKA[i][1]);
			IV notRecord10JQKA_2(notRecord10JQKA[i][2], record10JQKA[i][2]);
			IV notRecord10JQKA_3(notRecord10JQKA[i][3], record10JQKA[i][3]);
			IV notRecord10JQKA_4(notRecord10JQKA[i][4], record10JQKA[i][4]);
		end
	endgenerate

	NR4 nor4_1(is10JQKA[0][0], record10JQKA[0][0], record10JQKA[1][0], record10JQKA[2][0], 1'b0);
	NR2 nor2_1(is10JQKA[0][1], record10JQKA[3][0], record10JQKA[4][0]);
	ND2 nand2_1(is10JQKA[0][2], is10JQKA[0][0], is10JQKA[0][1]);

	NR4 nor4_2(is10JQKA[1][0], record10JQKA[0][1], record10JQKA[1][1], record10JQKA[2][1], 1'b0);
	NR2 nor2_2(is10JQKA[1][1], record10JQKA[3][1], record10JQKA[4][1]);
	ND2 nand2_2(is10JQKA[1][2], is10JQKA[1][0], is10JQKA[1][1]);

	NR4 nor4_3(is10JQKA[2][0], record10JQKA[0][2], record10JQKA[1][2], record10JQKA[2][2], 1'b0);
	NR2 nor2_3(is10JQKA[2][1], record10JQKA[3][2], record10JQKA[4][2]);
	ND2 nand2_3(is10JQKA[2][2], is10JQKA[2][0], is10JQKA[2][1]);

	NR4 nor4_4(is10JQKA[3][0], record10JQKA[0][3], record10JQKA[1][3], record10JQKA[2][3], 1'b0);
	NR2 nor2_4(is10JQKA[3][1], record10JQKA[3][3], record10JQKA[4][3]);
	ND2 nand2_4(is10JQKA[3][2], is10JQKA[3][0], is10JQKA[3][1]);

	NR4 nor4_5(is10JQKA[4][0], record10JQKA[0][4], record10JQKA[1][4], record10JQKA[2][4], 1'b0);
	NR2 nor2_5(is10JQKA[4][1], record10JQKA[3][4], record10JQKA[4][4]);
	ND2 nand2_5(is10JQKA[4][2], is10JQKA[4][0], is10JQKA[4][1]);

	wire temp[1:0];
	ND3 nand3_1(temp[0], is10JQKA[0][2], is10JQKA[1][2], is10JQKA[2][2]);
	ND2 nand2_6(temp[1], is10JQKA[3][2], is10JQKA[4][2]);
	NR2 nor_1(isStraight10JQKA, temp[0], temp[1]);

endmodule