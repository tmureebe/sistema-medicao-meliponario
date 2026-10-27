/*
 MONTAGEM DO SISTEMA NO MELIPONÁRIO — unidades em mm, frente em Y negativo.
 Manter este arquivo na mesma pasta dos cinco SCAD referenciados abaixo.
 Cada include está isolado em um módulo: nomes como conjunto(), vista, largura
 e espessura_tampa não se misturam entre os modelos. Os originais são preservados.

 Instalação: 3 colmeias embaixo, 2 em cima, cada uma sobre sua própria balança.
 O deslocamento vertical da colmeia vem de z_topo do arquivo da balança, não de
 uma cópia fixa dessa medida. A estante mantém as dimensões do meliponario.scad.
 Folga atual mínima acima das caixas inferiores: 64,3 mm até a viga superior;
 conferir manuseio das tampas no protótipo antes de construir a estante.

 Central na frente do pilar esquerdo, em painel de fixação adicional; prensa-cabos
 apontam para baixo. SHT40 em abrigo frontal, aproximadamente a 1,50 m do solo.
 A posição do abrigo é proposta espacial: conferir gotejamento, radiação e efeito
 térmico da cobertura no local. Chicote ambiental curto; validar I2C montado.
 Pluviômetro em mastro INDEPENDENTE, fora da projeção do telhado. Distância editável;
 verificar obstáculos reais e exposição. Seu suporte tem abertura sob os drenos.

 Os chicotes representam trajetos, não condutores individuais/esquema elétrico.
 Saem do lado FIXO das balanças, contornam as plataformas e não prendem a colmeia.
 Prever presilhas, proteção mecânica do trecho externo e alças de gotejamento.
 Baterias externas e carregador não possuem SCAD próprio e não foram inventados
 nesta montagem; entradas BAT A/B permanecem disponíveis na central.

 F5 recomendado para examinar o sistema em cores. Desligar telhado/colmeias para
 inspecionar os apoios. Central fechada omite sua eletrônica interna para agilizar
 o conjunto; abrir a central ativa a representação completa do arquivo original.
 F6 é mais demorado devido às cinco balanças e aos componentes detalhados.
 Este é um modelo de montagem/planejamento; imprimir peças nos SCAD individuais.
 Painel, mastro e suporte do pluviômetro representam madeira/metal, não peças FDM.
 */

/* [Inspeção da montagem] */
mont_mostrar_telhado = true;
mont_mostrar_colmeias = true;
mont_mostrar_cabos = true;
mont_central_aberta = false;
mont_mostrar_solo = true;

/* [Instalação da central e do ambiente] */
mont_altura_central = 1300; // Centro da caixa, instalada verticalmente.
mont_altura_base_ambiente = 1430; // SHT40 fica aproximadamente 71 mm acima.
mont_espessura_painel = 12;
mont_largura_painel = 230;
mont_altura_painel = 390;
mont_base_painel = 1120;
mont_folga_servico_minima = 60;

/* [Mastro independente do pluviômetro] */
mont_x_pluviometro = 2100;
mont_y_pluviometro = -1100;
mont_altura_base_pluviometro = 1400; // Boca fica aproximadamente a 1547 mm.
mont_diametro_mastro = 40;

/* [Hidden] */
$fn=36;
mont_cor_painel=[0.49,0.35,0.22];
mont_cor_metal=[0.34,0.40,0.42];

// Adaptador: importa a balança em escopo próprio e eleva apenas seus filhos.
module mont_balanca_com_colmeia(numero,z_prateleira,z_limite,h_colmeia) {
    include <unidade_pesagem.scad>
    vista="montada";
    peca="conjunto";
    mostrar_envelope_colmeia=false;
    assert(z_limite-z_prateleira-z_topo-h_colmeia>=mont_folga_servico_minima,
           str("Folga de serviço insuficiente na colmeia ",numero));
    echo(str("C0",numero," — altura da balança / folga superior (mm):"),
         z_topo,z_limite-z_prateleira-z_topo-h_colmeia);
    translate([0,0,z_topo]) children();
}

