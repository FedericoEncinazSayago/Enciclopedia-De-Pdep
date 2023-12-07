class Persona {
	var cantidadDeMonedas = 20
	var aniosActuales 

	method ganarRecursos(unaCantidad) {
		cantidadDeMonedas += unaCantidad
	}
	
	method gastarRecursos(unaCantidad) {
		cantidadDeMonedas -= unaCantidad
	}
	
	method recursosActuales() {
		return cantidadDeMonedas
	}
	
	method cumplirAnios() {
		aniosActuales++
	}
	
	method esDestacada() {
		return self.suEdadEstaEntreCiertoRango(18, 65) && self.tieneMasDeRecursosDadaUnaCantidad(30)
	}
	
	method suEdadEstaEntreCiertoRango(unaEdadMinimo, unaEdadMaximo) {
		return aniosActuales.between(unaEdadMinimo, unaEdadMaximo)
	}
	
	method tieneMasDeRecursosDadaUnaCantidad(unaCantidad) {
		return cantidadDeMonedas > unaCantidad
	}
	
	method trabajar(unPlaneta, unUnidadDeTiempo) {}
}