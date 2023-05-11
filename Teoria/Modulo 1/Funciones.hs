-- Que es una funcion?
-- Es una relacion entre un conjunto de entradas y un conjunto de salidas

-- Funcion que suma dos numeros
sumar :: Int -> Int -> Int -- Definicion de la funcion sumar 
sumar x y = x + y

-- Int -> Int -> Int => Recibe dos enteros y devuelve un entero

-- Funcion que sabe si un alumno aprobo o no
aprobo :: Int -> Bool
aprobo nota = nota >= 4

-- Funciones con guardas (if) 
max :: Int -> Int -> Int
max x y | x >= y = x 
        | otherwise = y

for(int i = 0; i < 10; i++)
{
        cout << ingresar valor << endl;
        cin >> valor;
        sumar += valor;
}