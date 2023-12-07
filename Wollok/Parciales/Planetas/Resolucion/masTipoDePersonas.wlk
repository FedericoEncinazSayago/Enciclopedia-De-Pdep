import personas.*
import regiones.*
import tecnicas.*

class Productor inherits Persona {
	var tecnicasActuales = [cultivo]
	
	override method recursosActuales() {
		return cantidadDeMonedas * tecnicasActuales.size()
	}
	
	override method esDestacada() {
		return super() && self.conoceMasDe5Tecnicas()
	}
	
	method conoceMasDe5Tecnicas() {
		return tecnicasActuales.size() > 5
	}
	
	method realizarUnaTecnica(unaTecnica, unaUnidadDeTiempo) {
		if(self.conoceLaTecnica(unaTecnica)) 
			self.ganarRecursos(unaUnidadDeTiempo * unaTecnica.monedasAGanar())
		else
			self.gastarRecursos(1)
	}
	
	method aprenderTecnica(unaTecnica) {
		tecnicasActuales.add(unaTecnica)
	}
	
	method conoceLaTecnica(unaTecnica) {
		return tecnicasActuales.contains(unaTecnica)
	}
	
	override method trabajar(unPlaneta, unUnidadDeTiempo) {
		if(unPlaneta.viveEsteHabitante(self))
			self.realizarUnaTecnica(tecnicasActuales.last(), unUnidadDeTiempo)
	}
}

class Constructor inherits Persona {
	var property cantidadDeConstrucciones 
	const regionDondeVive
	const property inteligencia
	
	override method recursosActuales() {
		return cantidadDeMonedas + (10 * cantidadDeConstrucciones)
	}
	
	override method esDestacada() {
		return cantidadDeConstrucciones > 5
	}
	
	override method trabajar(unPlaneta, unUnidadDeTiempo) {
		unPlaneta.agregarConstruccion(regionDondeVive.construccionPorRegion(self, unUnidadDeTiempo, self.recursosActuales()))
		self.gastarRecursos(5)
		self.aumentarConstrucciones()
	}
	
	method aumentarConstrucciones() {
		cantidadDeConstrucciones++
	}
}
