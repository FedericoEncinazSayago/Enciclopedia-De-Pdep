-- Concediendo deseos

type Habilidades = [String]
type Deseo = Chico -> Chico
type Deseos = [Deseo]

data Chico = UnChico {
    nombre :: String,
    edad :: Int,
    habilidades :: Habilidades,
    deseos :: Deseos
}

-- Punto 1 (a, b y c):

versionesDeNeedForSpeeed :: [String]
versionesDeNeedForSpeeed = map (crearVersion "jugar need for speeed ") [1..]

crearVersion :: String -> Int -> String
crearVersion palabra nroDeVersion = palabra ++ show nroDeVersion

aprenderHabilidades :: Habilidades -> Deseo
aprenderHabilidades nuevasHabilidades chico = chico {habilidades = habilidades chico ++ nuevasHabilidades}

serGrosoEnNeedForSpeed :: Deseo
serGrosoEnNeedForSpeed chico = chico {habilidades = habilidades chico ++ versionesDeNeedForSpeeed}

serMayor :: Deseo
serMayor = chico {edad = 18}

cambiarEdad :: (Int -> Int) -> Chico -> Chico
cambiarEdad nuevaEdad chico = chico {edad = nuevaEdad (edad chico)}

-- Punto 2 (a, b y c):

type PadrinoMagico = Chico -> Chico

wanda :: PadrinoMagico
wanda chico = (cambiarEdad (+1) . cumplirDeseo chico) $ head (deseos chico)

cumplirDeseo :: Chico -> Deseo -> Chico
cumplirDeseo chico deseo = deseo chico

cosmo :: PadrinoMagico
cosmo = cambiarEdad (`div` 2)

muffinMagico :: PadrinoMagico
muffinMagico chico = foldl cumplirDeseo chico (deseos chico)

-- En Busqueda De Pareja 

-- Punto 1: (a y b)

type Requisito = Chico -> Bool
type Habilidad = String

data Chica = UnaChica {
    nombreDeLaChica :: String,
    requisitoParaSalir :: Requisito
}

tieneHabilidad :: String -> Requisito
tieneHabilidad habilidad chico = habilidad `elem` habilidades chico

esSuperMaduro :: Requisito
esSuperMaduro chico = esMayor chico && tieneHabilidad "manejar" chico

esMayor :: Chico -> Bool
esMayor chico = edad chico > 18

-- Punto 2

noEsTimmy :: Requisito
noEsTimmy chico = nombre chico /= "Timmy"

trixie, vicky :: Chica
trixie = UnaChica "Trixie Tang" noEsTimmy
vicky = UnaChica "Vicky" (tieneHabilidad "ser un supermodelo noruego")

type Pretendientes = [Chico]

quienConquistaA :: Chica -> Pretendientes -> Chico
quienConquistaA chica pretendientes
    | hayUnoQueCumpleLosRequisitos chica pretendientes = encontrarPrimeroQueCumplaRequisitos chica pretendientes
    | otherwise = last pretendientes

hayUnoQueCumpleLosRequisitos :: Chica -> Pretendientes -> Bool
hayUnoQueCumpleLosRequisitos chica = any (requisitoParaSalir chica)

encontrarPrimeroQueCumplaRequisitos :: Chica -> Pretendientes -> Chico
encontrarPrimeroQueCumplaRequisitos chica (pretendiente:pretendientes)
    | requisitoParaSalir chica pretendiente = pretendiente
    | otherwise = encontrarPrimeroQueCumplaRequisitos chica pretendientes

-- Da Rules

-- Punto 1:

habilidadesProhibidas :: Habilidades
habilidadesProhibidas = ["enamorar", "matar", "dominar el mundo"]

type Chicos = [Chico]

infractoresDeDaRules :: Chicos -> Chicos
infractoresDeDaRules = filter tieneHabilidadesProhibidas

tieneHabilidadesProhibidas :: Chico -> Bool
tieneHabilidadesProhibidas chico = any (`elem` habilidadesProhibidas) (tomar5HabilidadesIniciales chico)

tomar5HabilidadesIniciales :: Chico -> Habilidades
tomar5HabilidadesIniciales chico = take 5 (habilidades (muffinMagico chico))
