
//=====================================================================================================================//
//  Fall2020__CS4341-502(206)__Final-Project: 32-bit ALU                                                               //
//  Name(Last,First)  : Ziaei, Armin                                                                                   //
//  Date              : Nov/20/2020                                                                                    //
//                                                                                                                     //
//  Software version  : Icarus Verilog version 11.0 (http://iverilog.icarus.com/)(http://bleyer.org/icarus/)           //
//                    : MinGW (http://www.mingw.org/)                                                                  //
//                    : VSCode (https://code.visualstudio.com/)                                                        //
//                    : leafvmaple (VSCode Extension)--verilog compiler                                                //
//=====================================================================================================================//

//==================================================================================
module AND_gate(A, B, Out); //AND gate
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  assign Out = (A & B);
endmodule
//==================================================================================
module OR_gate(A, B, Out); //OR gate
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  assign Out = (A | B);
endmodule
//==================================================================================
module XOR_gate(A, B, Out); //XOR gate
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  assign Out = (A ^ B);
endmodule
//==================================================================================
module NOT_gate(A, Out); //NOT gate
  input [31:0] A;
  output [31:0] Out;
  assign Out = ~A;
endmodule
//==================================================================================
module NAND_gate(A, B, Out); //NAND gate
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  assign Out = ~(A & B);
endmodule
//==================================================================================
module NOR_gate(A, B, Out); //NOR gate
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  assign Out = ~(A | B);
endmodule
//==================================================================================
module XNOR_gate(A, B, Out); //XNOR gate
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  assign Out = ~(A ^ B);
endmodule
//==================================================================================
module ADD_er(A, B, SUM, Cout); //ADDER
  input [31:0] A;
  input [31:0] B;
  output Cout;
  output [31:0] SUM;
  reg [31:0] SUM_local;
  always @(*) begin
    SUM_local = A+B;
  end
  assign SUM = SUM_local[31:0]; //SUM
  assign Cout = SUM_local[32]; //Cout
endmodule
//==================================================================================
module SUB_er(A, B, Out);//subtractor
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  reg [31:0] SUB_local;
  always @(*) begin
    SUB_local = B-A;
  end
  assign Out = SUB_local[31:0];
endmodule
//==================================================================================
module MUL_er(A, B, Out); //multiplier
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  reg [31:0] MUL_local;
  always @(*) begin
    MUL_local = A*B;
  end
  assign Out = MUL_local[31:0];
endmodule
//==================================================================================
module DIV_er(A, B, Out, Remainder);//divider/remainder
  input [31:0] A;
  input [31:0] B;
  output [31:0] Out;
  output [31:0] Remainder;
  reg [31:0] DIV_local;
  reg [31:0] REMAIN_local;
  always @(*) begin
    DIV_local = B/A;
    REMAIN_local = B%A;
  end
  assign Out = DIV_local[31:0];
  assign Remainder = REMAIN_local[31:0];
endmodule
//==================================================================================
module SHL_Logic(A, Out); //1-bit logic shift left
  input [31:0] A;
  output [31:0] Out;
  reg [31:0] SHL_local;
  always @(*) begin
    SHL_local = (A << 1);
  end
  assign Out = SHL_local[31:0];
endmodule
//==================================================================================
module SHR_Logic(A, Out); //1-bit logic shift right
  input [31:0] A;
  output [31:0] Out;
  reg [31:0] SHR_local;
  always @(*) begin
    SHR_local = (A >> 1);
  end
  assign Out = SHR_local[31:0];
endmodule
//==================================================================================
module DFF(clk, inputA, Out); //DFF for ERROR state
  input clk;
  input inputA;
  output Out;
  reg Out;
  always @(posedge clk) begin
    Out = inputA;
  end
