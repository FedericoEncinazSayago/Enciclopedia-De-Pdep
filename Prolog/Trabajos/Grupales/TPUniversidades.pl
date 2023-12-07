% Nos interesa analizar la situacion actual del estudiante de las universidades argentinas:

estudia("Agustin", "Ingenieria en sistemas", "UTN").
estudia("Carlos", "Ingenieria en sistemas", "UTN").
estudia("Nicolas", "Biologo", "Oxford").
estudia("Charly", "Actuario", "Oxford").

trabaja("Agustin", empleoPrivado("Microsoft", "Tecnologia"), 8).
trabaja("Agustin", empleoPublico("YPF", "Ministerio de Economia", "Industria petrolera"), 8).
trabaja("Charly", empleoPrivado("IBM", "Economia"), 10).
trabaja("Carlos", planSocial("ANSES"), 8).

organizacion("ANSES", "Seguridad social").

habilitacionProfesional("Actuario", ["Economia"]).
habilitacionProfesional("Ingenieria en sistemas", ["Tecnologia"]).

% Punto 1: Las universidades a las que puede califcarse como obreras, considerando todos los estudiantes de es esa universidad trabajan.

esObrera(Universidad) :-
    estudia(_, _, Universidad),
    forall(estudia(Estudiante, _, Universidad), trabaja(Estudiante, _, _)).

% Punto 2: La universidad con mayor porcentaje de estudiantes trabajadores.

sonTrabajadoresEstudiantes(Estudiante, Universidad) :-
    estudia(Estudiante, _, Universidad),
    trabaja(Estudiante, _, _).

cantDeEstudiantesTotalesEn(Universidad, CantidadTotal) :-
    estudia(_, _, Universidad),
    findall(Estudiante, estudia(Estudiante, _, Universidad), Estudiantes),
    length(Estudiantes, CantidadTotal).

cantDeEstudiantesTrabajadoresEn(Universidad, Cantidad) :-
    estudia(_, _, Universidad),
    findall(Estudiante, sonTrabajadoresEstudiantes(Estudiante, Universidad), Estudiantes),
    length(Estudiantes, Cantidad).

porcentajeDeEstudiantesTrabajadores(Universidad, Porcentaje) :-
    estudia(_, _, Universidad),
    cantDeEstudiantesTotalesEn(Universidad, CantidadTotal),
    cantDeEstudiantesTrabajadoresEn(Universidad, CantidadDeTrabajadores),
    Porcentaje is (CantidadDeTrabajadores / CantidadTotal).

tieneMasPorcentajeEstudiantes(Universidad, OtraUniversidad) :-
    estudia(_, _, Universidad),
    estudia(_, _, OtraUniversidad),
    Universidad \= OtraUniversidad,
    porcentajeDeEstudiantesTrabajadores(Universidad, PrimerPorcentaje),
    porcentajeDeEstudiantesTrabajadores(OtraUniversidad, SegundoPorcentaje),
    SegundoPorcentaje > PrimerPorcentaje.

mayorPorcentajeDeEstudiantes(Universidad) :-
    estudia(_, _, Universidad),
    not(tieneMasPorcentajeEstudiantes(Universidad, _)).

% Punto 3: Las personas que trabajan, pero nunca en algo vinculado con una carrera que estudien.

deQueRubroSonSusTrabajos(Trabajador, Rubro) :-
    trabaja(Trabajador, empleoPrivado(_, Rubro),_).

deQueRubroSonSusTrabajos(Trabajador, Rubro) :-
    trabaja(Trabajador, empleoPublico(_, _, Rubro), _).

deQueRubroSonSusTrabajos(Trabajador, Rubro) :-
    trabaja(Trabajador, planSocial(Organizacion), _),
    organizacion(Organizacion, Rubro).

sonTrabajosAsociados(Rubro, Carrera) :-
    habilitacionProfesional(Carrera, ListaDeRubros),
    member(Rubro, ListaDeRubros).

noTieneTrabajoDeCampo(Estudiante) :-
    estudia(Estudiante, Carrera, _),
    trabaja(Estudiante,_,_),
    forall(deQueRubroSonSusTrabajos(Estudiante, Rubro), not(sonTrabajosAsociados(Rubro, Carrera))).



    
