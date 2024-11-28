`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2024 04:18:09 PM
// Design Name: 
// Module Name: Memory
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

module Memory(CS, WE, CLK, ADDR, data_in, data_out);
  input CS;
  input WE;
  input CLK;
  input [6:0] ADDR;
//  inout [31:0] Mem_Bus;
  input [31:0] data_in;
  output [31:0] data_out;

  reg [31:0] data_out_reg;
  reg [31:0] RAM [0:127];

  integer i;
  initial
  begin
     for (i=0; i<128; i=i+1)
         begin
            RAM[i] = 32'd0; //initialize all locations to 0
         end
         $readmemh("MC_Lab7_TestProgram.txt", RAM);
         for(i=0; i<35; i=i+1) begin  // Print first 20 instructions or however many you need
            $display("RAM[%0d] = %h", i, RAM[i]);
         end
         //this optional statement can be inserted to read initial values
        //from a file
  end

  assign data_out = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bZ : data_out_reg;

  always @(negedge CLK)
  begin
    if((CS == 1'b1) && (WE == 1'b1))
      RAM[ADDR] <= data_in;
    data_out_reg <= RAM[ADDR];
  end
  
endmodule