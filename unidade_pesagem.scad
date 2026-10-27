/*
 UNIDADE DE PESAGEM — uma balança para caixa de abelhas sem ferrão.
 Arquivo independente, sem importar o meliponário. Unidades: mm.

 Referência de célula: Bit Maker, barra 20 kg, 80 x 12,7 x 12,7 mm,
 2 fixações M5 e 2 M4. https://www.bitmaker.com.br/sensor-de-peso-c-lula-de-carga-20kg
 O passo dos furos e a atribuição de cada extremidade são HIPÓTESES ajustáveis:
 medir o lote recebido. Furos da célula e parafusos são simplificados, sem rosca.
 Não usar esta representação para fabricar a própria célula de carga.

 CAMINHO DE CARGA: plataforma -> chapa superior -> calço móvel -> célula
 -> calço fixo -> chapa inferior -> base. Nenhum outro apoio toca a plataforma.
 Centro do calço móvel em X=0, Y=0, sob o centro da caixa.
 A região flexível da célula não toca calços, tampas, cabos ou chapa de reforço.

 MATERIAIS:
 base e plataforma: compensado naval selado (12 mm iniciais) ou material rígido
 redimensionado; chapas, calços, batentes e ferragens: METAL.
 Caixa/tampa HX711: acessórios imprimíveis em ASA/PETG protegido, não estruturais.
 Não imprimir a montagem inteira para usar como balança.
 A caixa impressa não tem classificação IP certificada: vedar tampa e passagens.

 A folga do batente é apenas ilustrativa. Ajustá-la após medir a deflexão real,
 de modo que não toque em toda a faixa útil e atue antes da sobrecarga.
 Ensaiar carga excêntrica e deriva antes de colocar uma colmeia viva.
 A geometria não certifica rigidez, precisão nem capacidade de carga.

 F5: cores e visualização; F6: geometria completa.
 Use vista="explodida" ou "sem_plataforma" para inspecionar a montagem.
 Use peca="caixa_hx711" ou "tampa_hx711" para exportar cada acessório em STL.
 O quadro verde opcional é só uma referência da base da colmeia (260 x 260).
 Parafusos comerciais: escolher comprimento/engate após medir célula e placas;
 nunca permitir que a ponta do parafuso encoste no outro suporte ou force a célula.
 */

/* [Visualização] */
vista = "sem_plataforma"; // [montada,sem_plataforma,explodida]
peca = "conjunto"; // [conjunto,base_fixa,plataforma_movel,chapa_fixa,chapa_movel,calco_fixo,calco_movel,caixa_hx711,tampa_hx711]
mostrar_ferragens = true;
mostrar_eletronica = true;
mostrar_cabo = true;
mostrar_envelope_colmeia = false;
passo_explosao = 25;

/* [Placas rígidas — não são peças para imprimir] */
largura = 300;
profundidade = 300;
espessura_base = 12;
espessura_plataforma = 12;
raio_canto = 8;
largura_colmeia = 260;
profundidade_colmeia = 260;
espessura_chapa = 3;
altura_calco = 6;

/* [Célula de carga — conferir furação e roscas do lote] */
comprimento_celula = 80;
largura_celula = 12.7;
altura_celula = 12.7;
distancia_entre_apoios = 60;
passo_furos_fixo = 10;
passo_furos_movel = 10;
diametro_furo_fixo = 5;
diametro_furo_movel = 4;
comprimento_calco = 22;
largura_calco = 24;

/* [Proteções mecânicas — folgas ilustrativas, ajustar no ensaio] */
recuo_batente = 38;
folga_batente = 1.0;
diametro_batente = 6;
folga_retencao_vertical = 2;
diametro_retencao = 4;
diametro_furo_retencao = 10;
recuo_retencao = 10;

/* [Caixa do HX711 — conferir placa e vedação] */
caixa_largura = 80;
caixa_profundidade = 44;
caixa_altura = 20;
parede_caixa = 2.4;
espessura_tampa = 2.4;
diametro_passagem_cabo = 5;

/* [Hidden] */
$fn=48;
eps=0.04;
folga_furo=0.5;
madeira=[0.70,0.50,0.29];
madeira_topo=[0.84,0.68,0.44];
aluminio=[0.74,0.78,0.79];
aco=[0.36,0.42,0.44];
plastico=[0.16,0.36,0.37];
x_fixo=-distancia_entre_apoios;
x_celula=-distancia_entre_apoios/2;
z_chapa_fixa=espessura_base;
z_calco_fixo=z_chapa_fixa+espessura_chapa;
z_celula=z_calco_fixo+altura_calco;
z_calco_movel=z_celula+altura_celula;
z_chapa_movel=z_calco_movel+altura_calco;
z_plataforma=z_chapa_movel+espessura_chapa;
z_topo=z_plataforma+espessura_plataforma;
bx=largura/2-recuo_batente;
by=profundidade/2-recuo_batente;
rx=largura/2-recuo_retencao;
hx_y=-profundidade/2+caixa_profundidade/2+18;
furos_caixa_x=caixa_largura/2-6;
furos_caixa_y=caixa_profundidade/2-6;
expl= vista=="explodida" ? passo_explosao : 0;

