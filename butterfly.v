

module butterfly (
     input signed [31:0]         xp_real, // Xm(p)   //a
     input signed [31:0]         xp_imag,                   	//b
     input signed [31:0]         xq_real, // Xm(q)	//c
     input signed [31:0]         xq_imag,			//d
     input signed [31:0]         wnr_real, // Wnr
     input signed [31:0]         wnr_imag,
	 
     output signed [31:0]        yp_real, //Xm+1(p) //fft_a_real
     output signed [31:0]        yp_imag,			//fft_a_im
     output signed [31:0]        yq_real, //Xm+1(q)	//fft_a_real
     output signed [31:0]        yq_imag
);			//fft_a_im


   wire signed [31 : 0 ]  yp_real_wire =  xp_real + xq_real ; //a+c
   wire signed [31 : 0 ]   yp_imag_wire =  xp_imag + xq_imag ; //b+d
   wire signed [64 : 0 ]   yq_real_wire =  (xp_real - xq_real)*wnr_real + ( xq_imag  - xp_imag )*wnr_imag ;
   wire signed [64: 0 ]   yq_imag_wire =  (xp_real - xq_real)*wnr_imag + ( xp_imag - xq_imag )*wnr_real;
   
   
    assign  yp_real =  yp_real_wire; //a+c
   assign   yp_imag =  yp_imag_wire ; //b+d
   //assign  yq_real =  (yq_real_wire[15])?yq_real_wire[47:16]+1:yq_real_wire[47:16];
   //assign  yq_imag =  (yq_imag_wire[15])?yq_imag_wire[47:16]+1:yq_imag_wire[47:16];
   assign  yq_real =  yq_real_wire[47:16];
   assign  yq_imag =  yq_imag_wire[47:16];

endmodule 


