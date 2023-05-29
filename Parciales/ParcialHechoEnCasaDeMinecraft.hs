type Material = String
type Materiales = [String]

data Personaje = UnPersonaje {
    nombre :: String,
    puntaje :: Int,
    inventario :: Materiales
} deriving Show

-- Craft:

-- Punto 1:

data Receta = UnaReceta {
    nombreDelMaterial :: Material,
    materialesNecesarios :: Materiales,
    segundosEnCraftear :: Int
} deriving Show

fogata, polloAsado, sueter :: Receta
fogata = UnaReceta "fogata" ["madera", "fosforo"] 10
polloAsado = UnaReceta "pollo asado" ["fogata", "pollo"] 300
sueter = UnaReceta "sueter" ["lana", "agujas", "tintura"] 600

type Craftear = Receta -> Personaje -> Personaje

craftearObjeto :: Craftear
craftearObjeto receta personaje
    | comprobarSiTieneLosMateriales (materialesNecesarios receta) (inventario personaje) = agregarCambios (personajeSinMaterialesPorLaReceta personaje (materialesNecesarios receta)) receta
    | otherwise = cambiarPuntaje (-100) personaje

comprobarSiTieneLosMateriales :: Materiales -> Materiales -> Bool
comprobarSiTieneLosMateriales materialesDeLaReceta materialesDelJugador = all (`elem` materialesDelJugador) materialesDeLaReceta

cambiarPuntaje :: Int -> Personaje -> Personaje
cambiarPuntaje nuevoPuntaje personaje = personaje {puntaje = puntaje personaje + nuevoPuntaje}

personajeSinMaterialesPorLaReceta :: Personaje -> Materiales -> Personaje
personajeSinMaterialesPorLaReceta = foldl vaSacandoElementosRepitidos

sacarMaterialNecesarioDelInventario :: Personaje -> Material -> Personaje
sacarMaterialNecesarioDelInventario personaje materialNecesario = personaje {inventario = tomarUnMaterialNecesario materialNecesario (inventario personaje)}

tomarUnMaterialNecesario :: Material -> Materiales -> Materiales
tomarUnMaterialNecesario _ [] = []
tomarUnMaterialNecesario materialNecesario (material:materiales)
    | materialNecesario == material = materiales
    | otherwise = material : tomarUnMaterialNecesario materialNecesario materiales

agregarCambios :: Personaje -> Receta -> Personaje
agregarCambios personaje receta = (cambiarPuntaje (10 * segundosEnCraftear receta) . agregarMaterial (nombreDelMaterial receta)) personaje

-- Punto 2: (a, b y c)

type Recetas = [Receta]

recetasQueDuplicanPuntaje :: Recetas -> Personaje -> Recetas
recetasQueDuplicanPuntaje recetas jugador = filter (siDuplicaPuntaje jugador) recetas

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

artico :: Bioma
artico = UnBioma "Artico" ["iglu", "hielo", "agua congelada"] (tenerElementoEnElInventario "sueter")

tenerElementoEnElInventario :: String -> Condicion
tenerElementoEnElInventario elementoRequirido materiales = elementoRequirido `elem` materiales

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
