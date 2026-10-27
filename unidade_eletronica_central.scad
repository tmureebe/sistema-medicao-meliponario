/*
 UNIDADE ELETRÔNICA CENTRAL DO MELIPONÁRIO. Arquivo independente. Medidas em mm.
 Caixa, tampa com canal de vedação e bandeja removível; representação espacial
 de ESP32, RTC/backup, microSD, 3 conversores BSS138, reguladores, proteção,
 corte por subtensão, distribuição, comutação e filtragem das entradas.

 F5: cores; F6: geometria. A vista inicial é ABERTA para mostrar os componentes.
 vista="montada" fecha a tampa; "explodida" separa a bandeja e a tampa.
 peca="caixa", "tampa" ou "bandeja" exporta apenas uma peça imprimível.
 Eletrônica, cabos, prensa-cabos e junta são representações, não peças para FDM.
 A serigrafia das PCBs aparece só no F5; gravações da caixa/tampa fazem parte do sólido.
 Imprimir 1 caixa, 1 tampa e 1 bandeja. Todas cabem na K1C na configuração inicial.

 LIMITES DIMENSIONAIS:
 Placas e componentes são ENVELOPES PROVISÓRIOS; os anúncios não definem toda a
 furação. Medir o lote antes da fabricação. A matriz modulos abaixo centraliza
 posição, tamanho e padrão de apoio. Furos de montagem são hipóteses, não desenhos
 de fabricante. Para placas sem furos, usar adaptador isolante/soquete com o padrão
 da bandeja; não furar uma PCB montada. Apoios deixam espaço para soldas inferiores.
 ESP32: apoios concentrados na região inferior, sem parafusos sob a ponta da antena.
 microSD e USB são acessados com a tampa aberta; não há janela externa de serviço.

 CONSTRUÇÃO:
 ASA claro para caixa/tampa, ASA ou PETG para bandeja. Começar com camada 0,20 mm
 e 4 perímetros; conferir suportes nos furos horizontais e prensa-cabos no fatiador.
 Bandeja: 4 M3; tampa: 4 M3 com vedação sob cabeça, pilotos ajustáveis na caixa.
 Canal da tampa para cordão de silicone: ajustar compressão conforme material real.
 Nove prensa-cabos comerciais: A, B, C01-C05, AMB e CHUVA. Diâmetro dos furos
 provisório 12,5 mm; escolher rosca, faixa de aperto e vedação pelo cabo comprado.
 Fixar em posição vertical: Y positivo para cima, prensa-cabos Y negativo para baixo.
 Abas de montagem não atravessam a cavidade. Fazer alças de gotejamento externas.
 Caixa impressa e junta modelada NÃO constituem certificação IP; ensaiar vedação,
 condensação e temperatura. Uma caixa comercial vedada continua sendo alternativa
 do orçamento; adaptar a bandeja ao seu interior se for usada.

 ORGANIZAÇÃO ELÉTRICA (não substitui esquema/PCB):
 A/B -> fusível individual + bloqueio reverso/OR -> corte por subtensão -> 12/5 V.
 Proteção inicial/fusível também junto de CADA bateria, antes do cabo até esta caixa.
 Baterias e carregador ficam fora; nunca unir packs diretamente em paralelo.
 5 V -> ESP32 pela entrada apropriada, ramo HX711 e interface microSD validada.
 Regulador 3,3 V -> auxiliares; não pôr sua saída em paralelo com o regulador da DevKit.
 Desenho de chicotes é esquemático: cores/linhas não definem pinagem nem bitola.
 3 BSS138 x 4 canais: dez usados (SCK/DOUT de cada HX711). Validar níveis e bordas.
 HX711 ficam junto das células, nas unidades de pesagem; seus cabos chegam C01-C05.
 GPIO: DOUT 34/35/36/39/32; SCK 25/26/27/14/13. I2C SDA21/SCL22: RTC+SHT40.
 SD: SCK18/MISO19/MOSI23/CS33. Chuva: GPIO4. Chaves externas: GPIO16/17.
 Validar pull-ups, estados desligados e ausência de alimentação parasita antes do uso.
 Pilha RTC: suporte compatível, sem recarregar pilha primária. microSD: lógica 3,3 V;
 alimentação do módulo conforme placa real. USB de serviço: evitar retorno entre fontes.

 Fonte de orientação de antena (validar também dentro da caixa e no local instalado):
 https://docs.espressif.com/projects/esp-hardware-design-guidelines/en/latest/esp32/esp-hardware-design-guidelines-en-master-esp32.pdf
 */

