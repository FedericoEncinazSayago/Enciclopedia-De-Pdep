import hogwart.*

class GrupoEstudiante {
    const estudiantes = []

    method asistirA(materia) {
        estudiantes.forEach({estudiante => estudiante.asistirA(materia)})
    }

    method irHogwart() {
        estudiantes.forEach({estudiante => hogwart.celebrarCeremoniaDeSeleccion(estudiante)})
    }
}

