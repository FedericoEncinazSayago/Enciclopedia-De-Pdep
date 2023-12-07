padre(homero,bart).
padre(homero,maggie). 
padre(homero,lisa). 
padre(juan, fede). 
padre(nico, julieta).

cantidadDeHijos(Padre, Cantidad) :-     
	padre(Padre, _),
    findall(Hijo, padre(Padre, Hijo), Hijos),
    length(Hijos, Cantidad).