/* [Visualização] */
peca = "conjunto"; // [conjunto,caixa,tampa,bandeja]
vista = "aberta"; // [aberta,montada,explodida]
mostrar_modulos = true;
mostrar_chicotes = true;
mostrar_prensa_cabos = true;
mostrar_junta = true;
mostrar_area_antena = false;
mostrar_rotulos = true;

/* [Caixa] */
largura = 200;
profundidade = 180;
altura = 60;
parede = 3;
fundo = 3;
raio_canto = 8;
espessura_tampa = 3.2;
piloto_m3 = 2.7;
largura_canal_junta = 2;
profundidade_canal_junta = 1.2;

/* [Bandeja] */
largura_bandeja = 178;
profundidade_bandeja = 150;
espessura_bandeja = 2.8;
z_bandeja = 10;
altura_apoio_placa = 6;
piloto_placas = 1.8; // Hipótese de fixação M2; conferir lote/adaptador.

/* [Passagens de cabos] */
diametro_furo_prensa = 12.5;
z_prensas = 29;
passo_prensas = 20;

/* [Hidden] */
$fn=48;
eps=0.02;
folga_visual=0.05;
z_pcb=z_bandeja+espessura_bandeja+altura_apoio_placa;
pcb_h=1.6;
xt=largura/2-8;
yt=profundidade/2-16;
xb=largura_bandeja/2-6;
yb=profundidade_bandeja/2-9;
expl= vista=="explodida" ? 35 : 0;
branco=[0.91,0.93,0.92];
cinza=[0.65,0.69,0.70];
azul=[0.12,0.32,0.51];
portas=["BAT A","BAT B","C01","C02","C03","C04","C05","AMB","CHUVA"];
terminais=[-32,-13,6,25,44,63,79.5];

// [identificação, X, Y, largura PCB, profundidade PCB, tipo]
// Dimensões, posições e furação são provisórias, conforme aviso no cabeçalho.
modulos=[
 ["PROTECAO / OR",-66,-19,44,44,"protecao"],
 ["CORTE UV",-64,15,36,20,"uv"],
 ["12 > 5 V",-64,45,44,26,"buck"],
 ["3V3 AUX",-21,29,22,17,"reg"],
 ["RTC",5,55,32,24,"rtc"],
 ["ESP32",50,42,30,55,"esp"],
 ["microSD",52,-22,42,24,"sd"],
 ["LV1",-18,-12,16,22,"nivel"],
 ["LV2",5,-12,16,22,"nivel"],
 ["LV3",19,16,16,22,"nivel"],
 ["INTERCONEXOES",22,-52,128,30,"io"]
];

assert(vista=="aberta" || vista=="montada" || vista=="explodida");
assert(largura>=200 && profundidade>=180,"Reorganizar módulos ao reduzir a caixa.");
assert(largura_bandeja<largura-2*parede-8 && profundidade_bandeja<profundidade-2*parede-8);
assert(z_pcb+20<altura-4,"Pouca altura para componentes e chicotes.");
assert(8*passo_prensas+18<largura-2*parede);
assert(z_prensas-10>fundo && z_prensas+10<altura);
assert(profundidade_canal_junta<espessura_tampa-1);
for(m=modulos) {
    assert(abs(m[1])+m[3]/2<largura_bandeja/2);
    assert(abs(m[2])+m[4]/2<profundidade_bandeja/2);
}

module placa(w,d,h,r=3) {
    linear_extrude(height=h) offset(r=r) square([w-2*r,d-2*r],center=true);
}
module anel(w,d,esp,h,r) {
    difference() {
        placa(w,d,h,r);
        translate([0,0,-eps]) placa(w-2*esp,d-2*esp,h+2*eps,max(0.5,r-esp));
    }
}
module furo(x,y,z,d,h) { translate([x,y,z]) cylinder(d=d,h=h); }
module furo_y(d,h) { rotate([-90,0,0]) cylinder(d=d,h=h); }
module texto(txt,x,y,z,tam=3) {
    if(mostrar_rotulos && $preview) translate([x,y,z]) linear_extrude(height=0.25)
        text(txt,size=tam,halign="center",valign="center",font="DejaVu Sans:style=Bold");
}

