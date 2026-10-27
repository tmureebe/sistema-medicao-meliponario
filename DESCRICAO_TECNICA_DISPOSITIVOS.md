# Descrição técnica dos dispositivos do meliponário

Este documento descreve a função e o funcionamento dos dispositivos representados nos modelos 3D. O sistema foi planejado para cinco caixas de abelhas sem ferrão, instaladas em uma estante externa coberta. Ele registra a massa de cada caixa, a temperatura e a umidade do ar no entorno e a chuva. As medidas seguem para um computador por Wi-Fi e também podem ficar guardadas localmente.

**Estado do projeto:** os arquivos `.scad` são modelos de geometria e montagem; o [planejamento técnico](planejamento_tecnico_meliponario.pdf) define a arquitetura proposta. Eles não demonstram que a eletrônica, o programa, a vedação e a calibração já foram construídos ou validados. Todas as dimensões abaixo são as configurações iniciais dos modelos, em milímetros.

## Visão do conjunto

```text
Caixa C01 ─ célula 20 kg ─ HX711 ─┐
Caixa C02 ─ célula 20 kg ─ HX711 ─┤
Caixa C03 ─ célula 20 kg ─ HX711 ─┼── unidade central/ESP32 ── Wi-Fi ── computador
Caixa C04 ─ célula 20 kg ─ HX711 ─┤          │                    │
Caixa C05 ─ célula 20 kg ─ HX711 ─┘          ├── microSD           └── backup periódico
SHT40 no abrigo externo ──────────────────────┤
Pluviômetro de báscula ───────────────────────┘
                  bateria removível ── proteção/regulação ──┘
```

Cada caixa tem uma balança independente, identificada de **C01 a C05**. A unidade central reúne as leituras com data e hora. O computador é o destino principal dos dados recebidos pela rede; uma cópia externa, como Firestore, é uma possibilidade prevista no planejamento, não um componente necessário para medir.

## 1. Estante coberta e caixas — `meliponario.scad`

**Função.** Sustentar cinco colmeias no ambiente externo e oferecer cobertura contra a chuva direta. Três caixas ficam na prateleira inferior e duas na superior. As entradas das colmeias ficam voltadas para a frente da estante.

**Geometria inicial.** A estante mede 1.540 mm de largura por 600 mm de profundidade. As superfícies de apoio ficam a 610 e 1.190 mm do solo; o beiral está a 1.820 mm. Cada corpo de caixa mede 260 × 260 × 345 mm, com tampa de 26 mm. A altura representada do conjunto corpo+tampa é, portanto, 371 mm. O desenho inclui telhado de duas águas, pilares, travamentos e sapatas.

**Funcionamento no sistema.** A caixa repousa sobre a plataforma móvel da balança, que por sua vez se apoia na prateleira. Nenhuma fixação da caixa à estante deve desviar parte do peso da célula de carga. O telhado reduz exposição direta, mas não substitui os abrigos e vedações dos sensores e da eletrônica. O modelo é espacial; a resistência estrutural da estante e as condições de manejo precisam ser verificadas antes da construção.

## 2. Unidade de pesagem — `unidade_pesagem.scad`

**Quantidade:** cinco, uma por caixa. **Medição:** massa total apoiada na plataforma, incluindo caixa, colônia, reservas, tampa e qualquer item acrescentado sobre ela.

**Partes modeladas.** Base fixa e plataforma móvel de 300 × 300 × 12 mm; chapas e calços metálicos; uma célula de carga tipo barra de 20 kg com envelope de 80 × 12,7 × 12,7 mm; quatro batentes de sobrecarga; dois retentores para limitar movimento vertical; e caixa pequena para o conversor HX711. A caixa da colmeia mede 260 × 260 mm na base do modelo.

**Como funciona.** A carga segue o percurso **plataforma → chapa superior → calço móvel → célula de carga → calço fixo → chapa inferior → base → prateleira**. A deformação mínima da célula altera o sinal elétrico de sua ponte de Wheatstone de quatro fios. O HX711, junto à célula, amplifica e converte esse sinal para leitura digital pelo ESP32. Cada balança recebe sua própria calibração de zero e de escala; o programa converte a leitura para massa.

