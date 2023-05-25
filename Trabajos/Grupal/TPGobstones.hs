-- Punto 1:

type BolitaDeColor = String
type BolitasDeColores = [BolitaDeColor]
type Posicion = (Number, Number)
type Celda = (Posicion, BolitasDeColores)
type Celdas = [Celda]
type Direccion = Posicion -> Posicion
type Direcciones = [Direccion]

data Tablero = UnTablero {
    celdas :: Celdas,
    cabezal :: Cabezal
}

data Cabezal = UnCabezal {
    celdaActual :: Posicion,
    direccionesQuePuedeMoverse :: Direcciones
}

coloresPosibles :: Colores
coloresPosibles = ["Rojo", "Azul", "Verde", "Negro"]

bolitaRojo, bolitaAzul, bolitaVerde, bolitaNegra :: BolitaDeColor
bolitaRojo = "Rojo"
bolitaAzul = "Azul"
bolitaVerde = "Verde"
bolitaNegra = "Negro"

norte, sur, este, oeste :: Direccion
norte posicionActual = armarTupla posicionActual 1 1
sur posicionActual = armarTupla posicionActual (-1) (-1)
este posicionActual = armarTupla posicionActual 0 1
oeste posicionActual = armarTupla posicionActual (-1) 0

armarTupla :: Posicion -> Number -> Number -> Posicion
armarTupla posicionActual primeraCoordenaNueva segundaCoordenaNueva = (fst posicionActual + primeraCoordenaNueva, snd posicionActual + segundaCoordenaNueva)

direccionesDisponibles :: Direcciones
direccionesDisponibles = [norte, sur, este, oeste]

-- Punto 2:

inicializarTablero :: Number -> Number -> Tablero
inicializarTablero cantFilas cantColumnas = UnTablero (hacerCeldas cantFilas cantColumnas) (UnCabezal (1, 1) direccionesDisponibles)

hacerCeldas :: Number -> Number -> Celdas
hacerCeldas cantFilas cantColumnas = [((x, y), []) | x <- [0..(cantFilas - 1)], y <- [0..(cantColumnas - 1)]]

-- Punto 3: (a, b y c)

type Sentencia = Tablero -> Tablero
type FuncionBolitas = BolitaDeColor -> BolitasDeColores -> BolitasDeColores

mover :: Direccion -> Sentencia
mover direccionAMover tablero
    | puedeMoverse (calcularNuevaPosicion direccionAMover tablero) tablero = actualizarCabezal (calcularNuevaPosicion direccionAMover tablero) tablero
    | otherwise = error "El cabezal se cayó del tablero"

calcularNuevaPosicion :: Direccion -> Tablero -> Posicion
calcularNuevaPosicion direccionAMover tablero = direccionAMover (celdaActual (cabezal tablero))

puedeMoverse :: Posicion -> Tablero -> Bool
puedeMoverse posicionNueva tablero = any (\celda -> fst celda == posicionNueva) (celdas tablero)

actualizarCabezal :: Posicion -> Tablero -> Tablero
actualizarCabezal posicionNueva tablero = tablero {cabezal = (cabezal tablero) {celdaActual = posicionNueva}}

poner :: BolitaDeColor -> Sentencia
poner = actualizarTablero agregarBolita

agregarBolita :: BolitaDeColor -> BolitasDeColores -> BolitasDeColores
agregarBolita bolitaDeColor bolitasDeColores = bolitaDeColor : bolitasDeColores

actualizarTablero :: FuncionBolitas -> BolitaDeColor -> Tablero -> Tablero
actualizarTablero funcionAplicar bolitasDeColor tablero = tablero {celdas = actualizarCelda funcionAplicar bolitasDeColor tablero (celdas tablero)}

actualizarCelda :: FuncionBolitas -> BolitaDeColor -> Tablero -> Celdas -> Celdas
actualizarCelda funcionAplicar bolitaDeColor tablero = map (actualizarBolitasSiEsLaCeldaDelCabezal funcionAplicar bolitaDeColor tablero)

