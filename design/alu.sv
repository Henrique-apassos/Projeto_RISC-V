`timescale 1ns / 1ps 

/*
timescale <unidade de tempo>/ <precisão>
    A unidade de tempo interpreta atrasos no código, como #delay 
    1 unid de tempo equivale a 1 nanosegundo 
    #5 -> 5 nanosegundos 
    #1 -> 1 nanosegundo 
    se fosse 1ps/1ps -> #5 significaria 5 picosegundos 

    A precisão define a menor precisão que a simulação pode representar
    Um atraso ou tempo medido será arredondado para o múltiplo mais próximo 
    Se o tempo fosse 0,55 ns, seria representado como 0,5ns, pois eh maior do q 1ps
    Se o tempo fosse 1ns/1ns, seria arredondado para 1ns, pois 0,55ns é menor do q 1ns
    no código: #0,55 -> 0,55ns de atraso -> aceito pq 1ps permite aceitar isso
    timescale 1ns/1ns -> #0,55 -> 0,55ns de atraso -> não aceito, pois o atraso tem q ser maior do q 1ns (arredondado para 1ns)
*/

module alu#( //cabeçalho do módulo ALU - define dois parâmetros 
        parameter DATA_WIDTH = 32, //tamando dos dados/operandos -> 32 bits
        parameter OPCODE_LENGTH = 4 //tamanho do código de operação -> 4 bits (permite 2^4 = 16 operações diferentes)
        )

        //obs: [DATA_WIDTH-1:0] = [31:0] = vetor de 32 bits, que vai do bit 31 ao bit 0
        //obs: [OPCODE_LENGTH-1:0] = [3:0] = vetor de 4 bits, que vai do bit 3 ao bit 0

        ( //definição das entradas e das saídas 
        input logic [DATA_WIDTH-1:0]    SrcA, //primeiro operando de 32 bits
        input logic [DATA_WIDTH-1:0]    SrcB, //segundo operando de 32 bits

        input logic [OPCODE_LENGTH-1:0]    Operation, //código da operação (tem 4 bits), que define qual operação a ALU executará
        output logic[DATA_WIDTH-1:0] ALUResult //resultado da operação realizada pela ALU -> 32bits 
        );
    
        always_comb //bloco para lógica combinacional (Sem clock. Apenas com base nos sinais de entrada)
        begin
            case(Operation) //define diferentes operações para a ALU, dependendo do código da operação no input
            4'b0000:		//AND, ANDI
                    ALUResult = SrcA & SrcB;
			4'b0001:		//OR, ORI
                    ALUResult = SrcA | SrcB;
            4'b0010:		//ADD
                    ALUResult = SrcA + SrcB;
			4'b0011:		//SUB
                    ALUResult = SrcA - SrcB;
			4'b0100:		//SRLI
                    ALUResult = SrcA >> SrcB;
			4'b0101:		//SLLI
                    ALUResult = SrcA << SrcB;
			4'b0110:		//XOR
                    ALUResult = SrcA ^ SrcB;
			4'b0111:		//SRAI
                    ALUResult = $signed(SrcA) >>> $signed(SrcB);
            4'b1000:		// BEQ
                    ALUResult = (SrcA == SrcB) ? 1 : 0; //se forem iguais, retorna 1
            4'b1001:		// BNE
                    ALUResult = (SrcA != SrcB) ? 1 : 0; //se não forem iguais, retorna 1
		     4'b1010:		// JALR
                    ALUResult = $signed(SrcA) + $signed(SrcB);
            4'b1011:		// BGE
                    ALUResult = ($signed(SrcA) >= $signed(SrcB)) ? 1 : 0; //se SrcA for maior ou igual a SrcB, retorna 1
			4'b1100:		// SLT, SLTI, BLT
                    ALUResult =  ($signed(SrcA) < $signed(SrcB)) ? 1 : 0; //se SrcA for menor do que SrcB, retorna 1
            4'b1101:        // BLTU, SLTU, SLTIU
                ALUResult = ($unsigned(SrcA) < $unsigned(SrcB)) ? 1 : 0;
            4'b1110:        // BGEU
                ALUResult = ($unsigned(SrcA) >= $unsigned(SrcB)) ? 1 : 0;
            4'b1111:        // LUI
                ALUResult = SrcB;
            default:
                    ALUResult = 0;
            endcase
        end
endmodule

