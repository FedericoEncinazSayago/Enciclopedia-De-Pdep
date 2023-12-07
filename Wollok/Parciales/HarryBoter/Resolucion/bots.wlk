import aceites.*
import casas.*

class Bot {
	var aceite
	var property cargaActual 
	
	method sufrirEfectosDeUnHechizo(unHechizo) {
		const efectosDeUnHechizo = unHechizo.efectoDeUnHechizo(self)
		if(self.esNoEsElSombreroSeleccionador()) {
			if(efectosDeUnHechizo.haceImpuroAlAceite() && aceite.esPuro())
				self.hacerImpuroAlAceite()
		}
		
		self.reducirUnaCantidadLaCarga(efectosDeUnHechizo.cantidadEnergiaAReducir())
	}
	
	method tieneAceiteSucio() = not(aceite.esPuro())
	
	method hacerImpuroAlAceite() = aceite.hacerImpuro()
	
	method estaActivo() = cargaActual > 0
	
	method tieneUnaCargaMayorAUnaCantidad(unaCantidad) = cargaActual > unaCantidad
	
	method esNoEsElSombreroSeleccionador() = self != sombreroSeleccionador
	
	method puedeDictarClases() = false
	
	method puedeSerAdmitidoEnHogwarts() = false
	
	method reducirUnaCantidadLaCarga(unaCantidad) {
		cargaActual = cargaActual - unaCantidad
	}
}


// Bots conocidos:
const nadiePronuncia = new Bot(aceite = new Aceite(esPuro = true), cargaActual = 100)

object sombreroSeleccionador inherits Bot(aceite = new Aceite(esPuro = true), cargaActual = 100) {
	const casasConocidas = [gryffindor, slytherin, ravenclaw, hufflepuff]
	var posicionDeLaCasaASeleccionar = 0
	
	method asignarAUnEstudianteAUnaCasa(unEstudiante) {
		if(posicionDeLaCasaASeleccionar > casasConocidas.size()) 
			posicionDeLaCasaASeleccionar = 0
			
		if(unEstudiante.puedeSerAdmitidoEnHogwarts()) {
			unEstudiante.elegirUnaCasa(casasConocidas.get(posicionDeLaCasaASeleccionar))
		 	posicionDeLaCasaASeleccionar++
		}
		 
	}
}
