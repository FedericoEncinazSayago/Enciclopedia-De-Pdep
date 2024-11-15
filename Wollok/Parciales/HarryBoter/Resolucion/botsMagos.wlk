import bots.*

class BotMago inherits Bot {
    var casaAct
    const hechizos = #{}

    override method asignarCasa(casa) {
        casaAct = casa
        casa.agregarEstudiante(casa)
    }

    method intentarLanzarHechizo(hechizo, hechizado) {
        if(not (self.cumpleCondicionBase(hechizo) && hechizo.cumpleRequisito(self)))
            self.error("No se pudo lanzar el hechizo")
        
        hechizo.sufriConsecuenciasA(hechizado)
    }

    method aprenderHechizo(hechizo) {
        hechizos.add(hechizo)
    }

    method lanzarUltimoHechizoA(hechizado) {
        const ultimoHechizo = hechizos.last()
        self.intentarLanzarHechizo(ultimoHechizo, hechizado)
    }

    method asistirA(materia) {}

    method cumpleCondicionBase(hechizo) = self.estaActivo() && self.tieneHechizo(hechizo)

    method tieneHechizo(hechizo) = hechizos.contains(hechizo)

    method esExperimentando() = hechizos.size() > 3 && cargaElectrica > 50
}

class BotEstudiante inherits BotMago {
    override method asistirA(materia) {
        const hechizoNuevo = materia.hechizoAEnseniar() 
        self.aprenderHechizo(hechizoNuevo)
    }
}


class BotProfesor inherits BotMago {
    const materias = []

    override method agotarEnergia() {
        cargaElectrica /= 3 
    }

    method agregarMateria(materia) {
        materia.add(materia)
    }

    override method disminuirEnergiaEn(valor) {}

    override method esExperimentando() = super() && materias >= 2
}