**Condição essencial.** A plataforma não pode encostar na base, nos batentes ou em cabos durante a faixa normal de uso: qualquer apoio paralelo faz a leitura subestimar o peso. Os batentes devem tocar somente antes de uma sobrecarga. A célula de 20 kg foi escolhida por custo, mas a carga admissível do conjunto deve considerar a plataforma, os objetos sobre a caixa e uma margem mecânica. O plano usa como limite inicial de projeto **13,33 kg no conjunto móvel**, a confirmar com a primeira caixa real.

**Fabricação e validação.** Base, plataforma e apoios no caminho da carga devem ser rígidos; o modelo propõe madeira selada e metal. A impressão 3D se aplica à caixa/tampa do HX711, não ao caminho de carga. A furação e o lado fixo/móvel da célula devem ser conferidos na peça comprada. Antes de colocar uma colônia, comparar massas conhecidas no centro e nos quatro cantos, verificar deriva durante carga prolongada e testar a folga dos batentes. Tara por software não aumenta a capacidade física da célula.

## 3. Unidade de temperatura e umidade — `unidade_temperatura_umidade.scad`

**Quantidade:** uma. **Medição:** temperatura e umidade relativa do **ar externo ao redor do meliponário**, não do interior das colmeias.

**Partes modeladas.** Abrigo passivo com cinco pratos ventilados de 140 mm de diâmetro, cobertura de 150 mm, fundo, suporte para uma placa SHT40, suporte de fixação e passagem inferior do cabo. O volume de referência da placa é 18 × 25 × 1,6 mm; precisa ser ajustado ao módulo efetivamente adquirido.

**Como funciona.** O ar circula pelas aberturas laterais entre os pratos. A cobertura e a disposição dos pratos sombreiam o sensor e reduzem o efeito de sol e chuva direta sobre a leitura. O SHT40 mede temperatura e umidade e envia os valores digitais ao ESP32 pela ligação I²C. A instalação prevista no conjunto posiciona o sensor aproximadamente a 1,5 m do solo, separado da caixa eletrônica e do calor de seus componentes.

**Instalação e validação.** Manter o sensor ventilado, sem tinta, cola ou vedação sobre o elemento sensível. Fazer alça de gotejamento no cabo. A posição definitiva deve evitar respingos, água que escorre do telhado e aquecimento por superfícies próximas. Comparar suas leituras com um instrumento de referência em diferentes condições externas. O abrigo modelado não tem classificação de estanqueidade certificada.

## 4. Pluviômetro — `pluviometro.scad`

**Quantidade:** um. **Medição:** chuva acumulada no local.

**Partes modeladas.** Funil com boca efetiva de 160 mm, filtro removível, báscula de duas conchas, eixo metálico, batentes reguláveis, ímã e suporte para contato magnético do tipo reed, carcaça com drenos e abas de fixação. Na montagem geral ele fica em um mastro próprio, fora da projeção do telhado.

**Como funciona.** A água entra pelo funil e cai em uma das conchas. Quando essa concha acumula volume suficiente, a báscula gira, esvazia a concha cheia e coloca a outra sob o funil. Um ímã na báscula passa pelo reed e produz um pulso elétrico. O ESP32 conta os pulsos e multiplica pela lâmina de chuva **calibrada por pulso**. Os drenos deixam a água sair sem recircular pelo mecanismo.

**Calibração.** A área da boca de 160 mm é aproximadamente **201,1 cm²**. O alvo inicial de 0,2 mm por basculada corresponde a cerca de **4,02 mL por basculada**, mas esse valor não é garantido pelo desenho. Deve-se aplicar água em volume e vazão conhecidos, após pré-molhar as conchas, verificar os dois sentidos da báscula e calcular o fator real. Para volume `V` em mL e `N` pulsos, a chuva equivalente é `10 × V / 201,1` mm e o fator é `k = 10 × V / (201,1 × N)` mm/pulso. Atrito, aderência de gotas, vazamentos e repiques do reed afetam a contagem. Instalar nivelado e limpar regularmente filtro, conchas e drenos.

## 5. Unidade eletrônica central — `unidade_eletronica_central.scad`

**Quantidade:** uma. **Função:** alimentar os circuitos, ler os sensores, datar as medições, guardá-las e enviá-las pela rede.

**Partes modeladas.** Caixa de 200 × 180 × 60 mm, tampa com canal para junta, bandeja removível, nove entradas de cabos e volumes representativos das placas. As entradas identificadas são duas para baterias (**BAT A/B**), cinco para balanças (**C01–C05**), uma para sensor ambiental (**AMB**) e uma para pluviômetro (**CHUVA**). Há espaço representado para ESP32, relógio DS3231, módulo microSD, três conversores de nível de quatro canais, reguladores, proteção elétrica, corte por subtensão e interconexões.

