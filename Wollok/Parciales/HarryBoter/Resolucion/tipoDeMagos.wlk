import magos.*
import hechizos.*
import bots.*

class Estudiante inherits MagoDeHowgarts {
	const property cargaNecesaria = 50
	const property hechizosNecesarios = 3
	
	method esExperimentado() = self.conoceUnaCantidadMayorDeHechizos(self.hechizosNecesarios()) && self.tieneUnaCargaMayorAUnaCantidad(self.cargaNecesaria())
	
	method puedeDictarUnaMateria() {
		return false
	}
}

class Profesor inherits MagoDeHowgarts {
	var materiasDadas = []
	
	method esExperimentado() = materiasDadas.size() >= 2
	
	override method sufrirEfectosDeUnHechizo(unHechizo) {
		const efectosDeUnHechizo = unHechizo.efectoDeUnHechizo(self)
		if(efectosDeUnHechizo.cantidadEnergiaAReducir() == self.cargaActual())
			self.reducirUnaCantidadLaCarga(efectosDeUnHechizo.cantidadEnergiaAReducir() / 2)
	}
	
	method agregarUnaMateria(unaMateria) {
		materiasDadas.add(unaMateria)
	}
	
	override method puedeDictarClases() = true
} 