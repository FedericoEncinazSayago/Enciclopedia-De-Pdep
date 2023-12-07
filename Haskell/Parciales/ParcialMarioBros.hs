import Data.Char (isUpper)
import Data.List (genericLength)

-- Punto 1: Modelar a los "plomeros" y "herramientas"

type Herramientas = [Herramienta]

data Plomero = UnPlomero {
    nombre :: String,
    reparacionesHechas :: Reparaciones,
    dineroDisponible :: Float,
    cajaDeHerramienta :: Herramientas
}

data Herramienta = UnaHerramienta {
    nombreDelaHerramienta :: String,
    precio :: Float,
    mango :: Mango
} deriving (Show, Eq)

data Mango = Hierro | Madera | Goma | Plastico deriving (Show, Eq)

-- Funcion auxiliar para las herramientas:

tenerInfinitasHerramientas :: Herramienta -> Herramientas
tenerInfinitasHerramientas herramientaConocida = [aumentarPrecio herramientaConocida precio | precio <- [0..]]

aumentarPrecio :: Herramienta -> Float -> Herramienta
aumentarPrecio herramienta valorNuevo = herramienta {precio = precio herramienta + valorNuevo}

-- Herramientas conocidas:

llaveInglesa, martillo, llaveFrancesa :: Herramienta

llaveInglesa = UnaHerramienta "Llave Inglesa" 200 Hierro
martillo = UnaHerramienta "Martillo " 20 Madera
llaveFrancesa = UnaHerramienta "Llave Francesa" 1 Hierro

-- Plomeros Conocidos:

mario, wario :: Plomero

mario =  UnPlomero "Mario" [] 1200 [llaveInglesa, martillo]
wario = UnPlomero "Wario" [] 0.5 (tenerInfinitasHerramientas llaveFrancesa)

-- Punto 2: Saber si un plomero

esMalvado :: Plomero -> Bool
esMalvado plomero = ((== "Wa") . tomarNCantidadDeCaracteres 2) (nombre plomero)

tomarNCantidadDeCaracteres :: Int -> String -> String
tomarNCantidadDeCaracteres = take

puedeComprar :: Herramienta -> Plomero -> Bool
puedeComprar herramienta plomero = dineroDisponible plomero >= precio herramienta

tieneUnaHerramientaConTalNombre :: String -> Plomero -> Bool
tieneUnaHerramientaConTalNombre nombre plomero = any (esNombreBuscado nombre) (cajaDeHerramienta plomero)

esNombreBuscado :: String -> Herramienta -> Bool
esNombreBuscado nombreBuscado herramienta = ((== nombreBuscado). tomarNCantidadDeCaracteres (length nombreBuscado)) (nombreDelaHerramienta herramienta)

-- Punto 3: Saber si es una herramienta es buena

-- Definimos los requesitos actuales:

type Requisito = Herramienta -> Bool

tieneEsteMango :: Mango -> Herramienta -> Bool
tieneEsteMango mangoBuscado herramienta = mango herramienta == mangoBuscado

esUnMartilloConGomaOMadera :: Requisito
esUnMartilloConGomaOMadera herramienta
    | esNombreBuscado "Martillo" herramienta = tieneEsteMango Goma herramienta || tieneEsteMango Madera herramienta
    | otherwise = False

tieneUnMangoQueSaleTanto :: Requisito
tieneUnMangoQueSaleTanto herramienta = tieneEsteMango Hierro herramienta && (precio herramienta >= 10000)

-- Realizamos la funcion para saber si una herramienta es buena:

esBuena :: Herramienta -> Bool
esBuena herramienta = esUnMartilloConGomaOMadera herramienta || tieneUnMangoQueSaleTanto herramienta

-- Punto 4: Puede comprar una herramienta:

-- Funciones auxiliares para los plomeros:

type FuncionCaja = (Herramientas -> Herramientas)

agregarHerramienta :: Herramienta -> Herramientas -> Herramientas
agregarHerramienta herramienta cajaDeHerramienta = herramienta : cajaDeHerramienta

actualizarCajaDeherramienta :: FuncionCaja -> Plomero -> Plomero
actualizarCajaDeherramienta funcionParaAplicar plomero = plomero {cajaDeHerramienta = funcionParaAplicar (cajaDeHerramienta plomero)}

actualizarDinero :: Float -> Plomero -> Plomero
actualizarDinero variacion plomero = plomero {dineroDisponible = max 0 (dineroDisponible plomero + variacion)}

-- Realizamos la funcion para comprar una herramienta:

intentarComprar :: Herramienta -> Plomero -> Plomero
intentarComprar herramienta plomero
    | precio herramienta <= dineroDisponible plomero = comprar (precio herramienta) herramienta plomero
    | otherwise = plomero

comprar :: Float -> Herramienta -> Plomero -> Plomero
comprar precioDeLaHerramienta herramienta = actualizarDinero (-precioDeLaHerramienta) . actualizarCajaDeherramienta (agregarHerramienta herramienta)

-- Punto 5: Reparaciones 

type Condicion = Plomero -> Bool

data Reparacion = UnaReparacion {
    descripcion :: String,
    condicion :: Condicion
}

