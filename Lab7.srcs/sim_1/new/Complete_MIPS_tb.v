`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2024 04:20:05 PM
// Design Name: 
// Module Name: Complete_MIPS_tb
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


// You can use this skeleton testbench code, the textbook testbench code, or your own
// Most code here is adapted from Charles Roth, Lizy K. John Digital Systems Design Using Verilog Textbook
module Complete_MIPS_tb ();
  reg CLK;
  reg RST;
  wire CS;
  wire WE;
  wire [31:0] Mem_Bus;
  wire [6:0] Address;
  wire [6:0] Address_MUX;
  
    // Adapted from Textbook
    parameter N = 10;
    reg[31:0] expected[N:1];
  
    integer i = 1;
    wire [31:0] CPU_Driver;
    wire [31:0] Memory_Driver;
    wire [31:0] cpu_reg1;
 
    MIPS CPU(CLK, RST, CS, WE, Address, Mem_Bus, CPU_Driver, cpu_reg1);
    Memory MEM(CS, WE, CLK, Address, Mem_Bus, Memory_Driver);
  
    assign Mem_Bus = (CS && !WE)? Memory_Driver : 32'bz;
    assign Mem_Bus = (WE)? CPU_Driver : 32'bz;
  
    

  // End
  
  initial
  begin
     expected[1] = 32'h00000006; // $1 content=6 decimal
     expected[2] = 32'h00000012; // $2 content=18 decimal
     expected[3] = 32'h00000018; // $3 content=24 decimal
     expected[4] = 32'h0000000C; // $4 content=12 decimal
     expected[5] = 32'h00000002; // $5 content=2
     expected[6] = 32'h00000016; // $6 content=22 decimal
     expected[7] = 32'h00000001; // $7 content=1
     expected[8] = 32'h00000120; // $8 content=288 decimal
     expected[9] = 32'h00000003; // $9 content=3
     expected[10] = 32'h00412022; // $10 content=5th instr 
    CLK = 0;

    
  end

  always begin
  
      #10 CLK <= ~CLK;
      if (CPU.state == 2 && CPU.opsave == CPU.jr) begin
            $display("JR instruction detected!");
            $display("alu_in_A = %h", CPU.alu_in_A);
            $display("New PC will be: %h", CPU.alu_in_A[6:0]);
      end
  end


  initial
  begin
    RST <= 1'b1; //reset the processor

    //Notice that the memory is initialize in the in the memory module not here


    @(posedge CLK);

    @(posedge CLK);
    // driving reset low here puts processor in normal operating mode
    RST <= 1'b0;

    /* add your testing code here */
    // you can add in a 'Halt' signal here as well to test Halt operation
    // you will be verifying your program operation using the
    // waveform viewer and/or self-checking operations
    for(i = 1; i <= N; i = i+1) begin
        
         @(posedge WE); // When a store word is executed
         @(negedge CLK);
         $display("Finished iteration %d", i);
         $display("Membus status %d\n", Mem_Bus);
         if(Mem_Bus != expected[i])
            $display("Output mismatch: got %d, expect %d", Mem_Bus,expected[i]);
    end
         
    $display("TEST COMPLETE");
    $stop;
  end

endmodule