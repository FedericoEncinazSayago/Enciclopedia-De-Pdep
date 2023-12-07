/*

Hay diferentes platos: 
- Las entradas nunca tienen azúcar y siempre son bonitas.
- Los principales pueden tener una cantidad de azúcar o nada, y pueden
- Los postres siempre llevan 120g de azúcar, y son bonitos cuando tienen más de 3 colores.
 
*/

class Plato {
	const responsableDePlato 
	const baseCalorias = 100
	
	method cantidadDeAzucar()
	
	method responsableDePlato() = responsableDePlato
		
	// Punto 1: Conocer las calorías de un plato. Las calorías de cualquier plato se calculan como 3 * la cantidad de azúcar que contiene + 100 de base.
	method conocerCalorias() {
		return self.cantidadDeAzucar() * 3 + baseCalorias
	}
}

class Entrada inherits Plato {
	method esBonito() = true
	
	override method cantidadDeAzucar() = 0
}

class Postre inherits Plato {
	const cantidadDeColores
	
	override method cantidadDeAzucar() = 120
	
	method esBonito() {
		return cantidadDeColores.size() > 3
	}
}

class Principal inherits Plato {
	const esBonito
	const cantidadDeAzucar
	
	override method cantidadDeAzucar() = cantidadDeAzucar
	
	method esBonito() = esBonito
}