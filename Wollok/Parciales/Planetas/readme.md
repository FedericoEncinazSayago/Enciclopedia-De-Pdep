# Planetas en el universo

Queremos armar un modelo de un juego galáctico.

## Personas.

De cada **persona** debe poder obtenerse: los _recursos_ y si es o no _destacado_. 

En principio, corresponden estas definiciones:
- los _recursos_ son las monedas que tiene una persona, inicialmente 20 para cualquier de ellas, pero puede ir variando con el tiempo.
- una persona es _destacada_ si tiene entre 18 y 65 años o más de 30 de recursos. 

Además, a las personas le puede pasar : 
- ganar o gastar monedas, en una cantidad dada.
- cumplir años

## Construcciones

Existen diferentes construcciones, de las cuales nos interesa averiguar su valor.
- _murallas_: su valor depende de su longitud, a razón de 10 monedas por unidad de medida.
- _museo_: su valor se calcula como su superficie cubierta multiplicada por su índice de importancia, que va de 1 a 5. 

## Planetas.

De cada **planeta** se conocen las personas que lo habitan. También se lleva el registro de las construcciones que se fueron efectuando en él.
 
Se tiene que poder obtener, para cada planeta
- la _delegación diplomática_, que está formada por todos los habitantes destacados y el habitante que tenga más recursos. Si llegara a coincidir que el habitante con más recursos fuera tambien destacado, mantiene su pertenencia a la delegación. 
- si es _valioso_: la condición es que el total del valor de todas las construcciones sea mayor a 100 monedas.


### Pruebas
Considerar un planeta con cuatro personas como habitantes, dos murallas y un museo. Verificar que:
- la delegación diplomática está formada por tres de ellas
- es valioso
- agregar otro planeta, con habitantes y construcciones, pero que no sea valioso. 

Hacer que algunos de sus habitantes ganen o gasten monedas y/o cumplan años y en consecuencia cambien algunas de las respuestas anteriores.


## Más personas

Además de las personas anteriores, existen algunas de ellas que tienen otras responsabilidades: productores y constructores. 

De cada **productor** se registran las técnicas que conoce (inicialmente todos saben "cultivo"). 
Los _recursos_ de un productor es su cantidad de monedas, como para todas las personas, multiplicado por la cantidad de técnicas que conoce.
Un productor _es destacado_ si cumple la condición común para todas las personas, o si conoce más de 5 técnicas.
 
Definir las siguientes acciones para los productores:
- _realizar_ una técnica durante una cantidad de tiempo: el efecto es ganar 3 monedas por cada unidad de tiempo, pero sólo en caso que conozca dicha técnica. P.ej. el efecto de realizar un cultivo durante un tiempo 5, es ganar 15 monedas. En caso que le pidan realizar uan tarea que no conoce, pierde una unidad de sus recursos básicos.
- _aprender_ una técnica: hace que el productor conozca una nueva técnica.
- _trabajar_ durante una cantidad de tiempo en un planeta: implica realizar la última tecnica aprendida durante dicho tiempo, pero sólo en caso que sea el planeta en que vive el productor. 

De cada **constructor** se conoce la cantidad de construcciones realizadas y la región donde vive dentro del planeta. 
Los _recursos_ de un constructor son sus monedas, como toda persona, más 10 monedas por cada construcción realizada.
Un constructor es destacado si realizó más de 5 construcciones, independientemente de su edad. 

Sus acciones son:
- _trabajar_ una determinada cantidad de tiempo en un planeta: Construye una construcción en el planeta dado, sin importar que sea el que vive. Además, gasta 5 monedas. (Lo que en definitiva es una inversión, porque sus recursos van a aumentar al tener una construcción más realizada) 
	- si vive en la montaña, construye una muralla. Su largo será igual a la mitad de las horas que trabaje.
	- si vive en la costa, construye un museo. Su superficie será igual a la cantidad de horas que trabaje y con nivel 1.
	- si vive en la llanura, depende: si no es destacado, construye una muralla (largo a la mitad de las horas que trabaje), pero si es destacado contruye un museo (la superficie será igual a la cantidad de horas que trabaje, pero con un nivel entre 1 y 5, proporcional a sus recursos)
	- agregar una nueva región y que lo que construya dependa de la inteligencia del constructor

Ser productor o constructor no es algo que se aprende con el tiempo o que se pueda cambiar. Para las personas que no son ni constructoras ni productoras, trabajar no les afecta ni altera el planeta.

### Más pruebas
- Definir constructores que vivan en diferentes regiones y al menos un productor y probar que trabajen bien.
- Hacer que algunos de ellos integren la delegación diplomática de su planeta 

## La historia del planeta
- Hacer que la delegación diplomática del planeta trabaje durante un determinado tiempo en su planeta
- Hacer que un planeta invada a otro y obligue a su delegación diplomática a trabajar para el planeta invasor.
