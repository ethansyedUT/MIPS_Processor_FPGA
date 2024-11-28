`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2024 04:16:53 PM
// Design Name: 
// Module Name: REG
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


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module REG(CLK, RegW, DR, SR1, SR2, Reg_In, ReadReg1, ReadReg2, reg1, reg2, sw);
  input CLK;
  input RegW;
  input [4:0] DR;
  input [4:0] SR1;
  input [4:0] SR2;
  input [31:0] Reg_In;
  input [2:0] sw;
  
  output reg [31:0] ReadReg1;
  output reg [31:0] ReadReg2;
  output reg [31:0] reg1;
  output reg [31:0] reg2;

  reg [31:0] REG [0:31];
  integer i;

  initial begin
    ReadReg1 = 0;
    ReadReg2 = 0;
  end

  always @(posedge CLK)
  begin
    if(RegW == 1'b1)
      REG[DR] <= Reg_In[31:0];
    else
      REG[1] <= {REG[1][31:3], sw[2:0]};
    ReadReg1 <= REG[SR1];
    ReadReg2 <= REG[SR2];
    reg1 <= REG[1];
    reg2 <= REG[2];
  end
endmodule