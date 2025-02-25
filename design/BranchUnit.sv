`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic Halt, //adicionado
    input logic Jal, //adicionado 
    input logic Jalr, //adicionado
    input logic [31:0] AluResult,
    output logic [31:0] PC_Imm,
    output logic [31:0] PC_Four,
    output logic [31:0] BrPC,
    output logic PcSel
);

  logic Branch_Sel;
  logic [31:0] PC_Full;

  assign PC_Full = {23'b0, Cur_PC};

  assign PC_Imm = (Jalr == 1) ? AluResult : PC_Full + Imm; //verifica se Jalr é igual a 1
  assign PC_Four = Halt ? 0'b0 : PC_Full + 32'b100; // verifica se Halt é verdadeiro
  // expandida para incluir a verificação de Halt, Jal e Jalr
  assign Branch_Sel = ((Branch && AluResult[0]) || (Halt) || (Jal) || (Jalr)) ;  // 0:Branch is taken; 1:Branch is not taken

  assign BrPC = (Branch_Sel) ? PC_Imm : 32'b0;  // Branch -> PC+Imm   // Otherwise, BrPC value is not important
  assign PcSel = Branch_Sel;  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule
