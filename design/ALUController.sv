`timescale 1ns / 1ps

/*
A ALUController está dentro do processador, na Unidade de Controle. Ela recebe informações derivadas das instruções que estão sendo lidas (ALUOp, Funct3, Funct7) e geram um código Operation.
O código Operation que define qual é a operação que será realizada dentro da ALU.

A unidade de controle (ALUController) vê o Opcode(7 bits) e define qual é a classe das instruções que a ALU fará (ALUOp)
O ALUController usa então o Funct3 e o Funct7 para refinarem qual é a operação específica dentro da ALU
Operation é então o código final que a ALU usa para realizar a operação
Operation é então a operação final da ALU, determinada pela combinação de opcode, Funct3 e Funct7
*/

module ALUController (
    // Inputs
    input logic [1:0] ALUOp,  // classe das instruções que a ALU irá fazer: Load/Store (00); Branch (01); tipo R e I (10); JAl e LUI (11);
    input logic [6:0] Funct7,  // II- usado para diferenciar variantes de operações  
    input logic [2:0] Funct3,  // I - usado para diferenciar operações dentro de uma mesma classe de instruções

    // Output
    output logic [3:0] Operation  // operação selecionada para a ALU (saída)
);

  assign Operation[0] = ((ALUOp == 2'b10) && (Funct3 == 3'b110)) || // R\I-or
                        ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)) || // R-sub
                        ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) || // R\I-SLL & SLLI <<
                        ((ALUOp == 2'b01) && (Funct3 == 3'b001)) || // BNE
                        ((ALUOp == 2'b01) && (Funct3 == 3'b100)) || // BLT
                        ((ALUOp == 2'b01) && (Funct3 == 3'b101)) || // BGE
                        ((ALUOp == 2'b01) && (Funct3 == 3'b111)) || // BGEU
                        ((ALUOp == 2'b10) && (Funct3 == 3'b011)) || // HALT
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000));  // R\I-SRAI >>>

  assign Operation[1] = (ALUOp == 2'b00) || // LW\SW
                        ((ALUOp == 2'b10) && (Funct3 == 3'b000)) || // R\I-add
                        ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)) || // R-sub
                        ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // R\I- SRAI >>>
                        ((ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)) || // XOR
                        ((ALUOp == 2'b11) && (Funct3 == 3'b000)) || // JALR
                        ((ALUOp == 2'b01) && (Funct3 == 3'b101)) || // BGE
                        ((ALUOp == 2'b01) && (Funct3 == 3'b110)) || // BLTU
                        ((ALUOp == 2'b10) && (Funct3 == 3'b011)) || // HALT
                        ((ALUOp == 2'b01) && (Funct3 == 3'b111));   // BGEU


  assign Operation[2] =  ((ALUOp==2'b10) && (Funct3==3'b001) && (Funct7==7'b0000000)) || // R\I-SLL & SLLI <<
                         ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // R\I-SRAI >>>
                         ((ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)) || // XOR
                         ((ALUOp == 2'b01) && (Funct3 == 3'b110)) || // BLTU
                         ((ALUOp == 2'b01) && (Funct3 == 3'b111)) || // BGEU
                         ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) || // R\I- SRL & SRLI >>
                         ((ALUOp == 2'b10) && (Funct3 == 3'b010)) || // R\I- SLTI <
                         ((ALUOp == 2'b10) && (Funct3 == 3'b011)); // HALT
		
  assign Operation[3] = (ALUOp == 2'b01) ||  // BEQ
                        ((ALUOp == 2'b01) && (Funct3 == 3'b001)) || // BNE
                        ((ALUOp == 2'b01) && (Funct3 == 3'b100)) || // BLT
                        ((ALUOp == 2'b01) && (Funct3 == 3'b101)) || // BGE
                        ((ALUOp == 2'b01) && (Funct3 == 3'b110)) || // BLTU
                        ((ALUOp == 2'b01) && (Funct3 == 3'b111)) || // BGEU
                        ((ALUOp == 2'b10) && (Funct3 == 3'b011)) || // HALT                                    
                        ((ALUOp == 2'b10) && (Funct3 == 3'b010));   // R\I- SLTI<

endmodule
