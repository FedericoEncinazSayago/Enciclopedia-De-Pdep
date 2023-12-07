import planetas.*
import construcciones.*
import personas.*

class UserException inherits wollok.lang.Exception {}

object regionDeMontana {
	method construccionPorRegion(unConstructor, unaUnidadDeTiempo, unosRecursos) {
		return new Muralla(longitud = unaUnidadDeTiempo / 2))
	}
}

object regionDeCosta {
	method construccionPorRegion(unConstructor, unaUnidadDeTiempo, unosRecursos) {
		return new Museo(superficieOcupada = unaUnidadDeTiempo, indiceDeImportancia = 1)
	}
}

object regionDeLlanura {
	method construccionPorRegion(unConstructor, unaUnidadDeTiempo, unosRecursos) {
		if(unConstructor.esDestacada())
			return new Muralla(longitud = unaUnidadDeTiempo / 2)
		else
		{
			const indiceDeImportancia = new Range(start = 1, end = unosRecursos).anyOne()
			if(indiceDeImportancia > 5)
				throw new UserException(message = "No se pueden crear un Museo con indice mayor a 5!")
			else
				return new Museo(superficieOcupada = unaUnidadDeTiempo, indiceDeImportancia = indiceDeImportancia))
		}
	}
}

object regionInventada {
	method construccionPorRegion(unConstructor, unaUnidadDeTiempo, unosRecursos) {
		if(unConstructor.inteligencia() > 100)
			return new Muralla(longitud = unaUnidadDeTiempo * unosRecursos)
		else
			throw new UserException(message = "El constructor no tiene la inteligencia suficiente!")
	}
}