module mont_central() {
    include <unidade_eletronica_central.scad>
    peca="conjunto";
    vista=mont_central_aberta ? "aberta" : "montada";
    mostrar_modulos=mont_central_aberta;
    mostrar_chicotes=mont_central_aberta;
    mostrar_area_antena=false;
}

module mont_ambiente() {
    include <unidade_temperatura_umidade.scad>
    peca="conjunto";
    vista="montada";
}

module mont_pluviometro() {
    include <pluviometro.scad>
    peca="conjunto";
    vista="montada";
    animar=false;
    // Anel metálico: abertura central deixa livres os oito drenos da base.
    color(mont_cor_metal) translate([0,0,-6]) difference() {
        cylinder(d=184,h=6);
        translate([0,0,-0.1]) cylinder(d=102,h=6.2);
        for(a=angulos_fixacao) pos_radial(a,rb+12,-0.1) cylinder(d=5.5,h=6.2);
    }
    // Aranha sob o anel. Braços entre as linhas de descarga, sem tampá-las.
    color(mont_cor_metal) for(a=[90,210,330]) rotate([0,0,a])
        translate([0,-5,-12]) cube([84,10,6]);
    color(mont_cor_metal) translate([0,0,90-mont_altura_base_pluviometro])
        cylinder(d=mont_diametro_mastro,h=mont_altura_base_pluviometro-102);
    color([0.60,0.61,0.58]) translate([0,0,-mont_altura_base_pluviometro])
        cylinder(d=180,h=90);
}

module mont_chicote(pontos,cor=[0.16,0.20,0.23],diametro=4) {
    color(cor) for(i=[0:len(pontos)-2]) hull() {
        translate(pontos[i]) sphere(d=diametro,$fn=12);
        translate(pontos[i+1]) sphere(d=diametro,$fn=12);
    }
}

function mont_comprimento(pontos,i=0)= i>=len(pontos)-1 ? 0 :
    norm(pontos[i+1]-pontos[i])+mont_comprimento(pontos,i+1);

module mont_sistema() {
    // Este include constrói somente a estante e, opcionalmente, sua cobertura.
    // As caixas originais são suprimidas; são instanciadas abaixo sobre balanças.
    include <meliponario.scad>
    mostrar_caixas=false;
    mostrar_telhado=mont_mostrar_telhado;
    mostrar_piso=false;

    x_central=-px;
    y_painel=-profundidade_estante/2-mont_espessura_painel;
    y_ambiente=y_painel-110; // Referência ao braço de 110 mm do abrigo atual.
    y_prensas=y_painel-29; // z_prensas do modelo central, após rotação de 90°.
    z_pontas=mont_altura_central-94; // Encontro com os chicotes internos da central.
    posicoes=[
        [-passo_caixas,-12,altura_prateleira_inferior],
        [0,-12,altura_prateleira_inferior],
        [passo_caixas,-12,altura_prateleira_inferior],
        [-passo_caixas/2,-12,altura_prateleira_superior],
        [passo_caixas/2,-12,altura_prateleira_superior]
    ];
    assert(300<passo_caixas && profundidade_estante>360,
           "Plataformas de pesagem sem espaço nesta estante.");
    assert(mont_altura_central+106<mont_altura_base_ambiente-6,
           "Central invade o suporte do abrigo ambiental.");
    assert(mont_altura_central-106>mont_base_painel &&
           mont_altura_base_ambiente+54<mont_base_painel+mont_altura_painel,
           "Painel de montagem não cobre as fixações.");
    assert(mont_x_pluviometro-92>largura_telhado/2 &&
           mont_y_pluviometro+92 < -meia_profundidade_telhado,
           "Pluviômetro precisa ficar fora da projeção do telhado.");

    for(i=[0:4]) translate(posicoes[i])
        mont_balanca_com_colmeia(i+1,posicoes[i][2],
            i<3?altura_prateleira_superior-90:altura_beiral-100,altura_caixa)
            if(mont_mostrar_colmeias) colmeia(i+1,cores_caixas[i]);

