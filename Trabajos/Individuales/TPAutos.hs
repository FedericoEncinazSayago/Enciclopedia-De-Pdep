-- Defincion de tipos de datos: 
data Persona = UnaPersona {nombre :: String, comprobanteDeImpuestos :: Bool, autos :: [Auto]} deriving (Show)
data Auto = UnAuto {marca :: String, modelo :: Float, kilometros :: Float} deriving (Show)
data Concesionaria = UnaConcesionaria {nombreConcesionaria :: String, autoEnVenta :: Auto, preferencia :: Persona -> Bool}

-- Definicion de variables:
marcasExoticas :: [String]
marcasExoticas = ["Ferrari", "Porsche ", "Lamborghini ", "Bugatti"]

auto1, auto2, auto3, auto4, auto5, auto6 :: Auto
auto1 = UnAuto "Ferrari" 2023 0
auto2 = UnAuto "Renault" 2022 200000
auto3 = UnAuto "Fiat" 1970 100000
auto4 = UnAuto "Porsche" 2022 50000
auto5 = UnAuto "Lamborghini" 1970 100000
auto6 = UnAuto "Bugatti" 2023 0
auto7 = UnAuto "Haskell" 2023 0
auto8 = UnAuto "Lamborghini" 2023 0

federico, francisco, lucas, tomas, nico :: Persona
federico = UnaPersona "Federico" True [auto1, auto2, auto3]
francisco = UnaPersona "Francisco" True [auto1, auto1, auto1]
lucas = UnaPersona "Lucas" False [auto4, auto6, auto2]
tomas = UnaPersona "Tomas" False [auto2]
nico = UnaPersona "Nicolas" True [auto1, auto4]

personas :: [Persona]
personas = [federico, francisco, lucas, tomas, nico]

concesionaria1, concesionaria2, concesionaria3 :: Concesionaria
concesionaria1 = UnaConcesionaria "PdepAutos" auto1 esMillonario
concesionaria2 = UnaConcesionaria "Funcional" auto7 ((>=2) . length . autos)
concesionaria3 = UnaConcesionaria "Promocion" auto8 ((>=8) . length .autos)

concesionariasExistente :: [Concesionaria]
concesionariasExistente = [concesionaria1, concesionaria2, concesionaria3]

-- Definicion de funciones:
esHonesto :: Persona -> Bool
esHonesto = comprobanteDeImpuestos

calcularValorDelAuto :: Auto -> Float
calcularValorDelAuto (UnAuto marca modelo kilometros)
      | marca `elem` marcasExoticas  = 1000000 + 20000 - (1000 * (2023 - modelo)) - (0.05 * kilometros)
      | otherwise =  20000 - (1000 * (2023 - modelo)) - (0.05 * kilometros)

sumarValorDeLosAutos :: [Auto] -> Float
sumarValorDeLosAutos autos = sum (map calcularValorDelAuto autos)

esMillonario :: Persona -> Bool
esMillonario persona = sumarValorDeLosAutos (autos persona) > 1000000

cuantosMilonariosHonestosHay :: [Persona] -> Int
cuantosMilonariosHonestosHay personas = length (filter esHonesto (filter esMillonario personas))

-- Funciones del agregado al ejercicio:
visitarUnConcesionario :: Persona -> Concesionaria -> Persona
visitarUnConcesionario persona concesionaria
  | concesionaria `elem` concesionariasExistente = agregarAuto ((preferencia concesionaria) persona) (autoEnVenta concesionaria) persona
  | otherwise = persona

agregarAuto :: Bool -> Auto -> Persona -> Persona
agregarAuto False _ persona = persona
agregarAuto True auto persona = UnaPersona (nombre persona) (comprobanteDeImpuestos persona) (auto : autos persona)

verificarSiNoComproAutos :: Persona -> [Concesionaria] -> Bool
verificarSiNoComproAutos _ [] = True
verificarSiNoComproAutos persona (concesionaria : concesionarias)
    | length (autos persona) < length (autos (visitarUnConcesionario persona concesionaria)) = False
    | otherwise = verificarSiNoComproAutos persona concesionarias

maximo :: [Auto] -> (Auto -> Float) -> [Auto]
maximo = sacarMaximo 0 []

sacarMaximo :: Float -> [Auto] -> [Auto] -> (Auto -> Float) -> [Auto]
sacarMaximo maximo autosMaximos [] funcionAplicada = [x | x <- autosMaximos, funcionAplicada x == maximo]
sacarMaximo maximo autosMaximos (auto:autos) funcionAplicada
    | funcionAplicada auto >= maximo = sacarMaximo (funcionAplicada auto) (auto:autosMaximos) autos funcionAplicada
    | otherwise = sacarMaximo maximo autosMaximos autos funcionAplicada

esMejorElAutoPor :: [Persona] -> (Auto -> Float) -> [Auto]
esMejorElAutoPor personas funcionAplicada = eliminarRepetidos (maximo (concatMap autos personas) funcionAplicada)
