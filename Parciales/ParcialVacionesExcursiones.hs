type Idiomas = [String]
type Excursiones = Turista -> Turista

data Turista = UnTurista{
    cansancio :: Int,
    estaSolo :: Bool,
    strees :: Int,
    idiomasQueHabla :: Idiomas
}

cambiarStress :: Int -> Turista -> Turista
cambiarStress nivelNuevo turista = turista {strees = strees turista + nivelNuevo}

cambiarCansancio :: Int -> Turista -> Turista
cambiarCansancio nivelNuevo turista = turista {cansancio = cansancio turista + nivelNuevo}

cambiarSolo :: Turista -> Turista
cambiarSolo turista = turista {estaSolo = True}

agregarIdioma :: String -> Turista -> Turista
agregarIdioma idiomaNuevo turista
    | idiomaNuevo `elem` idiomasQueHabla turista = turista
    | otherwise = turista {idiomasQueHabla = idiomaNuevo : idiomasQueHabla turista}

calcularUnidades :: Int -> Int
calcularUnidades minutos = minutos `div` 4

irPlaya :: Excursiones
irPlaya turista
    | estaSolo turista = cambiarCansancio (-5) turista
    | otherwise = cambiarStress (-1) turista

apreciarElemento :: String -> Excursiones
apreciarElemento elemento = cambiarStress (-(length elemento))

hablarUnIdioma :: String -> Excursiones
hablarUnIdioma idiomaNuevo turista = cambiarSolo (agregarIdioma idiomaNuevo turista)

caminar :: Int -> Excursiones
caminar minutos turista = cambiarStress (-(calcularUnidades minutos)) (cambiarCansancio (calcularUnidades minutos) turista)

paseoEnBarco :: Excursiones


