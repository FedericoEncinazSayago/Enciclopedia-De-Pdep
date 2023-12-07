% Sombrero Seleccionador:

% Tenemos que registrar en nuestra base de conocimiento
% que caracteristicas tienen los distintos magos:

ingresante(harry, sangreImpura, [amistoso, orgulloso, coraje, inteligente]).
ingresante(draco, sangrePura, [inteligente, orgulloso]).
ingresante(hermione, sangreImpura, [inteligente, orgulloso, responsable]).

odia(harry, slytherin).
odia(draco, hufflepuf).

% Nos interesa saber cuales son las caracteristicas principales
% que el sombrero tiene para elegir la casa más apropiada:

% Para Gryffindor, lo más importante es tener coraje:
caracteristicaImportante(gryffindor, [coraje]).

% Para Slytherin, lo más importante es el orgulloso y inteligencia:
caracteristicaImportante(slytherin, [orgulloso, inteligencia]).

% Para Hufflepuff, lo más importante es ser amistoso:
caracteristicaImportante(hufflepuf, [amistoso]).

% Punto 1: 

puedeEntrar(Mago, CasaMagica) :-
    ingresante(Mago, TipoDeSangre, _),
    enBaseAlTipoDeSangreVa(CasaMagica, TipoDeSangre).

enBaseAlTipoDeSangreVa(slytherin, TipoDeSangre) :-
    TipoDeSangre \= sangreImpura.

enBaseAlTipoDeSangreVa(gryffindor, _).
enBaseAlTipoDeSangreVa(hufflepuf, _).
enBaseAlTipoDeSangreVa(ravenclaw, _).

% Punto 2: 

tieneElCaracterApropiado(Mago, CasaQueLoDejaEntrar) :-
    ingresante(Mago, _, CaracteristicasDelMago),
    caracteristicaImportante(CasaQueLoDejaEntrar, CaracteristicasDeLaCasa),
    forall(member(CaracteristicaDeLaCasa, CaracteristicasDeLaCasa), member(CaracteristicaDeLaCasa, CaracteristicasDelMago)).

% Punto 3:

enQueCasaQueda(hermione, gryffindor).

enQueCasaQueda(Mago, CasaQueLoDejaEntrar) :-
    ingresante(Mago, TipoDeSangre, CaracteristicasDelMago),
    puedeEntrar(TipoDeSangre, CasaQueLoDejaEntrar),
    tieneElCaracterApropiado(CaracteristicasDelMago, CasaQueLoDejaEntrar),
    not(odia(Mago, CasaQueLoDejaEntrar)).

% Punto 4:

sacarCaracteristicas(ingresante(_, _, ListaDeCaracteristicas), ListaDeCaracteristicas).

cadenaDeAmistades(Magos) :-
    forall((member(Mago, Magos),sacarCaracteristicas(Mago, ListaDeCaracteristicas)), member(amistoso, ListaDeCaracteristicas)),
    compararMagos(Magos).

compararMagos([_]).
compararMagos([MagoPrimero, MagoSegundo | Magos]) :-
    enQueCasaQueda(MagoPrimero, CasaQueLoDejaEntrar),
    enQueCasaQueda(MagoSegundo, CasaQueLoDejaEntrar),
    compararMagos([MagoSegundo | Magos]).

% La copa de las cosas:

% A lo largo del año los alumnos pueden ganar o perder puntos
% para su casa en base a buenas y malas acciones

% Malas acciones: Son andar de noche fuera de la cama
% o ir a lugares prohibidos

% Andar fuera de la cama resta 50 puntos
malaAccion(andarFueraDeLaCama, -50).

% Ir al "el bosque' resta 50 puntos
malaAccion(elBosque, -50).

% Ir a la seccion restringida resta 10 puntos
malaAccion(seccionRestringida, -10).

% Ir a la tercer piso resta 75 puntos
malaAccion(tercerPiso, -75).

% Buenas acciones: Son reconocidas por los profesores y prefectos
% el puntaje se indicará para cada acción premiada

% Ganar una partida de ajedrez magico suma 50 puntos
buenaAccion(ajedrezMagico, 50).

% Usar el intelecto para salvar a sus amigos de una muerte suma 50 puntos
buenaAccion(intelecto, 50).

% Ganarle a Voldemort suma 60 puntos
buenaAccion(voldemort, 60).

% Acciones que realizaron los alumnos:

% Harry anduvo fuera de cama
accion(harry, andarFueraDeLaCama).

% Hermione fue al tercer piso 
% y a la sección restringida de la biblioteca
accion(hermione, tercerPiso).
accion(hermione, seccionRestringida).

% Draco fue a las mazmorras
accion(draco, mazmorras).

% Ron gano una partida de ajedrez magico
accion(ron, ajedrezMagico).

% Hermione uso intelecto para salvar a sus amigos de la muerte
accion(hermione, intelecto).

% Harry le gano a Voldemort
accion(harry, voldemort).

% También sabemos en qué casa quedó seleccionado efectivamente 
% cada alumno mediante el predicado esDe/2 
% que relaciona a la persona con su casa

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Punto 1A: 

buenAlumno(Mago) :- 
    accion(Mago, _),
    forall((accion(Mago, Accion), sacarPuntos(Accion, Puntos)), Puntos >= 0).

sacarPuntos(Accion, 0) :-
    not(buenaAccion(Accion, _)),
    not(malaAccion(Accion, _)).

sacarPuntos(Accion, Puntos) :-
    buenaAccion(Accion, Puntos).

sacarPuntos(Accion, Puntos) :-
    malaAccion(Accion, Puntos).

% Punto 1B:

esRecurrente(Accion) :-
    accion(Mago, Accion),
    accion(OtroMago, Accion),
    Mago \= OtroMago.

% Punto 2: 

puntajeTotal(Casa, PuntajeTotal) :-
    esDe(_, Casa),
    setof(Estudiante, esDe(Estudiante, Casa), Estudiantes),
    findall(Punto, (member(Estudiante, Estudiantes), accion(Estudiante, Accion), sacarPuntos(Accion, Puntos)), Puntos),
    sum_list(Puntos, PuntajeTotal).
