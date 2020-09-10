//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// File: Round_Robin.v
// Purpose: Explain the bus arbitrator functionality of a Router Design, providing prioritzed signle grant amongst the multiple requestors.
// Concept: 1. Round Robin Rotator takes in four requests at a time and generates one grant with priority every clock cycle.
//          2. After a grant, the LRU will hold that grant decision for 1 more clock cycle.
//          3. The priorities are initialized with a positive edge triggered synchronous reset (*Active High Rst), based on a mealy operation.
//          4. If “enable” (* active high) is not active then neither grant is generated, nor priorities updated.
//          5. Grant priorities order according to Requestor's ID --> In the 0 - 100 CLKs : 0>1>2>3, In the 101-200 CLKs : 1>2>3>0, In the 201-300 CLKs : 2>3>0>1 and so on.....
// 
// Owner: Rohit Kumar Singh
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


`timescale 1ns/1ns

module Round_Robin_4(grant_vector, req_vector, enable, CLK, RST);
output reg [3:0] grant_vector;
input [3:0] req_vector;
input CLK, RST, enable;
integer temp;
reg [1:0] state;
reg [3:0]LRU;

localparam 
GRNT0 = 4'b0001, // If Requestor 0 was given the grant in the previous clock
GRNT1 = 4'b0010,
GRNT2 = 4'b0100, 
GRNT3 = 4'b1000;


always@(posedge CLK) 
begin
if (RST)
begin
	grant_vector<=GRNT0;
	temp=0;
	LRU<=4'b0000;
end

else if (enable)
begin
LRU<=grant_vector;

case(state)

2'b00:
// if we use blocking statment --> then even if 2 requestors are asking for a request, then one amongst the two will be processed. We don't want that, we want all the requestor's to be processed.
begin  
if (req_vector[0]==1)                        
grant_vector<= GRNT0; //Assume GRNT0 is same as REQT0, i.e 4'b0000
else if (req_vector[1]==1)
grant_vector<= GRNT1;
else if (req_vector[2]==1)
grant_vector<= GRNT2;
else if (req_vector[3]==1)
grant_vector<= GRNT3; 
end

2'b01:
begin  
if (req_vector[1]==1)                        
grant_vector<= GRNT1; 
else if (req_vector[2]==1)
grant_vector<= GRNT2;
else if (req_vector[3]==1)
grant_vector<= GRNT3;
else if (req_vector[0]==1)
grant_vector<= GRNT0; 
end

2'b10: 
begin  
if (req_vector[2]==1)                        
grant_vector<= GRNT2; //Assume GRNT0 is same as REQT0, i.e 4'b0000
else if (req_vector[3]==1)
grant_vector<= GRNT3;
else if (req_vector[0]==1)
grant_vector<= GRNT0;
else if (req_vector[1]==1)
grant_vector<= GRNT1; 
end

2'b11:
begin
if (req_vector[3]==1)                        
grant_vector<= GRNT3; //Assume GRNT0 is same as REQT0, i.e 4'b0000
else if (req_vector[0]==1)
grant_vector<= GRNT0;
else if (req_vector[1]==1)
grant_vector<= GRNT1;
else if (req_vector[2]==1)
grant_vector<= GRNT2; 
end

endcase
end
end  //end of always block

always @ (posedge CLK) begin
		if ((temp>=0)&&(temp<=99))
		begin 
		state<=2'b00;
		temp<=temp+1;
		end
		else if ((temp>99)&&(temp<=199))
		begin
		state<=2'b01;
		temp<=temp+1;
		end
		else if ((temp>199)&&(temp<=299)) 
        begin 
		state<=2'b10;
		temp<=temp+1;
		end
		else if ((temp>299)&&(temp<=399)) 
        begin 
		state<=2'b11;
		temp<=temp+1;
		end
		else 
		begin
		state<=2'b00;
	    temp<=0;
		end
end
   
endmodule

