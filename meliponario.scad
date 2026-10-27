/*
 * MELIPONÁRIO — cinco colmeias em estante externa coberta
 * Unidades: milímetros. Frente: lado Y negativo. Eixo Z: altura.
 * Distribuição: três caixas na prateleira inferior e duas na superior.
 * Modelo conceitual para planejamento espacial; sem sensores.
 * As medidas são propostas editáveis, não um projeto estrutural executivo.
 * Abrir no OpenSCAD: F5 = visualizar; F6 = renderizar a geometria.
 */

/* [Estante] */
largura_estante = 1540;
profundidade_estante = 600;
secao_pilar = 70;
altura_beiral = 1820;
altura_prateleira_inferior = 610; // superfície de apoio
altura_prateleira_superior = 1190;
espessura_prateleira = 28;

/* [Caixas iguais — quantidade fixa: 5] */
largura_caixa = 260;
profundidade_caixa = 260;
altura_corpo_caixa = 345;
espessura_parede = 22;
espessura_tampa = 26;
diametro_entrada = 18;

/* [Telhado] */
beiral_lateral = 130;
beiral_frontal = 170;
elevacao_cumeeira = 270;

/* [Visualização] */
mostrar_telhado = true;
mostrar_caixas = true;
mostrar_piso = false; // placa de referência opcional, não integra a estante

/* [Hidden] */
$fn = 48;
eps = 0.1;
madeira = [0.36, 0.22, 0.13];
madeira_clara = [0.72, 0.51, 0.30];
topo_caixa = [0.84, 0.70, 0.46];
metal = [0.22, 0.29, 0.30];
cores_caixas = [[0.27,0.53,0.49], [0.84,0.62,0.26],
                [0.64,0.33,0.24], [0.34,0.48,0.64], [0.59,0.65,0.37]];
px = (largura_estante-secao_pilar)/2;
py = (profundidade_estante-secao_pilar)/2;
largura_telhado = largura_estante + 2*beiral_lateral;
meia_profundidade_telhado = profundidade_estante/2 + beiral_frontal;
inclinacao = atan(elevacao_cumeeira/meia_profundidade_telhado);
comprimento_agua = sqrt(pow(meia_profundidade_telhado,2)+pow(elevacao_cumeeira,2));
z_cumeeira = altura_beiral + elevacao_cumeeira;
passo_caixas = (largura_estante-2*secao_pilar)/3;
altura_caixa = altura_corpo_caixa + espessura_tampa;

assert(largura_caixa+24 < passo_caixas, "As três caixas não cabem entre os pilares.");
assert(profundidade_caixa+60 < profundidade_estante-secao_pilar,
       "A caixa excede a profundidade disponível.");
assert(altura_prateleira_inferior+altura_caixa+100 < altura_prateleira_superior-90,
       "Falta espaço livre sobre as caixas inferiores.");
assert(altura_prateleira_superior+altura_caixa+100 < altura_beiral-100,
       "Falta espaço livre sobre as caixas superiores.");
assert(espessura_parede > 3 && 2*espessura_parede < min(largura_caixa,profundidade_caixa));
assert(altura_corpo_caixa > 120 && diametro_entrada > 0 && diametro_entrada < 50);

// Viga de seção quadrada ligando dois pontos; usada nos contraventamentos.
module viga_entre(a, b, secao) {
    v = b-a;
    comprimento = norm(v);
    translate(a)
        rotate(a=acos(v[2]/comprimento), v=[-v[1],v[0],0])
            translate([-secao/2,-secao/2,0]) cube([secao,secao,comprimento]);
}

module prateleira(z) {
    // Travessas sob o tablado, com acesso livre pela frente.
    color(madeira)
        for (y=[-py,py])
            translate([-largura_estante/2,y-24,z-90])
                cube([largura_estante,48,90-espessura_prateleira]);
    color(madeira)
        for (x=[-px,0,px])
            translate([x-23,-profundidade_estante/2,z-78])
                cube([46,profundidade_estante,78-espessura_prateleira]);
    // Tábuas com juntas discretas e superfície contínua nas áreas de apoio.
    color(madeira_clara)
        for (i=[0:5])
            translate([-largura_estante/2,
                       -profundidade_estante/2+i*profundidade_estante/6,
                       z-espessura_prateleira])
                cube([largura_estante,profundidade_estante/6-3,espessura_prateleira]);
}

