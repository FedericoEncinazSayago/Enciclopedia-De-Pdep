import bots.*

class MagoDeHowgarts inherits Bot {
	var hechizosConocidos = []
	var casaPerteneciente = null
	
	method lanzarUnHechizo(unHechizo, unObjectivo) {
		if(self.cumpleConLosRequisitosParaLanzarUnHechizo(unHechizo))
			unObjectivo.sufrirEfectosDeUnHechizo(unHechizo)
	}
	
	method cumpleConLosRequisitosParaLanzarUnHechizo(unHechizo) = hechizosConocidos.contains(unHechizo) && self.estaActivo() && unHechizo.cumpleConLasCondiciones(self)
	
	method conoceUnaCantidadMayorDeHechizos(unaCantidad) =  unaCantidad > hechizosConocidos.size()
	
	method esPeligrosaSuCasa() = casaPerteneciente.esPeligrosa()
	
	method agregarHechizo(unHechizo) = hechizosConocidos.add(unHechizo)
	
	method ultimoHechizoConocido() = hechizosConocidos.last()

	override method puedeSerAdmitidoEnHogwarts() = true
	
	method elegirUnaCasa(unaCasa) {
		casaPerteneciente = unaCasa
	}
	
}