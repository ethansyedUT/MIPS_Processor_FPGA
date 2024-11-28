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

module Complete_MIPS(clk, RST, sw, btnL, btnR, seg, an);
  // This is your top module for synthesis.
  // You define what signals the top module needs.
    input clk;
    input RST;
    input [3:0]sw;
    input btnL, btnR;
  
    output[6:0] seg;
    output[3:0] an;
    
    wire CS, WE;
    wire [6:0] ADDR;
    wire [31:0] Mem_Bus;
    wire fpgaClk, btnClk;
  
    wire [31:0] CPU_Driver, Memory_Driver;
    wire [31:0] reg1_watch, reg2_watch;
  
    wire [15:0] num;
    wire Hi;
    
    assign num = (Hi)? reg2_watch[31:16] : reg2_watch[15:0];
    assign Mem_Bus = (CS && !WE)? Memory_Driver : 32'bz;
    assign Mem_Bus = (WE)? CPU_Driver : 32'bz;
    
    clkdiv #(.RELOAD_TIME(50_000_000)) FPGAClk(clk, fpgaClk);  // 1 Hz clock for FPGA
    clkdiv #(.RELOAD_TIME(1_500_000)) btnNoiseClk(clk, btnClk); // 33.33 Hz clk for btn debounce
    
    inputHandler in(btnClk, btnL, btnR, Hi);
    
    MIPS CPU(fpgaClk, sw, CS, WE, ADDR, Mem_Bus, CPU_Driver, reg1_watch, reg2_watch);
    Memory MEM(CS, WE, fpgaClk, ADDR, Mem_Bus, Memory_Driver);
    Display_Controller ds(clk, num, seg, an);
  

endmodule