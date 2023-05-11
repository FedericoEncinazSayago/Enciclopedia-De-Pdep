saberSiUnStringEstaEnOtro :: String -> String -> Bool
saberSiUnStringEstaEnOtro primerCadena segundaCadena = igualarCaracteres primerCadena segundaCadena 0 == length primerCadena

igualarCaracteres :: String -> String -> Int -> Int
igualarCaracteres primeraCadena [] posicion = 0
igualarCaracteres primeraCadena (w:ws) posicion
    | primeraCadena !! posicion == w = 1 + igualarCaracteres primeraCadena ws (posicion + 1)
    | otherwise = igualarCaracteres primeraCadena ws posicion

substring :: [Char] -> [Char] -> Bool
substring string1 "" = False
substring palabra1 (letra2:palabra2) = palabra1 == take (length palabra1) palabra2 || substring palabra1 palabra2