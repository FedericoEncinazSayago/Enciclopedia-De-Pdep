import Data.List (isInfixOf)

-- Punto 1: (Que es un alfajor?) (a, b y c)

type Rellenos = [Relleno]

data Alfajor = UnAlfajor {
    capasDeRelleno :: Rellenos,
    pesoEnGramos :: Int,
    dulzorInnato :: Int,
    nombreDelAlfajor :: String
} deriving Show

data Relleno = UnRelleno {
    nombreDeRelleno :: String,
    valor :: Int
} deriving (Show, Eq)

-- Definicion de rellenos disponibles:

dulceDeLeche, mousse, fruta :: Relleno
dulceDeLeche = UnRelleno "Dulce De Leche " 12
mousse = UnRelleno "Mousse" 15
fruta = UnRelleno "Fruta" 10

rellenosDisponibles :: Rellenos
rellenosDisponibles = [dulceDeLeche, mousse, fruta]

-- Definicion de alfajores:

jorgito, havanna, capitanDelEspacio :: Alfajor
jorgito = UnAlfajor [dulceDeLeche] 80 8 "Jorgito"
havanna = UnAlfajor [mousse, mousse] 60 12 "Havanna"
capitanDelEspacio = UnAlfajor [dulceDeLeche] 40 12 "Capitan del espacio"

-- Funciones axuliares para los alfajores:

saberCoeficienteDeDulzor :: Alfajor -> Float
saberCoeficienteDeDulzor alfajor = fromIntegral (dulzorInnato alfajor) / fromIntegral (pesoEnGramos alfajor)

saberPrecioDelAlfajor :: Alfajor -> Int
saberPrecioDelAlfajor alfajor = (2 * pesoEnGramos alfajor) + sumatoriaDeLosPreciosDeLosRellenos (capasDeRelleno alfajor)

sumatoriaDeLosPreciosDeLosRellenos :: Rellenos -> Int
sumatoriaDeLosPreciosDeLosRellenos = sum . map sacarValorSiEstaEnLosSaboresDisponibles

sacarValorSiEstaEnLosSaboresDisponibles :: Relleno -> Int
sacarValorSiEstaEnLosSaboresDisponibles relleno
  | relleno `elem` rellenosDisponibles = valor relleno
  | otherwise = 0

unAlfajorEsPotable :: Alfajor -> Bool
unAlfajorEsPotable alfajor = verCapasRelleno (capasDeRelleno alfajor) && cumpleConCoeficienteDeDulzorEstablecido 0.1 alfajor

cumpleConCoeficienteDeDulzorEstablecido :: Float -> Alfajor -> Bool
cumpleConCoeficienteDeDulzorEstablecido indice alfajor = saberCoeficienteDeDulzor alfajor >= indice

verCapasRelleno :: Rellenos -> Bool
verCapasRelleno [] = False
verCapasRelleno [relleno] = True
verCapasRelleno (relleno : rellenos) = sonTodosDelMismoSabor relleno rellenos

sonTodosDelMismoSabor :: Relleno -> Rellenos -> Bool
sonTodosDelMismoSabor rellenoPrincipal = all (== rellenoPrincipal)

-- Punto 2 (Escalabilidad vertical) (a, b, c, d, e y f)

abaratarUnAlfajor :: Alfajor -> Alfajor
abaratarUnAlfajor = actulizarDulzor 7 . actulizarPeso

actulizarPeso :: Alfajor -> Alfajor
actulizarPeso alfajor = alfajor {pesoEnGramos = nuevoPeso (pesoEnGramos alfajor) 10}

nuevoPeso :: Int -> Int -> Int
nuevoPeso actualPeso variacion
    | actualPeso >= 15 = actualPeso - variacion
    | otherwise = 5

actulizarDulzor :: Int -> Alfajor -> Alfajor
actulizarDulzor nuevoDulzor alfajor = alfajor {dulzorInnato = nuevoDulzor}

renombrarAlfajor :: String -> Alfajor -> Alfajor
renombrarAlfajor nombreNuevo alfajor = alfajor {nombreDelAlfajor = nombreNuevo}

agregarCapa :: Relleno -> Alfajor -> Alfajor
agregarCapa rellenoNuevo alfajor = alfajor {capasDeRelleno = rellenoNuevo : capasDeRelleno alfajor}

intentarHacerPremium :: Alfajor -> Alfajor
intentarHacerPremium alfajor
    | unAlfajorEsPotable alfajor = hacerPremium (head (capasDeRelleno alfajor)) (nombreDelAlfajor alfajor ++ " premium") alfajor
    | otherwise = alfajor

