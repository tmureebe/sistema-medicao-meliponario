/*
 UNIDADE EXTERNA DE TEMPERATURA / UMIDADE — SHT40. Unidades: mm.
 Arquivo independente. Abrigo passivo de radiação com pratos sobrepostos,
 entrada lateral de ar, fundo protegido, suporte removível e fixação na estante.
 O ESP32 e a bateria ficam em outra caixa, para não aquecer o sensor.

 USO NO OPENSCAD:
   vista = "montada", "corte" ou "explodida"; F5 para cores, F6 para geometria.
   peca seleciona uma peça individual, já posicionada para exportação STL.
   Imprimir: 1 fundo, 5 pratos, 1 cobertura, 1 suporte_sensor e 1 suporte_estante.
   Não imprimir o conjunto: sensor, cabo e ferragens são referências de montagem.

 FABRICAÇÃO / MONTAGEM:
   ASA branco no abrigo; PETG pode ser usado em instalação protegida do sol.
   Peças individuais cabem na K1C. Perfil inicial: camada 0,20 mm, 4 perímetros.
   Os cones têm inclinação de 45 graus; avaliar no fatiador pontes, fechamento
   central dos pratos cegos e suportes locais. Não prometer impressão sem suporte.
   Remover rebarbas dos canais de ar e conferir furos com ferragens reais.
   3 hastes roscadas M3, arruelas e porcas inox travam os espaçadores integrados.
   Cortar as hastes ao comprimento da montagem (aprox. 132 mm na configuração
   inicial); usar vedação sob as arruelas superiores, sem bloquear a ventilação.
   O suporte da estante prende duas hastes por baixo. Fixação na madeira: quatro
   parafusos de diâmetro compatível com furos de 4,5 mm; escolher comprimento local.
   Fixar o suporte do sensor no fundo com 2 parafusos M3 e porcas pelo lado inferior.
   Prender a placa nas guias com abraçadeiras pelos rasgos, sem cobrir o sensor.
   A placa 18 x 25 x 1,6 é apenas um ENVELOPE: medir o módulo comprado e ajustar.
   Saída inferior do cabo: deixar alça de gotejamento e prender na estante.

 INSTALAÇÃO / LIMITES:
   Instalar conforme planejamento, longe de telhado quente e fontes de calor,
   com circulação de ar. Abrigo ventilado não é caixa estanque nem possui IP
   certificado. Validar contra instrumento de referência sob sol e chuva com vento.
   Não aplicar cola, tinta ou selante sobre o elemento sensível. O desenho não
   certifica erro de medição, proteção contra insetos ou resistência ao tempo.
   Guia de integração consultado (Sensirion):
   https://sensirion.com/media/documents/FC5BED84/662B494D/Sensirion_Humidity_Temperature_Design_Guide.pdf
 */

/* [Visualização] */
peca = "conjunto"; // [conjunto,fundo,prato,cobertura,suporte_sensor,suporte_estante]
vista = "corte"; // [montada,corte,explodida]
mostrar_sensor = true;
mostrar_ferragens = true;
mostrar_cabo = true;
passo_explosao = 18;

/* [Abrigo] */
diametro_prato = 140;
diametro_cobertura = 150;
diametro_camara = 60;
espessura = 2.4;
numero_pratos = 5;
passo_pratos = 16;
raio_hastes = 62;
diametro_coluna = 10;
diametro_furo_haste = 3.6;

/* [Placa SHT40 — medir o módulo comprado] */
largura_placa = 18;
altura_placa = 25;
espessura_placa = 1.6;
diametro_cabo = 3;
diametro_saida_cabo = 5;

/* [Fixação] */
afastamento_parede = 110;
largura_parede = 48;
altura_parede = 60;
espessura_suporte = 6;

/* [Hidden] */
$fn = 72;
eps = 0.02;
// Separação gráfica apenas na montagem, para evitar faces/arestas coincidentes.
// Não é folga a deixar nos apoios reais; peças individuais mantêm a medida nominal.
folga_visual = 0.05;
r = diametro_prato/2;
rc = diametro_camara/2;
rt = diametro_cobertura/2;
altura_cone = r-rc;
z_sensor = altura_cone+espessura;
z_cobertura = (numero_pratos+1)*passo_pratos;
z_porcas = z_cobertura+passo_pratos;
angulos = [90,210,330];
x_travessa = raio_hastes*cos(30);
y_travessa = -raio_hastes/2;
expl = vista=="explodida" ? passo_explosao : 0;
branco = [0.93,0.94,0.92];
cinza = [0.62,0.67,0.69];

