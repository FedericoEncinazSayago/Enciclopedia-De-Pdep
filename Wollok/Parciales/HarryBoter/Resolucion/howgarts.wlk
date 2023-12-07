import materias.*
import bots.*

class UserException inherits wollok.lang.Exception {}

object howgarts {
	var materiasDisponibles = []
	
	method seleccionarCasasParaLosEstudiantes(unGrupoDeEstudiantes) {
		unGrupoDeEstudiantes.forEach({unEstudiante => sombreroSeleccionador.asignarAUnEstudianteAUnaCasa(unEstudiante)})
	}
	
	method queUnGrupoAprendeElHechizoDeUnaMateria(unGrupoDeEstudiantes, unaMateria) {
		unGrupoDeEstudiantes.forEach({unEstudiante => unaMateria.darHechizo(unEstudiante)})
	}
	
	method crearUnaMateria(unProfesor, unHechizo) {
		if(unProfesor.puedeDictarClases())
		{
			const materiaNueva = new Materia(profesorACargo = unProfesor, hechizoADictar = unHechizo)
			unProfesor.agregarMateria(materiaNueva)
			
			return materiaNueva
		}
		else
			throw new UserException(message = "Un bot o un estudiante no puede dar una clase!")
	}
	
	method todosLosIntegrantesDeUnaCasaLanceElUltimoHechizoContraElNadiePronuncia(unaCasa) {
		unaCasa.integrantes().forEach({unIntegrante => unIntegrante.lanzarHechizo(unIntegrante.ultimoHechizoConocido(), nadiePronuncia)})
	}
}
