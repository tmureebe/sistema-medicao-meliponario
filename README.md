# Autoria

**Autores**: Thiago Mureebe Carrijo e Alícia Alves Carrijo Bueno Mureebe.

# Modelos do sistema do meliponário

Este conjunto de modelos mostra uma proposta de meliponário com cinco colmeias de abelhas sem ferrão e instrumentos para acompanhar o ambiente. A ideia é observar, ao longo do tempo, a massa de cada caixa, a temperatura e a umidade do ar e a chuva no local. Isso pode ajudar a comparar períodos, floradas e mudanças de manejo.

Uma variação de massa, sozinha, não diz se a colônia está bem nem mede diretamente sua população ou a produção de mel. Ela precisa ser interpretada junto com a espécie, a época do ano, as condições de florada e as observações do meliponicultor. O sensor de temperatura e umidade mede o **ambiente externo**, não o interior das caixas.

Os arquivos são modelos visuais editáveis feitos no OpenSCAD. Servem para examinar formas e disposição geral; não são, por si só, projeto estrutural da estante, circuito pronto nem garantia de que uma peça esteja calibrada para uso.

## Instalar o OpenSCAD no Windows

1. Abra a [página oficial de downloads do OpenSCAD](https://openscad.org/downloads.html).
2. Na seção **Windows**, baixe o instalador **x86 (64-bit) - exe installer**, se o computador for Windows de 64 bits, como a maioria dos computadores atuais.
3. Abra o arquivo baixado e siga as etapas de instalação. Ao terminar, inicie o OpenSCAD pelo menu Iniciar.

Se não souber qual versão escolher, consulte **Configurações → Sistema → Sobre → Tipo de sistema** no Windows. A página oficial também oferece outros pacotes para Windows. Use a versão estável indicada em **Releases**, em vez de uma versão de desenvolvimento. [Página oficial de downloads](https://openscad.org/downloads.html)

## Abrir e navegar pelos modelos

1. Salve **todos os arquivos `.scad` recebidos na mesma pasta**. Isso é necessário para abrir o arquivo de montagem geral, que reúne os outros modelos.
2. No OpenSCAD, escolha **File → Open** e selecione o arquivo que deseja ver.
3. Pressione **F5** para atualizar a prévia colorida. Essa é a forma recomendada para conhecer os modelos.
4. Se precisar, pressione **F6** para renderizar a geometria completa. A montagem do sistema reúne muitas peças e pode levar um tempo para renderizar.
5. Na área do modelo, arraste com o botão esquerdo para girar, com o direito para mover a vista e use a roda do mouse para aproximar ou afastar.

As opções de visualização ficam no painel **Customizer**. Se ele não estiver visível, procure a opção correspondente no menu **View**. Em alguns arquivos, os nomes das opções aparecem em português e sem acentos, por exemplo `vista` ou `mont_mostrar_telhado`.

## O que há em cada arquivo

**Os arquivos abaixo estão dentro da pasta compactada modelos_3d.zip**.

### [montagem_sistema_meliponario.scad](montagem_sistema_meliponario.scad)

É o arquivo principal para ver o projeto como um todo: estante coberta, cinco colmeias nas prateleiras, uma unidade de pesagem sob cada caixa, a caixa eletrônica central, o abrigo de temperatura e umidade e o pluviômetro em um mastro separado.

Ele usa os outros cinco arquivos `.scad`. Por isso, mantenha os nomes originais e deixe todos juntos na mesma pasta.

Na prévia inicial, o telhado, as colmeias e os cabos estão visíveis. No painel **Customizer**, é possível:

- desmarcar `mont_mostrar_telhado` para ver as caixas e os equipamentos;
- desmarcar `mont_mostrar_colmeias` para examinar as balanças;
- desmarcar `mont_mostrar_cabos` para simplificar a vista;
- marcar `mont_central_aberta` para ver a representação dos módulos dentro da caixa eletrônica;
- desmarcar `mont_mostrar_solo` para ocultar a placa de referência do terreno.

O pluviômetro aparece afastado da estante e do telhado, em um suporte próprio. A distância é ilustrativa e pode ser alterada no painel.

### [meliponario.scad](meliponario.scad)

Mostra a estante externa coberta e as cinco colmeias, sem os instrumentos. É útil para ver apenas a disposição das caixas. As opções `mostrar_telhado` e `mostrar_caixas` permitem ocultar essas partes.

### [unidade_pesagem.scad](unidade_pesagem.scad)

Mostra uma unidade de pesagem para uma caixa: base, plataforma, célula de carga, proteções e uma pequena caixa para o módulo de leitura. A vista inicial está sem a plataforma, para deixar o mecanismo visível.

No painel **Customizer**, altere `vista` para:

- `montada`, para ver a unidade com a plataforma;
- `sem_plataforma`, para observar o mecanismo;
- `explodida`, para separar visualmente as partes.

### [unidade_temperatura_umidade.scad](unidade_temperatura_umidade.scad)

Mostra o abrigo ventilado para o sensor ambiental SHT40, com pratos sobrepostos, suporte e passagem do cabo. A vista inicial é em corte, deixando o interior visível. Em `vista`, escolha `montada` para ver o abrigo fechado ou `explodida` para separar as peças.

### [pluviometro.scad](pluviometro.scad)

Mostra o pluviômetro de báscula dupla, com funil, filtro, drenos, suporte e sensor de passagem. A vista inicial deixa o interior à mostra. Use `vista` para escolher `montada` ou `explodida`. O campo `angulo_bascula` permite observar a báscula em diferentes posições; a opção `animar` mostra um movimento ilustrativo.

### [unidade_eletronica_central.scad](unidade_eletronica_central.scad)

Mostra a caixa central, a bandeja removível e representações dos módulos, das conexões e das entradas de cabos. A vista inicial é aberta para facilitar a visualização. Em `vista`, escolha `montada` para fechar a tampa ou `explodida` para separar tampa e bandeja.

Os módulos desenhados representam os componentes previstos para o sistema; as dimensões e os apoios devem ser ajustados às placas que forem compradas.

## Dica rápida

Para uma primeira apresentação, abra `montagem_sistema_meliponario.scad` e pressione **F5**. Depois, abra os arquivos individuais para mostrar os detalhes de cada unidade. O arquivo principal depende dos cinco modelos individuais: envie os seis `.scad` juntos, sem renomeá-los.