assert(numero_pratos>=3 && numero_pratos==floor(numero_pratos));
assert(vista=="montada" || vista=="corte" || vista=="explodida");
assert(passo_pratos>espessura+6,"Pouca passagem de ar entre pratos.");
assert(raio_hastes+diametro_coluna/2<r,"Colunas ultrapassam a borda.");
assert(raio_hastes-diametro_coluna/2>rc,"Colunas invadem a câmara.");
assert(rt-raio_hastes+espessura<passo_pratos,"Aumentar passo: coluna da cobertura curta.");
assert(afastamento_parede-espessura_suporte>rt+10,"Suporte encosta no abrigo.");
assert(largura_placa>=14 && largura_placa+12<diametro_camara);
assert(altura_placa+9+z_sensor<z_cobertura+rt-rc-5,"Sensor alto demais.");
assert(diametro_cabo+1<diametro_saida_cabo);

module pontos_hastes() {
    for(a=angulos) translate([raio_hastes*cos(a),raio_hastes*sin(a),0]) children();
}

// Cone de parede fina, aberto no centro. Geratriz a 45 graus para impressão.
module casca(re=r) {
    rotate_extrude() polygon([[rc,re-rc],[rc,re-rc+espessura],
                             [re,espessura],[re,0]]);
}

module prato(tipo="aberto") {
    re=tipo=="topo" ? rt : r;
    difference() {
        union() {
            casca(re);
            // Fundo e cobertura fecham a visão vertical do sensor.
            if(tipo!="aberto") translate([0,0,re-rc])
                cylinder(r=rc+eps,h=espessura);
            // Espaçadores integrados: assentam plano contra plano entre camadas.
            pontos_hastes() cylinder(d=diametro_coluna,h=passo_pratos);
        }
        pontos_hastes() translate([0,0,-eps])
            cylinder(d=diametro_furo_haste,h=re-rc+espessura+2*eps);
        if(tipo=="fundo") {
            for(x=[-9,9]) translate([x,6,-eps]) cylinder(d=3.4,h=altura_cone+espessura+2*eps);
            translate([0,-8,-eps]) cylinder(d=diametro_saida_cabo,h=altura_cone+espessura+2*eps);
        }
    }
}

module suporte_sensor() {
    w=largura_placa;
    difference() {
        union() {
            // Pé para dois M3 e pescoço de pequena seção.
            translate([-14,-3,0]) cube([28,15,3]);
            translate([-4,1,2]) cube([8,4,7]);
            translate([-w/2-3,-2,6]) cube([w+6,7,3]);
            for(s=[-1,1]) translate([s*(w/2-1)-1.5,0,8])
                cube([3,3,altura_placa+1]);
        }
        for(x=[-9,9]) translate([x,6,-eps]) cylinder(d=3.4,h=3+2*eps);
        // Rasgos para abraçadeiras finas nas guias laterais, longe do chip.
        for(s=[-1,1]) translate([s*(w/2-1)-0.85,-eps,11])
            cube([1.7,3+2*eps,4]);
    }
}

module suporte_estante() {
    difference() {
        union() {
            translate([-x_travessa-8,y_travessa-7,-espessura_suporte])
                cube([2*x_travessa+16,14,espessura_suporte]);
            translate([-12,-afastamento_parede,-espessura_suporte])
                cube([24,afastamento_parede+y_travessa+4,espessura_suporte]);
            translate([-largura_parede/2,-afastamento_parede,-espessura_suporte])
                cube([largura_parede,espessura_suporte,altura_parede]);
            // Nervura sob o braço; não invade pratos nem canais de ar.
            translate([-3,0,0]) rotate([90,0,90]) linear_extrude(height=6)
                polygon([[-afastamento_parede+espessura_suporte,-espessura_suporte],
                         [y_travessa,-espessura_suporte],
                         [-afastamento_parede+espessura_suporte,-20]]);
        }
        for(x=[-x_travessa,x_travessa]) translate([x,y_travessa,-espessura_suporte-eps])
            cylinder(d=diametro_furo_haste,h=espessura_suporte+2*eps);
        for(x=[-15,15],z=[10,36]) translate([x,-afastamento_parede-eps,z])
            rotate([-90,0,0]) cylinder(d=4.5,h=espessura_suporte+2*eps);
    }
}

