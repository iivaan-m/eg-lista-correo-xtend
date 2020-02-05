package ar.edu.listaCorreoSimple

import java.util.List
import org.eclipse.xtend.lib.annotations.Data

@Data
class Post {

	Miembro emisor
	String mensaje

	def tiene(String palabra) {
		palabrasDelMensaje.contains(palabra)
	}

	def List<String> palabrasDelMensaje() {
		mensaje.split(" ")
	}

}