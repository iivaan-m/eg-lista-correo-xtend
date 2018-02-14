package ar.edu.listaCorreoMailSingleton

import ar.edu.listaCorreoMailSingleton.observers.PostObserver
import ar.edu.listaCorreoMailSingleton.suscripcion.SuscripcionAbierta
import ar.edu.listaCorreoMailSingleton.suscripcion.SuscripcionCerrada
import ar.edu.listaCorreoMailSingleton.suscripcion.TipoSuscripcion
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ListaCorreo {
	List<Miembro> miembros
	TipoEnvio tipoEnvio
	List<PostObserver> postObservers
	String encabezado
	TipoSuscripcion tipoSuscripcion
	
	/**
	 * CONSTRUCTORES
	 
	 */
	 
	/** Constructor default: toda lista es abierta */
	new() {
		miembros = new ArrayList<Miembro>
		tipoEnvio = new EnvioAbierto
		postObservers = new ArrayList<PostObserver>
		tipoSuscripcion = new SuscripcionAbierta
	}
	
	def static ListaCorreo listaAbierta() {
		new ListaCorreo
	}	

	def static ListaCorreo listaCerrada() {
		new ListaCorreo => [
			tipoEnvio = new EnvioRestringido
			tipoSuscripcion = new SuscripcionCerrada
		]
	}	

	/** 
	 * CASO DE USO: Suscripción
	 *  
	 **/
	def suscribir(Miembro miembro)  {
		tipoSuscripcion.suscribir(miembro, this)
	}
	
//  otra decisión de diseño podría ser no obligar a la lista abierta a aprobar suscripción
//  pero eso complica al test porque tiene que acceder al strategy 		
	def aprobarSuscripcion(Miembro miembro)  {
		tipoSuscripcion.aprobarSuscripcion(miembro, this)
	}
	
	def void agregarMiembro(Miembro miembro) {
		miembros.add(miembro)
	}

	/** 
	 * CASO DE USO: Envío de post
	 *  
	 **/
	def void recibirPost(Post post) {
		tipoEnvio.validarEnvio(post, this)
		post.enviar
		postObservers.forEach [ sender | sender.send(post) ]
	}
	
	def void agregarPostObserver(PostObserver postObserver) {
		postObservers.add(postObserver)
	}
	
	def getDestinatarios(Post post) {
		miembros.filter [ miembro | !miembro.equals(post.emisor) ].toList
	}
	
	def getMailsDestino(Post post) {
		getDestinatarios(post).map [ miembro | miembro.mail ]
	}
	
	def estaSuscripto(Miembro miembro) {
		miembros.contains(miembro)	
	}
	
}