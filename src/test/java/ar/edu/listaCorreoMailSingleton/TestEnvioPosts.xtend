package ar.edu.listaCorreoMailSingleton

import ar.edu.listaCorreoMailSingleton.exceptions.BusinessException
import ar.edu.listaCorreoMailSingleton.observers.Mail
import ar.edu.listaCorreoMailSingleton.observers.MailObserver
import ar.edu.listaCorreoMailSingleton.observers.MalasPalabrasObserver
import ar.edu.listaCorreoMailSingleton.observers.MessageSender
import ar.edu.listaCorreoMailSingleton.observers.StubMailSender
import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static org.mockito.ArgumentMatchers.*
import static org.mockito.Mockito.*

class TestEnvioPosts {

	ListaCorreo listaProfes
	ListaCorreo listaAlumnos
	Miembro dodain
	Miembro nico
	Miembro deby
	Miembro alumno
	Post mensajeAlumno
	Post mensajeDodainAlumnos
	// ya no puedo crear un nuevo StubMailSender, esta línea no compila porque el constructor es privado
	// StubMailSender stubMailSender = new StubMailSender
	// entonces ...
	StubMailSender stubMailSender = StubMailSender.instance
	
	MalasPalabrasObserver malasPalabrasObserver = new MalasPalabrasObserver

	@Before
	def void init() {

		/** Listas de correo */
		listaAlumnos = ListaCorreo.listaAbierta()
		listaProfes = ListaCorreo.listaCerrada()

		/** Profes */
		dodain = new Miembro("fernando.dodino@gmail.com")
		nico = new Miembro("nicolas.passerini@gmail.com")
		deby = new Miembro("debyfortini@gmail.com")

		/** Alumnos **/
		alumno = new Miembro("alumno@uni.edu.ar")

		/** en la lista de profes están los profes */
		listaProfes => [
			agregarMiembro(dodain)
			agregarMiembro(nico)
			agregarMiembro(deby)
			agregarPostObserver(new MailObserver)
		]

		listaAlumnos => [
			agregarMiembro(dodain)
			agregarMiembro(nico)
			agregarMiembro(deby)
			agregarPostObserver(new MailObserver)
			agregarPostObserver(malasPalabrasObserver)
		]

		mensajeAlumno = new Post(alumno, "Hola, queria preguntar que es la recursividad", listaProfes)
		mensajeDodainAlumnos = new Post(dodain,
			"Para explicarte recursividad tendría que explicarte qué es la recursividad", listaAlumnos)
	}

	/*************************************************************/
	/*                     TESTS CON STUBS                       */
	/*                      TEST DE ESTADO                       */
	/*************************************************************/
	@Test(expected=BusinessException)
	def void alumnoNoPuedeEnviarPostAListaProfes() {
		listaProfes.recibirPost(mensajeAlumno)
	}

	@Test
	def void alumnoPuedeEnviarMailAListaAbierta() {
		Assert.assertEquals(0, stubMailSender.mailsDe("alumno@uni.edu.ar").size)
		listaAlumnos.recibirPost(mensajeAlumno)
		Assert.assertEquals(1, stubMailSender.mailsDe("alumno@uni.edu.ar").size)
	}

	@Test
	def void alumnoEnviaMailConMalaPalabra() {
		val mensajeFeo = new Post(alumno, "Cuál es loco! Me tienen podrido", listaAlumnos)
		malasPalabrasObserver.agregarMalaPalabra("podrido")
		listaAlumnos.recibirPost(mensajeFeo)
		Assert.assertEquals(1, malasPalabrasObserver.mensajesConMalasPalabras.size)
	}

	/*************************************************************/
	/*                     TESTS CON MOCKS                       */
	/*                  TEST DE COMPORTAMIENTO                   */
	/*************************************************************/
	@Test
	def void testEnvioPostAListaAlumnosLlegaATodosLosOtrosSuscriptos() {
		//creacion de mock
		val mockedMailSender = mock(MessageSender)
		//no le puedo pasar el mockedMailSender!!
		//listaAlumnos.agregarPostObserver(new MailObserver(mockedMailSender))
		//este test está destinado a fallar
		listaAlumnos.agregarPostObserver(new MailObserver)

		// un alumno envía un mensaje a la lista
		listaAlumnos.recibirPost(mensajeDodainAlumnos)

		//verificacion
		//test de comportamiento, verifico que se enviaron 2 mails 
		// a fede y a deby, no así a dodi que fue el que envió el post
		verify(mockedMailSender, times(2)).send(any(Mail))
	}
	
}
