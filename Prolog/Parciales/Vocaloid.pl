% Vocaloid:

% De cada vocaloid (o cantante) se conoce el nombre y
% además la cancion que sabe cantar. De cada canción se
% conoce el nombre y la cantidad de minutos de duracion

% Queremos reflejar entonces que:

% megurineLuka sabe cantar la canción nightFever 
%cuya duración es de 4 min 
% y también canta la canción foreverYoung que dura 5 min
vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).

% hatsuneMiku sabe cantar la canción tellYourWorld 
% que dura 4 minutos
vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).

% gumi sabe cantar foreverYoung que dura 4 min 
% y tellYourWorld que dura 5 min
vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).

% seeU sabe cantar novemberRain con una duración de 6 min 
% y nightFever con una duración de 5 min.
vocaloid(seeU, cancion(novemberRain, 6)).
vocaloid(seeU, cancion(nightFever, 5)).

% kaito no sabe cantar ninguna canción
vocaloid(kaito).

% Los siguientes predicados que sean totalmente inversibles

% Punto 1:

esNovedoso(Cantante) :-
    vocaloid(Cantante, _),
    tieneAlMenosDosCanciones(Cantante),
    duracionTotalDeSusCanciones(Cantante, TiempoTotal),
    TiempoTotal < 15.

tieneAlMenosDosCanciones(Cantante) :-
    cancion(Cantante, NombreDePrimeraCancion),
    cancion(Cantante, NombreDeSegundaCancion),
    NombreDePrimeraCancion \= NombreDeSegundaCancion.

cancion(Cantante, NombreDeCancion) :-
    vocaloid(Cantante, Cancion),
    nombreDeCancion(Cancion, NombreDeCancion).

nombreDeCancion(cancion(NombreDeCancion, _), NombreDeCancion).

duracionTotalDeSusCanciones(Cantante, TiempoTotal) :-
    vocaloid(Cantante, _),
    findall(Duracion, duracionDeAlgunaCancion(Cantante, Duracion), ListaDeDuraciones),
    sum_list(ListaDeDuraciones, TiempoTotal).
    
duracionDeAlgunaCancion(Cantante, Duracion) :-
    vocaloid(Cantante, Cancion),
    cuantoDura(Cancion, Duracion).

cuantoDura(cancion(_, Duracion), Duracion).

% Punto 2:

esAcelerado(Cantante) :-
    vocaloid(Cantante, _),
    not((duracionDeAlgunaCancion(Cantante, Duracion), not(Duracion > 4))).

% Además de los vocaloids, conocemos información acerda de varios 
% conciertos que se darán en un futuro muy legano.

% De cada concierto se sabe su nombre, el país donde se realiza, una cantidad
% de fama y el tipo de concierto

% Hay tres tipos de conciertos:

% Gigantes: Se sabe la cantidad minima de canciones
% que el cantante tiene que saber y además la duracion
% total de todas las canciones tiene que ser mayor a una cantidad dada

% Mediano: solo pide que la duracion total de las canciones
% del cantante sea menor a una cantidad determinada

% Pequeño: El unico requisito es que alguna de las canciones dura
% más de una cantidad dada

% Punto 1:

% Miku Expo, es un concierto gigante que se va a realizar en Estados Unidos
% le brinda 2000 de fama al vocaloid que pueda participar en él 
% y pide que el vocaloid sepa más de 2 canciones 
% y el tiempo mínimo de 6 minutos
concierto(mikuExpo, estadosUnidos, 2000 , grande(2, 6)).

% Magical Mirai, se realizará en Japón 
% y también es gigante, pero da una fama de 3000 
% y pide saber más de 3 canciones por cantante 
% con un tiempo total mínimo de 10 minutos.
concierto(magicalMirai, japon, 3000, grande(3, 10)).

% Vocalekt Visions, se realizará en Estados Unidos 
% y es mediano brinda 1000 de fama 
% y exige un tiempo máximo total de 9 minutos
concierto(vocalektVision, estadosUnidos, 1000, mediano(9)).

% Miku Fest, se hará en Argentina 
% y es un concierto pequeño que solo da 100 de fama al vocaloid 
% que participe en él
% con la condición de que sepa una o más canciones de más de 4 minutos
concierto(mikuFest, argentina, 100, pequeno(4)).

% Punto 2: 

participaDeUnConcierto(hatsuneMiku, Concierto) :-
    concierto(Concierto, _, _, _).

participaDeUnConcierto(Cantante, Concierto, Pais) :-
    vocaloid(Cantante, _),
    Cantante \= hatsuneMiku,
    concierto(Concierto, Pais, _, Requisitos),
    cumpleConLosRequisitos(Cantante, Requisitos).

cumpleConLosRequisitos(Cantante, pequeno(TiempoRequerido)) :-
    vocaloid(Cantante, Cancion),
    cuantoDura(Cancion, TiempoRequerido).

cumpleConLosRequisitos(Cantante, grande(CantidadMinima, DuracionMinima)) :-
    tieneCiertaCantidadDeCanciones(Cantante, CantidadTotal),
    CantidadTotal >= CantidadMinima,
    duracionTotalDeSusCanciones(Cantante, DuracionTotal),
    DuracionTotal > DuracionMinima.

tieneCiertaCantidadDeCanciones(Cantante, CantidadDeCanciones) :-
    vocaloid(Cantante, _),
    findall(NombreDeCancion, cancion(Cantante, NombreDeCancion), ListaDeCanciones),
    length(ListaDeCanciones, CantidadDeCanciones).

cumpleConLosRequisitos(Cantante, mediano(DuracionMaxima)) :-
    duracionTotalDeSusCanciones(Cantante, DuracionTotal),
    DuracionMaxima >= DuracionTotal.

% Punto 3:

vocaloidMasFamoso(Cantante) :-
    vocaloid(Cantante, _),
    famaVerdadera(Cantante, NivelDeFama),
    forall(famaVerdadera(_, OtroNivelDeFama), NivelDeFama >= OtroNivelDeFama).
    
famaVerdadera(Cantante, NivelDeFama) :-
    vocaloid(Cantante, _),
    totalDeFamaReunida(Cantante, FamaTotal),
    tieneCiertaCantidadDeCanciones(Cantante, CantidadDeCanciones),
    NivelDeFama is FamaTotal * CantidadDeCanciones.    

totalDeFamaReunida(Cantante, FamaTotal) :-
    findall(NivelDeFama, famaReunida(Cantante, NivelDeFama), NivelesDeFamaReunido),
    sum_list(NivelesDeFamaReunido, FamaTotal).

famaReunida(Cantante, Fama) :-
    participaDeUnConcierto(Cantante, Concierto, _),
    sacarFamaGanada(Concierto, Fama).

sacarFamaGanada(Concierto, Fama) :-
    concierto(Concierto, _, Fama, _).