-- Definicion de types:
type Chocobo = (Int, Int, Int)
type Pista = (Int, Chocobo -> Int)
type Corredor = (String, Chocobo)

-- Definicion de funciones de correcion de velocidad:
f1 :: Chocobo -> Int
f1 chocobo = velocidad chocobo * 2

f2 :: Chocobo -> Int
f2 chocobo = velocidad chocobo + fuerza chocobo

f3 :: Chocobo -> Int
f3 chocobo = velocidad chocobo `div` peso chocobo

-- Definicion de funciones de acceso a los datos de un Chobobo:
fuerza :: Chocobo -> Int
fuerza (f,_,_) = f

peso :: Chocobo -> Int
peso (_,p,_) = p

velocidad :: Chocobo -> Int
velocidad (_,_,v) = v

-- Definicion de variables:
bosqueTenebroso, pantanoDelDestino :: [Pista]
bosqueTenebroso = [(100, f1), (50, f2), (120, f2), (200, f1), (80, f3)]
pantanoDelDestino = [(40, f2), (90, \(f,p,v) -> f + p + v), (120, fuerza), (20, fuerza)]

amarillo , negro, blanco, rojo :: Chocobo
amarillo = (5, 3, 3)
negro = (4, 4, 4)
blanco = (2, 3, 6)
rojo = (3, 3, 4)

apocalipsis :: [Corredor]
apocalipsis = [("Leo", amarillo), ("Gise", blanco), ("Mati", negro), ("Alf",rojo)]

-- Defincion de funciones de auxiliares: 
quickSort :: (a -> a -> Bool) -> [a] -> [a]
quickSort _ [] = []
quickSort criterio (x:xs) = (quickSort criterio . filter (not . criterio x)) xs ++ [x] ++ (quickSort criterio . filter (criterio x)) xs

ordenarPorTuplas :: Ord a1 => [(a0, a1)] -> [(a0, a1)]
ordenarPorTuplas = quickSort (\(_,t1) (_,t2) -> t2 > t1)

mapearPorTiempoTotal :: [Pista] -> [Corredor] -> [(Chocobo, Int)]
mapearPorTiempoTotal pistas = map (\(x,y) -> (y, tiempoTotal pistas y))

mapearPorTiempo :: Pista -> [Corredor] -> [(Chocobo, Int)]
mapearPorTiempo pista = map (\(x,y) -> (y, tiempo y pista))

losMejoresChocobos :: [Pista] -> [Corredor] -> [(Chocobo,Int)]
losMejoresChocobos pistas corredores = take 3 (ordenarPorTuplas (mapearPorTiempoTotal pistas corredores))

hacerListaDelPodio :: [Pista] -> [Corredor] -> [Corredor]
hacerListaDelPodio pistas corredores = filter (\(x,y) -> (y, tiempoTotal pistas y) `elem` losMejoresChocobos pistas corredores) corredores

elMejorCorredor :: Pista -> [Corredor] -> [(Chocobo, Int)]
elMejorCorredor pista corredores = take 1 (ordenarPorTuplas (mapearPorTiempo pista corredores))

hacerListaDelMejorCorredor :: Pista -> [Corredor] -> [Corredor]
hacerListaDelMejorCorredor pista corredores = filter (\(x,y) -> (y, tiempo y pista) `elem` elMejorCorredor pista corredores) corredores

-- Funciones del punto 1: 
mayorSegun :: Ord a => (t -> a) -> t -> t -> Bool
mayorSegun funcionAplicada primerValor segundoValor = funcionAplicada primerValor > funcionAplicada segundoValor

menorSegun :: Ord a => (t -> a) -> t -> t -> Bool
menorSegun funcionAplicada primerValor segundoValor = not (mayorSegun funcionAplicada primerValor segundoValor)

-- Funciones del punto 2:
tiempo :: Chocobo -> Pista -> Int
tiempo chocobo (distancia, correcciónDeVelocidad) = distancia `div` correcciónDeVelocidad chocobo

tiempoTotal :: [Pista] -> Chocobo -> Int
tiempoTotal pistas chocobo = sum (map (tiempo chocobo) pistas)

-- Funciones del punto 3:
podio :: [Pista] -> [Corredor] -> [Corredor]
podio = hacerListaDelPodio

-- Funciones del punto 4:
elMejorDelTramo :: Pista -> [Corredor] -> String
elMejorDelTramo pista corredores = fst (head (hacerListaDelMejorCorredor pista corredores))

elMasWinner :: [Pista] -> [Corredor] -> String
elMasWinner pistas corredores = head (quickSort (==) (map (`elMejorDelTramo` corredores) pistas))

-- Funciones del punto 5:
quienesPueden :: Pista -> Int -> [Corredor]  -> [String]
quienesPueden pista tiempoMax corredores = [x | (x, y) <- corredores, tiempo y pista <= tiempoMax]
