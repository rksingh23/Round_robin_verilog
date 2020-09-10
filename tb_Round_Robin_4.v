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

module tb_Round_Robin_4();
reg [3:0] req_vector;
reg CLK, RST, enable;
wire [3:0] grant_vector;

//Instanciating the dut
Round_Robin_4 dut(.grant_vector(grant_vector),.req_vector(req_vector),.enable(enable),.CLK(CLK),.RST(RST));

always #1 CLK<=~CLK;

initial begin
enable=0;
CLK=0;
RST=1;
#8;

RST=0;
enable=1;
#5
req_vector=4'b1111;
#7;
req_vector=4'b1010;
#7;
req_vector=4'b0000;
#10;
req_vector=4'b1001;
#184;


req_vector=4'b1111;
#7;
req_vector=4'b1010;
#9;
req_vector=4'b0000;
#9;
req_vector=4'b1011;
#187;

req_vector=4'b1111;
#7;
req_vector=4'b0010;
#7;
req_vector=4'b0000;
#10;
req_vector=4'b1010;
#189;

req_vector=4'b1111;
#7;
req_vector=4'b0010;
#9;
req_vector=4'b0000;
#10;
req_vector=4'b1010;
#7;

end
endmodule