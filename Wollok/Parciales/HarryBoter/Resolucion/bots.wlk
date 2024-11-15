class Bot {
    var cargaElectrica
    var aceite 

    method estaActivo() = cargaElectrica > 0

    method tieneAceitePuro() = aceite.sosPuro()

    method disminuirEnergiaEn(valor) {
        cargaElectrica = (cargaElectrica - valor).max(0)
    }

    method agotarEnergia() { 
        cargaElectrica = 0 
    }

    method cambiarAceite(nuevoAceite) {
        aceite = nuevoAceite
    }

    method asignarCasa(casa) {}
}