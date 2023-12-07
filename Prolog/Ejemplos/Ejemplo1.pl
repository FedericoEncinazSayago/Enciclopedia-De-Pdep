% Hechos
hombre(juan).
hombre(pedro).
mujer(maria).
mujer(laura).
padre(juan, pedro).
padre(juan, laura).
madre(maria, pedro).
madre(maria, laura).

% Reglas
hermano(X, Y) :- padre(Z, X), padre(Z, Y), X \= Y.
hermana(X, Y) :- madre(Z, X), madre(Z, Y), X \= Y.