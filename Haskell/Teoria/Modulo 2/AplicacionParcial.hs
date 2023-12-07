{-

Aplicación parcial de funciones => Es una forma de crear funciones a partir de otras funciones
 
-}

-- Ejemplo de aplicacion parcial de funciones
doble :: Int -> Int -> Int
doble x y = 2 * x + y

doble' :: Int -> Int
doble' = doble 1 -- Acorde a la firma de la funcion doble, le damos un valor a x y nos queda una funcion que recibe un entero y devuelve un entero

-- (+) :: Int -> Int -> Int
-- (1 +) :: Int -> Int -- Aplicacion parcial de la funcion (+) => Le damos un valor a x y nos queda una funcion que recibe un entero y devuelve un entero

siguiente :: Int -> Int
siguiente = (1 +) 

esP :: Char -> Bool
esP = (== 'p')

-- Definicion de  ($)
-- ($) :: (a -> b) -> a -> b => Recibe una funcion y un valor y devuelve un valor
-- ($) f x = f x

-- Ejemplo de aplicacion parcial y composicion de funciones
comienzaConP :: String -> Bool
comienzaConP = esP . head