/* 
 
Los cocineros pueden ser pasteleros o chefs. 
Todo cocinero, además de cocinar, también sabe catar un plato (o sea, calificarlo).

- Cada pastelero tiene un nivel deseado de dulzor, 
  y luego de catar un plato, otorga una calificación que se calcula como 5 * la cantidad de azúcar del plato / dulzor deseado (máximo 10).

- Un chef al catar un plato, da una calificación de 10 en caso que sea bonito y además tenga hasta cierta cantidad de calorías (definida por cada chef). 
  Lo califica con 0 en caso contrario.


*/

import platos.*

class Cocinero {
	var especialidad
	
	method cocinar() {
		return especialidad.platoDeEspecialidad(self)
	}
	
	// Punto 2: Catar un plato. Cuando un plato es catado, se obtiene la calificación que le da el catador.
	method catarUnPlato(unPlato) {
		return especialidad.criticaPorEspecialidad(unPlato)
	}
	
	// Punto 3: Que un cocinero pueda cambiar de especialidad (por ejemplo, pasar de ser chef a ser pastelero).
	method cambiarDeEspecialidad(unaEspecialidad) {
		especialidad = unaEspecialidad
	}
}

class Pastelero {
	const nivelDulzor
	
	method notaMaxima() = 10 
	
	method criticaPorEspecialidad(unPlato) {
		return (5 * unPlato.cantidadDeAzucar() / nivelDulzor).min(self.notaMaxima())
	}
	
	// Puntos 5: Los pasteleros crean postres con tantos colores como su nivel de dulzor deseado dividido 50.
	method platoDeEspecialidad(unCocinero) {
		return new Postre(cantidadDeColores = nivelDulzor / 50, responsableDePlato = unCocinero)
	}
}

class Chef {
	const cantidadDeCaloriasDeseadas
	
	method notaMaxima() = 10
	
	method notaMinima(unPlato) = 0
	
	method criticaPorEspecialidad(unPlato) {
		if(self.cumpleConLasExpectavivas(unPlato))
			return self.notaMaxima()
		else
			return self.notaMinima(unPlato)
	}
	
	method cumpleConLasExpectavivas(unPlato) {
		return unPlato.esBonito() && unPlato.cantidadDeCalorias() < cantidadDeCaloriasDeseadas
	}
	
	// Punto 5: Los chefs crean platos principales bonitos con una cantidad de azúcar igual a la cantidad de calorías preferida del cocinero.
	 method platoDeEspecialidad(unCocinero) {
		return new Principal(esBonito = true, cantidadDeAzucar = cantidadDeCaloriasDeseadas, responsableDePlato = unCocinero)
	}
}

// Punto 4: Agregar la especialidad souschef. 
// El souschef es como el chef pero cuando no se cumplen las expectativas la calificación que pone es la cantidad de calorías del plato / 100 (máximo 6).
class Souschef inherits Chef {
	
	override method notaMinima(unPlato) = (unPlato.conocerCalorias() / 100).min(6)
	
	// Punto 5: Los souschefs crean entradas
	override method platoDeEspecialidad(unCocinero) {
		return new Entrada(responsableDePlato = unCocinero)
	}
}






