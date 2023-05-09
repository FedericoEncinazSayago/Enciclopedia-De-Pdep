data Ley = UnaLey {
    nombre :: String,
    tema :: String,
    presupuesto :: Int,
    apoyos :: [String]
}
instance Show Ley where
    show :: Ley -> String
    show = nombre
instance Eq Ley where
    (==) :: Ley -> Ley -> Bool
    (==) (UnaLey _ t1 _ a1) (UnaLey _ t2 _ a2) = (t1 == t2) && comparadorDeApoyo a1 a2

leyMedicinal, leyEducacionSuperior, leyMesaTenis , leyTenis :: Ley
leyMedicinal = UnaLey "Ley Medicinal" "medicinal" 10 ["cambio de todos", "sector financiero","sector conservador"]
leyEducacionSuperior = UnaLey "Ley Educacion Superior" "educacion" 30 ["docentes universitarios", "partido de centro federal"]
leyMesaTenis = UnaLey  "Ley Mesa de Tenis" "tenis" 20 ["partido de centro federal", "liga de deportistas autonomos", "club paleta veloz"]
leyTenis = UnaLey "Ley Tenis" "tenis" 20 ["liga de deportistas autonomos","sector financiero"]
-- Falta compatibilidad de temas, un string adentro de otro
-- "tenis" esta adentro de "cancha de tenis con estacionamiento"
-- "dora" está adentro de "computadoras para colegios"
----- > [1,2,3,4,5,7]   [3,4,5]
comparadorDeApoyo :: [String] -> [String] -> Bool
-- No usar recursividad para esto (any? ver)
comparadorDeApoyo [] _ = False
comparadorDeApoyo (x:xc) apoyo2
    | x `elem` apoyo2 = True
    | otherwise = comparadorDeApoyo xc apoyo2

-- Constitucionalidad de las leyes parte 1
temasEnAgenda :: [String]
temasEnAgenda = ["medicinal", "tenis"]

type Juez = Ley -> Bool

juezOpinionPublica, juezFinanciero, juezPreocupado, juezTolerante, juezConservador:: Juez
juezOpinionPublica ley = tema ley `elem` temasEnAgenda
juezFinanciero ley = "sector financiero" `elem` apoyos ley
-- Repetido entre jueces
-- juezPreocupadoPorPlata monto = presupuesto ley > monto
-- juezPreocupado = juezPreocupadoPorPlata 10
-- juezTolerante = juezPreocupadoPorPlata 20
juezPreocupado ley = presupuesto ley <= 10
juezTolerante ley = presupuesto ley <= 20
-- Mismo acá
juezConservador ley = "sector conservador" `elem` apoyos ley

corteSuprema :: [Juez]
corteSuprema = [juezOpinionPublica, juezFinanciero, juezPreocupado, juezTolerante, juezConservador]

corteTernera :: [Juez]
corteTernera = [juezOpinionPublica, juezFinanciero, juezPreocupado, juezTolerante, juezConservador, juezAfirmativo, juezInventado, juezExquisito]

constitucionalidad :: [Juez] -> Ley -> Bool
constitucionalidad jueces ley = length jueces `div` 2 < contarVerdaderos jueces ley

-- Length de filter 
contarVerdaderos :: [Juez] -> Ley -> Int
contarVerdaderos [] _ = 0
-- Tarea para el hogar: transformar esto en un filter genérico
-- Tarea para el hogar: transformar esto en un sum genérico que recibe una función
contarVerdaderos (x:xs) ley
    | x ley = 1 + contarVerdaderos xs ley
    | otherwise = contarVerdaderos xs ley

-- Constitucionalidad de las leyes parte 2
juezAfirmativo, juezInventado, juezExquisito :: Juez
juezAfirmativo _ = True
juezInventado ley = length (apoyos ley) >= 2
juezExquisito ley = presupuesto ley <= 30 -- un tipo no tan preocupado

-- Constitucionalidad de las leyes parte 2
listaDeLeyes :: [Ley]
listaDeLeyes = [leyMedicinal, leyMesaTenis, leyTenis, leyEducacionSuperior]

queLeyEsInconstitucional :: [Ley] -> [Juez] -> [Ley]
queLeyEsInconstitucional listaLeyes cortSuprema = filter (not . constitucionalidad cortSuprema) listaLeyes

leyesInconstAConst :: [Ley] -> [Juez] -> [Juez] -> [Ley]
leyesInconstAConst leyes juecesViejos juecesNuevos = filter (constitucionalidad juecesNuevos)  (queLeyEsInconstitucional leyes juecesViejos)

-- Cuestión de principios 
borocotizar :: [Juez] -> [Juez]
borocotizar = map (not .)


-- No usar recursividad
-- sectorEstaEnTodas sector leyes corte = (estaEnTodas sector) (aprobadasPorLaCorte corte leyes)
-- estaEnTodas = all (elem ....) (sectores leyes)
saberSiEseSectorSocialEstaEnTodas :: [String] -> [[String]] -> [String]
saberSiEseSectorSocialEstaEnTodas [] _ = []
-- Solo el all, no recursividad
saberSiEseSectorSocialEstaEnTodas (x:xs) apoyosDeLasOtrasLeyes
  | all (\sublista -> x `elem` sublista) apoyosDeLasOtrasLeyes = x : saberSiEseSectorSocialEstaEnTodas xs apoyosDeLasOtrasLeyes
  | otherwise = saberSiEseSectorSocialEstaEnTodas xs apoyosDeLasOtrasLeyes



leyesApoyadasPorEl :: Juez -> [Ley] -> [Ley]
leyesApoyadasPorEl juez listaDeLeyes = filter (juez) listaDeLeyes

apoyosDeLasLeyes :: [Ley] -> [[String]]
apoyosDeLasLeyes = map apoyos

tomarUnaListaDeApoyos :: [[String]] -> [String]
tomarUnaListaDeApoyos listaDeApoyos = head listaDeApoyos

saberSiApoyaUnSectorSocial :: Juez -> [Ley] -> Bool
saberSiApoyaUnSectorSocial juez listaDeLeyes = length (saberSiEseSectorSocialEstaEnTodas ((tomarUnaListaDeApoyos . apoyosDeLasLeyes . leyesApoyadasPorEl juez) listaDeLeyes) ((apoyosDeLasLeyes . leyesApoyadasPorEl juez) listaDeLeyes)) == 1


{- Para pensar: Si hubiera una ley apoyada por infinitos sectores ¿puede ser declarada constitucional? ¿cuáles jueces podrián votarla y cuáles no? Justificar y ejemplificar -}

{- Respuesta:
Si la pregunta es moral, si porque todos estan de acuerdo. Si la pregunta es en cuanto a que
pasaria con el codigo, nunca se llegaria declarar porque la funcion no terminaria de correr al
trabarse en por ejemplo el juezInventado necesita el lenght de la lista de apoyos y al ser infinita
nunca lo obtendria. Mismo pasa con el juezFinanciero que busca el sector financiero en la lista
de apoyos y si el sector financiero es el ultimo en el listado se quedaria sin memoria antes de
llegar.

Los jueces que no interactuen con la lista de apoyos podrian votar sin problemas, mientras que los
que si interactuan con la misma tendrian problemas como juezFinanciero y juezConservador o 
sino un juez como juezInventado nunca podria terminar -}
