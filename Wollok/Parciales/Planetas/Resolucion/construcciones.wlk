class Muralla {
	const longitud
	const precioPorUnidad = 10
	
	method valorDeConstruccion() {
		return longitud * precioPorUnidad
	}
}

class Museo {
	const superficieOcupada
	const indiceDeImportancia
	
	method valorDeConstruccion() {
		return superficieOcupada * indiceDeImportancia
	}
}