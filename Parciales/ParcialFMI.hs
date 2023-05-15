-- Punto 1: (a y b)

type Recurso = String
type Recursos = [String]

data Pais = UnPais {
    perCapita :: Int,
    activosPublicos :: Int,
    activosPrivados :: Int,
    recursos :: Recursos,
    deudaConFMI :: Int
}

namibia :: Pais
namibia = UnPais 4140 4000000 650000 ["mineria", "ecoturismo"] 50

-- Punto 2:

type Estrategia = Pais -> Pais

prestarN :: Int -> Estrategia
prestarN cantidad pais = pais {deudaConFMI = deudaConFMI pais + calcularPorcentaje cantidad 150}

calcularPorcentaje :: Int -> Int -> Int
calcularPorcentaje cantidad porcentaje = (cantidad * porcentaje) `div` 100

reducirPuestos :: Int -> Estrategia
reducirPuestos cantPuestos pais = pais {activosPublicos = activosPublicos pais - cantPuestos, perCapita = perCapita pais + cuantoAumenta cantPuestos}

cuantoAumenta :: Int -> Int
cuantoAumenta cantPuestos
    | cantPuestos > 100 = calcularPorcentaje cantPuestos 20
    | otherwise = calcularPorcentaje cantPuestos 15

sacarleUnRecurso :: Recurso -> Estrategia
sacarleUnRecurso empresa pais =  pais {recursos = filter (/= empresa) (recursos pais), deudaConFMI = deudaConFMI pais - 2}

establecerBlindaje :: Estrategia
establecerBlindaje pais =  (prestarN (productoBrutoInterno pais) . sacarActivosPublicos 500) pais

productoBrutoInterno :: Pais -> Int
productoBrutoInterno pais = perCapita pais * (activosPublicos pais + activosPrivados pais)

sacarActivosPublicos :: Int -> Pais -> Pais
sacarActivosPublicos activosNuevos pais = pais {activosPublicos = activosPublicos pais - activosNuevos}

-- Punto 3: (a y b)

type Receta = [Estrategia]

recetaInventada :: Receta
recetaInventada = [prestarN 200, sacarleUnRecurso "Mineria"]

aplicarReceta :: Pais -> Receta -> Pais
aplicarReceta = foldl (\pais estrategia -> estrategia pais)

-- Punto 4: (a, b y c)

type Paises = [Pais]

averiguarQuienZafa :: Paises -> Paises
averiguarQuienZafa = filter tienePetroleo

tienePetroleo :: Pais -> Bool
tienePetroleo pais = "Petroleo" `elem` recursos pais

deudaTotalDeLosPaises :: Paises -> Int
deudaTotalDeLosPaises = sum . map deudaConFMI

-- Punto 5: 

type Recetas = [Receta]

saberSiVaAscendete :: Recetas -> Pais -> Bool
saberSiVaAscendete = estaOrdenado

estaOrdenado :: Recetas -> Pais -> Bool
estaOrdenado [] _  = True
estaOrdenado [_] _ = True
estaOrdenado (receta1:receta2:recetas) pais
    | esMenorElPBI receta1 receta2 pais = estaOrdenado (receta2:recetas) pais
    | otherwise = False

esMenorElPBI :: Receta -> Receta -> Pais -> Bool
esMenorElPBI primeraReceta segundaReceta pais = productoBrutoInterno (aplicarReceta pais primeraReceta) < productoBrutoInterno (aplicarReceta pais segundaReceta)