module estante() {
    for (x=[-px,px], y=[-py,py]) {
        // Sapatas elevam a madeira acima do solo externo.
        color([0.60,0.61,0.58])
            translate([x-65,y-65,0]) cube([130,130,90]);
        color([0.22,0.24,0.24])
            translate([x-40,y-40,82]) cube([80,80,40]);
        color(madeira)
            translate([x-secao_pilar/2,y-secao_pilar/2,110])
                cube([secao_pilar,secao_pilar,altura_beiral-110]);
    }
    prateleira(altura_prateleira_inferior);
    prateleira(altura_prateleira_superior);
    color(madeira) {
        // Cruzamento traseiro em planos distintos, fixado às faces dos pilares.
        viga_entre([-px,py+17,300],[px,py+17,altura_beiral-110],32);
        viga_entre([px,py+51,300],[-px,py+51,altura_beiral-110],32);
        for (x=[-px,px]) {
            translate([x-35,-profundidade_estante/2,altura_beiral-95])
                cube([70,profundidade_estante,95]);
            viga_entre([x,-py,altura_prateleira_superior+90],
                       [x,py,altura_beiral-90],38);
        }
        for (y=[-py,py])
            translate([-largura_estante/2,y-35,altura_beiral-75])
                cube([largura_estante,70,75]);
    }
}

// Cilindro perpendicular à face frontal, apontando para dentro da caixa.
module furo_frontal(r, comprimento) {
    rotate([-90,0,0]) cylinder(r=r,h=comprimento);
}

module colmeia(numero, tonalidade) {
    w = largura_caixa;
    d = profundidade_caixa;
    h = altura_corpo_caixa;
    t = espessura_parede;
    entrada_z = 66;
    color(tonalidade)
    difference() {
        translate([-w/2,-d/2,0]) cube([w,d,h]);
        // Interior oco com fundo; a tampa fecha o volume superior.
        translate([-w/2+t,-d/2+t,t]) cube([w-2*t,d-2*t,h]);
        translate([0,-d/2-eps,entrada_z])
            furo_frontal(diametro_entrada/2,t+2*eps);
        // Duas linhas rebaixadas sugerem os três módulos empilhados.
        for (z=[h/3,2*h/3])
            translate([0,0,z]) difference() {
                translate([-w/2-1,-d/2-1,0]) cube([w+2,d+2,3]);
                translate([-w/2+2,-d/2+2,-eps]) cube([w-4,d-4,3+2*eps]);
            }
    }
    color(topo_caixa) {
        translate([-w/2-12,-d/2-12,h]) cube([w+24,d+24,espessura_tampa]);
        // Pequena plataforma de pouso e aro da entrada.
        translate([-44,-d/2-42,entrada_z-22]) cube([88,44,10]);
        translate([0,-d/2-8,entrada_z]) difference() {
            furo_frontal(diametro_entrada/2+7,9);
            translate([0,-eps,0]) furo_frontal(diametro_entrada/2,9+2*eps);
        }
        for (s=[-1,1])
            translate([s*(w/2+7)-9,-50,2*h/3+25]) cube([18,100,22]);
    }
    // Identificação das cinco posições, útil em futuras revisões do modelo.
    color([0.20,0.23,0.21])
        translate([-29,-d/2-3,h-67]) cube([58,4,36]);
    color([0.96,0.92,0.80])
        translate([0,-d/2-2.9,h-49]) rotate([90,0,0])
            linear_extrude(height=0.8)
                text(str("0",numero),size=21,halign="center",valign="center",
                     font="DejaVu Sans:style=Bold");
}

module cobertura() {
    // Duas águas em chapa, com nervuras que acompanham o escoamento.
    for (s=[-1,1]) {
        color(metal)
            translate([0,0,z_cumeeira]) rotate([-s*inclinacao,0,0])
                scale([1,s,1]) {
                    translate([-largura_telhado/2,0,0])
                        cube([largura_telhado,comprimento_agua,8]);
                    for (x=[-largura_telhado/2+30:100:largura_telhado/2-20])
                        translate([x,0,7]) cube([9,comprimento_agua,9]);
                }
        // Caibros sob cada água, sobre os dois pórticos laterais.
        color(madeira)
            for (x=[-px,px])
                translate([x,0,z_cumeeira]) rotate([-s*inclinacao,0,0])
                    scale([1,s,1])
                        translate([-30,0,-65]) cube([60,comprimento_agua,65]);
    }
    color(madeira)
        translate([-largura_estante/2,-25,z_cumeeira-65])
            cube([largura_estante,50,65]);
    // Arremate contínuo sobre o encontro das duas chapas.
    color([0.29,0.36,0.37])
        translate([-largura_telhado/2,0,z_cumeeira+7])
            rotate([0,90,0]) cylinder(r=18,h=largura_telhado,$fn=4);
}

estante();
if (mostrar_caixas) {
    for (i=[0:2])
        translate([(i-1)*passo_caixas,-12,altura_prateleira_inferior])
            colmeia(i+1,cores_caixas[i]);
    for (i=[0:1])
        translate([(i-0.5)*passo_caixas,-12,altura_prateleira_superior])
            colmeia(i+4,cores_caixas[i+3]);
}
if (mostrar_telhado) cobertura();
if (mostrar_piso)
    color([0.72,0.74,0.65])
        translate([-1100,-750,-30]) cube([2200,1500,30]);
