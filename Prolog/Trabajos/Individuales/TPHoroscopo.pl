% Hechos: Personas, signos y meses

nacio(nacho, bsas, 26, 5, 1989).
nacio(tito, bsas, 20, 6, 2000).
nacio(tita, bsas, 10, 6, 2000).
nacio(lola, bsas, 1, 1, 2001).
nacio(lucas,bsas,1,4,2002).

signoPdeP(funcional, 28, 3, 12, 4). % Los signos estan establecidos por nombre del signo, dia de inicio, mes de inicio, dia final y mes final
signoPdeP(funcional, 12, 4, 29, 5).
signoPdeP(logico, 30, 5, 13, 6).
signoPdeP(logico, 13, 6, 18, 7).
signoPdeP(objetos, 22, 8, 26, 9).
signoPdeP(objetos, 26, 9, 31, 10).
signoPdeP(objetos, 31, 10, 28,11).
signoPdep(nada, 29, 11, 30, 12).

mes(1, 31).
mes(2, 28).
mes(2, 29).
mes(3, 31).
mes(4, 30).
mes(5, 31).
mes(6, 30).
mes(7, 31).
mes(8, 31).
mes(9, 30).
mes(10, 31).
mes(11, 30).
mes(12, 31).

% Regla: De qué signo es una persona?

horoscopoPdep(Nombre, Signo) :- 
    nacio(Nombre, _, DiaDeNac, MesDeNac, _),
    signoPdeP(Signo, DiaInico, MesDeNac, _, _), % Verifica si alguno signo inicia en el mes de nacimiento de la persona, y ademas trae el dia de inicio del signo
    mes(MesDeNac,CantDias),
    DiaDeNac >= DiaInico, % Si encuentra uno, verifica si el dia de nacimiento esta entre el rango del dia de inicio y la cantidad de dias de ese mes 
    DiaDeNac =< CantDias.

horoscopoPdep(Nombre, Signo) :- 
    nacio(Nombre, _, DiaDeNac, MesDeNac, _), 
    signoPdeP(Signo, _, _, DiaFinal, MesDeNac), % Verifica si alguno signo termina en el mes de nacimiento de la persona, y ademas trae el dia final del signo
    DiaDeNac =< DiaFinal. % Compara si el dia de nacimiento es menor al dia final establecido 