module placa_sensor() {
    // Envelope ilustrativo: não reproduz furação nem pinagem de fabricante.
    color([0.08,0.45,0.33]) translate([-largura_placa/2,-espessura_placa,9])
        cube([largura_placa,espessura_placa,altura_placa]);
    color([0.74,0.76,0.72]) translate([-1.5,-espessura_placa-1,altura_placa+2])
        cube([3,1,3]);
    color([0.10,0.12,0.13]) translate([-3,-espessura_placa-2,10]) cube([6,2,4]);
}

module porca() {
    difference() {
        cylinder(d=6.4,h=2.4,$fn=6);
        translate([0,0,-eps]) cylinder(d=3.3,h=2.4+2*eps,$fn=36);
    }
}

module arruela() {
    difference() {
        cylinder(d=8,h=0.8,$fn=36);
        translate([0,0,-eps]) cylinder(d=3.3,h=0.8+2*eps,$fn=36);
    }
}

module ferragens() {
    // Pequena folga gráfica nas roscas; ferragens comerciais não imprimíveis.
    color(cinza) for(a=angulos) {
        x=raio_hastes*cos(a); y=raio_hastes*sin(a);
        zb=a==90 ? 0 : -espessura_suporte-folga_visual;
        translate([x,y,zb-5]) cylinder(d=3,h=z_porcas+5-(zb-5),$fn=36);
        translate([x,y,zb-0.8]) arruela();
        translate([x,y,zb-3.2-folga_visual]) porca();
        translate([x,y,z_porcas]) arruela();
        translate([x,y,z_porcas+0.8+folga_visual]) porca();
    }
}

module cabo() {
    // Alça inferior de gotejamento; rota ilustrativa até o chicote externo.
    pts=[[0,-espessura_placa-2,z_sensor+10], [0,-8,z_sensor-2],
         [0,-8,-12], [18,-8,-18], [28,-8,-8]];
    color([0.12,0.14,0.15]) for(i=[0:len(pts)-2]) hull() {
        translate(pts[i]) sphere(d=diametro_cabo,$fn=16);
        translate(pts[i+1]) sphere(d=diametro_cabo,$fn=16);
    }
}

module abrigo() {
    color(branco) prato("fundo");
    for(i=[1:numero_pratos]) color(i%2==0 ? branco : [0.87,0.90,0.90])
        translate([0,0,i*(passo_pratos+expl)]) prato();
    color(branco) translate([0,0,(numero_pratos+1)*(passo_pratos+expl)]) prato("topo");
}

module conjunto() {
    if(vista=="corte") difference() {
        abrigo();
        // Corte didático do quadrante frontal direito, sem cortar o sensor.
        translate([0,-rt-1,-1]) cube([rt+1,rt+1,z_cobertura+rt+20]);
    } else abrigo();
    color([0.40,0.48,0.51]) translate([0,0,-folga_visual]) suporte_estante();
    color([0.76,0.81,0.80]) translate([0,0,z_sensor+folga_visual]) suporte_sensor();
    if(mostrar_sensor) translate([0,0,z_sensor+folga_visual]) placa_sensor();
    if(mostrar_ferragens && vista!="explodida") ferragens();
    if(mostrar_cabo && vista!="explodida") cabo();
}

if(peca=="conjunto") conjunto();
else if(peca=="prato") prato();
else if(peca=="fundo") prato("fundo");
else if(peca=="cobertura") prato("topo");
else if(peca=="suporte_sensor") suporte_sensor();
else if(peca=="suporte_estante")
    // Parede traseira plana sobre a mesa de impressão.
    translate([0,0,afastamento_parede]) rotate([90,0,0]) suporte_estante();
else assert(false,"Peça desconhecida.");

echo("Diâmetro máximo do abrigo (mm):",diametro_cobertura);
echo("Altura do abrigo, sem suporte (mm):",z_cobertura+rt-rc+espessura);
echo("Imprimir: 1 fundo,",numero_pratos,"pratos, 1 cobertura e 2 suportes.");
