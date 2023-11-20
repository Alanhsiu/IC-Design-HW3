module sortByRank(
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

	// if compareResult[i] has 4 1's, then rank[i] is the largest
	wire isRankHas4Ones[4:0], notRankHas4Ones[4:0];
	AN4 isRank0Has4Ones_gate(isRankHas4Ones[0], compareResult[0][1], compareResult[0][2], compareResult[0][3], compareResult[0][4]);
	AN4 isRank1Has4Ones_gate(isRankHas4Ones[1], compareResult[1][0], compareResult[1][2], compareResult[1][3], compareResult[1][4]);
	AN4 isRank2Has4Ones_gate(isRankHas4Ones[2], compareResult[2][0], compareResult[2][1], compareResult[2][3], compareResult[2][4]);
	AN4 isRank3Has4Ones_gate(isRankHas4Ones[3], compareResult[3][0], compareResult[3][1], compareResult[3][2], compareResult[3][4]);
	AN4 isRank4Has4Ones_gate(isRankHas4Ones[4], compareResult[4][0], compareResult[4][1], compareResult[4][2], compareResult[4][3]);

	genvar i4;
	generate
		for (i4 = 0; i4 < 5; i4 = i4 + 1)
		begin
			IV notRankHas4Ones_gate(notRankHas4Ones[i4], isRankHas4Ones[i4]);
		end
	endgenerate

	// if compareResult[i] has 3 1's, then rank[i] is the second largest
	wire isRankHas3Ones[4:0];
	wire isRankHasOnly3Ones[4:0], notRankHasOnly3Ones[4:0];
	wire are3Ones[4:0][4:0];

	AN3 isRank0Has3Ones1_gate(are3Ones[0][1], compareResult[0][1], compareResult[0][2], compareResult[0][3]);
	AN3 isRank0Has3Ones2_gate(are3Ones[0][2], compareResult[0][1], compareResult[0][2], compareResult[0][4]);
	AN3 isRank0Has3Ones3_gate(are3Ones[0][3], compareResult[0][1], compareResult[0][3], compareResult[0][4]);
	AN3 isRank0Has3Ones4_gate(are3Ones[0][4], compareResult[0][2], compareResult[0][3], compareResult[0][4]);
	OR4 isRank0Has3Ones_gate(isRankHas3Ones[0], are3Ones[0][1], are3Ones[0][2], are3Ones[0][3], are3Ones[0][4]);
	AN2 isRank0HasOnly3Ones_gate(isRankHasOnly3Ones[0], isRankHas3Ones[0], notRankHas4Ones[0]);

	AN3 isRank1Has3Ones1_gate(are3Ones[1][0], compareResult[1][0], compareResult[1][2], compareResult[1][3]);
	AN3 isRank1Has3Ones2_gate(are3Ones[1][2], compareResult[1][0], compareResult[1][2], compareResult[1][4]);
	AN3 isRank1Has3Ones3_gate(are3Ones[1][3], compareResult[1][0], compareResult[1][3], compareResult[1][4]);
	AN3 isRank1Has3Ones4_gate(are3Ones[1][4], compareResult[1][2], compareResult[1][3], compareResult[1][4]);
	OR4 isRank1Has3Ones_gate(isRankHas3Ones[1], are3Ones[1][0], are3Ones[1][2], are3Ones[1][3], are3Ones[1][4]);
	AN2 isRank1HasOnly3Ones_gate(isRankHasOnly3Ones[1], isRankHas3Ones[1], notRankHas4Ones[1]);

	AN3 isRank2Has3Ones1_gate(are3Ones[2][0], compareResult[2][0], compareResult[2][1], compareResult[2][3]);
	AN3 isRank2Has3Ones2_gate(are3Ones[2][1], compareResult[2][0], compareResult[2][1], compareResult[2][4]);
	AN3 isRank2Has3Ones3_gate(are3Ones[2][3], compareResult[2][0], compareResult[2][3], compareResult[2][4]);
	AN3 isRank2Has3Ones4_gate(are3Ones[2][4], compareResult[2][1], compareResult[2][3], compareResult[2][4]);
	OR4 isRank2Has3Ones_gate(isRankHas3Ones[2], are3Ones[2][0], are3Ones[2][1], are3Ones[2][3], are3Ones[2][4]);
	AN2 isRank2HasOnly3Ones_gate(isRankHasOnly3Ones[2], isRankHas3Ones[2], notRankHas4Ones[2]);

	AN3 isRank3Has3Ones1_gate(are3Ones[3][0], compareResult[3][0], compareResult[3][1], compareResult[3][2]);
	AN3 isRank3Has3Ones2_gate(are3Ones[3][1], compareResult[3][0], compareResult[3][1], compareResult[3][4]);
	AN3 isRank3Has3Ones3_gate(are3Ones[3][2], compareResult[3][0], compareResult[3][2], compareResult[3][4]);
	AN3 isRank3Has3Ones4_gate(are3Ones[3][4], compareResult[3][1], compareResult[3][2], compareResult[3][4]);
	OR4 isRank3Has3Ones_gate(isRankHas3Ones[3], are3Ones[3][0], are3Ones[3][1], are3Ones[3][2], are3Ones[3][4]);
	AN2 isRank3HasOnly3Ones_gate(isRankHasOnly3Ones[3], isRankHas3Ones[3], notRankHas4Ones[3]);

	AN3 isRank4Has3Ones1_gate(are3Ones[4][0], compareResult[4][0], compareResult[4][1], compareResult[4][2]);
	AN3 isRank4Has3Ones2_gate(are3Ones[4][1], compareResult[4][0], compareResult[4][1], compareResult[4][3]);
	AN3 isRank4Has3Ones3_gate(are3Ones[4][2], compareResult[4][0], compareResult[4][2], compareResult[4][3]);
	AN3 isRank4Has3Ones4_gate(are3Ones[4][3], compareResult[4][1], compareResult[4][2], compareResult[4][3]);
	OR4 isRank4Has3Ones_gate(isRankHas3Ones[4], are3Ones[4][0], are3Ones[4][1], are3Ones[4][2], are3Ones[4][3]);
	AN2 isRank4HasOnly3Ones_gate(isRankHasOnly3Ones[4], isRankHas3Ones[4], notRankHas4Ones[4]);

	genvar i3;
	generate
		for (i3 = 0; i3 < 5; i3 = i3 + 1)
		begin
			IV notRankHasOnly3Ones_gate(notRankHasOnly3Ones[i3], isRankHasOnly3Ones[i3]);
		end
	endgenerate

	// if compareResult[i] has 2 1's, then rank[i] is the third largest
	wire isRankHasOnly2Ones[4:0], notRankHasOnly2Ones[4:0];
	wire are2Ones[4:0][5:0];
	wire firstThreeCompares[4:0];
	wire lastThreeCompare[4:0];

	genvar i2;
	generate
		for (i2 = 0; i2 < 5; i2 = i2 + 1)
		begin
			IV notRankHas2Ones_gate(notRankHasOnly2Ones[i2], isRankHasOnly2Ones[i2]);
		end
	endgenerate

	AN2 isRank0Has2Ones1_gate(are2Ones[0][0], compareResult[0][1], compareResult[0][2]);
	AN2 isRank0Has2Ones2_gate(are2Ones[0][1], compareResult[0][1], compareResult[0][3]);
	AN2 isRank0Has2Ones3_gate(are2Ones[0][2], compareResult[0][1], compareResult[0][4]);
	AN2 isRank0Has2Ones4_gate(are2Ones[0][3], compareResult[0][2], compareResult[0][3]);
	AN2 isRank0Has2Ones5_gate(are2Ones[0][4], compareResult[0][2], compareResult[0][4]);
	AN2 isRank0Has2Ones6_gate(are2Ones[0][5], compareResult[0][3], compareResult[0][4]);
	OR3 firstThreeCompares_gate0(firstThreeCompares[0], are2Ones[0][0], are2Ones[0][1], are2Ones[0][2]);
	OR3 lastThreeCompare_gate0(lastThreeCompare[0], are2Ones[0][3], are2Ones[0][4], are2Ones[0][5]);
	AN4 isRank0Has2Ones_gate(isRankHasOnly2Ones[0], firstThreeCompares[0], lastThreeCompare[0], notRankHasOnly3Ones[0], notRankHas4Ones[0]);

	AN2 isRank1Has2Ones1_gate(are2Ones[1][0], compareResult[1][0], compareResult[1][2]);
	AN2 isRank1Has2Ones2_gate(are2Ones[1][1], compareResult[1][0], compareResult[1][3]);
	AN2 isRank1Has2Ones3_gate(are2Ones[1][2], compareResult[1][0], compareResult[1][4]);
	AN2 isRank1Has2Ones4_gate(are2Ones[1][3], compareResult[1][2], compareResult[1][3]);
	AN2 isRank1Has2Ones5_gate(are2Ones[1][4], compareResult[1][2], compareResult[1][4]);
	AN2 isRank1Has2Ones6_gate(are2Ones[1][5], compareResult[1][3], compareResult[1][4]);
	OR3 firstThreeCompares_gate1(firstThreeCompares[1], are2Ones[1][0], are2Ones[1][1], are2Ones[1][2]);
	OR3 lastThreeCompare_gate1(lastThreeCompare[1], are2Ones[1][3], are2Ones[1][4], are2Ones[1][5]);
	AN4 isRank1Has2Ones_gate(isRankHasOnly2Ones[1], firstThreeCompares[1], lastThreeCompare[1], notRankHasOnly3Ones[1], notRankHas4Ones[1]);

	AN2 isRank2Has2Ones1_gate(are2Ones[2][0], compareResult[2][0], compareResult[2][1]);
	AN2 isRank2Has2Ones2_gate(are2Ones[2][1], compareResult[2][0], compareResult[2][3]);
	AN2 isRank2Has2Ones3_gate(are2Ones[2][2], compareResult[2][0], compareResult[2][4]);
	AN2 isRank2Has2Ones4_gate(are2Ones[2][3], compareResult[2][1], compareResult[2][3]);
	AN2 isRank2Has2Ones5_gate(are2Ones[2][4], compareResult[2][1], compareResult[2][4]);
	AN2 isRank2Has2Ones6_gate(are2Ones[2][5], compareResult[2][3], compareResult[2][4]);
	OR3 firstThreeCompares_gate2(firstThreeCompares[2], are2Ones[2][0], are2Ones[2][1], are2Ones[2][2]);
	OR3 lastThreeCompare_gate2(lastThreeCompare[2], are2Ones[2][3], are2Ones[2][4], are2Ones[2][5]);
	AN4 isRank2Has2Ones_gate(isRankHasOnly2Ones[2], firstThreeCompares[2], lastThreeCompare[2], notRankHasOnly3Ones[2], notRankHas4Ones[2]);

	AN2 isRank3Has2Ones1_gate(are2Ones[3][0], compareResult[3][0], compareResult[3][1]);
	AN2 isRank3Has2Ones2_gate(are2Ones[3][1], compareResult[3][0], compareResult[3][2]);
	AN2 isRank3Has2Ones3_gate(are2Ones[3][2], compareResult[3][0], compareResult[3][4]);
	AN2 isRank3Has2Ones4_gate(are2Ones[3][3], compareResult[3][1], compareResult[3][2]);
	AN2 isRank3Has2Ones5_gate(are2Ones[3][4], compareResult[3][1], compareResult[3][4]);
	AN2 isRank3Has2Ones6_gate(are2Ones[3][5], compareResult[3][2], compareResult[3][4]);
	OR3 firstThreeCompares_gate3(firstThreeCompares[3], are2Ones[3][0], are2Ones[3][1], are2Ones[3][2]);
	OR3 lastThreeCompare_gate3(lastThreeCompare[3], are2Ones[3][3], are2Ones[3][4], are2Ones[3][5]);
	AN4 isRank3Has2Ones_gate(isRankHasOnly2Ones[3], firstThreeCompares[3], lastThreeCompare[3], notRankHasOnly3Ones[3], notRankHas4Ones[3]);

	AN2 isRank4Has2Ones1_gate(are2Ones[4][0], compareResult[4][0], compareResult[4][1]);
	AN2 isRank4Has2Ones2_gate(are2Ones[4][1], compareResult[4][0], compareResult[4][2]);
	AN2 isRank4Has2Ones3_gate(are2Ones[4][2], compareResult[4][0], compareResult[4][3]);
	AN2 isRank4Has2Ones4_gate(are2Ones[4][3], compareResult[4][1], compareResult[4][2]);
	AN2 isRank4Has2Ones5_gate(are2Ones[4][4], compareResult[4][1], compareResult[4][3]);
	AN2 isRank4Has2Ones6_gate(are2Ones[4][5], compareResult[4][2], compareResult[4][3]);
	OR3 firstThreeCompares_gate4(firstThreeCompares[4], are2Ones[4][0], are2Ones[4][1], are2Ones[4][2]);
	OR3 lastThreeCompare_gate4(lastThreeCompare[4], are2Ones[4][3], are2Ones[4][4], are2Ones[4][5]);
	AN4 isRank4Has2Ones_gate(isRankHasOnly2Ones[4], firstThreeCompares[4], lastThreeCompare[4], notRankHasOnly3Ones[4], notRankHas4Ones[4]);



	// if compareResult[i] has 1 1's, then rank[i] is the fourth largest
	wire isRankHas1One[4:0];
	wire isRankHasOnly1One[4:0], notRankHasOnly1One[4:0];

	OR4 isRank0Has1One_gate(isRankHas1One[0], compareResult[0][1], compareResult[0][2], compareResult[0][3], compareResult[0][4]);
	OR4 isRank1Has1One_gate(isRankHas1One[1], compareResult[1][0], compareResult[1][2], compareResult[1][3], compareResult[1][4]);
	OR4 isRank2Has1One_gate(isRankHas1One[2], compareResult[2][0], compareResult[2][1], compareResult[2][3], compareResult[2][4]);
	OR4 isRank3Has1One_gate(isRankHas1One[3], compareResult[3][0], compareResult[3][1], compareResult[3][2], compareResult[3][4]);
	OR4 isRank4Has1One_gate(isRankHas1One[4], compareResult[4][0], compareResult[4][1], compareResult[4][2], compareResult[4][3]);
	AN4 isRank0HasOnly1One_gate(isRankHasOnly1One[0], isRankHas1One[0], notRankHasOnly2Ones[0], notRankHasOnly3Ones[0], notRankHas4Ones[0]);
	AN4 isRank1HasOnly1One_gate(isRankHasOnly1One[1], isRankHas1One[1], notRankHasOnly2Ones[1], notRankHasOnly3Ones[1], notRankHas4Ones[1]);
	AN4 isRank2HasOnly1One_gate(isRankHasOnly1One[2], isRankHas1One[2], notRankHasOnly2Ones[2], notRankHasOnly3Ones[2], notRankHas4Ones[2]);
	AN4 isRank3HasOnly1One_gate(isRankHasOnly1One[3], isRankHas1One[3], notRankHasOnly2Ones[3], notRankHasOnly3Ones[3], notRankHas4Ones[3]);
	AN4 isRank4HasOnly1One_gate(isRankHasOnly1One[4], isRankHas1One[4], notRankHasOnly2Ones[4], notRankHasOnly3Ones[4], notRankHas4Ones[4]);

	genvar i1;
	generate
		for (i1 = 0; i1 < 5; i1 = i1 + 1)
		begin
			IV notRankHas1One_gate(notRankHasOnly1One[i1], isRankHasOnly1One[i1]);
		end
	endgenerate

	// if compareResult[i] has 0 1's, then rank[i] is the smallest
	wire isRankHas0One[4:0];

	NR4 isRank0Has0One_gate(isRankHas0One[0], compareResult[0][1], compareResult[0][2], compareResult[0][3], compareResult[0][4]);
	NR4 isRank1Has0One_gate(isRankHas0One[1], compareResult[1][0], compareResult[1][2], compareResult[1][3], compareResult[1][4]);
	NR4 isRank2Has0One_gate(isRankHas0One[2], compareResult[2][0], compareResult[2][1], compareResult[2][3], compareResult[2][4]);
	NR4 isRank3Has0One_gate(isRankHas0One[3], compareResult[3][0], compareResult[3][1], compareResult[3][2], compareResult[3][4]);
	NR4 isRank4Has0One_gate(isRankHas0One[4], compareResult[4][0], compareResult[4][1], compareResult[4][2], compareResult[4][3]);

	// assign sorted_rank
	integer i;
	always @(*)
	begin
		for (i = 0; i < 5; i = i + 1)
		begin
			if (isRankHas4Ones[i]==1'b1)
			begin
				sorted_rank[i] = rank[i];
			end
			else if (isRankHasOnly3Ones[i]==1'b1)
			begin
				sorted_rank[i] = rank[i];
			end
			else if (isRankHasOnly2Ones[i]==1'b1)
			begin
				sorted_rank[i] = rank[i];
			end
			else if (isRankHasOnly1One[i]==1'b1)
			begin
				sorted_rank[i] = rank[i];
			end
			else if (isRankHas0One[i]==1'b1)
			begin
				sorted_rank[i] = rank[i];
			end
		end
		sorted_rank0 = sorted_rank[0];
		sorted_rank1 = sorted_rank[1];
		sorted_rank2 = sorted_rank[2];
		sorted_rank3 = sorted_rank[3];
		sorted_rank4 = sorted_rank[4];
	end

endmodule