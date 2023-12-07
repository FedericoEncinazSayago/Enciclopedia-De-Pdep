% De cada restaurante, se conoce cuántas estrellas se le otorgaron en la guía y en qué barrio se ubica:
restaurante(panchoMayo, 2, barracas).
restaurante(tuki, 3, barracas).
restaurante(finoli, 3, villaCrespo).

% De los restaurantes se sabe qué ofrecen de menú, que pueden tener platos a la carta o por pasos. 

% En el menú a la carta se indica el precio y una descripción del plato.

% El menú por pasos, diseñado por un chef en conjunto con un sommelier de vino, 
% consta de un número determinado de platos, un precio, 
% una lista de vinos y una cantidad estimada de comensales que comparte el menú. 

menu(panchoMayo, carta(1000, pancho)).
menu(panchoMayo, carta(200, hamburguesaBarata)).
menu(finoli, carta(2000, hamburguesaBarata)).
menu(finoli, pasos(15, 15000, [chateauMessi, francescoliSangiovese, susanaBalboaMalbec], 6)).
menu(noTanFinoli, pasos(2, 3000, [guinoPin, juanaDama],3)).

%Y luego, de cada vinos se conoce su país de origen y su costo por botella
vino(chateauMessi, francia, 5000).
vino(francescoliSangiovese, italia, 1000).
vino(susanaBalboaMalbec, argentina, 1200).
vino(christineLagardeCabernet, argentina, 5200).
vino(guinoPin, argentina, 500).
vino(juanaDama, argentina, 1000).

% Se pide saber:

% Punto 1: Cuáles son los restaurantes de más de N estrellas por barrio

restaurantesConMasNEstrellas(Restaurantes, Barrio, EstrellasLimite) :-
    findall(Restaurante, tieneMasEstrellas(Restaurante, Barrio, EstrellasLimite), Restaurantes).
        
tieneMasEstrellas(Restaurante, Barrio, EstrellasLimite) :-
    cuantasEstrellasTiene(Restaurante, Barrio,Estrellas),
    Estrellas >= EstrellasLimite.

cuantasEstrellasTiene(Restaurante, Barrio, Estrellas) :-
    restaurante(Restaurante, Estrellas, Barrio).

% Punto 2: Cuáles son los restaurantes sin estrellas.

restauranteSinEstrellas(Restaurantes) :-
    findall(Restaurante, tieneMenuPeroNoRecibioEstrellas(Restaurante), Restaurantes).

tieneMenuPeroNoRecibioEstrellas(Restaurante) :-
    menu(Restaurante, _),
    not(restaurante(Restaurante, _, _)).

% Punto 3: Si un restaurante está mal organizado, que es cuando tiene algún menú que tiene más pasos que la cantidad de vinos disponibles 
% o cuando tiene en su menú a la carta dos veces una misma comida con diferente precio.

estaMalOrganizado(Restaurante) :-
    menu(Restaurante, _),
    tieneAlgunMenuConMasPasosQueVinosDisponibles(Restaurante).

tieneAlgunMenuConMasPasosQueVinosDisponibles(Restaurante) :-
    menu(Restaurante, Menu),
    tieneAlgoMalOrganizado(Menu).

tieneAlgoMalOrganizado(pasos(CantidadDePasos, _, ListaDeVinos, _)) :-
    length(ListaDeVinos, CantidadDeVinos),
    CantidadDePasos > CantidadDeVinos.

estaMalOrganizaddo(Restaurante) :-
    menu(Restaurante, _),
    tieneAlgunMenuRepetidoPeroMasBarato(Restaurante).

tieneAlgunMenuRepetidoPeroMasBarato(Restaurante) :-
    menu(Restaurante, carta(Precio, Comida)),
    menu(Restaurante, carta(OtroPrecio, Comida)),
    Precio \= OtroPrecio.

% Punto 4: Qué restaurante es copia barata de qué otro restaurante, lo que sucede cuando el primero tiene todos los platos a la carta 
% que ofrece el otro restaurante, pero a un precio menor. 
% Además, no puede tener más estrellas que el otro. 

copiaBarata(Restaurante, CopiaDeRestaurante) :-
    menu(CopiaDeRestaurante, _),
    menu(Restaurante, _),
    forall(sacarPlato(Restaurante, NombreDelPlato, Precio), tieneEsePlatoMasBarato(NombreDelPlato, Precio, CopiaDeRestaurante)),
    tieneMasEstrellas(Restaurante, CopiaDeRestaurante).
    
sacarPlato(Restaurante, NombreDelPlato, Precio) :-
    menu(Restaurante, carta(Precio, NombreDelPlato)).

tieneEsePlatoMasBarato(NombreDelPlato, Precio, Restaurante) :-
    sacarPlato(Restaurante, NombreDelPlato, OtroPrecio),
    Precio > OtroPrecio.

tieneMasEstrellas(Restaurante, OtroRestaurante) :-
    restaurante(Restaurante, Estrellas, _),
    restaurante(OtroRestaurante, OtraEstrellas, _),
    Estrellas > OtraEstrellas.

% Punto 5: Cuál es el precio promedio de los menúes de cada restaurante, por persona. 
% En los platos, se considera el precio indicado ya que se asume que es para una persona.
% En los menú por pasos, el precio es el indicado más la suma de los precios de todos los vinos incluidos, pero dividido en la cantidad de % % comensales. 
% Los vinos importados pagan una tasa aduanera del 35% por sobre su precio publicado.

precioPromedio(Restaurante, Promedio) :-
    menu(Restaurante, _),
    promedioDePrecios(Restaurante, Promedio).

promedioDePrecios(Restaurante, Promedio) :-
    findall(Precio, sacarPrecio(Restaurante, Precio), ListaDePrecios),
    sum_list(ListaDePrecios, SumaDePrecios),
    length(ListaDePrecios, CantidadDePlatos),
    Promedio is (SumaDePrecios / CantidadDePlatos).

sacarPrecio(Restaurante, Precio) :-
    menu(Restaurante, Menu),
    precioDeMenu(Menu, Precio).
    
precioDeMenu(carta(Precio, _), Precio).

precioDeMenu(pasos(_, PrecioIndicado, ListaDeVinos, CantidadDeComensales), Precio) :-
    sacarPrecioDeVinos(ListaDeVinos, PreciosDeVinos),
    Precio is ((PrecioIndicado + PreciosDeVinos) / CantidadDeComensales).

sacarPrecioDeVinos(ListaDeVinos, PreciosDeVinos) :-
    findall(PrecioDeVino, preciosIndividuales(ListaDeVinos, PrecioDeVino), ListaDePreciosDeLosVinos),
    sum_list(ListaDePreciosDeLosVinos, PreciosDeVinos).

preciosIndividuales(ListaDeVinos, PrecioIndividual) :-
    member(Vino, ListaDeVinos),
    precioDeVino(Vino, PrecioIndividual).

precioDeVino(Vino, PrecioDeVino) :-
    vino(Vino, argentina, PrecioDeVino).

precioDeVino(Vino, PrecioDeVino) :-
    vino(Vino, Pais, PrecioAhora),
    Pais \= argentina,
    PrecioDeVino is (PrecioAhora * 1.35).
