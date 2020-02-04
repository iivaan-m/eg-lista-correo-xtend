package ar.edu.listaCorreoDecorada.listas

import ar.edu.listaCorreoDecorada.emails.Email
import ar.edu.listaCorreoDecorada.emails.EmailSender
import java.util.ArrayList

import static org.junit.jupiter.api.Assertions.assertEquals

class EmailSenderMock implements EmailSender {

	val emailsEnviados = new ArrayList<Email>()

	override send(Email email) {
		this.emailsEnviados.add(email)
	}

	def void assertEmailEnviado(String message, int cantidad, Post post) {
		val correspondientes = emailsEnviados.filter(
			[Email email|email.from == post.from && email.subject == post.subject && email.content == post.content])
		assertEquals(cantidad, correspondientes.size, message)
	}
}
