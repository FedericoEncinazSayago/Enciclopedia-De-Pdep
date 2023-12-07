% Viscosos pero Sabrosos

% Tenemos tres tipos de bichos, representados por functores:
% Las vaquitas de San Antonio (de quienes nos interesa un peso)
% Las cucarachas (de quienes nos interesa un tamaño y un peso)
% Las hormigas, que pesan siempre lo mismo

% La base de conocimiento es la que sigue:

comio(pumba, vaquitaSanAntonio(gervasia, 3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger, 15, 6)).
comio(pumba, cucaracha(erikElRojo, 25, 70)).

comio(timon, vaquitaSanAntonio(romualda, 4)).
comio(timon, cucaracha(gimeno, 12, 8)).
comio(timon, cucaracha(cucurucha, 12, 5)).

comio(simba, vaquitaSanAntonio(remeditos, 4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).

pesoHormiga(2).

peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).

animal(simba).
animal(pumba).
animal(timon).
animal(scar).
animal(shenzi).
animal(banzai).

esUnAnimal(Personaje) :-
    animal(Personaje).

% A falta de pochoclos: 

% Punto 1: Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño 
% pero ella es más gordita

jugosita(cucaracha(Nombre, Tamanio, Peso)) :-
    comio(_, cucaracha(OtroNombre, Tamanio, OtroPeso)),
    Nombre \= OtroNombre,
    Peso > OtroPeso.

% Punto 2: Si un personaje es hormigofílico... (Comió al menos dos hormigas)

hormigofilico(Personaje) :-
    esUnAnimal(Personaje),
    findall(NombreDeLaHormiga, comio(Personaje, hormiga(NombreDeLaHormiga)), ListaDeHormigas),
    length(ListaDeHormigas, Cantidad),
    Cantidad >= 2.

% Punto 3: Si un personaje es cucarachofóbico (no comió cucarachas)

cucarachofobico(Personaje) :-
    esUnAnimal(Personaje),
    forall(comio(Personaje, Comida), Comida \= cucaracha(_, _, _)).

% % Punto 4: Conocer al conjunto de los picarones. 
% Un personaje es picarón si comió una cucaracha jugosita ó si se
% come a Remeditos la vaquita
% Además, pumba es picarón de por sí

picarones(ConjuntoDePersonajes) :-
    findall(Personaje, picaron(Personaje), ConjuntoDePersonajes).

picaron(pumba).

picaron(Personaje) :-
    esUnAnimal(Personaje),
    comio(Personaje, Comida),
    jugosita(Comida).

picaron(Personaje) :-
    esUnAnimal(Personaje),
    comio(Personaje, vaquitaSanAntonio(remeditos, _)).

% Pero yo quiero carne:

% Aparece en escena el malvado Scar, que persigue a algunos de nuestros amigos. 
% Y a su vez, las hienas Shenzi y Banzai también se divierten

persigue(scar, timon).
persigue(scar, pumba).

persigue(shenzi, simba).
persigue(shenzi, scar).

persigue(banzai, timon).

% Por ejemplo, un día había una hiena distraida y con mucho
% hambre y amplio su dieta
comio(shenzi, hormiga(conCaraDeSimba)).

peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).

% Punto 1:

cuantoEngorda(Personaje, Peso) :-
    esUnAnimal(Personaje),
    pesoRecogido(Personaje, Peso).

pesoRecogido(Personaje, PesoRecogido) :-
    esUnAnimal(Personaje),
    findall(PesoDeComida, sacarPesoDeComida(Personaje, PesoDeComida), ListaDePesos),
    sum_list(ListaDePesos, PesoRecogido).

sacarPesoDeComida(Personaje, PesoDeComida) :-
    comio(Personaje, Comida),
    pesoDeComida(Comida, PesoDeComida).

pesoDeComida(vaquitaSanAntonio(_, Peso), Peso).
pesoDeComida(cucaracha(_, _, Peso), Peso).

pesoDeComida(hormiga(_), Peso) :-
    pesoHormiga(Peso).

% Punto 2: 

sacarPesoDeComida(Personaje, PesoReal) :-
    persigue(Personaje, OtroPersonaje),
    peso(OtroPersonaje, PesoReal).

% Punto 3:

sacarPesoDeComida(Personaje, PesoTotal) :-
    persigue(Personaje, OtroPersonaje),
    peso(OtroPersonaje, PesoAnterior),
    pesoRecogido(OtroPersonaje, PesoEngordado),
    PesoTotal is (PesoEngordado + PesoAnterior).
    

