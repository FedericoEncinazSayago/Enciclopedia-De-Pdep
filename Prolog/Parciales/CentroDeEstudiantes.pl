% Centro de estudiantes:

% Primera parte:

% Sabemos los años que hay elecciones:
elecciones(2019).
elecciones(2021).

% Tenemos un padrón de estudiantes regulares
% organizado por carrera y año
estudiantes(sistemas, 2021, juli).
estudiantes(mecanica, 2021, agus).
estudiantes(sistemas, 2021, dani).
estudiantes(mecanica, 2019, agus).
estudiantes(sistemas, 2019, dani).
estudiantes(mecanica, 2021, tati).

% Y por supuesto tenemos la info de la cantiad de votos
% obtenida en el detalle de las carreras
votos(franjaNaranja, 50, sistemas, 2019).
votos(franjaNaranja, 20, mecanica, 2019).
votos(franjaNaranja, 100, sistemas, 2021).
votos(agosto29, 70, sistemas, 2021).

% Punto 1: Quien ganó cada elección en la facultad

quienGano(Anio, CentroDeEstudiante) :-
    participoDeEsaEleccion(Anio, CentroDeEstudiante),
    cantidadDeVotos(Anio, CentroDeEstudiante, CantidadDeVotos),
    forall(cantidadDeVotos(Anio, _, OtraCantidadDeVotos), CantidadDeVotos >= OtraCantidadDeVotos).

participoDeEsaEleccion(Anio, CentroDeEstudiante) :-
    elecciones(Anio),
    votos(CentroDeEstudiante, _, _, Anio).

cantidadDeVotos(Anio, CentroDeEstudiante, CantidadDeVotos) :-
    participoDeEsaEleccion(Anio, CentroDeEstudiante),
    findall(Votos, votos(CentroDeEstudiante,Votos, _, Anio), ListaDeVotos),
    sum_list(ListaDeVotos, CantidadDeVotos).

% Punto 2: Si es Cierto que siempre gana el mismo

ganaSiempreElMismo(CentroDeEstudiante) :-
    quienGano(_, CentroDeEstudiante),
    forall(elecciones(Anios), quienGano(Anios, CentroDeEstudiante)).

% Punto 3: Si hubo fraude en un año en particular

huboFraude(Anio) :-
    elecciones(Anio),
    cantidadDeVotos(Anio, _, CantidadDeVotos),
    cantidadDeElectoresDeEseAnio(Anio, CantidadDeElectores),
    CantidadDeVotos > CantidadDeElectores.

cantidadDeElectoresDeEseAnio(Anio, CantidadDeElectores) :-
    estudiantes(_, Anio, _),
    findall(Estudiante, estudiantes(_, Anio, Estudiante), ListaDeEstudiantes),
    length(ListaDeEstudiantes, CantidadDeElectores).
    
% Punto 4: Todos los años en que hubo fraude

aniosQueHuboFraude(Anios) :-
    setof(Anio, huboFraude(Anio), Anios).

% Punto 5: Si Alguna agrupacion ganó elección por afano en
% una carrera en particular, debido a que la diferencia con
% el segundo es muy grande

ganoPorAfanoEnUnCarrera(CentroDeEstudiante, OtroCentroDeEstudiante, CarreraVotante) :-
    participoDeEsaEleccion(Anio, CentroDeEstudiante),
    participoDeEsaEleccion(Anio, OtroCentroDeEstudiante),
    OtroCentroDeEstudiante \= CentroDeEstudiante,
    votosDeCarreraQueEligeAlCentro(CentroDeEstudiante, CarreraVotante, Anio, CantidadDeVotos),
    votosDeCarreraQueEligeAlCentro(OtroCentroDeEstudiante, CarreraVotante, Anio, OtraCantidadDeVotos),
    CantidadDeVotos > OtraCantidadDeVotos.

votosDeCarreraQueEligeAlCentro(CentroDeEstudiante, CarreraVotante, Anio, CantidadDeVotos) :-
    votos(CentroDeEstudiante, CantidadDeVotos, CarreraVotante, Anio).

% Segunda parte:

% Nos llega informacion extraoficial sobre las acciones que realiza cada agrupacion

realizoAccion(franjaNaranja, lucha(salarioDocente)).
realizoAccion(franjaNaranja, gestionIndividual("Excepción de correlativas", tati, 2021)).
realizoAccion(franjaNaranja, obra(2021)).
realizoAccion(agosto29, lucha(salarioDocente)).
realizoAccion(agosto29, lucha(boletoEstudiantil)).

% Punto 1:

esDeTipo(CentroDeEstudiante, demagogica) :-
    realizoAccion(CentroDeEstudiante, _),
    forall(realizoAccion(CentroDeEstudiante, Accion), not(Accion \= gestionIndividual(_, _, _))).

esDeTipo(CentroDeEstudiante, burocrata) :-
    realizoAccion(CentroDeEstudiante, _),
    not(realizoAccion(CentroDeEstudiante, lucha(_))).

esDeTipo(CentroDeEstudiante, transparente) :-
    realizoAccion(CentroDeEstudiante, _),
    forall(realizoAccion(CentroDeEstudiante, Accion), esGenuina(Accion)).

esGenuina(lucha(_)).

esGenuina(obra(Anio)) :-
    not(elecciones(Anio)).

esGenuina(gestionIndividual(_, Estudiante, AnioRegular)) :-
    estudiantes(_, Estudiante, AnioRegular).


