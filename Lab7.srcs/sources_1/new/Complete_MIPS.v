`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2024 04:19:03 PM
// Design Name: 
// Module Name: Complete_MIPS
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

module Complete_MIPS(clk, sw,led);
  // This is your top module for synthesis.
  // You define what signals the top module needs.
  input clk;
  input [1:0] sw;
  output [7:0] led;
  

  wire CS, WE;
  wire [6:0] ADDR;
  wire [31:0] CPU_reg1;
  wire fpgaClk;
  
  wire [31:0] CPU_Driver, Memory_Driver;
  wire [31:0] Mem_Bus;
  
//  assign led[7:0] = {
//    fpgaClk,          // led[7] - clock
//    CS,               // led[6] - chip select
//    WE,               // led[5] - write enable
//    CPU_reg1[4:0]     // led[4:0] - register bits
//  };
  assign led[7:0] = CPU_reg1[7:0];
  assign Mem_Bus = (CS && !WE) ? Memory_Driver :
                   (WE) ? CPU_Driver : 32'bz;
  

  clkdiv FPGAClk(clk, fpgaClk);  // 2 Hz
  
  MIPS CPU(fpgaClk, sw, CS, WE, ADDR, Mem_Bus, CPU_Driver, CPU_reg1);
  Memory MEM(CS, WE, fpgaClk, ADDR, Mem_Bus, Memory_Driver);
  
  

endmodule