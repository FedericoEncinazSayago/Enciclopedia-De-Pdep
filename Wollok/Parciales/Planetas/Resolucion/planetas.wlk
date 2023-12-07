import personas.*

class Planeta {
	var habitantes = []
	var construccionesHechas = []

	method delegacionDiplomatica() { 
		return habitantes.filter({unHabitante => unHabitante.esDestacada() || self.esElHabitanteConMasRecursos(unHabitante)})
	}
	
	method esElHabitanteConMasRecursos(unHabitante) {
		return not(habitantes.any({otroHabitante => otroHabitante.recursosActuales() > unHabitante.recursosActuales()}))
	}
	
	method esValioso() {
		return self.sumaDeLosValoresDeTodasLasConstrucciones() > 100
	}
	
	method sumaDeLosValoresDeTodasLasConstrucciones() {
		return construccionesHechas.sum({unaConstruccion => unaConstruccion.valorDeConstruccion()})
	}
	
	method viveEsteHabitante(unHabitante) {
		return habitantes.contains(unHabitante)
	}
	
	method agregarConstruccion(unaConstruccion) {
		construccionesHechas.add(unaConstruccion)
	}
	
	method hacerQueLaDelegacionDiplomaticaTrabajeEnUnPlaneta(unPlaneta, unaUnidadDeTiempo) {
		self.delegacionDiplomatica().forEach({unDiplomatico => unDiplomatico.trabajar(unPlaneta, unaUnidadDeTiempo)})
	}
	
	method hacerQueDelegacionTrabajeEnSuPlaneta(unaUnidadDeTiempo) {
		self.hacerQueLaDelegacionDiplomaticaTrabajeEnUnPlaneta(self, unaUnidadDeTiempo)
	}
	
	method invadirUnPlanetaPorUnTiempo(otroPlaneta, unaUnidadDeTiempo) {
		otroPlaneta.hacerQueLaDelegacionDiplomaticaTrabajeEnUnPlaneta(self, unaUnidadDeTiempo)
	}
}