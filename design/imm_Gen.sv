`timescale 1ns / 1ps


//módulo que, com base no Opcode da instrução, determina formato da instrução 
module imm_Gen (
    input  logic [31:0] inst_code, //recebe uma instrução de 32 bits
    output logic [31:0] Imm_out //dependendo do tipo da instrução, gera um valor imediato Imm_out corretamente estendido para 32 bits
);


  always_comb //avalia o opcode da instrução para identificar seu tipo e extrair o imediato corretamente -> cada tipo de instrução manipula o imediato de forma específica 
    case (inst_code[6:0])
      7'b0000011:  //Instruções do tipo I possuem o imediato nos bits [31:20]
        Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]}; //se o bit 31(de sinal) for 1, 20 bits com 1 acrescentados ao imediato recebido. Caso seja 0, 20 bits com 0 acrescentados ao imediato.
		
		  7'b0010011: /*I-type arithmetic part*/
		  Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b0100011:  /*S-type*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:25], inst_code[11:7]};

      7'b1100011:  /*B-type*/
      Imm_out = {
        inst_code[31] ? 19'h7FFFF : 19'b0,
        inst_code[31],
        inst_code[7],
        inst_code[30:25],
        inst_code[11:8],
        1'b0
      };

      7'b1101111: /*JAL*/
        Imm_out = {{11{inst_code[31]}}, inst_code[31], inst_code[19:12], inst_code[20], inst_code[30:21], 1'b0};

      7'b1100111: /*JALR*/
        Imm_out = {{20{inst_code[31]}}, inst_code[31:20]};
        
      default: Imm_out = {32'b0};

    endcase

endmodule


