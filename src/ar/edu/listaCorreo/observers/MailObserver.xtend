package ar.edu.listaCorreo.observers

import ar.edu.listaCorreo.observers.PostObserver
import ar.edu.listaCorreo.Post

class MailObserver implements PostObserver {
	MessageSender messageSender

	new(MessageSender pMessageSender) {
		messageSender = pMessageSender
	}

	override send(Post post) {
		val lista = post.destino
		lista.getMailsDestino(post).forEach [ mailDestino |
			var mail = new Mail
			mail.from = post.emisor.mail
			mail.titulo = "[" + lista.encabezado + "] nuevo post"
			mail.message = post.mensaje
			mail.to = mailDestino
			messageSender.send(mail)
		]
	}

}