assert(vista=="montada" || vista=="sem_plataforma" || vista=="explodida",
       "Vista desconhecida.");
assert(largura>=largura_colmeia+30 && profundidade>=profundidade_colmeia+20,
       "Plataforma pequena: conferir envelope da colmeia e retentores.");
assert(rx-diametro_furo_retencao/2>largura_colmeia/2,
       "Retentor invade a base de apoio da colmeia.");
assert(distancia_entre_apoios/2+max(passo_furos_fixo,passo_furos_movel)/2
       +max(diametro_furo_fixo,diametro_furo_movel)/2 < comprimento_celula/2,
       "Furação ultrapassa as extremidades da célula.");
assert(comprimento_calco>max(passo_furos_fixo,passo_furos_movel)+8);
assert(folga_batente>0 && folga_batente<5 && folga_retencao_vertical>0);
assert(z_plataforma-espessura_base>caixa_altura+espessura_tampa+2,
       "Caixa HX711 encosta na plataforma móvel.");
assert(x_fixo-40>-largura/2+5,"Chapa fixa ultrapassa a base.");

// Cubo de cantos arredondados apenas em XY; fundo sempre em Z=0.
module placa(w,d,h,r=3) {
    linear_extrude(height=h)
        offset(r=r) square([w-2*r,d-2*r],center=true);
}

module furo(x,y,z,d,h) {
    translate([x,y,z]) cylinder(d=d,h=h);
}

module furos_apoio(x,passo,d,z,h) {
    for (s=[-1,1]) furo(x+s*passo/2,0,z,d,h);
}

module base_fixa() {
    difference() {
        placa(largura,profundidade,espessura_base,raio_canto);
        furos_apoio(x_fixo,passo_furos_fixo,diametro_furo_fixo+folga_furo,-eps,espessura_base+2*eps);
        // Rebaixo inferior deixa cabeça M5 embutida, base plana na prateleira.
        furos_apoio(x_fixo,passo_furos_fixo,9.5,-eps,5+eps);
        for (x=[-bx,bx],y=[-by,by]) {
            furo(x,y,-eps,diametro_batente+folga_furo,espessura_base+2*eps);
            // Porca inferior embutida; conserva a face inferior plana.
            furo(x,y,-eps,13,6+eps);
        }
        for (x=[-rx,rx]) {
            furo(x,0,-eps,diametro_retencao+folga_furo,espessura_base+2*eps);
            furo(x,0,-eps,9,6+eps);
        }
        // Quatro furos para fixar a base à prateleira; ancoragens não incluídas.
        for (x=[-largura/2+16,largura/2-16],y=[-profundidade/2+16,profundidade/2-16]) {
            furo(x,y,-eps,5.5,espessura_base+2*eps);
            furo(x,y,espessura_base-4,10,4+eps);
        }
        for(x=[-caixa_largura/2-5,caixa_largura/2+5])
            furo(x,hx_y,-eps,3.4,espessura_base+2*eps);
    }
}

module plataforma_movel() {
    difference() {
        placa(largura,profundidade,espessura_plataforma,raio_canto);
        furos_apoio(0,passo_furos_movel,diametro_furo_movel+folga_furo,-eps,espessura_plataforma+2*eps);
        // Cabeças M4 abaixo da superfície de apoio.
        furos_apoio(0,passo_furos_movel,8,espessura_plataforma-4,4+eps);
        for(x=[-rx,rx]) furo(x,0,-eps,diametro_furo_retencao,espessura_plataforma+2*eps);
    }
}

module chapa(fixa=true) {
    difference() {
        placa(80,50,espessura_chapa,3);
        furos_apoio(0,fixa?passo_furos_fixo:passo_furos_movel,
                    (fixa?diametro_furo_fixo:diametro_furo_movel)+folga_furo,
                    -eps,espessura_chapa+2*eps);
    }
}

module calco(fixo=true) {
    difference() {
        placa(comprimento_calco,largura_calco,altura_calco,1);
        furos_apoio(0,fixo?passo_furos_fixo:passo_furos_movel,
                    (fixo?diametro_furo_fixo:diametro_furo_movel)+folga_furo,
                    -eps,altura_calco+2*eps);
    }
}

