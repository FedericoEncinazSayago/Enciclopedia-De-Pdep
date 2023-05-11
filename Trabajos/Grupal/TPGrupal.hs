data Ley = UnaLey {tema :: String, presupuesto :: Int, apoyos :: [String]}
data Juez = UnJuez {sectorQueApoya :: String, votaA :: Ley -> Bool} 

-- Definicion de instancias para Ley:
instance Eq Ley where
    (==) :: Ley -> Ley -> Bool
    (==) (UnaLey t1 p1 a1) (UnaLey t2 p2 a2) = t1 == t2 && not (null (interseccion a1 a2))



-- Definicion de variables:
ley1 ,ley2, ley3, ley4 , ley5:: Ley
ley1 = UnaLey "educacion" 100 ["partido socialista", "partido comunista", "partido conservador"]
ley2 = UnaLey "seguridad" 200 ["partido socialista", "partido comunista"]
ley3 = UnaLey "economia" 300 ["partido socialista", "partido comunista", "partido conservador"]
ley4 = UnaLey "medio ambiente" 400 ["partido socialista", "partido comunista", "partido conservador"]
ley5 = UnaLey "deporte" 10 ["partido socialista", "partido comunista", "partido conservador"]

juez1' :: Juez

juez1' = UnJuez "partido socialista" enFavorDelSectorFinanciepp-p

leyes :: [Ley]
leyes = [ley1, ley2, ley3, ley4]

agendaDeTemas :: [String]
agendaDeTemas = ["educacion", "seguridad", "economia", "medio ambiente", "deporte"]

juez1, juez2, juez3, juez4, juez5 :: Juez
juez1 = opinionPublica
juez2 = enFavorDelSectorFinanciero
juez3 = enFavorDelPartidoConservador
juez4 = unPocoTolerante
juez5 = masTolerante

corteSuprema :: [Juez]
corteSuprema = [juez1, juez2, juez3, juez4, juez5]

-- Definicion de funciones: 
interseccion :: Eq a => [a] -> [a] -> [a]
interseccion [] _ = []
interseccion (x:xs) ys
    | x `elem` ys = x : interseccion xs ys
    | otherwise = interseccion xs ys

opinionPublica :: Juez
opinionPublica leyEvaluada = tema leyEvaluada `elem` agendaDeTemas

enFavorDelSectorFinanciero :: Juez -> Ley -> Bool 
enFavorDelSectorFinanciero juez leyEvaluada = sectorQueApoya juez `elem` apoyos leyEvaluada

enFavorDelPartidoConservador :: Juez
enFavorDelPartidoConservador leyEvaluada = "partido conservador" `elem` apoyos leyEvaluada

unPocoTolerante :: Juez
unPocoTolerante leyEvaluada = presupuesto leyEvaluada <= 10

masTolerante :: Juez
masTolerante leyEvaluada = presupuesto leyEvaluada <= 20

hayMasVotosPositivos :: [Bool] -> Bool
hayMasVotosPositivos lista = length (filter not lista) < length lista - length (filter not lista)

esConstitucional :: Ley -> [Juez] -> Bool
esConstitucional ley corteSuprema = hayMasVotosPositivos (map (\juez -> juez ley) corteSuprema)

leyesInconstitucionales :: [Ley] -> [Juez] -> [Ley]
leyesInconstitucionales listaDeLeyes corteSuprema = filter (\ley -> not (esConstitucional ley corteSuprema)) listaDeLeyes

cambiarVoto :: Juez -> Juez
cambiarVoto juez = not . juez

borocotizar :: [Juez] -> [Juez]
borocotizar = map cambiarVoto

apoyaUnSectorSocial :: Juez -> [Ley] -> Bool
apoyaUnSectorSocial juez [] = False
apoyaUnSectorSocial juez listaDeLeyes = length (filter (cambiarVoto juez) listaDeLeyes) < length (filter juez listaDeLeyes)