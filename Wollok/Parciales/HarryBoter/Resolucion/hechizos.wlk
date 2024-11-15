import aceite.*
class HechizosQueDisminuyenEnergia {
    const valorADisminuir 

    method sufriConsecuenciasA(hechizado) {
        hechizado.disminuirEnergiaEn(valorADisminuir)
    }

    method cumpleRequisito(hechicero) = hechicero.cargaElectrica() > valorADisminuir
}

object inmobilus inherits HechizosQueDisminuyenEnergia(valorADisminuir = 50) {
    override method cumpleRequisito(hechicero) = true
}

object sectumSempra {
    method sufriConsecuenciasA(hechizado) {
        hechizado.cambiarAceite(aceiteSucio)
    }

    method cumpleRequisito(hechicero) = hechicero.esExperimento()
}

object avadakedabra {
    method sufriConsecuenciasA(hechizado) {
        hechizado.agotarEnergia()
    }

    method cumpleRequisito(hechicero) = not hechicero.tieneAceitePuro() || hechicero.perteneceACasaPeligrosa()
}