module celula() {
    // Envelope e rebaixo central esquemáticos, não desenho do elemento elástico.
    color(aluminio)
    difference() {
        translate([-comprimento_celula/2,-largura_celula/2,0])
            cube([comprimento_celula,largura_celula,altura_celula]);
        // Folga gráfica de 0,15 mm evita contatos degenerados com a haste lisa.
        // É simplificação das roscas; não é tolerância de usinagem/furação.
        furos_apoio(-distancia_entre_apoios/2,passo_furos_fixo,diametro_furo_fixo+0.15,-eps,altura_celula+2*eps);
        furos_apoio(distancia_entre_apoios/2,passo_furos_movel,diametro_furo_movel+0.15,-eps,altura_celula+2*eps);
        for(x=[-5,5])
            translate([x,-largura_celula/2-eps,altura_celula/2])
                rotate([-90,0,0]) cylinder(d=7,h=largura_celula+2*eps);
    }
    // Proteção dos extensômetros: apenas visual, sem sustentação externa.
    color([0.93,0.94,0.91])
        for(s=[-1,1]) translate([-12,s*largura_celula/2-(s<0?0.6:0),altura_celula/2-4.5])
            cube([24,0.6,9]);
}

module porca(d=6,h=5,diam_ext=10.4) {
    difference() {
        cylinder(d=diam_ext,h=h,$fn=6);
        translate([0,0,-eps]) cylinder(d=d+0.2,h=h+2*eps);
    }
}

module parafuso(d,h,cabeca_d,cabeca_h) {
    // Haste sobe desde Z=0; cabeça em sua extremidade superior.
    cylinder(d=d,h=h);
    translate([0,0,h]) difference() {
        cylinder(d=cabeca_d,h=cabeca_h);
        translate([0,0,cabeca_h-1.6]) cylinder(d=d*0.8,h=1.6+eps,$fn=6);
    }
}

module batentes() {
    for(x=[-bx,bx],y=[-by,by]) {
        color(aco) translate([x,y,2])
            parafuso(diametro_batente,z_plataforma-folga_batente-3-2,12,3);
        color(aluminio) {
            // Porcas opostas travam o ajuste na base (rosca não modelada).
            translate([x,y,espessura_base]) porca(6,5,11.5);
            translate([x,y,1]) porca(6,5,11.5);
        }
    }
}

module retentores() {
    for(x=[-rx,rx]) {
        // Passagem livre na plataforma e cabeça acima dela: não pesa normalmente.
        color(aco) translate([x,0,2])
            parafuso(diametro_retencao,z_topo+folga_retencao_vertical-2,13,4);
        color(aluminio) translate([x,0,espessura_base]) porca(4,3.2,7.5);
        color(aluminio) translate([x,0,2.8]) porca(4,3.2,7.5);
    }
}

module parafusos_celula() {
    // Parafusos M5 inseridos por baixo, engate visual de 5 mm na célula.
    color(aco) for(s=[-1,1])
        translate([x_fixo+s*passo_furos_fixo/2,0,z_celula+5])
            rotate([180,0,0]) parafuso(diametro_furo_fixo,z_celula,9,5);
    // Parafusos M4 inseridos por cima; engate visual, confirmar comprimento real.
    color(aco) for(s=[-1,1])
        translate([s*passo_furos_movel/2,0,z_calco_movel-5+6*expl])
            parafuso(diametro_furo_movel,z_topo-4-(z_calco_movel-5),7.5,4);
}

module caixa_hx711() {
    difference() {
        union() {
            difference() {
                placa(caixa_largura,caixa_profundidade,caixa_altura,4);
                translate([0,0,parede_caixa])
                    placa(caixa_largura-2*parede_caixa,caixa_profundidade-2*parede_caixa,
                          caixa_altura,2);
            }
            // Quatro pilares roscáveis para tampa (parafuso M3, piloto 2,6 mm).
            for(x=[-furos_caixa_x,furos_caixa_x],y=[-furos_caixa_y,furos_caixa_y])
                translate([x,y,0]) cylinder(d=8,h=caixa_altura);
            for(x=[-caixa_largura/2-4,caixa_largura/2+4])
                translate([x,0,0]) placa(16,16,3,3);
        }
        for(x=[-furos_caixa_x,furos_caixa_x],y=[-furos_caixa_y,furos_caixa_y])
            furo(x,y,4,2.6,caixa_altura);
        for(x=[-caixa_largura/2-5,caixa_largura/2+5]) furo(x,0,-eps,3.4,4);
        // Passagens para cabo da célula e chicote digital; instalar vedação adequada.
        for(x=[-caixa_largura/2-1,caixa_largura/2-parede_caixa-1])
            translate([x,0,10]) rotate([0,90,0])
                cylinder(d=diametro_passagem_cabo,h=parede_caixa+3);
    }
}

