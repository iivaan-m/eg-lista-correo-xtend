package ar.edu.listaCorreo.observers

import ar.edu.listaCorreo.Post

class MailObserver implements PostObserver {
	MessageSender messageSender

	new(MessageSender _messageSender) {
		messageSender = _messageSender
	}

	override send(Post post) {
		val lista = post.destino
		lista.getMailsDestino(post).forEach [ mailDestino |
			val mail = new Mail => [
				from = post.emisor.mail
				titulo = "[" + lista.encabezado + "] nuevo post"
				message = post.mensaje
				to = mailDestino
			]
			messageSender.send(mail)
		]
	}

}
