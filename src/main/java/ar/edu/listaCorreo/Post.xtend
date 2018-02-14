package ar.edu.listaCorreo

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Post {

	Miembro emisor
	ListaCorreo destino
	String mensaje

	new(Miembro pEmisor, String pMensaje, ListaCorreo pDestino) {
		emisor = pEmisor
		mensaje = pMensaje
		destino = pDestino
	}

	def tiene(String palabra) {
		palabrasDelMensaje.contains(palabra)
	}

	def List<String> palabrasDelMensaje() {
		mensaje.split(" ")
	}
	
	def enviarMail() {
		emisor.envioMail
	}

}