    // Painel apoiado à face frontal do pilar; não depende de uma colmeia/balança.
    color(mont_cor_painel)
        translate([x_central-mont_largura_painel/2,y_painel,mont_base_painel])
            cube([mont_largura_painel,mont_espessura_painel,mont_altura_painel]);
    // Z local da central passa a apontar para a frente; Y local passa a ser vertical.
    translate([x_central,y_painel,mont_altura_central]) rotate([90,0,0]) mont_central();
    // O braço do abrigo aponta para trás e encosta no mesmo painel de montagem.
    translate([x_central,y_ambiente,mont_altura_base_ambiente]) rotate([0,0,180]) mont_ambiente();
    translate([mont_x_pluviometro,mont_y_pluviometro,mont_altura_base_pluviometro]) mont_pluviometro();

    if(mont_mostrar_cabos) {
        // C01-C05: saída digital do HX711, contorno lateral da base fixa e fundo da estante.
        for(i=[0:4]) {
            p=posicoes[i];
            x_bus=i<3 ? -px+55 : x_central+mont_largura_painel/2+15;
            x_descida=x_central+mont_largura_painel/2+15;
            x_porta=x_central-40+20*i;
            rota=[
                [p[0]+39,p[1]-110,p[2]+22],
                [p[0]+52,p[1]-110,p[2]+22],
                [p[0]+70,p[1]-75,p[2]+22],
                [p[0]+160,p[1]-75,p[2]+22],
                [p[0]+160,190,p[2]+22],
                [x_bus,190+i*5,p[2]+22],
                [x_bus,y_painel-18,p[2]+22],
                [x_descida,y_painel-18,p[2]+22],
                [x_descida,y_painel-42,z_pontas-35-i*3],
                [x_porta,y_prensas,z_pontas-35-i*3],
                [x_porta,y_prensas,z_pontas]
            ];
            mont_chicote(rota,[0.18,0.27+0.025*i,0.32],4);
        }
        rota_ambiente=[
            [x_central-28,y_ambiente+8,mont_altura_base_ambiente-8],
            [x_central-28,y_ambiente+23,mont_altura_base_ambiente-32],
            [x_central-10,y_painel-78,mont_altura_central+20],
            [x_central+60,y_painel-78,z_pontas-20],
            [x_central+60,y_prensas,z_pontas-20],
            [x_central+60,y_prensas,z_pontas]
        ];
        mont_chicote(rota_ambiente,[0.16,0.40,0.31],3);
        echo("Chicote ambiental externo representado (mm), somar trechos internos:",
             mont_comprimento(rota_ambiente));
        // Descida no mastro e rota baixa esquemática, independente das colmeias.
        mont_chicote([
            [mont_x_pluviometro,mont_y_pluviometro+63,mont_altura_base_pluviometro+12],
            // Contorna a borda do anel antes de descer; não atravessa a chapa.
            [mont_x_pluviometro,mont_y_pluviometro+104,mont_altura_base_pluviometro+12],
            [mont_x_pluviometro,mont_y_pluviometro+104,mont_altura_base_pluviometro-30],
            [mont_x_pluviometro,mont_y_pluviometro+28,mont_altura_base_pluviometro-50],
            [mont_x_pluviometro,mont_y_pluviometro+28,150],
            [mont_x_pluviometro-200,mont_y_pluviometro+28,80],
            [x_central+140,-500,80],
            [x_central+140,y_painel-78,z_pontas-40],
            [x_central+80,y_prensas,z_pontas-26],
            [x_central+80,y_prensas,z_pontas]
        ],[0.28,0.30,0.20],4);
    }
    if(mont_mostrar_solo) %color([0.68,0.72,0.62,0.4])
        translate([-1100,mont_y_pluviometro-220,-8])
            cube([mont_x_pluviometro+1350,profundidade_estante/2-mont_y_pluviometro+650,8]);
    echo("Montagem: cinco colmeias + cinco balanças + ambiente + central + pluviômetro.");
}

mont_sistema();
