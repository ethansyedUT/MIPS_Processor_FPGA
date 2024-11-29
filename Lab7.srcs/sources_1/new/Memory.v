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
  input [31:0] data_in;
  output [31:0] data_out;

  reg [31:0] data_out_reg;
  
// (* ram_style = "block" *) 
// (* ram_init_file = "MC_RotateLEDMIPS.txt" *) 
  reg [31:0] RAM [0:127];
//  initial begin
//    $readmemh("MC_RotateLEDMIPS.txt", RAM);
//  end


  integer i;
  initial
  begin
     for (i=0; i<128; i=i+1)
     begin
        RAM[i] = 32'd0; //initialize all locations to 0
     end
     $readmemh("MC_RotateLEDMIPS.txt", RAM);
     for(i=0; i<6; i=i+1) begin  // Print first 20 instructions or however many you need
        $display("RAM[%0d] = %h", i, RAM[i]);
     end
     //this optional statement can be inserted to read initial values
    //from a file
//    RAM[0] = 32'h20010001;  // addi $1, $0, 1
//    RAM[1] = 32'h20020080;  // addi $2, $0, 128
//    RAM[2] = 32'h00010840;  // sll $1, $1, 1
//    RAM[3] = 32'h14220001;  // bne $1, $2, 1
//    RAM[4] = 32'h20010001;  // addi $1, $0, 1
//    RAM[5] = 32'h08000002;  // j 2
  end

  assign data_out = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bZ : data_out_reg;

  always @(negedge CLK)
  begin
    if((CS == 1'b1) && (WE == 1'b1))
      RAM[ADDR] <= data_in;
    data_out_reg <= RAM[ADDR];
  end
  
endmodule