endmodule
//==================================================================================
module DFF_register(clk, reset, inputA, Out); //ACC
  input clk;
  input reset;
  input [31:0] inputA;
  output [31:0] Out;
  wire [31:0] zeroes;
  assign zeroes = {32{1'b0}};
  reg [31:0] rst;
  always @(posedge clk)
  begin
    rst = inputA;
    if (reset==1) begin
      rst = 0;
    end
  end
  assign Out = rst;
endmodule
//==================================================================================
module ERROR_Check(clk, rst, add_of, LED);//ERROR-CHECK

  input clk;
  input rst;
  input add_of;
  output LED;
  wire Overflow_ERR;
  assign Overflow_ERR = add_of;
  wire ERROR_wire;
  reg ERROR_value;

  DFF ERROR_CHECKER (clk, Overflow_ERR, ERROR_wire);
  always@(*)
  begin
    ERROR_value = ERROR_wire;
    if (rst == 0)
    begin
      ERROR_value = 0;
    end
  end
  assign LED = ERROR_wire;
endmodule
//==================================================================================
module MUX(channels, select, Out);//16 channels(32bit) - Multiplexer
  input [15:0][31:0] channels;
  input [3:0] select;
  output [31:0] Out;
  assign Out = channels[select];
endmodule
//==================================================================================
module breadboard(clk,reset,A,B,C,opcode, ERR_out);//breadboard
  input clk;
  input reset;
  input [3:0] opcode;
  input [31:0] A;
  input [31:0] B;
  output [31:0] C;
  output ERR_out;
  
  reg [31:0] curA;
  reg [31:0] curB;
  reg [31:0] curC;
  reg curERROR;

  reg [31:0] nextA;
  reg [31:0] nextB;
  reg [31:0] nextC;
  reg nextERROR;

  wire rst_wire;
  wire clk_wire;
  wire [31:0] inputA_wire;
  wire [31:0] inputB_wire;
  wire [31:0] reg_A_cur_wire;
  wire [31:0] reg_B_cur_wire;

  assign rst_wire = reset;
  assign clk_wire = clk;
  assign inputA_wire = A;
  assign inputB_wire = B;

  wire opcode_s0;
  wire opcode_s1;
  wire opcode_s2;
  wire opcode_s3;
  
  assign opcode_s0 = opcode[0];
  assign opcode_s1 = opcode[1];
  assign opcode_s2 = opcode[2];
  assign opcode_s3 = opcode[3];

  wire [3:0] opcode_MUX;
  wire [31:0] zeros_wire;
  wire [31:0] ADD_out_wire;
  wire carry_error_wire;
  wire [31:0] SUB_out_wire;
  wire [31:0] MUL_out_wire;
  wire [31:0] DIV_out_wire;
  wire [31:0] remainder_wire;
  wire [31:0] AND_out_wire;
  wire [31:0] OR_out_wire;
  wire [31:0] XOR_out_wire;
  wire [31:0] NOT_out_wire;
  wire [31:0] NAND_out_wire;
  wire [31:0] NOR_out_wire;
  wire [31:0] XNOR_out_wire;
  wire [31:0] SHL_out_wire;
  wire [31:0] SHR_out_wire;

  assign zeros_wire = {32{1'b0}};
  assign opcode_MUX = opcode;

  wire [15:0][31:0] MUX_channels;
  
  assign MUX_channels[0]  = reg_out_wire;
  assign MUX_channels[1]  = ADD_out_wire;
  assign MUX_channels[2]  = SUB_out_wire;
  assign MUX_channels[3]  = MUL_out_wire;
  assign MUX_channels[4]  = DIV_out_wire;
  assign MUX_channels[5]  = remainder_wire;
  assign MUX_channels[6]  = AND_out_wire;
  assign MUX_channels[7]  = OR_out_wire;
  assign MUX_channels[8]  = XOR_out_wire;
  assign MUX_channels[9]  = NOT_out_wire;
  assign MUX_channels[10] = NAND_out_wire;
  assign MUX_channels[11] = NOR_out_wire;
  assign MUX_channels[12] = XNOR_out_wire;
  assign MUX_channels[13] = SHL_out_wire;
  assign MUX_channels[14] = SHR_out_wire;
  assign MUX_channels[15] = zeros_wire;

  wire [31:0] MUX_out_wire;
  wire [31:0] reg_out_wire;
  wire [31:0] acc_result;
  wire ERROR_result;

  ADD_er        Ch1  (inputA_wire, inputB_wire, ADD_out_wire, carry_error_wire);
  SUB_er        Ch2  (inputA_wire, inputB_wire, SUB_out_wire);
  MUL_er        Ch3  (inputA_wire, inputB_wire, MUL_out_wire);
  DIV_er        Ch4  (inputA_wire, inputB_wire, DIV_out_wire, remainder_wire);
  DIV_er        Ch5  (inputA_wire, inputB_wire, DIV_out_wire, remainder_wire);
  AND_gate      Ch6  (inputA_wire, inputB_wire, AND_out_wire);
  OR_gate       Ch7  (inputA_wire, inputB_wire, OR_out_wire);
  XOR_gate      Ch8  (inputA_wire, inputB_wire, XOR_out_wire);
  NOT_gate      Ch9  (inputB_wire, NOT_out_wire);
  NAND_gate     Ch10 (inputA_wire, inputB_wire, NAND_out_wire);
  NOR_gate      Ch11 (inputA_wire, inputB_wire, NOR_out_wire);
  XNOR_gate     Ch12 (inputA_wire, inputB_wire, XNOR_out_wire);
  SHL_Logic     Ch13 (inputA_wire, SHL_out_wire);
  SHR_Logic     Ch14 (inputA_wire, SHR_out_wire);
  
  MUX           CMD (MUX_channels, opcode_MUX, MUX_out_wire);
  DFF_register  ACC (clk_wire, rst_wire, MUX_out_wire, reg_out_wire);
  ERROR_Check   ERR (clk_wire, rst_wire, carry_error_wire, ERROR_result);

  always @(*)
  begin
    curA = reg_A_cur_wire;
    curB = reg_B_cur_wire;
    curC = reg_out_wire;
    curERROR = ERROR_result;

    nextA = inputA_wire;
    nextB = inputB_wire;
    nextC = MUX_out_wire;
    nextERROR = carry_error_wire;
  end

  assign C = reg_out_wire; 
  assign ERR_out = ERROR_result;

endmodule
//==================================================================================
module testbench();//test-bench
  reg clkk;
  reg resett;
  reg [3:0] opcodee;
  reg [31:0] AA;
  reg [31:0] BB;
  reg [15:0][5*8:0] string;
  reg fx;
  
  wire [31:0] CC;

  // create breadboard
  breadboard ALU (clkk, resett, AA, BB, CC, opcodee, err_fout);
   
  //CLOCK
  initial begin
    forever
      begin
       clkk = 0;
       #5;
       clkk = 1;
       #5;
      end
  end

  //Start Output Thread
  initial 
  begin
    	$dumpfile("dump.vcd");
		  $dumpvars;
    $display("+=+");
	  $display("|C|========+================================+=========================================+=============+=========================================+=====+");
	  $display("|L|Input                                    |ACC                                      |Instruction  |Next                                     |     |");  
	  $display("|K|#Hex    |BIN                             |#HEX    |BIN                             | CMD  |Opcode|#HEX    |BIN                             |Error|");  
	  $display("|=|========+================================|========+================================|======+======|========+================================|=====|");  
	  #3;//Offset to make sure data is not on the exact low-to-high positive edge.
    
    forever
    begin
      string[4'b0000] = {"No-op"};
      string[4'b0001] = {"ADD"};
      string[4'b0010] = {"SUB"};
      string[4'b0011] = {"MUL"};
      string[4'b0100] = {"DIV"};
      string[4'b0101] = {"REM"};
      string[4'b0110] = {"AND"};
      string[4'b0111] = {"OR"};
      string[4'b1000] = {"XOR"};
      string[4'b1001] = {"NOT"};
      string[4'b1010] = {"NAND"};
      string[4'b1011] = {"NOR"};
      string[4'b1100] = {"XNOR"};
      string[4'b1101] = {"SHL"};
      string[4'b1110] = {"SHR"};
      string[4'b1111] = {"RESET"};
      
      $display("|%1b|%8h|%32b|%8h|%32b|%s| %4b |%8h|%32b|%1b    |", 
      clkk,
      AA,
      AA,
      ALU.C,
      ALU.C,
      string[opcodee],
      opcodee,
      ALU.nextC,
      ALU.nextC,
      fx);
      #5;
    end
  end

  //STIMULOUS
  initial begin
    #2;
    fx=0;

    opcodee = 4'b0000;//no-op
    AA = 32'b00000000000000000000000000000000;
    BB = ALU.curC;
    #10;

    opcodee = 4'b1111;//reset
    AA = 32'b00000000000000000000000000000000;
    BB = ALU.curC;
    #10;

    opcodee = 4'b0001;//ADD
    AA = 32'b00000000000000000000000000000101;
    BB = ALU.curC;
    #10;
    
    opcodee = 4'b0010;//SUB
    AA = 32'b00000000000000000000000000000001;
    BB = ALU.curC;
    #10;

    opcodee = 4'b0011;//MUL
    AA = 32'b00000000000000000000000000000011;
    BB = ALU.curC;
    #10;

    opcodee = 4'b0100;//DIV
    AA = 32'b00000000000000000000000000000011;
    BB = ALU.curC;
    #10;


    opcodee = 4'b0101;//MOD
    AA = 32'b00000000000000000000000000000011;
    BB = ALU.curC;
    #10;

    opcodee = 4'b0110;//AND
    AA = 32'b00000000000000000000000011111111;
    BB = ALU.curC;
    #10;
    
    opcodee = 4'b0111;//OR
    AA = 32'b00000000001111111111111111111111;
    BB = ALU.curC;
    #10;
    
    opcodee = 4'b1000;//XOR
    AA = 32'b00000000000001010101010101010101;
    BB = ALU.curC;
    #10;

    opcodee = 4'b1001;//NOT
    AA = 0;
    BB = ALU.curC;
    #10;
       
    opcodee = 4'b1010;//NAND
    AA = 32'b00000000000000000000000000000111;
    BB = ALU.curC;
    #10;
    
    opcodee = 4'b1011;//NOR
    AA = 32'b00000000000000000000000000000111;
    BB = ALU.curC;
    fx=1;
    #10;
    
    opcodee = 4'b1100;//XNOR
    AA = 32'b00000000000000000000000000000111;
    BB = ALU.curC;
    fx=0;
    #10;

    opcodee = 4'b1101;//SHL
    AA = 32'b00000000000000000000000000111111;
    #10;

    opcodee = 4'b1110;//SHR
    AA = 32'b00000000000000000000000000111111;
    #10;

    opcodee = 4'b1111;//RESET
    AA = 32'b00000000000000000000000000000000;
    BB = ALU.curC;
    #10;

    $finish;
  end
endmodule
//=======================================[END :)]====================================//
