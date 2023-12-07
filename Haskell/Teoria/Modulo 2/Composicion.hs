{-

Composicion de funciones => Es una forma de crear funciones a partir de otras funciones
Simbolo => (.)

-}

-- Ejemplo de composicion de funciones
doble :: Int -> Int
doble x = 2 * x

sumar :: Int -> Int
sumar x = x + 1

composicion :: Int -> Int
composicion = doble . sumar -- primero se ejecuta sumar y luego doble => 2 * (x + 1)

{-

Composicion de funciones con mas de un parametro
Siempre tenemos que tener en cuenta el tipo de dato que devuelve la funcion que estamos componiendo

-}


-- Ejemplo de composicion de funciones
unNombreTieneLongitudPar :: String -> Bool
unNombreTieneLongitudPar = even . length

-- Ejemplo incorrecto de composicion de funciones
unNombreTieneLongitudPar' :: String -> Bool
unNombreTieneLongitudPar' nombre = even . length nombre  -- Estas componiendo un valor con una funcion => ERROR
