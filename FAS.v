module  FAS (data_valid, data, clk, rst, fir_d, fir_valid, fft_valid, done, freq,
 fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8,
 fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0);
 
input clk, rst;
input data_valid;
input [15:0] data; 

output reg fir_valid, fft_valid;
output reg [15:0] fir_d;
output reg [31:0] fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8;
output reg [31:0] fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0;
output reg done;
output reg [3:0] freq;

///////////////////////////////////   FIR   /////////////////////////////////// 

`include "./dat/FIR_coefficient.dat"

integer            i,j;
reg         [10:0] count_fir;
reg	signed  [15:0] x_reg [0:31];

wire signed [35:0] product_fir [0:31];
wire signed [66:0] sum_fir;

assign	product_fir[0]  = FIR_C00 * x_reg[0];
assign	product_fir[1]  = FIR_C01 * x_reg[1];
assign	product_fir[2]  = FIR_C02 * x_reg[2];
assign	product_fir[3]  = FIR_C03 * x_reg[3];
assign	product_fir[4]  = FIR_C04 * x_reg[4];
assign	product_fir[5]  = FIR_C05 * x_reg[5];
assign	product_fir[6]  = FIR_C06 * x_reg[6];
assign	product_fir[7]  = FIR_C07 * x_reg[7];
assign	product_fir[8]  = FIR_C08 * x_reg[8];
assign	product_fir[9]  = FIR_C09 * x_reg[9];
assign	product_fir[10] = FIR_C10 * x_reg[10];
assign	product_fir[11] = FIR_C11 * x_reg[11];
assign	product_fir[12] = FIR_C12 * x_reg[12];
assign	product_fir[13] = FIR_C13 * x_reg[13];
assign	product_fir[14] = FIR_C14 * x_reg[14];
assign	product_fir[15] = FIR_C15 * x_reg[15];
assign	product_fir[16] = FIR_C16 * x_reg[16];
assign	product_fir[17] = FIR_C17 * x_reg[17];
assign	product_fir[18] = FIR_C18 * x_reg[18];
assign	product_fir[19] = FIR_C19 * x_reg[19];
assign	product_fir[20] = FIR_C20 * x_reg[20];
assign	product_fir[21] = FIR_C21 * x_reg[21];
assign	product_fir[22] = FIR_C22 * x_reg[22];
assign	product_fir[23] = FIR_C23 * x_reg[23];
assign	product_fir[24] = FIR_C24 * x_reg[24];
assign	product_fir[25] = FIR_C25 * x_reg[25];
assign	product_fir[26] = FIR_C26 * x_reg[26];
assign	product_fir[27] = FIR_C27 * x_reg[27];
assign	product_fir[28] = FIR_C28 * x_reg[28];
assign	product_fir[29] = FIR_C29 * x_reg[29];
assign	product_fir[30] = FIR_C30 * x_reg[30];
assign	product_fir[31] = FIR_C31 * x_reg[31];

assign  sum_fir = ((((product_fir[0] + product_fir[1]) + (product_fir[2] + product_fir[3])) + ((product_fir[4] + product_fir[5]) +(product_fir[6] + product_fir[7]))) + (((product_fir[8] + product_fir[9]) + (product_fir[10] + product_fir[11])) + ((product_fir[12] + product_fir[13]) + (product_fir[14] + product_fir[15])))) + ((((product_fir[16] + product_fir[17]) + (product_fir[18] + product_fir[19])) + ((product_fir[20] + product_fir[21]) + (product_fir[22] + product_fir[23]))) + (((product_fir[24] + product_fir[25]) + (product_fir[26] + product_fir[27])) +((product_fir[28] + product_fir[29]) + (product_fir[30] + product_fir[31]))));

always@(posedge clk or posedge rst)
begin

   if(rst) begin
   
       count_fir <= 0;
	   
	   for (i = 0; i < 32; i=i+1)begin
	   
	       x_reg[i] <= 16'd0;
		   
	   end
	   
   end
   else begin
       	   
		   
	       if(count_fir >= 32) begin
		   
		       fir_valid <= 1;
			   count_fir <= count_fir + 1;
			   
		   end
		   else begin
		   
		       fir_valid <= 0;
			   count_fir <= count_fir + 1;
			   
		   end		   
          
       
      
       
	   x_reg[0] <= data; 
	   for(j = 0; j < 31; j = j + 1) begin
	   
	       x_reg[j+1] <= x_reg[j];
	   
	   end
	   
	   if(sum_fir[66] == 0) begin
	   
	       fir_d <= sum_fir[31:16]; 	
		   
	   end
	   else begin
	   
	       fir_d <= sum_fir[31:16] + 1;
		   
	   end
       
   end
   
end


//////////////////////////////////////    S2P    //////////////////////////////////////

reg			[31:0]	s2p_reg	[0:15];
reg			[5:0]	count_s2p;
reg                 s2p_valid;
integer             k, kk ;

always@(posedge clk or posedge rst)
begin

   if(rst) begin
   
        count_s2p <= 0;	
        s2p_valid <= 0;		
		for (k = 0; k < 16; k = k + 1) begin
		
			s2p_reg[k]	<=	32'b0;
			
		end
     
   end
   else begin
   
       if(fir_valid == 1) begin
	   	        
            if(count_s2p == 6'd15)begin
                s2p_valid <= 1'b1;
                count_s2p <= 6'd0;				
            end
            else begin
                s2p_valid <= 1'b0;
				count_s2p <= count_s2p + 1'b1;
            end			
		    
			case(count_s2p)
			
					6'd0:	s2p_reg[0]	<=  fir_d<<<16;
					6'd1:	s2p_reg[1]	<=	fir_d<<<16;
					6'd2:	s2p_reg[2]	<=	fir_d<<<16;
					6'd3:	s2p_reg[3]	<=	fir_d<<<16;
					6'd4:	s2p_reg[4]	<=	fir_d<<<16;
					6'd5:	s2p_reg[5]	<=	fir_d<<<16;
					6'd6:	s2p_reg[6]	<=	fir_d<<<16;
					6'd7:	s2p_reg[7]	<=	fir_d<<<16;
					6'd8:	s2p_reg[8]	<=	fir_d<<<16;
					6'd9:	s2p_reg[9]	<=	fir_d<<<16;
					6'd10:	s2p_reg[10]	<=	fir_d<<<16;
					6'd11:	s2p_reg[11]	<=	fir_d<<<16;
					6'd12:	s2p_reg[12]	<=	fir_d<<<16;
					6'd13:	s2p_reg[13]	<=	fir_d<<<16;
					6'd14:	s2p_reg[14]	<=	fir_d<<<16;
					6'd15:	s2p_reg[15]	<=	fir_d<<<16;
					default;
			
			endcase
				
				
			
				
	   end
       else begin
	        
			for (kk = 0; kk < 16; kk = kk + 1) begin
		
			      s2p_reg[kk] <= s2p_reg[kk];
			
		    end
			
	   end
    
   end
   
end


/////////////////////////////     FFT      /////////////////////////////////

        
wire signed [31:0]  x_real [4:0] [15:0]; //wire to connect fft_operaion
wire signed [31:0]  x_imag [4:0] [15:0]; //wire to connect fft_operaion

wire signed [31:0]  w_real [7:0];
wire signed [31:0]  w_imag [7:0];

assign w_real[0] = 32'h00010000;     //The real part of the reference table about COS(x)+i*SIN(x) value , 0: 001
assign w_real[1] = 32'h0000EC83;     //The real part of the reference table about COS(x)+i*SIN(x) value , 1: 9.238739e-001
assign w_real[2] = 32'h0000B504;     //The real part of the reference table about COS(x)+i*SIN(x) value , 2: 7.070923e-001
assign w_real[3] = 32'h000061F7;     //The real part of the reference table about COS(x)+i*SIN(x) value , 3: 3.826752e-001
assign w_real[4] = 32'h00000000;     //The real part of the reference table about COS(x)+i*SIN(x) value , 4: 000
assign w_real[5] = 32'hFFFF9E09;     //The real part of the reference table about COS(x)+i*SIN(x) value , 5: -3.826752e-001
assign w_real[6] = 32'hFFFF4AFC;     //The real part of the reference table about COS(x)+i*SIN(x) value , 6: -7.070923e-001
assign w_real[7] = 32'hFFFF137D;     //The real part of the reference table about COS(x)+i*SIN(x) value , 7: -9.238739e-00101

assign w_imag[0] = 32'h00000000;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 0: 000
assign w_imag[1] = 32'hFFFF9E09;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 1: -3.826752e-001
assign w_imag[2] = 32'hFFFF4AFC;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 2: -7.070923e-001
assign w_imag[3] = 32'hFFFF137D;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 3: -9.238739e-001
assign w_imag[4] = 32'hFFFF0000;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 4: -01
assign w_imag[5] = 32'hFFFF137D;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 5: -9.238739e-001
assign w_imag[6] = 32'hFFFF4AFC;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 6: -7.070923e-001
assign w_imag[7] = 32'hFFFF9E09;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 7: -3.826752e-001	


//運算初始值
assign x_real[0][0]  = (s2p_valid == 1) ? s2p_reg[0]  : 32'd0;
assign x_real[0][1]  = (s2p_valid == 1) ? s2p_reg[1]  : 32'd0;
assign x_real[0][2]  = (s2p_valid == 1) ? s2p_reg[2]  : 32'd0;
assign x_real[0][3]  = (s2p_valid == 1) ? s2p_reg[3]  : 32'd0;
assign x_real[0][4]  = (s2p_valid == 1) ? s2p_reg[4]  : 32'd0;
assign x_real[0][5]  = (s2p_valid == 1) ? s2p_reg[5]  : 32'd0;
assign x_real[0][6]  = (s2p_valid == 1) ? s2p_reg[6]  : 32'd0;
assign x_real[0][7]  = (s2p_valid == 1) ? s2p_reg[7]  : 32'd0;
assign x_real[0][8]  = (s2p_valid == 1) ? s2p_reg[8]  : 32'd0;
assign x_real[0][9]  = (s2p_valid == 1) ? s2p_reg[9]  : 32'd0;
assign x_real[0][10] = (s2p_valid == 1) ? s2p_reg[10] : 32'd0;
assign x_real[0][11] = (s2p_valid == 1) ? s2p_reg[11] : 32'd0;
assign x_real[0][12] = (s2p_valid == 1) ? s2p_reg[12] : 32'd0;
assign x_real[0][13] = (s2p_valid == 1) ? s2p_reg[13] : 32'd0;
assign x_real[0][14] = (s2p_valid == 1) ? s2p_reg[14] : 32'd0;
assign x_real[0][15] = (s2p_valid == 1) ? s2p_reg[15] : 32'd0;

assign x_imag[0][0]  = 32'b0;
assign x_imag[0][1]  = 32'b0;
assign x_imag[0][2]  = 32'b0;
assign x_imag[0][3]  = 32'b0;
assign x_imag[0][4]  = 32'b0;
assign x_imag[0][5]  = 32'b0;
assign x_imag[0][6]  = 32'b0;
assign x_imag[0][7]  = 32'b0;	
assign x_imag[0][8]  = 32'b0;
assign x_imag[0][9]  = 32'b0;
assign x_imag[0][10] = 32'b0;
assign x_imag[0][11] = 32'b0;
assign x_imag[0][12] = 32'b0;
assign x_imag[0][13] = 32'b0;
assign x_imag[0][14] = 32'b0;
assign x_imag[0][15] = 32'b0;


// 第一級
FFTcalculation u1 (clk,rst,fir_valid,x_real[0][0], x_imag[0][0], x_real[0][8], x_imag[0][8], w_real[0], w_imag[0], x_real[1][0], x_imag[1][0], x_real[1][8], x_imag[1][8]);
FFTcalculation u2 (clk,rst,fir_valid,x_real[0][1], x_imag[0][1], x_real[0][9], x_imag[0][9], w_real[1], w_imag[1], x_real[1][1], x_imag[1][1], x_real[1][9], x_imag[1][9]);
FFTcalculation u3 (clk,rst,fir_valid,x_real[0][2], x_imag[0][2], x_real[0][10], x_imag[0][10], w_real[2], w_imag[2], x_real[1][2], x_imag[1][2], x_real[1][10], x_imag[1][10]);
FFTcalculation u4 (clk,rst,fir_valid,x_real[0][3], x_imag[0][3], x_real[0][11], x_imag[0][11], w_real[3], w_imag[3], x_real[1][3], x_imag[1][3], x_real[1][11], x_imag[1][11]);
FFTcalculation u5 (clk,rst,fir_valid,x_real[0][4], x_imag[0][4], x_real[0][12], x_imag[0][12], w_real[4], w_imag[4], x_real[1][4], x_imag[1][4], x_real[1][12], x_imag[1][12]);
FFTcalculation u6 (clk,rst,fir_valid,x_real[0][5], x_imag[0][5], x_real[0][13], x_imag[0][13], w_real[5], w_imag[5], x_real[1][5], x_imag[1][5], x_real[1][13], x_imag[1][13]);
FFTcalculation u7 (clk,rst,fir_valid,x_real[0][6], x_imag[0][6], x_real[0][14], x_imag[0][14], w_real[6], w_imag[6], x_real[1][6], x_imag[1][6], x_real[1][14], x_imag[1][14]);
FFTcalculation u8 (clk,rst,fir_valid,x_real[0][7], x_imag[0][7], x_real[0][15], x_imag[0][15], w_real[7], w_imag[7], x_real[1][7], x_imag[1][7], x_real[1][15], x_imag[1][15]);


// 第二級
FFTcalculation u9 (clk,rst,fir_valid,x_real[1][0], x_imag[1][0], x_real[1][4], x_imag[1][4], w_real[0], w_imag[0], x_real[2][0], x_imag[2][0], x_real[2][4], x_imag[2][4]);
FFTcalculation u10(clk,rst,fir_valid,x_real[1][1], x_imag[1][1], x_real[1][5], x_imag[1][5], w_real[2], w_imag[2], x_real[2][1], x_imag[2][1], x_real[2][5], x_imag[2][5]);
FFTcalculation u11(clk,rst,fir_valid,x_real[1][2], x_imag[1][2], x_real[1][6], x_imag[1][6], w_real[4], w_imag[4], x_real[2][2], x_imag[2][2], x_real[2][6], x_imag[2][6]);
FFTcalculation u12(clk,rst,fir_valid,x_real[1][3], x_imag[1][3], x_real[1][7], x_imag[1][7], w_real[6], w_imag[6], x_real[2][3], x_imag[2][3], x_real[2][7], x_imag[2][7]);
FFTcalculation u13(clk,rst,fir_valid,x_real[1][8], x_imag[1][8], x_real[1][12], x_imag[1][12], w_real[0], w_imag[0], x_real[2][8], x_imag[2][8], x_real[2][12], x_imag[2][12]);
FFTcalculation u14(clk,rst,fir_valid,x_real[1][9], x_imag[1][9], x_real[1][13], x_imag[1][13], w_real[2], w_imag[2], x_real[2][9], x_imag[2][9], x_real[2][13], x_imag[2][13]);
FFTcalculation u15(clk,rst,fir_valid,x_real[1][10], x_imag[1][10], x_real[1][14], x_imag[1][14], w_real[4], w_imag[4], x_real[2][10], x_imag[2][10], x_real[2][14], x_imag[2][14]);
FFTcalculation u16(clk,rst,fir_valid,x_real[1][11], x_imag[1][11], x_real[1][15], x_imag[1][15], w_real[6], w_imag[6], x_real[2][11], x_imag[2][11], x_real[2][15], x_imag[2][15]);
				   
				   
// 第三級          
FFTcalculation u17(clk,rst,fir_valid,x_real[2][0], x_imag[2][0], x_real[2][2], x_imag[2][2], w_real[0], w_imag[0], x_real[3][0], x_imag[3][0], x_real[3][2], x_imag[3][2]);
FFTcalculation u18(clk,rst,fir_valid,x_real[2][1], x_imag[2][1], x_real[2][3], x_imag[2][3], w_real[4], w_imag[4], x_real[3][1], x_imag[3][1], x_real[3][3], x_imag[3][3]);
FFTcalculation u19(clk,rst,fir_valid,x_real[2][4], x_imag[2][4], x_real[2][6], x_imag[2][6], w_real[0], w_imag[0], x_real[3][4], x_imag[3][4], x_real[3][6], x_imag[3][6]);
FFTcalculation u20(clk,rst,fir_valid,x_real[2][5], x_imag[2][5], x_real[2][7], x_imag[2][7], w_real[4], w_imag[4], x_real[3][5], x_imag[3][5], x_real[3][7], x_imag[3][7]);
FFTcalculation u21(clk,rst,fir_valid,x_real[2][8], x_imag[2][8], x_real[2][10], x_imag[2][10], w_real[0], w_imag[0], x_real[3][8], x_imag[3][8], x_real[3][10], x_imag[3][10]);
FFTcalculation u22(clk,rst,fir_valid,x_real[2][9], x_imag[2][9], x_real[2][11], x_imag[2][11], w_real[4], w_imag[4], x_real[3][9], x_imag[3][9], x_real[3][11], x_imag[3][11]);
FFTcalculation u23(clk,rst,fir_valid,x_real[2][12], x_imag[2][12], x_real[2][14], x_imag[2][14], w_real[0], w_imag[0], x_real[3][12], x_imag[3][12], x_real[3][14], x_imag[3][14]);
FFTcalculation u24(clk,rst,fir_valid,x_real[2][13], x_imag[2][13], x_real[2][15], x_imag[2][15], w_real[4], w_imag[4], x_real[3][13], x_imag[3][13], x_real[3][15], x_imag[3][15]);
				   
				   
// 第四級          
FFTcalculation u25(clk,rst,fir_valid,x_real[3][0], x_imag[3][0], x_real[3][1], x_imag[3][1], w_real[0], w_imag[0], x_real[4][0], x_imag[4][0], x_real[4][1], x_imag[4][1]);
FFTcalculation u26(clk,rst,fir_valid,x_real[3][2], x_imag[3][2], x_real[3][3], x_imag[3][3], w_real[0], w_imag[0], x_real[4][2], x_imag[4][2], x_real[4][3], x_imag[4][3]);
FFTcalculation u27(clk,rst,fir_valid,x_real[3][4], x_imag[3][4], x_real[3][5], x_imag[3][5], w_real[0], w_imag[0], x_real[4][4], x_imag[4][4], x_real[4][5], x_imag[4][5]);
FFTcalculation u28(clk,rst,fir_valid,x_real[3][6], x_imag[3][6], x_real[3][7], x_imag[3][7], w_real[0], w_imag[0], x_real[4][6], x_imag[4][6], x_real[4][7], x_imag[4][7]);
FFTcalculation u29(clk,rst,fir_valid,x_real[3][8], x_imag[3][8], x_real[3][9], x_imag[3][9], w_real[0], w_imag[0], x_real[4][8], x_imag[4][8], x_real[4][9], x_imag[4][9]);
FFTcalculation u30(clk,rst,fir_valid,x_real[3][10], x_imag[3][10], x_real[3][11], x_imag[3][11], w_real[0], w_imag[0], x_real[4][10], x_imag[4][10], x_real[4][11], x_imag[4][11]);
FFTcalculation u31(clk,rst,fir_valid,x_real[3][12], x_imag[3][12], x_real[3][13], x_imag[3][13], w_real[0], w_imag[0], x_real[4][12], x_imag[4][12], x_real[4][13], x_imag[4][13]);
FFTcalculation u32(clk,rst,fir_valid,x_real[3][14], x_imag[3][14], x_real[3][15], x_imag[3][15], w_real[0], w_imag[0], x_real[4][14], x_imag[4][14], x_real[4][15], x_imag[4][15]);

reg temp[0:11];
integer ww;

always@(posedge clk or posedge rst)
begin

   if(rst) begin
   
	   fft_valid <= 1'd0;
	   for( ww = 0 ; ww < 12 ; ww = ww + 1 ) 
				 temp[ww] <= 1'd0;

	   fft_d0 <= 32'd0;fft_d1 <= 32'd0;fft_d2 <= 32'd0;fft_d3 <= 32'd0;
	   fft_d4 <= 32'd0;fft_d5 <= 32'd0;fft_d6 <= 32'd0;fft_d7 <= 32'd0;
	   fft_d8 <= 32'd0;fft_d9 <= 32'd0;fft_d10 <= 32'd0;fft_d11 <= 32'd0;
	   fft_d12 <= 32'd0;fft_d13 <= 32'd0;fft_d14 <= 32'd0;fft_d15 <= 32'd0;
	     
   
   end
   else begin
   
       if(fir_valid == 1) begin
	        
	        /* if(s2p_valid == 1) begin
			    
				
			   //fft_valid <= 1;
				
			end
			else begin
			    
			end */
			temp[0] <= (s2p_valid) ? 1'b1 : 1'b0;
			for( ww = 0 ; ww < 11 ; ww = ww + 1 ) begin
				    temp[ww + 1] <= temp[ww];
				end 
			fft_valid <= temp[11];
	        
	        fft_d0  <= {x_real[4][0][31:16], x_imag[4][0][31:16]};
			fft_d8  <= {x_real[4][1][31:16], x_imag[4][1][31:16]};
			fft_d4  <= {x_real[4][2][31:16], x_imag[4][2][31:16]};
			fft_d12 <= {x_real[4][3][31:16], x_imag[4][3][31:16]};
			fft_d2  <= {x_real[4][4][31:16], x_imag[4][4][31:16]};
			fft_d10 <= {x_real[4][5][31:16], x_imag[4][5][31:16]};
			fft_d6  <= {x_real[4][6][31:16], x_imag[4][6][31:16]};
			fft_d14 <= {x_real[4][7][31:16], x_imag[4][7][31:16]};
			fft_d1  <= {x_real[4][8][31:16], x_imag[4][8][31:16]};
			fft_d9  <= {x_real[4][9][31:16], x_imag[4][9][31:16]};
			fft_d5  <= {x_real[4][10][31:16], x_imag[4][10][31:16]};
			fft_d13 <= {x_real[4][11][31:16], x_imag[4][11][31:16]};
			fft_d3  <= {x_real[4][12][31:16], x_imag[4][12][31:16]};
			fft_d11 <= {x_real[4][13][31:16], x_imag[4][13][31:16]};
			fft_d7  <= {x_real[4][14][31:16], x_imag[4][14][31:16]};
			fft_d15 <= {x_real[4][15][31:16], x_imag[4][15][31:16]};
			
			
				   
	   end
	   else begin
	    
               fft_d0 <= fft_d0;fft_d1 <= fft_d1;fft_d2 <= fft_d2;fft_d3 <= fft_d3;
			   fft_d4 <= fft_d4;fft_d5 <= fft_d5;fft_d6 <= fft_d6;fft_d7 <= fft_d7;
			   fft_d8 <= fft_d8;fft_d9 <= fft_d9;fft_d10 <= fft_d10;fft_d11 <= fft_d11;
			   fft_d12 <= fft_d12;fft_d13 <= fft_d13;fft_d14 <= fft_d14;fft_d15 <= fft_d15;  	   
	   
	   end
             
   end

end


///////////////////////////////       Analysis      ///////////////////////////////


reg          [31:0]  fft_reg [0:15];
reg          [31:0]  max;
reg          [31:0]  amp;
reg          [4:0]   count_an, max_index;

integer              ii, jj;



always@(posedge clk or posedge rst)
begin

    if(rst) begin
	
	    count_an <= 5'b0 ;
		done <=	1'b0;
	    freq <= 4'b0;
		for(ii = 0; ii < 16; ii = ii + 1)begin
		    
			fft_reg[ii] <= 32'd0;
			
		end 
		
		
	end
	else if(fft_valid == 1 || count_an) begin
	    
	    fft_reg[0] <= fft_d0;
		fft_reg[1] <= fft_d1;
		fft_reg[2] <= fft_d2;
		fft_reg[3] <= fft_d3;
		fft_reg[4] <= fft_d4;
		fft_reg[5] <= fft_d5;
		fft_reg[6] <= fft_d6;
		fft_reg[7] <= fft_d7;
		fft_reg[8] <= fft_d8;
		fft_reg[9] <= fft_d9;
		fft_reg[10] <= fft_d10;
		fft_reg[11] <= fft_d11;
		fft_reg[12] <= fft_d12;
		fft_reg[13] <= fft_d13;
		fft_reg[14] <= fft_d14;
		fft_reg[15] <= fft_d15;
	
		if(count_an == 5'd15) begin
		
	         count_an <= 5'd0;
             done <= 1'b1;	
             max  <= 34'd0;			 
		
		end
		else begin
		
		    done <= 1'b0;
			count_an <= count_an + 5'd1;
			if(count_an == 5'd0) begin
			
				max <= $signed(fft_d0 [31:16]) * $signed(fft_d0 [31:16]) + $signed(fft_d0 [15:0]) * $signed(fft_d0 [15:0]);
				freq <= 4'd0;
			
			end
			else begin
			
				amp = $signed(fft_reg[count_an] [31:16]) * $signed(fft_reg[count_an] [31:16]) + $signed(fft_reg[count_an] [15:0]) * $signed(fft_reg[count_an] [15:0]);
				
				if(amp > max) begin
				
					freq <= count_an ;
					max <= amp;
					
				end
				else begin
				
					freq <= freq;
					max <= max;
					
				end
				
			end
			
		end
		
		
	end
	else begin
	
	   for(jj = 0; jj < 16; jj = jj + 1)begin
		    
			fft_reg[jj] <= fft_reg[jj];
			
	   end
	   
	
	end


end


endmodule


module FFTcalculation (clk,rst,fir_valid,X_real, X_imag, Y_real, Y_imag, W_real, W_imag, fft_a_real, fft_a_imag, fft_b_real, fft_b_imag);

input clk,rst;
input fir_valid;
input signed  [31:0] X_real; //a
input signed  [31:0] X_imag; //b
input signed  [31:0] Y_real; //c
input signed  [31:0] Y_imag; //d
input signed  [31:0] W_real; 
input signed  [31:0] W_imag;

output reg signed [31:0] fft_a_real; 
output reg signed [31:0] fft_a_imag;			
output reg signed [31:0] fft_b_real; 
output reg signed [31:0] fft_b_imag; 

/* wire signed   [31:0] fft_a_real_wire;
wire signed   [31:0] fft_a_imag_wire;
wire signed   [64:0] fft_b_real_wire;
wire signed   [64:0] fft_b_imag_wire; */
reg signed   [31:0] fft_a_real_wire;
reg signed   [31:0] fft_a_imag_wire;

reg signed   [31:0] fft_a_real_temp3;
reg signed   [31:0] fft_a_imag_temp3;

reg signed   [32:0] fft_b_real_temp1;
reg signed   [32:0] fft_b_imag_temp1;

reg signed   [63:0] fft_b_real_temp2;
reg signed   [63:0] fft_b_imag_temp2;

reg signed   [63:0] fft_b_real_temp3;
reg signed   [63:0] fft_b_imag_temp3;

wire signed   [64:0] fft_b_real_wire = fft_b_real_temp2 + fft_b_real_temp3;
wire signed   [64:0] fft_b_imag_wire = fft_b_imag_temp2 - fft_b_imag_temp3;

//reg signed   [64:0] fft_b_real_wire;
//reg signed   [64:0] fft_b_imag_wire;

always@(posedge clk or posedge rst)
begin

    if(rst) begin
       fft_a_real_wire <= 'd0; 
	   fft_a_imag_wire <= 'd0;
						  
					  
		fft_a_real <= 'd0;
		fft_a_imag <= 'd0;
		fft_b_real <= 'd0;
		fft_b_imag <= 'd0;
  

	   
	   fft_a_real_temp3 <= 'd0;
	   fft_a_imag_temp3 <= 'd0;
						   
	   fft_b_real_temp1 <= 'd0;
	   fft_b_imag_temp1 <= 'd0;
						   
	   fft_b_real_temp2 <= 'd0;
	   fft_b_imag_temp2 <= 'd0;
						   
	   fft_b_real_temp3 <= 'd0; 
	   fft_b_imag_temp3 <= 'd0;
	   
			  
		
		
	end
	else if(fir_valid == 1) begin
	   fft_a_real_wire <= X_real + Y_real; // a+c
	   fft_a_imag_wire <= X_imag + Y_imag; // b+d
	   
	   fft_a_real_temp3 <= fft_a_real_wire;
	   fft_a_imag_temp3 <= fft_a_imag_wire;
	   
	   fft_a_real <= fft_a_real_temp3;
	   fft_a_imag <= fft_a_imag_temp3;
	   
	   fft_b_real_temp1 <=  (X_real - Y_real);
	   fft_b_imag_temp1 <=  (Y_imag - X_imag);
	   	   
	   
	   fft_b_real_temp2 <= fft_b_real_temp1 * W_real;
	   fft_b_imag_temp2 <= fft_b_real_temp1 * W_imag;
	   
	   fft_b_real_temp3 <= fft_b_imag_temp1 * W_imag; 
	   fft_b_imag_temp3 <= fft_b_imag_temp1 * W_real;
	   
	   fft_b_real <= fft_b_real_wire[47:16];
	   fft_b_imag <= fft_b_imag_wire[47:16];
	   
// b+d



	   
	end

/* assign   fft_a_real_wire = X_real + Y_real; // a+c
assign   fft_a_imag_wire = X_imag + Y_imag; // b+d
assign   fft_b_real_wire = (X_real - Y_real) * W_real + (Y_imag - X_imag) * W_imag;
assign   fft_b_imag_wire = (X_real - Y_real) * W_imag + (X_imag - Y_imag) * W_real;
   
assign   fft_a_real = fft_a_real_wire; 
assign   fft_a_imag = fft_a_imag_wire;
assign   fft_b_real = fft_b_real_wire[47:16];
assign   fft_b_imag = fft_b_imag_wire[47:16];
 */
 end
endmodule 