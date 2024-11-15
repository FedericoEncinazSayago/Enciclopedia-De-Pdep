import casas.*

object hogwart {
    const casasActuales = [gryffindor, slytherin, ravenClaw, hufflepuff]
    const asignadorDeCasas = sombreroAsignador 

    method celebrarCeremoniaDeSeleccion(estudiante) {
        asignadorDeCasas.distribuir(estudiante, casasActuales)
    }
}

object sombreroAsignador {
    var indexProximaCasa = 0

    method distribuir(estudiante, casasActuales) {
        const proxCasa = casasActuales.get(indexProximaCasa)
        const sizeCasas = casasActuales.size()

        estudiante.asignarCasa(proxCasa)
        proxCasa.asignarEstudiante(estudiante)

        indexProximaCasa = (indexProximaCasa + 1) % casasActuales.size()
    }   
}