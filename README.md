# Infraestrutura de Hardware - Projeto RISC-V Pipeline 🚀

Este repositório contém os arquivos base para o projeto da disciplina Infraestrutura de Hardware (IF674) no CIn-UFPE. O objetivo do projeto é implementar instruções em um processador RISC-V usando SystemVerilog.

---

## 📝 Instruções

A tabela abaixo mostra o status das instruções implementadas até o momento:

| # | Instrução | Implementada | Testada | Funcionando |
|---|-----------|:-----------:|:-------:|:-----------:|
| 1 | `BEQ`     |     ✅     |   ✅   |     ✅     |
| 2 | `LW`      |     ✅     |   ✅   |     ✅     |
| 3 | `SW`      |     ✅     |   ✅   |     ✅     |
| 4 | `ADD`     |     ✅     |   ✅   |     ✅     |
| 5 | `AND`     |     ✅     |   ✅   |     ✅     |

Seu objetivo é implementar as instruções restantes listadas abaixo:

| # | Instrução | Implementada | Testada | Funcionando |
|---|-----------|:-----------:|:-------:|:-----------:|
| 1  | `JAL`     |      ❌     |    ❌    |      ❌      |
| 2  | `JALR`    |      ❌     |    ❌    |      ❌      |
| 3  | `BNE`     |      ✅     |    ❌    |      ❌      |
| 4  | `BLT`     |      ✅     |    ❌    |      ❌      |
| 5  | `BGE`     |      ✅     |    ❌    |      ❌      |
| 6  | `LB`      |      ✅     |    ✅    |      ✅      |
| 7  | `LH`      |      ✅     |    ✅    |      ✅      |
| 8  | `LBU`     |      ✅     |    ✅    |      ✅      |
| 9  | `SB`      |      ✅     |    ✅    |      ✅      |
| 10 | `SH`      |      ✅     |    ✅    |      ✅      |
| 11 | `SLTI`    |      ✅     |    ❌    |      ❌      |
| 12 | `ADDI`    |      ✅     |    ✅    |      ✅      |
| 13 | `SLLI`    |      ✅     |    ❌    |      ❌      |
| 14 | `SRLI`    |      ✅     |    ❌    |      ❌      |
| 15 | `SRAI`    |      ✅     |    ❌    |      ❌      |
| 16 | `SUB`     |      ✅     |    ❌    |      ❌      |
| 17 | `SLT`     |      ✅     |    ❌    |      ❌      |
| 18 | `XOR`     |      ✅     |    ❌    |      ❌      |
| 19 | `OR`      |      ✅     |    ❌    |      ❌      |
| 20 | `HALT`    |      ❌     |    ❌    |      ❌      |

### Observações

- As instruções de 1 a 19 são parte oficial do conjunto RV32I. A pseudo-instrução `HALT` é uma instrução usada em linguagens de montagem para **indicar o fim de um programa ou pausar sua execução**. Quando o processador encontra a instrução `HALT`, geralmente é acionada uma ação específica, como inserir zeros (ou outro valor pré-determinado) no pipeline do processador e interromper o contador de programa (PC), impedindo a execução de novas instruções. Essa funcionalidade permite que o programador tenha controle sobre o fluxo do programa, indicando explicitamente quando o programa deve terminar.

- Você tem permissão para modificar a implementação do processador como desejar (por exemplo, incluir fios, alterar tamanhos, modificar sinais, remover ou adicionar módulos, etc.), desde que o resultado final continue funcionando como um pipeline e produza os resultados corretos. Suas decisões de projeto devem ser adequadamente documentadas.

## 📦 Entrega

A data de entrega do projeto será especificada no Classroom, assim como a quantidade de pessoas por grupo.

### Modelo de entrega

A entrega consiste no link do fork do repositório no GitHub, contendo o código-fonte do projeto e o relatório.

- Faça um fork desse repositório e inclua as alterações necessárias (**todos os integrantes do grupo devem contribuir!**).
  - Além das implementações, fique à vontade para alterar o README.md como achar melhor.

- O relatório deve estar no formato PDF ou como link de um Google Docs. Ele deve conter:
  - Nome dos integrantes do grupo.
  - Link para o fork do repositório no GitHub.
  - Descrição das escolhas de projeto.
  - Descrição dos testes realizados.
  - Resultados obtidos.
  - Dificuldades encontradas.
  - Conclusão.

O relatório não deve ser extenso, mas deve conter todas as informações necessárias para a avaliação do projeto.

## 📝 Avaliação

A avaliação do projeto será baseada na implementação correta das instruções, nos testes realizados e no funcionamento adequado do processador.

- O projeto será submetido a casos de teste para verificar seu funcionamento, mas o processo de avaliação também levará em conta a qualidade do código e do relatório.

## 📁 Estrutura do repositório
O repositório está organizado da seguinte forma:
- [`design`](/design): Contém o código-fonte do projeto do processador RISC-V.
- [`doc`](/doc): Contém mais explicações sobre a implementação.
- [`sim`](/sim): Contém os arquivos de simulação e os resultados, para uso nos testes.
- [`verif`](/verif): Contém os arquivos de testbench e as instruções de como testar o projeto.

## 📚 Recursos
- Para iniciar o estudo do conjunto de instruções RISC-V, consulte:
  - [Manual de Conjunto de Instruções RISC-V Volume I: ISA de Nível de Usuário - Documento Versão 2.2](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf)
  - [risc-v isa pages, by msyksphinz](https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html#)

- Para simular e testar o projeto do processador RISC-V, utilize:
  - [ModelSim-Intel® FPGAs Standard Edition Software Version 20.1.1](https://www.intel.com/content/www/us/en/software-kit/750666/modelsim-intel-fpgas-standard-edition-software-version-20-1-1.html)

- Para verificar os resultados:
  - Compare seus resultados com os exemplos fornecidos em [`sim`](/sim)
  - Utilize o simulador CompSim
  - Utilize o [RISC-V Interpreter, by Cornell University](https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter/)

## ❓ Dúvidas

Em caso de dúvidas ou dificuldades, entre em contato com os monitores da disciplina:
- [joaopmarinho](https://github.com/joaopmarinho)
- [nathaliafab](https://github.com/nathaliafab)

## 🐛 Encontrou um bug ou pensou numa melhoria?

Encorajamos os alunos a procurarem por bugs e sugerirem melhorias para o projeto, visando aperfeiçoá-lo para as próximas edições da disciplina. Se você identificou algum bug ou possui uma ideia para melhorar o projeto, ficaremos felizes em receber sua contribuição!

Existem duas maneiras de nos enviar suas sugestões:

1. **Issue**: Abra uma issue detalhando o problema ou a melhoria proposta. Certifique-se de fornecer informações claras e específicas para facilitar a compreensão do que precisa ser corrigido ou aprimorado.

2. **Pull Request**: Se você é familiarizado com o processo de pull requests, sinta-se à vontade para enviar suas alterações diretamente por meio de um pull request. Certifique-se de descrever claramente as alterações realizadas e o motivo por trás delas.