module caixa() {
    difference() {
        union() {
            difference() {
                placa(largura,profundidade,altura,raio_canto);
                translate([0,0,fundo]) placa(largura-2*parede,profundidade-2*parede,
                                            altura,raio_canto-parede);
            }
            for(x=[-xt,xt],y=[-yt,yt]) furo(x,y,0,12,altura);
            for(x=[-xb,xb],y=[-yb,yb]) furo(x,y,0,9,z_bandeja);
            for(x=[-70,70],s=[-1,1]) translate([x,s*(profundidade/2+6),0])
                placa(16,20,5,4);
        }
        for(x=[-xt,xt],y=[-yt,yt]) furo(x,y,12,piloto_m3,altura);
        for(x=[-xb,xb],y=[-yb,yb]) furo(x,y,4,piloto_m3,z_bandeja);
        for(x=[-70,70],s=[-1,1]) furo(x,s*(profundidade/2+8),-eps,4.5,5+2*eps);
        for(i=[0:8]) translate([(i-4)*passo_prensas,-profundidade/2-1,z_prensas])
            furo_y(diametro_furo_prensa,parede+2);
        // Identificação gravada das nove entradas, acima dos prensa-cabos.
        if(mostrar_rotulos) for(i=[0:8])
            translate([(i-4)*passo_prensas,-profundidade/2+0.6,z_prensas+15])
                rotate([90,0,0]) linear_extrude(height=0.8)
                    text(portas[i],size=2.8,halign="center",valign="center",font="DejaVu Sans:style=Bold");
    }
}

module tampa() {
    difference() {
        union() {
            placa(largura,profundidade,espessura_tampa,raio_canto);
            difference() {
                translate([0,0,-2.5]) anel(largura-2*parede-2.2,
                    profundidade-2*parede-2.2,1.6,2.5+eps,5);
                for(x=[-xt,xt],y=[-yt,yt]) furo(x,y,-3,16,4);
            }
        }
        translate([0,0,-eps]) anel(largura-1,profundidade-1,
            largura_canal_junta,profundidade_canal_junta+eps,raio_canto-0.5);
        for(x=[-xt,xt],y=[-yt,yt]) furo(x,y,-eps,3.4,espessura_tampa+2*eps);
        // Gravação na face externa; permite exportar essa face plana sobre a mesa.
        translate([0,8,espessura_tampa-0.5]) linear_extrude(height=0.6)
            text("MELIPONARIO",size=10,halign="center",font="DejaVu Sans:style=Bold");
        translate([0,-8,espessura_tampa-0.5]) linear_extrude(height=0.6)
            text("CENTRAL",size=8,halign="center",font="DejaVu Sans:style=Bold");
    }
}

module pos_furos_modulo(m) {
    // Padrão hipotético para módulos/adaptadores; não perfurar placas reais.
    ys=m[5]=="esp" ? [-22,6] : [-m[4]/2+3,m[4]/2-3];
    for(x=[-m[3]/2+3,m[3]/2-3],y=ys) translate([m[1]+x,m[2]+y,0]) children();
}

module bandeja() {
    difference() {
        union() {
            placa(largura_bandeja,profundidade_bandeja,espessura_bandeja,4);
            for(m=modulos) pos_furos_modulo(m) translate([0,0,espessura_bandeja-eps])
                cylinder(d=5.5,h=altura_apoio_placa+eps);
        }
        for(x=[-xb,xb],y=[-yb,yb]) furo(x,y,-eps,3.4,espessura_bandeja+2*eps);
        for(x=[-xt,xt],y=[-yt,yt]) furo(x,y,-eps,14,espessura_bandeja+2*eps);
        for(m=modulos) pos_furos_modulo(m) translate([0,0,espessura_bandeja-1])
            cylinder(d=piloto_placas,h=altura_apoio_placa+2);
        // Recorte sob a ponta da antena; bandeja isolante, sem chicotes nesta região.
        translate([50,65,-eps]) placa(42,19,espessura_bandeja+2*eps,2);
        // Quatro pares de rasgos para amarrar o chicote de entrada à bandeja.
        for(x=[-64,-20,24,68],y=[-71,-67]) translate([x-3,y-0.8,-eps])
            cube([6,1.6,espessura_bandeja+2*eps]);
    }
}

module pcb(m) {
    color(m[5]=="protecao" || m[5]=="uv" ? [0.48,0.23,0.16] : [0.10,0.39,0.30])
    difference() {
        translate([m[1],m[2],z_pcb]) placa(m[3],m[4],pcb_h,1);
        pos_furos_modulo(m) translate([0,0,z_pcb-eps]) cylinder(d=2.3,h=pcb_h+2*eps);
    }
}