hacerPremium :: Relleno -> String -> Alfajor -> Alfajor
hacerPremium rellenoParaAgregar nombrePremium = agregarCapa rellenoParaAgregar . renombrarAlfajor nombrePremium

hacerPremiumUnaCiertaCantidadDeVeces :: Int -> Alfajor -> Alfajor
hacerPremiumUnaCiertaCantidadDeVeces gradosDePremium alfajor
    | gradosDePremium >= 0 = hacerPremiumUnaCiertaCantidadDeVeces (gradosDePremium - 1) (intentarHacerPremium alfajor)
    | otherwise = alfajor

-- Nuevos alfajores:

jorgitito, jorgelin, capitanDelEspacioDeCostaACosta :: Alfajor
jorgitito = (renombrarAlfajor "Jorgitito" . abaratarUnAlfajor) jorgito
jorgelin = (renombrarAlfajor "Jorgelin" . agregarCapa dulceDeLeche) jorgito
capitanDelEspacioDeCostaACosta = (renombrarAlfajor "Capitan del espacio de costa a costa" . hacerPremiumUnaCiertaCantidadDeVeces 4 . abaratarUnAlfajor) capitanDelEspacio

-- Punto 3 (Clientes del kiosco) 

type Alfajores = [Alfajor]
type Criterio = Alfajor -> Bool
type Criterios = [Criterio]

data Cliente = UnCliente {
    nombreDelCliente :: String,
    plataDisponible :: Int,
    alfajoresComprados :: Alfajores,
    gustosPersonales :: Criterios
}

-- Funciones auxiliares para los criterios:

conteganEnSuNombre :: String -> Criterio
conteganEnSuNombre palabraContenida alfajor = palabraContenida `isInfixOf` nombreDelAlfajor alfajor

antiRelleno :: Relleno -> Criterio
antiRelleno rellenoQueNoSequiere alfajor = rellenoQueNoSequiere `notElem` capasDeRelleno alfajor

dulcero :: Criterio
dulcero = cumpleConCoeficienteDeDulzorEstablecido 0.15

extrano :: Criterio
extrano alfajor = not (unAlfajorEsPotable alfajor)

pretencioso :: Criterio
pretencioso = conteganEnSuNombre "premium"

-- Definicion de los clientes:

emi, tomi, dante, juan :: Cliente
emi = UnCliente "Emi" 120 [] [conteganEnSuNombre "Capitan del espacio"]
tomi = UnCliente "Tomi" 100 [] [pretencioso, dulcero]
dante = UnCliente "Dante" 200 [] [antiRelleno dulceDeLeche, extrano]
juan = UnCliente "Juan" 500 [] [conteganEnSuNombre "Jorgito", pretencioso, antiRelleno mousse]

-- Funciones para los clientes:

cualesLesGustan :: Alfajores -> Cliente -> Alfajores
cualesLesGustan alfajores cliente = leGustan alfajores (gustosPersonales cliente)

leGustan :: Alfajores -> Criterios -> Alfajores
leGustan alfajores gustosDelCliente = filter (cumplenConLosGustos gustosDelCliente) alfajores

cumplenConLosGustos :: Criterios -> Alfajor -> Bool
cumplenConLosGustos gustosPersonales alfajor = all (\gustoPersonal -> gustoPersonal alfajor) gustosPersonales

intentaComprar :: Alfajor -> Cliente -> Cliente
intentaComprar alfajor cliente
    | saberPrecioDelAlfajor alfajor <= plataDisponible cliente = compraAlfajor alfajor cliente
    | otherwise = cliente

compraAlfajor :: Alfajor -> Cliente -> Cliente
compraAlfajor alfajor = actulizarPlataDisponible (saberPrecioDelAlfajor alfajor) . agregarAlfajor alfajor

actulizarPlataDisponible :: Int -> Cliente -> Cliente
actulizarPlataDisponible gastoPorElAlfajor cliente = cliente {plataDisponible = plataDisponible cliente - gastoPorElAlfajor}

agregarAlfajor :: Alfajor -> Cliente -> Cliente
agregarAlfajor alfajorNuevo cliente = cliente {alfajoresComprados = alfajorNuevo : alfajoresComprados cliente}

comprarAlfajoresQueLeGusten :: Alfajores -> Cliente -> Cliente
comprarAlfajoresQueLeGusten alfajores cliente = comprarAlfajores cliente (cualesLesGustan alfajores cliente)

comprarAlfajores :: Cliente -> Alfajores -> Cliente
comprarAlfajores = foldl (flip compraAlfajor)
