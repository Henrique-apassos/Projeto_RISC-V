`timescale 1ns / 1ps

//obs: O Controller, com base nos opcodes presentes nas instruções, formam flags que orientam o comportamento da CPU.
//obs: Apenas a "flag" da ALUOp que ditará (juntamente com Funct3 e Funct7, mas esses estão presentes em outra parte da instrução, logo não são inputs do Controller) a operação que ocorrerá na ALU.

module Controller (
    //Input
    input logic [6:0] Opcode, //entrada com 7 bits, que indica a operação da instrução 
    

    //Outputs -> sinais de controle para orientar funcionamento da CPU
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,  //00: LW/SW; 01:Branch; 10: Rtype
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    
    output logic Jump,
    output logic JumpReg,
    output logic [1:0] JumpType, // 00: Sem salto, 01: JAL, 10: JALR
    output logic[1:0] JumpRegWriteControl  //Indica escrita no registrador de retorno (x1) 
    );

  logic [6:0] R_TYPE, L_TYPE, S_TYPE, B_TYPE, I_TYPE, JAL, JALR; //define variáveis que armazenam os opcodes de diferentes tipos de instruções

  assign R_TYPE = 7'b0110011;  //add,and,or,xor,srl,sub, slt 
  assign I_TYPE = 7'b0010011; //slti,addi,slli,srli,srai
  assign B_TYPE = 7'b1100011; //beq, bne, blt, bge
  assign L_TYPE = 7'b0000011;  //lw,lb,lh,lbu,lhu
  assign S_TYPE = 7'b0100011;  //sw,sb,sh
  assign JAL = 7'b1101111;  //jal
  assign JALR = 7'b1100111;  //jalr

  //Com base nos opcodes das instruções, serão definidas "flags" para orientar o comportamento da CPU:

  //ALUSrc define se o segundo operando da ALU vem do registrador(tipo R) ou da instrução(imediato tipo I)
  assign ALUSrc = (Opcode == L_TYPE || Opcode == S_TYPE || Opcode == I_TYPE); //1 - Load, Store, Tipo I e 0 - tipo R 

  //MemtoReg define se o valor escrito no registrador vem da memória ou da ALU 
  assign MemtoReg = (Opcode == L_TYPE); //1 - vem da memória(load) e 0 - vem da ALU

  //RegWrite define se um registrador será escrito 
  assign RegWrite = (Opcode == R_TYPE || Opcode == L_TYPE || Opcode == I_TYPE || Opcode == JAL || Opcode == JALR); //1 - tipo R, tipo I, Load, Jal, Jalr e 0 - Store e Branch, pois não alteram registradores

  //MemRead define se algum valor será lido da memória
  assign MemRead = (Opcode == L_TYPE); //1 - Load 

  //MemWrite define se algum valor será escrito na memória 
  assign MemWrite = (Opcode == S_TYPE); //1 - Store

  //ALUOp define a classe de instrução que será executada na ALU, portando ALUOp define o comportamento da ALU
  assign ALUOp[0] = (Opcode == B_TYPE || Opcode == JALR);
  assign ALUOp[1] = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == JALR);


  //Branch define se ocorrerá desvio
  assign Branch = (Opcode == B_TYPE || Opcode == JALR); //1 - Desvios condicionais e 0 - instruções normais

    // Define o tipo de salto: 
    // 00 - Sem salto, 01 - JAL, 10 - JALR
    assign JumpType = (Opcode == JAL)  ? 2'b01 :
                      (Opcode == JALR) ? 2'b10 :
                      2'b00;

    // Define se há escrita no registrador de retorno (x1)
    assign JumpRegWriteControl  = JumpRegWriteControl;


endmodule
