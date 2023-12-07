% Se conocen los comercios adheridos en cada destino que entran en el pograma

comercioAdherido(iguazu, grandHotelIguazu).
comercioAdherido(iguazu, gargantaDelDiabloTour).
comercioAdherido(bariloche, aerolineas).
comercioAdherido(buenosAires, aerolineas).

% También, se conoce de cada persona las facturas que presentó y el monto máximo reconocido para una habitacion de hotel

factura(estanislao, hotel(grandHotelIguazu, 2000)).
factura(antonieta, excursion(gargantaDelDiabloTour, 5000, 4)).
factura(antonieta, vuelo(1515, antonietaPerez)).

valorMaximoHotel(5000).

% Y los vuelos que efectivamente se hicieron:

registroVuelo(1515, buenosAires, aerolineas, [estanislaoGarcia, antonietaPerez, danielIto], 10000).

% Punto 1: El monto a devolver a cada persona que presentó facturas.

comercio(hotel(Comercio, _), Comercio).

comercio(excursion(Comercio, _, _), Comercio).

comercio(vuelo(NroDeVuelo, _), Comercio) :-
    comercioAdherido(_, Comercio),
    registroVuelo(NroDeVuelo, _, Comercio, _, _).

facturaTrucha(DetalleDeFactura) :-
    comercio(DetalleDeFactura, Comercio),
    not(comercioAdherido(_, Comercio)).

facturaTrucha(hotel(_, ImportePagado)) :-
    valorMaximoHotel(ValorMaximo),
    ValorMaximo >= ImportePagado.

facturaTrucha(vuelo(NroDeVuelo, NombreCompleto)) :-
    registroVuelo(NroDeVuelo, _, _, ListaPasajeros, _),
    not(member(NombreCompleto, ListaPasajeros)).

monto(hotel(_, _, Monto), Monto).

monto(excursion(_, ImportePagado, CantDePersonas), Monto) :-
    Monto is (ImportePagado / CantDePersonas).

monto(vuelo(NroDeVuelo, _), Monto) :-
    registroVuelo(NroDeVuelo, _, _, _,Monto).

porcentajeDevolucion(hotel(_, _), 0.5).

porcentajeDevolucion(excursion(_, _, _), 0.8).

porcentajeDevolucion(vuelo(NroDeVuelo, _), 0) :-
    registroVuelo(NroDeVuelo, buenosAires, _, _, _).

porcentajeDevolucion(vuelo(NroDeVuelo, _), 0.3) :-
    registroVuelo(NroDeVuelo, LugarDestino, _, _, _),
    LugarDestino \= buenosAires.

montoADevolverDeUnaFactura(Turista, Monto) :-
    factura(Turista, DetalleDeFactura),
    not(facturaTrucha(DetalleDeFactura)),
    monto(DetalleDeFactura, MontoSinPorcentaje),
    porcentajeDevolucion(DetalleDeFactura, Porcentaje),
    Monto is MontoSinPorcentaje * Porcentaje.

montoDePenalidad(Turista, 0) :-
    factura(Turista, DetalleDeFactura),
    not(facturaTrucha(DetalleDeFactura)).

montoDePenalidad(Turista, 15000) :-
    factura(Turista, DetalleDeFactura),
    facturaTrucha(DetalleDeFactura).

esUnaFacturaValidadDeHotel(Turista, Cuidad) :-
    factura(Turista, hotel(Cuidad, Comercio, ImportePagado)),
    comercioAdherido(Cuidad, Comercio),
    valorMaximoHotel(ValorMaximo),
    ImportePagado =< ValorMaximo.

montoAdicional(Turista, MontoAdicional) :-
    setof(Cuidad, esUnaFacturaValidadDeHotel(Turista, Cuidad), Cuidades),
    length(Cuidades, CantDeElementos),
    MontoAdicional is (1000 * CantDeElementos).

montoDeFacturas(Turista, MontoDeFacturas) :-
    findall(Monto, montoADevolverDeUnaFactura(Turista, Monto), ListaDeMontos),
    sum_list(ListaDeMontos, MontoDeFacturas).

montoADevolverTotal(Turista, MontoTotal) :-
    factura(Turista, _),
    montoDeFacturas(Turista, MontoDeFacturas),
    montoAdicional(Turista, MontoAdicional),
    montoDePenalidad(Turista, MontoDePenalidad),
    MontoTotal is (MontoDeFacturas + MontoAdicional - MontoDePenalidad).
    
