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
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_addi.txt", RAM);   // rev test
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_add8.txt", RAM);   // add8 test
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_lui.txt", RAM);   // lui test
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_rbit.txt", RAM);   // rbit test
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_rev.txt", RAM);   // rev test
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_sadd.txt", RAM);   // sadd test
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_ssub.txt", RAM);   // ssub test
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_jal.txt", RAM);   // jal test $31 = 14
//         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_Lab7_TestProgram.txt", RAM);   // jal test $31 = 14
         $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/TestPrograms/MC_real_Lab7_TP.txt", RAM);   // jal test $31 = 14
         //  $readmemh("C:/Users/Ethan/Desktop/Classes/ECE460M-DigitalSysDesign/Labs/Lab7/Lab7.srcs/sources_1/new/MC_Reg2_Test.txt", RAM); // Infinitely incr reg2
         for(i=0; i<35; i=i+1) begin  // Print first 20 instructions or however many you need
            $display("RAM[%0d] = %h", i, RAM[i]);
         end
                 // Initialize specific memory locations with program
//        RAM[0] = 32'h20260000;  // addi $6, $1, 0
//        RAM[1] = 32'h31080000;  // andi $8, $8, 0
//        RAM[2] = 32'h3C047000;  // lui $4, 28672
//        RAM[3] = 32'h3C057FFF;  // lui $5, 32767
//        RAM[4] = 32'h3508000B;  // ori $8, $8, 11
//        RAM[5] = 32'h1026FFFB;  // beq $6, $1, loop
//        RAM[6] = 32'h20260000;  // addi $6, $1, 0
//        RAM[7] = 32'h00010840;  // sll $7, $1, 1
//        RAM[8] = 32'h01073820;  // add $7, $8, $7
//        RAM[9] = 32'h00E00008;  // jr $7
//        RAM[10] = 32'h08000005; // j loop
//        RAM[11] = 32'h0C000000; // jal operation0
//        RAM[12] = 32'h08000005; // j loop
//        RAM[13] = 32'h0C000000; // jal operation1
//        RAM[14] = 32'h08000005; // j loop
//        RAM[15] = 32'h0C000000; // jal operation2
//        RAM[16] = 32'h08000005; // j loop
//        RAM[17] = 32'h0C000000; // jal operation3
//        RAM[18] = 32'h08000005; // j loop
//        RAM[19] = 32'h0C000000; // jal operation4
//        RAM[20] = 32'h08000005; // j loop
//        RAM[21] = 32'h0C000000; // jal operation5
//        RAM[22] = 32'h08000005; // j loop
//        RAM[23] = 32'h00852815; // add8 $2, $4, $5
//        RAM[24] = 32'h03E00008; // jr $31
//        RAM[25] = 32'h3C021000; // lui $2, 4096
//        RAM[26] = 32'h03E00008; // jr $31
//        RAM[27] = 32'h00051013; // rbit $2, $5
//        RAM[28] = 32'h03E00008; // jr $31
//        RAM[29] = 32'h00041010; // rev $2, $4
//        RAM[30] = 32'h03E00008; // jr $31
//        RAM[31] = 32'h00A51019; // sadd $2, $5, $5
//        RAM[32] = 32'h03E00008; // jr $31
//        RAM[33] = 32'h0085101A; // ssub $2, $4, $5
//        RAM[34] = 32'h03E00008; // jr $31
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