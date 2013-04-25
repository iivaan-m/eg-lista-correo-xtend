package ar.org.uqbar.disenio.listas.decorator

import org.junit.Before
import junit.framework.Assert
import org.junit.Test

class ListaAbiertaTestCase extends ListaTestCase<ListaCorreo> {
	
	
	@Before 
	override def void setUp() {
		super.setUp();
		lista = new ListaCorreroFactory().abiertaYLibre();
	}
	
	@Test
	def testSuscripcion() {
		lista.suscribir(leo);
		Assert::assertTrue("Se esperaba que leo este en la lista", lista.miembros.contains(leo));
		Assert::assertFalse("Se esperaba que pablo no este en la lista", lista.miembros.contains(pablo));
	}
	
	
}