module borne(n=4) {
    // Bloco de passo 3,5 mm, apenas envelope espacial, entradas voltadas a -Y.
    w=n*3.5+2;
    color([0.14,0.43,0.39]) difference() {
        translate([-w/2,-4.5,0]) cube([w,9,8]);
        for(i=[0:n-1]) translate([(i-(n-1)/2)*3.5,-5,3]) furo_y(2,4);
    }
    color(cinza) for(i=[0:n-1]) furo((i-(n-1)/2)*3.5,0,7.8,2.5,0.5);
}

module detalhes_modulo(m) {
    tipo=m[5]; w=m[3]; d=m[4];
    translate([m[1],m[2],z_pcb+pcb_h]) {
        if(tipo=="esp") {
            color(cinza) translate([-9,-10,0]) cube([18,25,3]);
            color([0.15,0.16,0.18]) translate([-3,-21,0]) cube([6,7,1.6]);
            color(cinza) translate([-4.5,-d/2-1,0]) cube([9,7,3.2]);
            color([0.78,0.65,0.20]) for(s=[-1,1],i=[0:14])
                translate([s*12,-22+i*2.54,0]) cylinder(d=1,h=2,$fn=12);
            color([0.81,0.69,0.26]) for(y=[19,22,25]) translate([-8,y,0]) cube([16,0.7,0.25]);
            color([0.96,0.96,0.96]) texto("ESP32",0,2,3.1,3.2);
        } else if(tipo=="rtc") {
            color([0.18,0.19,0.20]) cylinder(d=22,h=4);
            color(cinza) translate([0,0,4]) cylinder(d=20,h=2);
            color([0.10,0.12,0.13]) texto("RTC",0,0,6.05,3.2);
        } else if(tipo=="sd") {
            color(cinza) translate([3,-7,0]) cube([18,14,3]);
            color([0.13,0.14,0.16]) translate([17,-5.5,0.8]) cube([12,11,1]);
            color([0.95,0.95,0.95]) texto("microSD",-6,0,0.1,2.8);
        } else if(tipo=="buck") {
            color([0.22,0.24,0.25]) translate([-3,0,0]) cylinder(d=12,h=7);
            color([0.20,0.25,0.29]) for(x=[-15,15]) translate([x,3,0]) cylinder(d=7,h=12);
            color(azul) translate([8,-9,0]) cube([7,6,5]);
            color([0.96,0.96,0.96]) texto("12 > 5 V",-3,-9,0.1,2.7);
        } else if(tipo=="protecao") {
            for(x=[-12,12]) translate([x,-14,0]) borne(2);
            color([0.65,0.17,0.16]) for(x=[-12,12]) translate([x-4,-5,0]) cube([8,4,8]);
            color([0.12,0.13,0.14]) for(x=[-12,12]) translate([x-3,4,0]) cube([6,7,3]);
            color([0.91,0.90,0.83]) {
                texto("A",-12,-20,0.1,2.5); texto("B",12,-20,0.1,2.5);
                texto("F1   F2",0,0,0.1,2.6); texto("OR / TVS",0,16,0.1,3);
            }
        } else if(tipo=="io") {
            for(i=[0:6]) {
                translate([terminais[i]-m[1],0,0]) borne(i==6?2:4);
                color([0.96,0.96,0.91]) texto(i<5?str("C0",i+1):(i==5?"AMB":"CHUVA"),
                    terminais[i]-m[1],-10.5,0.1,i==6?2:2.6);
            }
            color([0.17,0.18,0.19]) for(x=[-35,-15,5,25,48])
                translate([x-3,7,0]) cube([6,4,1.5]);
            color([0.96,0.96,0.91]) texto("CHAVES / FILTROS / ESD",0,12,0.1,2.2);
        } else {
            color([0.15,0.16,0.17]) translate([-3,-3,0]) cube([6,6,2]);
            color([0.96,0.96,0.91]) texto(m[0],0,d/2-4,0.1,tipo=="nivel"?2.5:2.8);
            if(tipo=="nivel") color([0.78,0.65,0.22]) for(s=[-1,1],i=[0:5])
                translate([s*(w/2-1),-6+i*2.54,0]) cylinder(d=0.8,h=2,$fn=12);
        }
    }
}