**Aquisição.** O ESP32 lê os cinco HX711 separadamente, recebe o SHT40 por I²C e conta os pulsos de chuva. O DS3231 mantém a referência de data e hora quando o controlador reinicia ou fica sem rede. O planejamento propõe um registro a cada **5 minutos** e envio por Wi-Fi em lotes a cada **15 minutos**. No perfil de economia de energia, os circuitos de pesagem são ligados apenas durante a janela de medição, após um tempo de estabilização; esse perfil depende de ensaio comparativo com alimentação contínua. O contador de chuva precisa permanecer ativo entre as janelas de leitura.

**Alimentação.** O plano econômico prevê duas baterias removíveis **VRLA 12 V / 7 Ah**, uma em uso e outra pronta para troca e recarga fora do local. A central representa entradas independentes, fusíveis e proteção contra inversão/retorno de corrente, corte por tensão baixa e conversão para as tensões exigidas pelos circuitos. As baterias e o carregador **não estão desenhados** nos modelos `.scad`. A autonomia real depende do consumo medido do conjunto; a rotina de troca deve ser definida após esse teste.

**Armazenamento e envio.** O microSD permite manter registros locais enquanto a rede está indisponível. O ESP32 envia os registros ao computador por Wi-Fi; o plano prevê serviço de recepção e banco SQLite com deduplicação, além de backup diário em mídia separada. Uma réplica externa no Firestore é opcional. Falha de internet não deve apagar dados ainda não confirmados pelo servidor. Registros precisam incluir identificação da caixa, horário, valores e estado de qualidade, para distinguir ausência de medição de um valor zero.

**Cuidados de implementação.** Os HX711 econômicos podem operar com alimentação/sinais diferentes dos níveis aceitos pelo ESP32; medir tensões e validar os conversores de nível antes de conectar as entradas. A lógica do microSD também deve ser verificada na placa comprada. Os desenhos das placas, furos, chicotes e prensa-cabos são envelopes de planejamento, não esquema elétrico ou pinagem de fabricação. A caixa impressa requer junta e prensa-cabos adequados, ensaio de vedação e atenção à condensação. O orçamento do PDF também considera uma caixa comercial vedada como alternativa para a instalação real.

## 6. Montagem geral — `montagem_sistema_meliponario.scad`

Este arquivo coloca as cinco balanças sob as colmeias na estante, instala a central em um painel diante do pilar esquerdo, fixa o abrigo ambiental próximo dela e posiciona o pluviômetro em mastro separado. Representa as rotas dos cabos até a central, inclusive os cinco canais C01–C05. Os traços dos cabos indicam caminho físico aproximado; **não** especificam bitola, conectores, proteção ou ligação pino a pino.

Na montagem inicial, a boca do pluviômetro está a aproximadamente 1,55 m do solo. A central e o abrigo ficam elevados e separados das plataformas, para não introduzir carga falsa nas balanças. A montagem permite conferir interferências, acesso às caixas e posição relativa dos instrumentos. A distância do pluviômetro e a exposição do abrigo devem ser revistas no local real.

## Sequência de funcionamento prevista

1. O controlador mantém a contagem de chuva e desperta para uma nova janela de medição.
2. Lê e filtra as cinco balanças, cada uma com calibração e estado de qualidade próprios; lê temperatura e umidade.
3. Associa data e hora, chuva acumulada e identificação às leituras; grava o registro no microSD.
4. Quando há Wi-Fi, envia os registros pendentes ao computador e só considera concluído o envio após confirmação de gravação no servidor.
5. O computador mantém o histórico para gráficos e comparação com o manejo; faz cópias periódicas dos dados.

Variações de massa refletem o conjunto inteiro apoiado na balança. Entrada de néctar, consumo de reservas, madeira úmida, alimentação, retirada de tampa e manejo podem produzir mudanças parecidas. Por isso, os gráficos devem ser lidos junto com observações da colônia, floradas e eventos registrados pelo meliponicultor.

Para valores de compra, pinagem proposta, critérios de teste e decisões de energia e backup, consulte o [planejamento técnico](planejamento_tecnico_meliponario.pdf). Para abrir e inspecionar os modelos no OpenSCAD, consulte o [README](README.md).
