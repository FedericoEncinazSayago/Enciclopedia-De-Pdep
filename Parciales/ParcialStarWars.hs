-- Punto 1:

type Accion = Nave -> Nave
type Poder = [Accion]

data Nave = UnaNave {
    nombreDeNave :: String,
    durabilidad :: Int,
    escudo :: Int,
    ataque :: Int,
    poder :: Poder
}

-- Funciones auxiliares para las naves:

verificarSiSonNegativos :: Int -> Int -> Int
verificarSiSonNegativos actualNivel variacion
    | actualNivel + variacion > 0 = actualNivel + variacion
    | otherwise = 0

turbo :: Accion
turbo = actualizarAtaque 25

actualizarAtaque :: Int -> Accion
actualizarAtaque nuevoNivel nave = nave {ataque = verificarSiSonNegativos (ataque nave) nuevoNivel}

reparacionDeEmergencia :: Accion
reparacionDeEmergencia = actualizarAtaque (-30) . actualizarDurabilidad 50

actualizarDurabilidad :: Int -> Accion
actualizarDurabilidad nuevoNivel nave = nave {durabilidad = verificarSiSonNegativos (durabilidad nave) nuevoNivel}

superTurbo :: Accion
superTurbo = repetirMovimiento 3 turbo

repetirMovimiento :: Int -> Accion -> Nave -> Nave
repetirMovimiento cantDeVeces accion nave
    | cantDeVeces >= 0 = repetirMovimiento (cantDeVeces - 1) accion (accion nave)
    | otherwise = nave

actualizarEscudo :: Int -> Accion
actualizarEscudo nuevoNivel nave = nave {escudo = verificarSiSonNegativos (escudo nave) nuevoNivel}

-- Definimos las naves:

tieFighter, xWing, naveDeDarthVader, millenniumFalcon :: Nave

tieFighter = UnaNave "TIE Fighter" 200 100 50 [turbo]
xWing = UnaNave "X Wing" 300 150 100 [reparacionDeEmergencia]
naveDeDarthVader = UnaNave "Nave de Darth Vader" 500  300 200 [superTurbo, actualizarDurabilidad (-45)]
millenniumFalcon = UnaNave "Millennium Falcon" 1000 500 50 [reparacionDeEmergencia, actualizarEscudo 100]

-- Punto 2:

type Flota = [Nave]

durabilidadDeUnaFlota :: Flota -> Int
durabilidadDeUnaFlota = sum . map durabilidad

comoQuedoUnaNaveDespuesDeSerAtacada :: Nave -> Nave -> Nave
comoQuedoUnaNaveDespuesDeSerAtacada naveAtacante naveAtacada = actulizarNaveAtacada (activarPoderDeLaNave naveAtacada) (activarPoderDeLaNave naveAtacante)

actulizarNaveAtacada :: Nave -> Nave -> Nave
actulizarNaveAtacada naveAtacada naveAtacante
    | ataque naveAtacante > escudo naveAtacada = actualizarDurabilidad (-(calcularNivelDeDano naveAtacante naveAtacada)) naveAtacada
    | otherwise = naveAtacada

calcularNivelDeDano :: Nave -> Nave -> Int
calcularNivelDeDano naveAtacante naveAtacada = ataque naveAtacante - escudo naveAtacada

activarPoderDeLaNave :: Nave -> Nave
activarPoderDeLaNave nave = foldl (\nave accion -> accion nave) nave (poder nave)

-- Punto 4:

estaFueraDeCombate :: Nave -> Bool
estaFueraDeCombate nave = durabilidad nave == 0

-- Punto 5:

type Estrategia = Nave -> Bool

-- Definimos las estrategias:

navesDebiles :: Estrategia
navesDebiles nave = escudo nave <= 200

navesConCiertaPeligrosidad :: Int -> Estrategia
navesConCiertaPeligrosidad nivelDePeligrosidad nave = nivelDePeligrosidad > ataque nave

navesQueQuedarianFueraDeCombate :: Nave -> Estrategia
navesQueQuedarianFueraDeCombate naveAtacante = estaFueraDeCombate . comoQuedoUnaNaveDespuesDeSerAtacada naveAtacante

-- Funcion axuliares para una flota: 

mision :: Flota -> Nave -> Estrategia -> Flota
mision flota naveAtacante estrategia = map (realizarAtaqueSiCumpleConLaEstrategia estrategia naveAtacante) flota

realizarAtaqueSiCumpleConLaEstrategia :: Estrategia -> Nave -> Nave -> Nave
realizarAtaqueSiCumpleConLaEstrategia estrategia naveAtacante naveDeLaFlota
    | estrategia naveDeLaFlota = comoQuedoUnaNaveDespuesDeSerAtacada naveAtacante naveDeLaFlota
    | otherwise = naveDeLaFlota

cualMinimizaLaMision :: Flota -> Nave -> Estrategia -> Estrategia -> Flota
cualMinimizaLaMision flota naveAtacante primerEstrategia segundaEstrategia
    | minimizaLaDurabilidadLaPrimeraEstrategia flota naveAtacante primerEstrategia segundaEstrategia = mision flota naveAtacante primerEstrategia
    | otherwise = mision flota naveAtacante segundaEstrategia

minimizaLaDurabilidadLaPrimeraEstrategia :: Flota -> Nave -> Estrategia -> Estrategia -> Bool
minimizaLaDurabilidadLaPrimeraEstrategia flota naveAtacante primerEstrategia segundaEstrategia = compararDurabilidad (mision flota naveAtacante primerEstrategia) (mision flota naveAtacante segundaEstrategia)

compararDurabilidad :: Flota -> Flota -> Bool
compararDurabilidad flotaConPrimerEstrategia flotaConSegundaEstrategia = durabilidadDeUnaFlota flotaConPrimerEstrategia < durabilidadDeUnaFlota flotaConSegundaEstrategia