actualizarBolitasSiEsLaCeldaDelCabezal :: FuncionBolitas -> BolitaDeColor -> Tablero -> Celda -> Celda
actualizarBolitasSiEsLaCeldaDelCabezal funcionAplicar bolitaDeColor tablero celda
    | posicionDeLaCeldaEsIgualAlCabezal celda tablero = (posicionDeLaCelda celda, funcionAplicar bolitaDeColor (snd celda))
    | otherwise = celda

posicionDeLaCelda :: Celda -> Posicion
posicionDeLaCelda = fst

posicionDeLaCeldaEsIgualAlCabezal :: Celda -> Tablero -> Bool
posicionDeLaCeldaEsIgualAlCabezal celda tablero = posicionDeLaCelda celda == celdaActual (cabezal tablero)

sacar :: BolitaDeColor -> Sentencia
sacar bolitaDeColor tablero
    | hayUnaBolitaDeEseColor bolitaDeColor tablero = actualizarTablero sacarUnaBolitaDeEseColor bolitaDeColor tablero
    | otherwise = error "No hay bolitas del color para sacar de la celda actual"

sacarUnaBolitaDeEseColor :: BolitaDeColor -> BolitasDeColores -> BolitasDeColores
sacarUnaBolitaDeEseColor bolitaDeColor (bolitaDeColorPrimera : bolitasDeColores)
    | bolitaDeColor == bolitaDeColorPrimera = bolitasDeColores
    | otherwise = bolitaDeColorPrimera : sacarUnaBolitaDeEseColor bolitaDeColor bolitasDeColores

celdaActualDelCabezal :: Tablero -> Celda
celdaActualDelCabezal tablero = head (filter (\celda -> fst celda == celdaActual (cabezal tablero)) (celdas tablero))

hayUnaBolitaDeEseColor :: BolitaDeColor -> Tablero -> Bool
hayUnaBolitaDeEseColor bolitaDeColor tablero  = bolitaDeColor `elem` snd (celdaActualDelCabezal tablero)

-- Punto 4: (a, b, c y d)

type Sentencias = [Sentencia]

repetir :: Number -> Sentencias -> Sentencia
repetir cantDeVeces sentencias tablero = programa tablero (repetirSentencias cantDeVeces sentencias)

repetirSentencias :: Number -> Sentencias -> Sentencias
repetirSentencias cantDeVeces sentenciasActuales = concat (replicate cantDeVeces sentenciasActuales)

type Condicion = Tablero -> Bool

alternativa :: Condicion -> Sentencias -> Sentencias -> Sentencia
alternativa condicion primerConjunto segundoConjunto tablero
    | condicion tablero = programa tablero primerConjunto
    | otherwise = programa tablero segundoConjunto

si :: Condicion -> Sentencias -> Sentencia
si condicion sentencias = alternativa condicion sentencias []

siNo :: Condicion -> Sentencias -> Sentencia
siNo condicion sentencias = alternativa (not . condicion) sentencias []

mientras :: Condicion -> Sentencias -> Sentencia
mientras condicion sentencias tablero
    | condicion tablero = mientras condicion sentencias (programa tablero sentencias)
    | otherwise = tablero

irAlBorde :: Direccion -> Sentencia
irAlBorde direccion tablero = mientras (puedeMoverse (calcularNuevaPosicion direccion tablero)) [mover direccion] tablero

-- Punto 5:

cantidadDeBolitasDeEseColor :: BolitaDeColor -> Tablero -> Number
cantidadDeBolitasDeEseColor bolitaDeColor tablero = cuantoHayBolitasDeEseColorHay bolitaDeColor (celdaActualDelCabezal tablero)

cuantoHayBolitasDeEseColorHay :: BolitaDeColor -> Celda -> Number
cuantoHayBolitasDeEseColorHay bolitaDeColor celdaDeCabezal = length (filter (== bolitaDeColor) (snd celdaDeCabezal))

-- Punto 6:

programa :: Tablero -> Sentencias -> Tablero
programa = foldl (\tablero sentecia -> sentecia tablero)