module prensa_cabo() {
    // Rosca, porca e corpo simplificados; eixo local Z, cabo atravessa o centro.
    color([0.24,0.28,0.29]) difference() {
        union() {
            cylinder(d=12,h=11);
            translate([0,0,-4]) cylinder(d=18,h=4,$fn=6);
            translate([0,0,-14]) cylinder(d=15,h=10);
            translate([0,0,parede+1]) cylinder(d=18,h=4,$fn=6);
        }
        translate([0,0,-15]) cylinder(d=6,h=28);
    }
}

module chicote(pts,cor=[0.17,0.24,0.30],d=1.8) {
    // Cada linha representa um feixe; não representa cada condutor ou sua pinagem.
    color(cor) for(i=[0:len(pts)-2]) hull() {
        translate(pts[i]) sphere(d=d,$fn=12);
        translate(pts[i+1]) sphere(d=d,$fn=12);
    }
}

module chicotes() {
    for(i=[0:1]) chicote([[-80+20*i,-94,z_prensas],[-80+20*i,-73,29],
                         [-78+24*i,-38,24]],[0.65,0.18,0.13],3);
    for(i=[0:6]) chicote([[-40+20*i,-94,z_prensas],[-40+20*i,-75,29],
                         [terminais[i],-57,24]],i<5?[0.22,0.35,0.46]:[0.24,0.46,0.36],2.5);
    chicote([[-64,0,23],[-64,5,34],[-64,10,24]],[0.67,0.20,0.15]);
    chicote([[-64,22,24],[-64,28,34],[-64,34,25]],[0.67,0.20,0.15]);
    chicote([[-44,45,25],[-35,45,37],[-35,29,37],[-24,29,24]],[0.73,0.39,0.13]);
    chicote([[-35,36,37],[-35,-36,37],[-27,-43,25]],[0.73,0.39,0.13]);
    chicote([[-35,36,37],[30,36,37],[37,32,23]],[0.73,0.39,0.13]);
    chicote([[-10,29,24],[-7,24,33],[5,24,33],[5,43,24]],[0.65,0.27,0.42]);
    chicote([[37,35,24],[29,35,34],[26,44,34],[17,46,24]],[0.19,0.40,0.60]);
    chicote([[50,15,24],[50,3,35],[40,-5,35],[40,-17,24]],[0.19,0.40,0.60]);
    for(p=[[-18,-12],[5,-12],[19,16]]) chicote([[10,-43,24],[p[0],-32,34],
        [p[0],p[1],24]],[0.20,0.43,0.56]);
    chicote([[19,20,24],[28,23,33],[37,23,24]],[0.20,0.43,0.56]);
}

module conjunto() {
    color(branco) caixa();
    color([0.61,0.69,0.70]) translate([0,0,z_bandeja+folga_visual+expl]) bandeja();
    if(mostrar_modulos) translate([0,0,folga_visual+expl]) for(m=modulos) {
        pcb(m); detalhes_modulo(m);
    }
    if(mostrar_chicotes && mostrar_modulos && vista!="explodida") chicotes();
    if(mostrar_prensa_cabos) for(i=[0:8])
        translate([(i-4)*passo_prensas,-profundidade/2,z_prensas])
            rotate([-90,0,0]) prensa_cabo();
    if(vista!="aberta") {
        color(branco) translate([0,0,altura+folga_visual+3*expl]) tampa();
        if(mostrar_junta) color([0.24,0.35,0.34]) translate([0,0,altura+0.15+3*expl])
            anel(largura-1.3,profundidade-1.3,largura_canal_junta-0.3,0.8,raio_canto-0.65);
    }
    // Referência de keep-out só em F5; não entra na exportação STL.
    if(mostrar_area_antena) %color([0.8,0.35,0.1,0.25]) translate([25,49,z_pcb+expl])
        cube([54,35.5,18]);
}

if(peca=="conjunto") conjunto();
else if(peca=="caixa") caixa();
else if(peca=="tampa") translate([0,0,espessura_tampa]) rotate([180,0,0]) tampa();
else if(peca=="bandeja") bandeja();
else assert(false,"Peça desconhecida.");

echo("Caixa nominal, sem abas/prensas (mm):",[largura,profundidade,altura]);
echo("Placas de referência:",len(modulos),"Passagens de cabos:",len(portas));
echo("Imprimir apenas caixa, tampa e bandeja; conferir módulos e vedação reais.");
