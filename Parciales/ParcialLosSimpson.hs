-- Punto 1: Actividades de los personajes

type Actividad = Personaje -> Personaje

data Personaje = UnPersonaje {
    nombre :: String,
    felicidad :: Int,
    dinero :: Int
} deriving Show

-- Definimos funciones auxiliares para los personajes:

actualizarFelicidad :: Int -> Personaje -> Personaje
actualizarFelicidad nuevoNivel personaje = personaje {felicidad = comoQuedaElNivel (felicidad personaje) nuevoNivel}

comoQuedaElNivel :: Int -> Int -> Int
comoQuedaElNivel actualNivel variacion
    | actualNivel + variacion > 0 = actualNivel + variacion
    | otherwise = 0

actualizarDineroDisponible :: Int -> Personaje -> Personaje
actualizarDineroDisponible nuevoNivel personaje = personaje {dinero = dinero personaje + nuevoNivel}

-- Definimos las actividades:

irEscuelaElemental :: Actividad
irEscuelaElemental personaje
    | siNoEsTal "Lisa Simpson" personaje = actualizarFelicidad (-20) personaje
    | otherwise = actualizarFelicidad 20 personaje

siNoEsTal :: String -> Personaje -> Bool
siNoEsTal nombreDeLaPersona personaje = nombre personaje /= nombreDeLaPersona

comerDona :: Actividad
comerDona = actualizarFelicidad 10 . actualizarDineroDisponible (-10)

comerUnaCantidadDeDonas :: Int -> Actividad
comerUnaCantidadDeDonas cantDeDonasComidas personaje
    | cantDeDonasComidas >= 0 = comerUnaCantidadDeDonas (cantDeDonasComidas - 1) (comerDona personaje)
    | otherwise = personaje

irAlTrabajo :: String -> Actividad
irAlTrabajo trabajo = actualizarDineroDisponible (cuantoGano trabajo)

cuantoGano :: String -> Int
cuantoGano = length

serDirector :: Actividad
serDirector = actualizarFelicidad (-20) . irAlTrabajo "Escuela elemental"

-- Definimos personajes:

homero, skinner, lisa :: Personaje

homero = UnPersonaje "Homero Simpson" 50 100
skinner = UnPersonaje "Skinner" 10 500
lisa = UnPersonaje "Lisa Simpson" 100 0

-- Ejemplos de invocacion por terminal:

{-
    Invocacion: ghci> serDirector skinner 

    Resultado: ghci> UnPersonaje {nombre = "Skinner", felicidad = 0, dinero = 517}
-}

{-
    Invocacion: ghci> comerUnaCantidadDeDonas 12 homero

    Resultado: UnPersonaje {nombre = "Homero Simpson", felicidad = 180, dinero = -30}
-}

-- Punto 2: Logros

type Logro = Personaje -> Bool

-- Definimos el Sr.Burns:

srBurns :: Personaje
srBurns = UnPersonaje "Sr.Burns" 0 1000000000

-- Definimos los logros:

serMillonario :: Logro
serMillonario personaje = dinero personaje > dinero srBurns

alegrarse :: Int -> Logro
alegrarse nivelFelicidadDeseado personaje = felicidad personaje > nivelFelicidadDeseado

irAlProgramaDeKrosti :: Logro
irAlProgramaDeKrosti personaje = dinero personaje >= 10

-- Funciones auxiliares para los logros:

unaActividadResultaDecisivaParaLograrUnLogro :: Actividad -> Logro -> Personaje -> Bool
unaActividadResultaDecisivaParaLograrUnLogro actividad logro personaje
    | logro personaje = False
    | otherwise = (logro . actividad) personaje

type Actividades = [Actividad]

encontrarLaActivadadDecisivaParaLograrElLogro :: Actividades -> Logro -> Personaje -> Personaje
encontrarLaActivadadDecisivaParaLograrElLogro [] logro personaje = personaje
encontrarLaActivadadDecisivaParaLograrElLogro (actividad : actividades) logro personaje
    | unaActividadResultaDecisivaParaLograrUnLogro actividad logro personaje = actividad personaje
    | otherwise = encontrarLaActivadadDecisivaParaLograrElLogro actividades logro personaje

-- Definimos lista infita de actividades:

hacerActividadesInfinitas :: Actividades -> Actividades
hacerActividadesInfinitas actividades = actividades ++ hacerActividadesInfinitas actividades