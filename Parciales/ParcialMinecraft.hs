type Material = String
type Materiales = [String]

data Personaje = UnPersonaje {
    nombre :: String,
    puntaje :: Int,
    inventario :: Materiales
} deriving Show

-- Punto 1:

data Receta = UnaReceta {
    materialesNecesarios :: Materiales,
    segundosEnCraftear :: Int
} deriving Show

fogata, polloAsado, sueter :: Receta
fogata = UnaReceta ["madera", "fosforo"] 10
polloAsado = UnaReceta ["fogata", "pollo"] 300
sueter = UnaReceta ["lana", "agujas", "tintura"] 600

type Craftear = Receta -> Personaje -> Personaje

craftearObjeto :: Craftear
craftearObjeto receta personaje
      | comprobarSiTieneLosMateriales (materialesNecesarios receta) (inventario personaje) = (cambiarPuntaje (10*segundosEnCraftear receta) . sacarMateriales (materialesNecesarios receta)) personaje
      | otherwise = cambiarPuntaje (-100) personaje

comprobarSiTieneLosMateriales :: Materiales -> Materiales -> Bool
comprobarSiTieneLosMateriales materialesDeLaReceta materialesDelJugador = all (`elem` materialesDelJugador) materialesDeLaReceta

cambiarPuntaje :: Int -> Personaje -> Personaje
cambiarPuntaje nuevoPuntaje personaje = personaje {puntaje = puntaje personaje + nuevoPuntaje}

sacarMateriales :: Materiales -> Personaje -> Personaje
sacarMateriales materialesNecesarios personaje = foldl vaSacandoElementosRepitidos personaje materialesNecesarios

vaSacandoElementosRepitidos :: Personaje -> Material -> Personaje
vaSacandoElementosRepitidos jugador materialNecesario = jugador {inventario = verSiHayRepitidos materialNecesario (inventario jugador) ++ inventario jugador}

verSiHayRepitidos :: Material -> Materiales -> Materiales
verSiHayRepitidos material materiales
    | length (filter (== material) materiales) > 1 = [material]
    | otherwise = []

-- Punto 2: (a, b y c)

type Recetas = [Receta]

duplicanPuntaje :: Recetas -> Personaje -> Recetas
duplicanPuntaje recetas jugador = filter (siDuplicaPuntaje jugador) recetas

siDuplicaPuntaje :: Personaje -> Receta -> Bool
siDuplicaPuntaje jugador receta  = puntaje (craftearObjeto receta jugador) >= 2 * puntaje jugador

craftearTodasLasRecetas :: Recetas -> Personaje -> Personaje
craftearTodasLasRecetas recetas jugador = foldl (flip craftearObjeto) jugador recetas

averiguarSiConvieneCraftearAlReves :: Recetas -> Personaje -> Bool
averiguarSiConvieneCraftearAlReves recetas jugador = puntaje (craftearTodasLasRecetas recetas jugador) < puntaje (craftearTodasLasRecetas (reverse recetas) jugador)

-- Mine

-- Punto 1:

type Herramienta = Bioma -> Material
type Condicion = Materiales -> Bool

data Bioma = UnBioma {
    nombreDeBioma :: String,
    materialesDelBioma :: Materiales,
    condicionesParaMinar :: Condicion
}

hacha :: Herramienta
hacha bioma = last (materialesDelBioma bioma)

espada :: Herramienta
espada bioma = head (materialesDelBioma bioma)

pico :: Int -> Herramienta
pico posicion bioma = obtenerMaterialEnBasePosicion posicion (materialesDelBioma bioma)

obtenerMaterialEnBasePosicion :: Int -> Materiales -> Material
obtenerMaterialEnBasePosicion posicion materialesDelBioma = materialesDelBioma !! posicion

minar :: Herramienta -> Bioma -> Personaje -> Personaje
minar herramienta bioma jugador
    | condicionesParaMinar bioma (inventario jugador) = (cambiarPuntaje 50 . agregarMaterial (herramienta bioma)) jugador
    | otherwise = jugador

agregarMaterial :: Material -> Personaje -> Personaje
agregarMaterial materialNuevo personaje = personaje {inventario = materialNuevo : inventario personaje}

-- Punto 2 (a y b)

pala :: Herramienta
pala bioma = (obtenerMaterialEnBasePosicion (length (materialesDelBioma bioma) `div` 2) . materialesDelBioma) bioma

azada :: String -> Herramienta
azada materialBuscado bioma = head (filter (\materialDelBioma -> materialBuscado == materialDelBioma) (materialesDelBioma bioma)) -- Expresion lambda

azada' :: String -> Herramienta
azada' materialBuscado bioma = head (filter (==materialBuscado) (materialesDelBioma bioma)) -- Se puede hacer mejor de esta forma 


