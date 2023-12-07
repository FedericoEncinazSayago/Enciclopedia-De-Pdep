object campo {
	const hectareasTotales = 15
	var hectareasSembradas = 10
	var cultivoPlanteado = trigo
	var gananciasTotales = 0
	
	method estaAlMaximo() = hectareasSembradas >= hectareasTotales
	
	method setearHectareasSembradas(cantidad) {
		if(cantidad <= hectareasTotales) {
			hectareasSembradas = cantidad
		}
	}
	
	method plantarCultivo(nuevoCultivo) { 
		cultivoPlanteado = nuevoCultivo
	}
	
	method aplicarFertilizante() { 
		cultivoPlanteado.fertilizar()
	}
	
	method agregarUnaHectareaSembrada() { 
		if(!self.estaAlMaximo()) {
			hectareasSembradas = hectareasSembradas + 1
		}
	}
	
	method gananciasDelCultivo() { 
		gananciasTotales = cultivoPlanteado.precioTotal(hectareasSembradas)
	}
	
	method actualesHectareasTotales() { 
		return hectareasTotales
	}
	
	method actualesHectareasSembradas() { 
		return hectareasSembradas
	}
	
	method costoDelCultivo() { 
		return cultivoPlanteado.costo(hectareasSembradas)
	}
	
	method costoAlEstarMaximo() {
		return cultivoPlanteado.costo(hectareasTotales - hectareasSembradas)
	}
	
	method ganaciasDelCampo() { 
		self.gananciasDelCultivo()
		return gananciasTotales
	}
	
	method sacarGananciasPasadoUnaTemporada() {
		gananciasTotales = 0
	}
}

object trigo {
	const precio = 1000
	var rendimiento = 10
	
	method costo(cantidadDeHectareas) = 500 * cantidadDeHectareas
	
	method fertilizar() { 
		rendimiento = rendimiento + 2
	}
	
	method precioTotal(cantidadDeHectareas) { 
		return precio * rendimiento * cantidadDeHectareas
	}
}


object soja {
	var noEstaFertilizado = true
	var precioTotal = 0
	var rendimiento = 20

	method costo() = precioTotal / 2
	
	method costo(costoEstablecio) = costoEstablecio
	
	method establecerPrecio(precioEstablecio) { 
		precioTotal = precioEstablecio * (1 - 0.35)
	} 	
	
	method fertilizar() {
		if(noEstaFertilizado) {
			noEstaFertilizado = false
			rendimiento = 40
		}
		else {
			rendimiento = 20 
		}
	}
	
	method precioTotal(cantidadDeHectareas) { 
		return precioTotal * rendimiento * cantidadDeHectareas
	}
}

object maiz {
	const costoMaximo = 5000
	const costoInicial = 500
	const rendimiento = 15
	
	method fertilizante() {}
		
	method costo(cantidadDeHectareas) {
		if(costoInicial * cantidadDeHectareas <= costoMaximo) {
			return costoInicial * 500
		}
		else {
			return costoMaximo
		}
	}
	
	method precioTotal(cantidadDeHectareas) { 
		return soja.precioTotal(cantidadDeHectareas) / 2 * rendimiento
	}
}

object banco {
	var sueldoInicial = 5000
	
	method gastarDinero(costoDeDinero) {
		sueldoInicial -= costoDeDinero
	}
	
	method agregarDinero(dineroGanado) {
		sueldoInicial += dineroGanado
	}
	
	method dineroActual() {
		return sueldoInicial
	}
}

object donPonciano {
	const campoActual = campo
	const bancoActual = banco
	
	method fugimarCampo() {
		campoActual.aplicarFertilizante()
		bancoActual.gastarDinero(10 * campoActual.actualesHectareasTotales())
	}
	
	method fertilizarCampo() {
		campoActual.aplicarFertilizante()
		bancoActual.gastarDinero(campoActual.actualesHectareasSembradas() * 10)
	}
	
	method sembrarHectarea() {
		if(!campoActual.estaAlMaximo()) {
			campoActual.agregarUnaHectareaSembrada()
			bancoActual.gastarDinero(campoActual.costoDelCultivo())
		}
	}
	
	method resembrarCampo(nuevoCultivo) {	
		campoActual.plantarCultivo(nuevoCultivo)
		bancoActual.gastarDinero(campoActual.costoDelCultivo())
	}
	
	method llevarAlMaximo() {
		if(!campoActual.estaAlMaximo()) {
			bancoActual.gastarDinero(campoActual.costoAlEstarMaximo())
			campoActual.setearHectareasSembradas(campoActual.actualesHectareasTotales())
		}
	}
	
	method pasarNuevaTemporadaAlCampo(cantidadDeHectareas, nuevoCultivo) {
		bancoActual.agregarDinero(campoActual.ganaciasDelCampo())
		campoActual.setearHectareasSembradas(cantidadDeHectareas)
		campoActual.plantarCultivo(nuevoCultivo)
		campoActual.sacarGananciasPasadoUnaTemporada()
		bancoActual.gastarDinero(campoActual.costoDelCultivo())
	}
	
	method dineroActual() {
		return bancoActual.dineroActual()
	}
}