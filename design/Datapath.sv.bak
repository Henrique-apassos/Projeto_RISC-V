`timescale 1ns / 1ps

import Pipe_Buf_Reg_PKG::*;

//a saída do Datapath contém os dados para a execução da próxima instrução, decididos com base na instrução em execução (instrução atual no pipeline)
module Datapath #( //representa o caminho de dados de um processador com pipeline 
    parameter PC_W = 9, // Tamanho do PC (Contador de Programa - armazena endereço da instrução)
    parameter INS_W = 32, // Tamanho da instrução (32 bits)
    parameter RF_ADDRESS = 5, // Endereço do registrador -> 5 bits = 2^5 = 32 -> x0 ao x31
    parameter DATA_W = 32, //Tamanho do dado (32 bits)
    parameter DM_ADDRESS = 9, //Endereço da memória de dados = há 2^9 endereços/posições de memória disponíveis (cada posição armazena uma palavra, que pode ter 1,2,3,4...bytes)
    parameter ALU_CC_W = 4  //Código de controle da ALU
) (
    input  logic clk, // Relógio
    reset, // Reinicia estado do processador
    RegWrite, // Habilita escrita nos registradores
    MemtoReg,  // Controla se dado vem da ALU ou da memória para o registrador de destino
    ALUsrc, // Define se o segundo operando da ALU vem da memória de dados ou da ALU
    MemWrite,  // Habilita escrita na memória
    MemRead,  // Habilita leitura da memória de dados
    Branch,  // Informa se é uma instrução de branch ou uma instrução normal 
    Jump, // Informa quando deve ocorrer um jump
    input  logic [1:0] JumpRegWriteControl,  // Determina se a instrução de jump envolve escrita no registrador
    input  logic [1:0] ALUOp, // Define qual é a operação que a ALU deve executar 
    input  logic [ALU_CC_W -1:0] ALU_CC, // Dados sobre flags que guiam o comportamento no pipeline

    output logic [6:0] opcode, // Indica qual é a operação da instrução que será realizada 
    output logic [6:0] Funct7, // Ajuda a determinar qual é a operação da instrução que será realizada
    output logic [2:0] Funct3, // Ajuda a determinar qual é a operação da instrução que será realizada 
    output logic [1:0] ALUOp_Current, // Transmite qual é a operação desejada para a ALU, com base em ALUOp
    output logic [DATA_W-1:0] WB_Data, // O dado que será escrito de volta nos registradores após a execução da instrução

    // Para depuração no tesbench: testa se as instruções estão sendo executadas corretamente no pipeline 
    output logic [4:0] reg_num,  // Indica qual registrador foi escrito na última operação de escrita
    output logic [DATA_W-1:0] reg_data,  // Indica o valor que foi escrito no registrador
    output logic reg_write_sig,  // Flag que indica houve escrita no registrador no ciclo atual

    output logic wr,  // Indica se haverá escrita na memória no ciclo atual (não pode ser 1 qdo reade é 1)
    output logic reade,  // Indica se haverá leitura da memória no ciclo atual (não pode haver leitura e escrita no mesmo ciclo)
    output logic [DM_ADDRESS-1:0] addr,  // Endereço de memória que será acessado para escrita e para leitura
    output logic [DATA_W-1:0] wr_data,  // Indica que será escrito algo em addr
    output logic [DATA_W-1:0] rd_data  // Indica que será lido algo de addr
);

  logic [PC_W-1:0] PC, PCPlus4, Next_PC;
  logic [INS_W-1:0] Instr;
  logic [DATA_W-1:0] Reg1, Reg2;
  logic [DATA_W-1:0] ReadData;
  logic [DATA_W-1:0] SrcB, ALUResult;
  logic [DATA_W-1:0] ExtImm, BrImm, Old_PC_Four, BrPC;
  logic [DATA_W-1:0] WrmuxSrc,Data_Jal;
  logic PcSel,rdfinal,um;  // mux select / flush signal
  logic [1:0] FAmuxSel;
  logic [1:0] FBmuxSel;
  logic [DATA_W-1:0] FAmux_Result;
  logic [DATA_W-1:0] FBmux_Result;
  logic Reg_Stall;  //1: PC fetch same, Register not update
  logic haltOcorre; 

  if_id_reg A;
  id_ex_reg B;
  ex_mem_reg C;
  mem_wb_reg D;


  //PC contém endereço da instrução atual
  // next PC
  adder #(9) pcadd (  // Somador: incrementa o PC em 4 para a próxima instrução 
      PC,
      9'b100,
      PCPlus4
  );
  mux2 #(9) pcmux ( // Multiplexador: seleciona entre PC+4 ou um endereço de desvio
      PCPlus4,
      BrPC,
      PcSel,
      Next_PC
  );
  flopr #(9) pcreg ( // Registrador do PC: armazena o valor do PC e atualiza a cada ciclo de clock 
      clk,
      reset,
      Next_PC,
      Reg_Stall,
      Pcsel,
      PC
  );
  instructionmemory instr_mem ( // Memória de instruções: armazena instrução que será decodificada e executada 
      clk,
      PC,
      Instr
  );

  always @(posedge clk) begin 
    if(reset) begin
      haltOcorre <= 0;
    end
  end

  // IF_ID_Reg A;
  always @(posedge clk) begin // A cada subida do clock os valores de PC e da instrução são atualizados
    if ((reset) || (PcSel) || (haltOcorre))   // Se resetado ou se ocorreu um desvio
    begin
      A.Curr_Pc <= 0; // Zera o PC armazenado
      A.Curr_Instr <= 0; // Zera a instrução armazenada
    end
    else if (!Reg_Stall && !haltOcorre) // Se não houver stall (bolha)
    begin
      A.Curr_Pc <= PC; // Armazena PC atual
      A.Curr_Instr <= Instr; // Armazena instrução buscada
    end
  end

  //--// The Hazard Detection Unit
  HazardDetection detect ( // Se houver dependência, pipeline será pausado: Reg_Stall = 1
      A.Curr_Instr[19:15],
      A.Curr_Instr[24:20],
      B.rd,
      B.MemRead,
      Reg_Stall
  );

  // //Register File
  assign opcode = A.Curr_Instr[6:0];

  RegFile rf ( // Lê os valores dos registradores mencionados na instrução para as fases seguintes 
      clk,
      reset,
      D.RegWrite,
      D.rd,
      A.Curr_Instr[19:15],
      A.Curr_Instr[24:20],
      WB_Data,
      Reg1,
      Reg2
  );

  assign reg_num = D.rd;
  assign reg_data = WB_Data;
  assign reg_write_sig = D.RegWrite;

  // //sign extend
  imm_Gen Ext_Imm ( // Extensor de imediato
      A.Curr_Instr,
      ExtImm
  );

  // ID_EX_Reg B;
  always @(posedge clk) begin
    if ((reset) || (Reg_Stall) || (PcSel) || (haltOcorre))   
      begin
      B.ALUSrc <= 0;
      B.Jump <= 0;
      B.MemtoReg <= 0;
      B.RegWrite <= 0;
      B.MemRead <= 0;
      B.MemWrite <= 0;
      B.JumpRegWriteControl  <= 0;
      B.ALUOp <= 0;
      B.Branch <= 0;
      B.JumpReg <= 0;
      B.Curr_Pc <= 0;
      B.RD_One <= 0;
      B.RD_Two <= 0;
      B.RS_One <= 0;
      B.RS_Two <= 0;
      B.rd <= 0;
      B.ImmG <= 0;
      B.func3 <= 0;
      B.func7 <= 0;
      B.Curr_Instr <= A.Curr_Instr;  //debug tmp
    end else begin
      B.ALUSrc <= ALUsrc;
      B.Jump <= Jump;
      B.MemtoReg <= MemtoReg;
      B.RegWrite <= RegWrite;
      B.MemRead <= MemRead;
      B.MemWrite <= MemWrite;
      B.JumpRegWriteControl  <= JumpRegWriteControl;
      B.ALUOp <= ALUOp;
      B.Branch <= Branch;
      B.JumpReg <= JumpReg;
      B.Curr_Pc <= A.Curr_Pc;
      B.RD_One <= Reg1;
      B.RD_Two <= Reg2;
      B.RS_One <= A.Curr_Instr[19:15];
      B.RS_Two <= A.Curr_Instr[24:20];
      B.rd <= A.Curr_Instr[11:7];
      B.ImmG <= ExtImm;
      B.func3 <= A.Curr_Instr[14:12];
      B.func7 <= A.Curr_Instr[31:25];
      B.Curr_Instr <= A.Curr_Instr;  //debug tmp
    end
  end

  //--// The Forwarding Unit
  ForwardingUnit forunit (
      B.RS_One,
      B.RS_Two,
      C.rd,
      D.rd,
      C.RegWrite,
      D.RegWrite,
      FAmuxSel,
      FBmuxSel
  );

  // // //ALU
  assign Funct7 = B.func7;
  assign Funct3 = B.func3;
  assign ALUOp_Current = B.ALUOp;

  mux4 #(32) FAmux (
      B.RD_One,
      WrmuxSrc,
      C.Alu_Result,
      B.RD_One,
      FAmuxSel,
      FAmux_Result
  );
  mux4 #(32) FBmux (
      B.RD_Two,
      WrmuxSrc,
      C.Alu_Result,
      B.RD_Two,
      FBmuxSel,
      FBmux_Result
  );
  mux2 #(32) srcbmux (
      FBmux_Result,
      B.ImmG,
      B.ALUSrc,
      SrcB
  );
  alu alu_module (
      FAmux_Result,
      SrcB,
      ALU_CC,
      ALUResult
  );
  BranchUnit #(9) brunit (
      B.Curr_Pc,
      B.ImmG,
      B.Branch,
      B.Jump,
      ALUResult,
      BrImm,
      Old_PC_Four,
      BrPC,
      PcSel
      
  );

  // EX_MEM_Reg C;
  always @(posedge clk) begin
    if(ALUResult == 0 && Funct3 == 011) { //Funct3 == 011 indica o ALUResult é 0 por conta da instrução halt, e não por conta de uma instrução aritmética
      haltOcorre = 1;
    }

    if (reset || HaltOcorre)   // initialization
        begin
      C.RegWrite <= 0;
      C.Jump <= 0;
      C.MemtoReg <= 0;
      C.MemRead <= 0;
      C.MemWrite <= 0;
      C.JumpRegWriteControl  <= 0;
      C.Pc_Imm <= 0;
      C.Pc_Four <= 0;
      C.Imm_Out <= 0;
      C.Alu_Result <= 0;
      C.RD_Two <= 0;
      C.rd <= 0;
      C.func3 <= 0;
      C.func7 <= 0;
    end else begin
      C.RegWrite <= B.RegWrite;
      C.Jump <= B.Jump;
      C.MemtoReg <= B.MemtoReg;
      C.MemRead <= B.MemRead;
      C.MemWrite <= B.MemWrite;
      C.JumpRegWriteControl  <= B.JumpRegWriteControl;
      C.Pc_Imm <= BrImm;
      C.Pc_Four <= Old_PC_Four;
      C.Imm_Out <= B.ImmG;
      C.Alu_Result <= ALUResult;
      C.RD_Two <= FBmux_Result;
      C.rd <= B.rd;
      C.func3 <= B.func3;
      C.func7 <= B.func7;
      C.Curr_Instr <= B.Curr_Instr;  // debug tmp
    end
  end
  
  // // // // Data memory 
   datamemory data_mem (
      clk,
      C.MemRead,
      C.MemWrite,
      C.Alu_Result[8:0],
      C.RD_Two,
      C.func3,
      ReadData
  );

  assign wr = C.MemWrite;
  assign reade = C.MemRead;
  assign addr = C.Alu_Result[8:0];
  assign wr_data = C.RD_Two;
  assign rd_data = ReadData;

  // MEM_WB_Reg D;
  always @(posedge clk) begin
    if (reset || haltOcorre)   // initialization
        begin
      D.RegWrite <= 0;
      D.Jump <= 0;
      D.MemtoReg <= 0;
      D.JumpRegWriteControl  <= 0;
      D.Pc_Imm <= 0;
      D.Pc_Four <= 0;
      D.Imm_Out <= 0;
      D.Alu_Result <= 0;
      D.MemReadData <= 0;
      D.rd <= 0;
    end else begin
      D.RegWrite <= C.RegWrite;
      D.Jump <= Jump;
      D.MemtoReg <= C.MemtoReg;
      D.JumpRegWriteControl  <= C.JumpRegWriteControl;
      D.Pc_Imm <= C.Pc_Imm;
      D.Pc_Four <= C.Pc_Four;
      D.Imm_Out <= C.Imm_Out;
      D.Alu_Result <= C.Alu_Result;
      D.MemReadData <= ReadData;
      D.rd <= C.rd;
      D.Curr_Instr <= C.Curr_Instr;  //Debug Tmp
    end
  end

  //logic [DATA_W-1:0] Jmux_WrmuxSrc;

  //--// The LAST Block
  mux2 #(32) resmux (
      D.Alu_Result,
      D.MemReadData,
      D.MemtoReg,
      WrmuxSrc
  );
  mux4 #(32) wrsmux (
      WrmuxSrc,
      D.Pc_Four,
      D.Pc_Imm,
      D.Imm_Out,
      D.JumpRegWriteControl,
      Data_Jal
  );

  assign WB_Data = Data_Jal;

endmodule
