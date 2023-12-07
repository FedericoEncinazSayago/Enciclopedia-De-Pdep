class Casa {
	var property integrantes = []
	
	method agregarEstudiantes(unEstudiante) = integrantes.add(unEstudiante)
	
	method tengoMasEstudiantesConAceiteSucioQuePuros() {
		const cantidadDeAlumnosConAceiteSucio = integrantes.filter({unIntegrante => unIntegrante.tieneAceiteSucio()}).size()
		return cantidadDeAlumnosConAceiteSucio > (integrantes.size() / 2)
	}
}

class CasaSinCondiciones inherits Casa {
	var property esPeligrosa
}

class CasaConCondiciones inherits Casa {
	method esPeligrosa() = self.tengoMasEstudiantesConAceiteSucioQuePuros()
}


// Casas conocidas hasta ahora:
const gryffindor = new CasaSinCondiciones(esPeligrosa = false)
const slytherin = new CasaSinCondiciones(esPeligrosa = true)
const ravenclaw = new CasaConCondiciones()
const hufflepuff = new CasaConCondiciones()