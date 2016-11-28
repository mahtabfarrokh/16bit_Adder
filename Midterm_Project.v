module Full_Adder ( A1 , A2 , Cin , sum , carry ) ; 
  input A1 , A2 , Cin ; 
  output sum , carry ; 
  wire w1 , w2 , w3 ;
  xor #(3) x1 ( sum , A1 , A2 , Cin ) ; 
  xor #(2) x2 (w1 , A1, A2) ; 
  and #(2) x3 (w2 , w1 , Cin )  ;
  and #(2) x4 (w3 , A1 , A2 ) ; 
  or  #(2) x5 (carry , w3 , w2 ) ; 
endmodule  

module Adder1_16bit(A,B,Cin,S,Cout); 
  input [15:0]A; 
  input [15:0]B; 
  input Cin; 
  output [15:0]S; 
  output Cout; 
  wire [0:15] w ; 
  Full_Adder f1( A[0] , B[0] , Cin , S[0] , w[0] ) ; 
  Full_Adder f2( A[1] , B[1] , w[0] , S[1] , w[1] ) ; 
  Full_Adder f3( A[2] , B[2] , w[1] , S[2] , w[2] ) ; 
  Full_Adder f4( A[3] , B[3] , w[2] , S[3] , w[3] ) ; 
  Full_Adder f5( A[4] , B[4] , w[3] , S[4] , w[4] ) ;
  Full_Adder f6( A[5] , B[5] , w[4] , S[5] , w[5] ) ;
  Full_Adder f7( A[6] , B[6] , w[5] , S[6] , w[6] ) ;
  Full_Adder f8( A[7] , B[7] , w[6] , S[7] , w[7] ) ;
  Full_Adder f9( A[8] , B[8] , w[7] , S[8] , w[8] ) ;
  Full_Adder f10( A[9] , B[9] , w[8] , S[9] , w[9] ) ;
  Full_Adder f11( A[10] , B[10] , w[9] , S[10] , w[10] ) ;
  Full_Adder f12( A[11] , B[11] , w[10] , S[11] , w[11] ) ;
  Full_Adder f13( A[12] , B[12] , w[11] , S[12] , w[12] ) ;
  Full_Adder f14( A[13] , B[13] , w[12] , S[13] , w[13] ) ;
  Full_Adder f15( A[14] , B[14] , w[13] , S[14] , w[14] ) ;
  Full_Adder f16( A[15] , B[15] , w[14] , S[15] , Cout ) ;
endmodule 

module lookahead ( A , B , Cin , Sum , carry ) ; 
  input [3:0]A ; 
  input [3:0]B; 
  input Cin ; 
  output [3:0]Sum ; 
  output carry ; 
  wire [4:0]C ;
  wire [3:0]P ;
  wire [3:0]G ;
  wire [9:0]w ; 
  and 
    #(2) a1 ( G[0] , A[0] , B[0]) , 
         a2 ( G[1] , A[1] , B[1]) ,
         a3 ( G[2] , A[2] , B[2]) ,
         a4 ( G[3] , A[3] , B[3]) ;
  xor 
    #(2) x1 ( P[0] , A[0] , B[0]) ,
         x2 ( P[1] , A[1] , B[1]) ,
         x3 ( P[2] , A[2] , B[2]) ,
         x4 ( P[3] , A[3] , B[3]) ;
  assign C[0] = Cin ; 
  and #(2) ( w[0] , C[0] , P[0] ) ; 
  or  #(2) ( C[1] , w[0] , G[0] ) ; 
  and #(2) ( w[1] , P[1] , G[0] ) ; 
  and #(3) ( w[2] , P[1] , P[0] , C[0] ) ; 
  or  #(3) ( C[2] , G[1] , w[1] , w[2] ) ; 
  and #(2) ( w[3] , P[2] , G[1] ) ;
  and #(3) ( w[4] , P[2] , P[1] , G[0] ) ; 
  and #(4) ( w[5] , P[2] , P[1] , P[0] , C[0] ) ; 
  or  #(4) ( C[3] , G[2] , w[5] , w[4] , w[3] ) ; 
  and #(2) ( w[6] , G[2] , P[3] ) ; 
  and #(3) ( w[7] , G[1] , P[3] , P[2] ) ; 
  and #(4) ( w[8] , G[0] , P[3] , P[2] , P[1] ) ; 
  and #(5) ( w[9] , C[0] , P[3] , P[2] , P[1] , P[0] ) ; 
  or  #(5) ( C[4] , G[3] , w[9] , w[8] , w[7] , w[6] ) ; 
  assign carry = C[4] ; 
  xor #(2) 
    a5 ( Sum[0] , P[0] , C[0] ) , 
    a6 ( Sum[1] , P[1] , C[1] ) , 
    a7 ( Sum[2] , P[2] , C[2] ) , 
    a8 ( Sum[3] , P[3] , C[3] ) ;  
endmodule 

module Adder2_16bit(A,B,Cin,S,Cout); 
  input [15:0]A ;  
  input [15:0]B ; 
  input Cin ;
  output [15:0]S; 
  output Cout; 
  wire [0:2]C ; 
  lookahead l1( A[3:0] , B[3:0] , Cin , S[3:0] , C[0]) ; 
  lookahead l2( A[7:4] , B[7:4] , C[0] , S[7:4] , C[1]) ;
  lookahead l3( A[11:8] , B[11:8] , C[1] , S[11:8] , C[2]) ;
  lookahead l4( A[15:12] , B[15:12] , C[2] , S[15:12] , Cout) ; 
endmodule

module Adder16_TB ; 
  reg [0:15]A1 ;
  reg [0:15]B1 ;
  reg Cin1 ; 
  wire [15:0] S1; 
  wire Cout1 ; 
  reg [15:0]A2 ;
  reg [15:0]B2 ;
  reg Cin2 ; 
  wire [15:0] S2; 
  wire Cout2 ; 
  Adder1_16bit fig1(A1,B1,Cin1,S1,Cout1) ; 
  Adder2_16bit fig2(A2,B2,Cin2,S2,Cout2) ; 
  initial 
    begin 
      #1 
        A1 = 0 ; B1 = 0 ; A2 =0 ; B2= 0 ; Cin1 = 0 ; Cin2 = 0 ;
      #99 
        $display ("test1 :  S1 :  %b%b   -   S2 : %b%b" , Cout1 ,S1 ,Cout2 , S2 ) ;
      #100 
        A1 = 16'b0010010011010111 ;
        A2 = 16'b0010010011010111 ; 
        B1 = 16'b0000001111111000 ; 
        B2 = 16'b0000001111111000 ; 
      #100
        $display ("test2 :  S1 :  %b%b   -   S2 : %b%b"   , Cout1 , S1 ,Cout2 ,  S2 ) ;  
      #100 
        A1 = 16'b1111110111101000 ; 
        A2 = 16'b1111110111101000 ;
      #200
        $display ("test3 :  S1 :  %b%b   -   S2 : %b%b"  ,Cout1 ,S1 ,Cout2 ,  S2 ) ;
       
       
    end
    
endmodule 



