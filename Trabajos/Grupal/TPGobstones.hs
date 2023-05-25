-- Punto 1:

type Colores = [String]
type BolitasDeColores = [String]
type BolitaDeColor = String
type Posicion = (Int,Int)
type Celda = (Posicion, BolitasDeColores)
type Celdas = [(Posicion, BolitasDeColores)]
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

norte :: Direccion
norte posicionActual = armarTupla posicionActual 1 1

sur :: Direccion
sur posicionActual = armarTupla posicionActual (-1) (-1)

este :: Direccion
este posicionActual = armarTupla posicionActual 1 0

oeste :: Direccion
oeste posicionActual = armarTupla posicionActual (-1) 0

armarTupla :: Posicion -> Int -> Int -> Posicion
armarTupla posicionActual primeraCoordenaNueva segundaCoordenaNueva = (fst posicionActual + primeraCoordenaNueva, snd posicionActual + segundaCoordenaNueva)

direccionesDisponibles :: Direcciones
direccionesDisponibles = [norte, sur, este, oeste]

-- Punto 2:

inicializarTablero :: Int -> Int -> Tablero
inicializarTablero cantFilas cantColumnas = UnTablero (hacerCeldas cantFilas cantColumnas) (UnCabezal (1, 1) direccionesDisponibles)

hacerCeldas :: Int -> Int -> Celdas
hacerCeldas cantFilas cantColumnas = [((x, y), []) | x <- [1..cantFilas], y <- [1..cantColumnas]]

-- Punto 3: (a, b y c)

type Sentencia = Tablero -> Tablero
type FuncionBolitas = BolitaDeColor -> BolitasDeColores -> BolitasDeColores

moverCabezal :: Direccion -> Sentencia
moverCabezal direccionAMover tablero
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

repetir :: Int -> Sentencias -> Sentencia
repetir cantDeVeces sentencias tablero = aplicarSentenciasAlTablero tablero (repetirSentencias cantDeVeces sentencias)

repetirSentencias :: Int -> Sentencias -> Sentencias
repetirSentencias cantDeVeces sentenciasActuales = concat (replicate cantDeVeces sentenciasActuales)

aplicarSentenciasAlTablero :: Tablero -> Sentencias -> Tablero
aplicarSentenciasAlTablero = foldl (\tablero sentencia -> sentencia tablero)

type Condicion = Tablero -> Bool

alternativa :: Condicion -> Sentencias -> Sentencias -> Sentencia
alternativa condicion primerConjunto segundoConjunto tablero
    | condicion tablero = aplicarSentenciasAlTablero tablero primerConjunto
    | otherwise = aplicarSentenciasAlTablero tablero segundoConjunto

si :: Condicion -> Sentencias -> Sentencia
si condicion sentencias = alternativa condicion sentencias []

siNo :: Condicion -> Sentencias -> Sentencia
siNo condicion sentencias = alternativa (not . condicion) sentencias []

mientras :: Condicion -> Sentencias -> Sentencia
mientras condicion sentencias tablero
    | condicion tablero = mientras condicion sentencias (aplicarSentenciasAlTablero tablero sentencias)
    | otherwise = tablero

irAlBorde :: Direccion -> Sentencia
irAlBorde direccion tablero = mientras (puedeMoverse (calcularNuevaPosicion direccion tablero)) [moverCabezal direccion] tablero

-- Punto 5:

cantidadDeBolitasDeEseColor :: BolitaDeColor -> Tablero -> Int
cantidadDeBolitasDeEseColor bolitaDeColor tablero = cuantoHayBolitas bolitaDeColor (celdaActualDelCabezal tablero)

cuantoHayBolitas :: BolitaDeColor -> Celda -> Int
cuantoHayBolitas bolitaDeColor celdaDeCabezal = length (filter (== bolitaDeColor) (snd celdaDeCabezal))