module tampa_hx711() {
    difference() {
        placa(caixa_largura,caixa_profundidade,espessura_tampa,4);
        for(x=[-furos_caixa_x,furos_caixa_x],y=[-furos_caixa_y,furos_caixa_y])
            furo(x,y,-eps,3.4,espessura_tampa+2*eps);
    }
    // Texto baixo: a tampa é exportada com a face plana na mesa de impressão.
    translate([0,0,espessura_tampa-eps])
        linear_extrude(height=0.5+eps)
            text("HX711",size=8,halign="center",valign="center",font="DejaVu Sans:style=Bold");
}

module pcb_hx711() {
    // Representação espacial, não definição de furação/pinagem de uma placa específica.
    // Fita isolante de espuma de 1 mm fixa a placa sem encostar soldas no fundo.
    color([0.23,0.24,0.24]) translate([-14,-7,-1]) cube([28,14,1]);
    color([0.10,0.40,0.23]) translate([-17,-10,0]) cube([34,20,1.6]);
    color([0.10,0.12,0.12]) translate([-6,-4,1.6]) cube([12,8,2]);
    color([0.75,0.66,0.30]) for(x=[-13.5,13.5],y=[-6,-2,2,6])
        translate([x,y,1.6]) cylinder(d=1.4,h=3);
}

module cabo() {
    // Esquema de chicote flexível saindo do lado fixo; não representa instalação vedada.
    pts=[[x_fixo-2,-largura_celula/2-1,z_celula+5],
         [x_fixo-12,-25,espessura_base+7],
         [x_fixo-12,hx_y,espessura_base+10],
         [-caixa_largura/2+3,hx_y,espessura_base+10]];
    color([0.12,0.13,0.13]) for(i=[0:len(pts)-2]) hull() {
        translate(pts[i]) sphere(d=3,$fn=16);
        translate(pts[i+1]) sphere(d=3,$fn=16);
    }
}

module conjunto() {
    color(madeira) base_fixa();
    color(aco) translate([x_fixo,0,z_chapa_fixa+expl]) chapa(true);
    color(aluminio) translate([x_fixo,0,z_calco_fixo+2*expl]) calco(true);
    translate([x_celula,0,z_celula+3*expl]) celula();
    color(aluminio) translate([0,0,z_calco_movel+4*expl]) calco(false);
    color(aco) translate([0,0,z_chapa_movel+5*expl]) chapa(false);
    if(vista!="sem_plataforma")
        color(madeira_topo) translate([0,0,z_plataforma+6*expl]) plataforma_movel();
    if(mostrar_ferragens) {
        batentes();
        retentores();
        if(vista=="montada") parafusos_celula();
        // Nas vistas abertas, omitir M4/M5 da célula para revelar a furação.
    }
    if(mostrar_eletronica) {
        color(plastico) translate([0,hx_y,espessura_base]) caixa_hx711();
        if(vista!="sem_plataforma")
            color(plastico) translate([0,hx_y,espessura_base+caixa_altura+2*expl]) tampa_hx711();
        translate([0,hx_y,espessura_base+parede_caixa+1]) pcb_hx711();
    }
    if(mostrar_cabo && mostrar_eletronica && expl==0) cabo();
    // Operador %: referência só no preview; não entra em STL/F6.
    if(mostrar_envelope_colmeia && vista!="sem_plataforma")
        %color([0.3,0.7,0.4,0.3]) translate([0,0,z_topo+6*expl])
            placa(largura_colmeia,profundidade_colmeia,8,1);
}

if(peca=="conjunto") conjunto();
else if(peca=="base_fixa") base_fixa();
else if(peca=="plataforma_movel") plataforma_movel();
else if(peca=="chapa_fixa") chapa(true);
else if(peca=="chapa_movel") chapa(false);
else if(peca=="calco_fixo") calco(true);
else if(peca=="calco_movel") calco(false);
else if(peca=="caixa_hx711") caixa_hx711();
else if(peca=="tampa_hx711") tampa_hx711();
else assert(false,"Peça desconhecida.");

echo("Altura da superfície de apoio (mm):",z_topo);
echo("Altura total incluindo retentores (mm):",z_topo+folga_retencao_vertical+4);
echo("Folga nominal dos batentes (mm), ajustar fisicamente:",folga_batente);