-- Definimos funciones auxiliares para las reparaciones:

estaEnMayuscula :: String -> Bool
estaEnMayuscula = all isUpper

esDificilUnaReparacion :: Reparacion -> Bool
esDificilUnaReparacion reparacion = tieneMasDe100Caracteres (descripcion reparacion) && estaEnMayuscula (descripcion reparacion)

tieneMasDe100Caracteres :: String -> Bool
tieneMasDe100Caracteres palabra = length palabra >= 100

saberPresupuesto :: Reparacion -> Float
saberPresupuesto = (*3) . genericLength . descripcion

-- Definimos filtracion de agua:

filtracionDelAgua :: Reparacion
filtracionDelAgua = UnaReparacion "Filtracion del agua" (tieneUnaHerramientaConTalNombre "Llave Inglesa")

-- Punto 6: Hacer una reparacion 

destonillador :: Herramienta
destonillador = UnaHerramienta "Destonillador" 0 Plastico

intentarHacerReparacion :: Plomero -> Reparacion -> Plomero
intentarHacerReparacion plomero reparacion
    | cumpleLaCondicionOEsUnMalvadoConMartillo reparacion plomero = hacerReparacion reparacion plomero
    | otherwise = actualizarDinero 100 plomero

-- Funciones axuliares para los plomeros cuando realizan una reparacion:

cumpleLaCondicionOEsUnMalvadoConMartillo :: Reparacion -> Plomero -> Bool
cumpleLaCondicionOEsUnMalvadoConMartillo reparacion plomero = condicion reparacion plomero || esMalvadoConMartillo plomero

esMalvadoConMartillo :: Plomero -> Bool
esMalvadoConMartillo plomero
    | esMalvado plomero = tieneUnaHerramientaConTalNombre "Martillo" plomero
    | otherwise = False

agregarReparacion :: Reparacion -> Plomero -> Plomero
agregarReparacion reparacion plomero = plomero {reparacionesHechas = reparacion : reparacionesHechas plomero}

hacerReparacion :: Reparacion -> Plomero -> Plomero
hacerReparacion reparacion = actualizarDinero 100 . agregarReparacion reparacion . efectosColateralesDeLaReparacion reparacion

sacarBuenas :: Herramientas -> Herramientas
sacarBuenas = filter (not . esBuena)

sacarPrimerElemento :: Herramientas -> Herramientas
sacarPrimerElemento = tail

efectosColateralesDeLaReparacion :: Reparacion -> Plomero -> Plomero
efectosColateralesDeLaReparacion reparacion plomero
    | esMalvado plomero = actualizarCajaDeherramienta (agregarHerramienta destonillador) plomero
    | esDificilUnaReparacion reparacion = actualizarCajaDeherramienta sacarBuenas plomero
    | otherwise = actualizarCajaDeherramienta sacarPrimerElemento plomero

-- Punto 7: Jornada laboral 

type Reparaciones = [Reparacion]

hacerUnaJornadaLaboral :: Reparaciones -> Plomero -> Plomero
hacerUnaJornadaLaboral reparaciones plomero = foldl intentarHacerReparacion plomero reparaciones

-- Punto 8: 

type CriterioParaPlomero = (Plomero -> Float)

type Plomeros = [Plomero]

empleadosDespuesDeUnaJornadaLaboral :: Plomeros -> Reparaciones -> Plomeros
empleadosDespuesDeUnaJornadaLaboral plomeros reparaciones = map (hacerUnaJornadaLaboral reparaciones) plomeros

-- Definir los funciones para axuliares para los empleados:

elmasRepador :: CriterioParaPlomero
elmasRepador plomero = genericLength (reparacionesHechas plomero)

elQueMasInvertio :: CriterioParaPlomero
elQueMasInvertio plomero = genericLength (cajaDeHerramienta plomero)

sacarEmpleadoSegun :: CriterioParaPlomero -> Plomeros -> Plomero
sacarEmpleadoSegun _ [plomero] = plomero
sacarEmpleadoSegun funcionParaAplicar (plomero1 : plomero2 : plomeros)
    | funcionParaAplicar plomero1 > funcionParaAplicar plomero2 = sacarEmpleadoSegun funcionParaAplicar (plomero1 : plomeros)
    | otherwise = sacarEmpleadoSegun funcionParaAplicar (plomero2 : plomeros)

-- Realizar las funciones para sacar el empleado segun un criterio:

empleadoMasReparador :: Plomeros -> Reparaciones -> Plomero
empleadoMasReparador plomeros reparaciones = sacarEmpleadoSegun elmasRepador (empleadosDespuesDeUnaJornadaLaboral plomeros reparaciones)

empleadoQueMasDineroConsiguio :: Plomeros -> Reparaciones -> Plomero
empleadoQueMasDineroConsiguio plomeros reparaciones = sacarEmpleadoSegun dineroDisponible (empleadosDespuesDeUnaJornadaLaboral plomeros reparaciones)

empleadoQueMasInvirtio :: Plomeros -> Reparaciones -> Plomero
empleadoQueMasInvirtio plomeros reparaciones = sacarEmpleadoSegun elQueMasInvertio (empleadosDespuesDeUnaJornadaLaboral plomeros reparaciones) 
