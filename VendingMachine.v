`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2025 16:49:44
// Design Name: 
// Module Name: VendingMachine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VendingMachine(
   input clk ,reset,cancel,
   input [1:0] coin,//01-5rs , 10-10rs
   input [3:0] sel,
   output reg Pr1 , Pr2, Pr3,Pr4,Pr5, Pr6 , Pr7 , Pr8, Pr9 , Pr10 , change
  );
 parameter S0= 4'b0000,S5=4'b0001,S10=4'b0010,S15=4'b0011,S20=4'b0100,S25=4'b0101,
 S30=4'b0110,S35=4'b0111,S40=4'b1000,S45=4'b1001,S50=4'b1010;
 
 reg [3:0] current_state,next_state;
 
 always@(posedge clk or posedge reset) begin
 if(reset) 
 current_state<=S0;
 else current_state<= next_state ;
 end
 
 always @(*) begin
    case(current_state)
        S0: begin
            if(coin==2'b01) next_state=S5;
            else if(coin==2'b10) next_state=S10;
            else next_state = S0;
        end

        S5: begin 
            if (sel==4'b0000) next_state = S0; // Buy 5rs -> Reset to 0
            else if(coin==2'b01) next_state=S10;
            else if(coin==2'b10) next_state=S15;
            else if (cancel) next_state = S0;
            else next_state = S5;
        end

        S10: begin 
            // Buy 5rs or 10rs -> Reset to 0
            if (sel==4'b0000 || sel==4'b0001) next_state = S0; 
            else if(coin==2'b01) next_state=S15;
            else if(coin==2'b10) next_state=S20;
            else if (cancel) next_state = S0;
            else next_state = S10;
        end

        S15: begin 
            if (sel <= 4'b0010) next_state = S0; // Buy Pr1, Pr2, or Pr3 -> Reset
            else if(coin==2'b01) next_state=S20;
            else if(coin==2'b10) next_state=S25;
            else if (cancel) next_state = S0;
            else next_state = S15;
        end 

        S20: begin 
            if (sel <= 4'b0011) next_state = S0;
            else if(coin==2'b01) next_state=S25;
            else if(coin==2'b10) next_state=S30;
            else if (cancel) next_state = S0;
            else next_state = S20;
        end 

        S25: begin 
            if (sel <= 4'b0100) next_state = S0;
            else if(coin==2'b01) next_state=S30;
            else if(coin==2'b10) next_state=S35;
            else if (cancel) next_state = S0;
            else next_state = S25;
        end

        S30: begin 
            if (sel <= 4'b0101) next_state = S0;
            else if(coin==2'b01) next_state=S35;
            else if(coin==2'b10) next_state=S40;
            else if (cancel) next_state = S0;
            else next_state = S30;
        end  

        S35: begin 
            if (sel <= 4'b0110) next_state = S0;
            else if(coin==2'b01) next_state=S40;
            else if(coin==2'b10) next_state=S45;
            else if (cancel) next_state = S0;
            else next_state = S35;
        end 

        S40: begin 
            if (sel <= 4'b0111) next_state = S0;
            else if(coin==2'b01) next_state=S45;
            else if(coin==2'b10) next_state=S50;
            else if (cancel) next_state = S0;
            else next_state = S40;
        end 

        S45: begin 
            if (sel <= 4'b1000) next_state = S0;
            else if(coin==2'b01) next_state=S50;
            else if (cancel) next_state = S0;
            else next_state = S45;
        end

        S50: begin 
            if (sel <= 4'b1001) next_state = S0;
            else if (cancel) next_state = S0;
            else next_state = S50;
        end 

        default next_state=S0;
    endcase
end
 
 
always@(posedge clk or posedge reset) begin
if (reset)begin
Pr1 <= 0;
Pr2 <= 0;
Pr3 <= 0;
Pr4 <= 0;
Pr5 <= 0;
Pr6 <= 0;
Pr7 <= 0;
Pr8 <= 0;
Pr9 <= 0;
Pr10 <= 0;
change <= 0;
end 

else begin
Pr1 <= 0;
Pr2 <= 0;
Pr3 <= 0;
Pr4 <= 0;
Pr5 <= 0;
Pr6 <= 0;
Pr7 <= 0;
Pr8 <= 0;
Pr9 <= 0;
Pr10 <= 0;
change <= 0;

case(current_state) 
S5 : begin
if (sel==4'b0000) begin
Pr1<=1;
change <= 0;
end
end

S10 : begin
if (sel==4'b0000) begin
Pr1<=1;
change <= 1;
end
else if (sel==4'b0001) begin
Pr2<=1;
change <= 0;
end
end

S15 : begin
if (sel==4'b0000) begin
Pr1<=1;
change <= 1; //10rs
end
else if (sel==4'b0001) begin
Pr2<=1;
change <= 1; //5rs
end
else if (sel==4'b0010) begin
Pr3<=1;
change <= 0; 
end
end

S20 : begin
            if (sel==4'b0000) begin // 5rs
                Pr1<=1;
                change <= 1; 
            end
            else if (sel==4'b0001) begin // 10rs
                Pr2<=1;
                change <= 1; 
            end
            else if (sel==4'b0010) begin // 15rs
                Pr3<=1;
                change <= 1; 
            end
            else if(sel==4'b0011)begin // 20rs (Exact)
                Pr4<=1; // Corrected from Pr<=4
                change <= 0;
            end
        end

        S25 : begin
            if (sel==4'b0000) begin Pr1<=1; change <= 1; end      // 5rs
            else if (sel==4'b0001) begin Pr2<=1; change <= 1; end // 10rs
            else if (sel==4'b0010) begin Pr3<=1; change <= 1; end // 15rs
            else if (sel==4'b0011) begin Pr4<=1; change <= 1; end // 20rs
            else if (sel==4'b0100) begin Pr5<=1; change <= 0; end // 25rs (Exact)
        end

        S30 : begin
            if (sel==4'b0000) begin Pr1<=1; change <= 1; end      // 5rs
            else if (sel==4'b0001) begin Pr2<=1; change <= 1; end // 10rs
            else if (sel==4'b0010) begin Pr3<=1; change <= 1; end // 15rs
            else if (sel==4'b0011) begin Pr4<=1; change <= 1; end // 20rs
            else if (sel==4'b0100) begin Pr5<=1; change <= 1; end // 25rs
            else if (sel==4'b0101) begin Pr6<=1; change <= 0; end // 30rs (Exact)
        end

        S35 : begin
            if (sel==4'b0000) begin Pr1<=1; change <= 1; end      // 5rs
            else if (sel==4'b0001) begin Pr2<=1; change <= 1; end // 10rs
            else if (sel==4'b0010) begin Pr3<=1; change <= 1; end // 15rs
            else if (sel==4'b0011) begin Pr4<=1; change <= 1; end // 20rs
            else if (sel==4'b0100) begin Pr5<=1; change <= 1; end // 25rs
            else if (sel==4'b0101) begin Pr6<=1; change <= 1; end // 30rs
            else if (sel==4'b0110) begin Pr7<=1; change <= 0; end // 35rs (Exact)
        end

        S40 : begin
            if (sel==4'b0000) begin Pr1<=1; change <= 1; end      // 5rs
            else if (sel==4'b0001) begin Pr2<=1; change <= 1; end // 10rs
            else if (sel==4'b0010) begin Pr3<=1; change <= 1; end // 15rs
            else if (sel==4'b0011) begin Pr4<=1; change <= 1; end // 20rs
            else if (sel==4'b0100) begin Pr5<=1; change <= 1; end // 25rs
            else if (sel==4'b0101) begin Pr6<=1; change <= 1; end // 30rs
            else if (sel==4'b0110) begin Pr7<=1; change <= 1; end // 35rs
            else if (sel==4'b0111) begin Pr8<=1; change <= 0; end // 40rs (Exact)
        end

        S45 : begin
            if (sel==4'b0000) begin Pr1<=1; change <= 1; end      // 5rs
            else if (sel==4'b0001) begin Pr2<=1; change <= 1; end // 10rs
            else if (sel==4'b0010) begin Pr3<=1; change <= 1; end // 15rs
            else if (sel==4'b0011) begin Pr4<=1; change <= 1; end // 20rs
            else if (sel==4'b0100) begin Pr5<=1; change <= 1; end // 25rs
            else if (sel==4'b0101) begin Pr6<=1; change <= 1; end // 30rs
            else if (sel==4'b0110) begin Pr7<=1; change <= 1; end // 35rs
            else if (sel==4'b0111) begin Pr8<=1; change <= 1; end // 40rs
            else if (sel==4'b1000) begin Pr9<=1; change <= 0; end // 45rs (Exact)
        end

        S50 : begin
            if (sel==4'b0000) begin Pr1<=1; change <= 1; end      // 5rs
            else if (sel==4'b0001) begin Pr2<=1; change <= 1; end // 10rs
            else if (sel==4'b0010) begin Pr3<=1; change <= 1; end // 15rs
            else if (sel==4'b0011) begin Pr4<=1; change <= 1; end // 20rs
            else if (sel==4'b0100) begin Pr5<=1; change <= 1; end // 25rs
            else if (sel==4'b0101) begin Pr6<=1; change <= 1; end // 30rs
            else if (sel==4'b0110) begin Pr7<=1; change <= 1; end // 35rs
            else if (sel==4'b0111) begin Pr8<=1; change <= 1; end // 40rs
            else if (sel==4'b1000) begin Pr9<=1; change <= 1; end // 45rs
            else if (sel==4'b1001) begin Pr10<=1; change <= 0; end // 50rs (Exact)
        end

        endcase
        if(cancel) begin
        if(current_state != S0) 
            change <= 1;
        else 
            change <= 0;
    end
    end
end
endmodule
