package ar.edu.listaCorreoDecorada.listas

import ar.edu.listaCorreoDecorada.emails.Email
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Miembro {
	String mailDefault
	List<String> otrosMails = newArrayList

	def boolean esRemitente(Post post) {
		return mailDefault == post.from || otrosMails.contains(post.from)
	}

	def enviar(Post post) {
		EmailSenderProvider.emailSender.send(
			new Email() => [
				from = post.from
				to = this.mailDefault
				content = post.content
				subject = post.subject
			])

	}
}
