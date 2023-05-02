package com.demo.nutri;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.beans.factory.annotation.Autowired;

import com.demo.nutri.model.Alergias;
import com.demo.nutri.model.Alimento;
import com.demo.nutri.model.Receta;
import com.demo.nutri.model.RegistroComidas;
import com.demo.nutri.model.Usuario;
import com.demo.nutri.repository.AlergiasRepository;
import com.demo.nutri.repository.AlimentoRepository;
import com.demo.nutri.repository.RecetaRepository;
import com.demo.nutri.repository.RegistroComidasRepository;
import com.demo.nutri.repository.UsuarioRepository;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

@SpringBootTest
class NutriApplicationTests {

	@Autowired
    private UsuarioRepository usuarioRepo;
	@Autowired
    private AlimentoRepository alimentoRepo;
	@Autowired
    private AlergiasRepository alergiasRepo;
	@Autowired
    private RegistroComidasRepository registroRepo;
	@Autowired
    private RecetaRepository recetaRepo;
 
    @Test
    final void testUsuario() {
        Usuario usuario = new Usuario();
        usuario.setNombre("Usuario");
        usuario.setNombreUsuario("usuarioPrueba");
		usuario.setPassword("usuario");
        usuario.setAge("12");
        usuario.setGender("hombre");
		usuario.setWeight("50");
		usuario.setHeight("170");
		usuario.setActivity("poco activo");
		usuario.setObjective("mantener peso");
		usuario.setImageString("");
        usuarioRepo.save(usuario);
// Prueba de la creación de un usuario
        Optional<Usuario> usuario2 = usuarioRepo.findById("usuarioPrueba");
        assertEquals(usuario2.get().getNombreUsuario(), usuario.getNombreUsuario());
        assertEquals(usuario2.get().getNombre(), "Usuario");
// Prueba de la actualización de un usuario
        usuario.setAge("13");
        usuarioRepo.save(usuario);
        usuario2 = usuarioRepo.findById("usuarioPrueba");
        assertNotEquals(usuario2.get().getAge(), "12");            
// Prueba de la eliminación de un usuario
        usuarioRepo.delete(usuario);
        usuario2 = usuarioRepo.findById("usuarioPrueba");
        assertFalse(usuario2.isPresent());
    }


	@Test
    final void testAlimento() {
// Prueba de la creación de alimentos
        Alimento alimento = new Alimento();
        alimento.setName("Alimento");
        alimento.setCantidad(100.0);
		alimento.setUnidadesCantidad("gramos");
        alimento.setCalorias(150.0);
        alimento.setGrasas(2.0);
		alimento.setProteinas(0.5);
		alimento.setCarbohidratos(3.0);
		alimento.setAzucar(0.0);
		alimento.setFibra(0.0);
		alimento.setSodio(0.0);
		alimento.setImage("");
		alimento.setNombreUsuario("usuarioPrueba2");
		alimento.setCodigoDeBarras("1");
        alimentoRepo.save(alimento);

        Alimento alimento3 = new Alimento();
        alimento3.setName("Alimento");
        alimento3.setCantidad(100.0);
		alimento3.setUnidadesCantidad("gramos");
        alimento3.setCalorias(150.0);
        alimento3.setGrasas(2.0);
		alimento3.setProteinas(0.5);
		alimento3.setCarbohidratos(3.0);
		alimento3.setAzucar(0.0);
		alimento3.setFibra(0.0);
		alimento3.setSodio(0.0);
		alimento3.setImage("");
		alimento3.setNombreUsuario("usuarioPrueba2");
		alimento3.setCodigoDeBarras("2");
        alimentoRepo.save(alimento3);

// Prueba de la obtención de un alimento
		int id = alimento.getId();
        Optional<Alimento> alimento2 = alimentoRepo.findById(id);
        assertEquals(alimento2.get().getNombreUsuario(), alimento.getNombreUsuario());
        assertEquals(alimento2.get().getName(), "Alimento");
		assertEquals(alimento2.get().getCantidad(), 100.0);
		assertEquals(alimento2.get().getUnidadesCantidad(), "gramos");
		assertEquals(alimento2.get().getCalorias(), 150.0);

// Prueba de la obtención de los alimentos de un usuario
		List<Alimento> alimentosUsuario= alimentoRepo.findByNombreUsuario("usuarioPrueba2");
		assertNotEquals(alimentosUsuario.size(), 0);

//Prueba de la obtención de los alimentos con un codigo de barras y un usuario
		List<Alimento> alimentosCodigo = alimentoRepo.findByCodigoDeBarrasAndNombreUsuario("1", "usuarioPrueba");
		assertNotEquals(alimentosUsuario.size(), 0);


// Prueba de la actualización de un alimento
alimento.setGrasas(4.0);
		alimentoRepo.save(alimento);
        alimento2 = alimentoRepo.findById(id);
        assertNotEquals(alimento2.get().getGrasas(), 2.0);    

// Prueba de la eliminación de un alimento
	alimentoRepo.delete(alimento);
	alimentoRepo.delete(alimento3);
	alimento2 = alimentoRepo.findById(id);
	assertFalse(alimento2.isPresent());
}


@Test
final void testAlergias() {
	Alergias alergias = new Alergias();
	alergias.setNombreUsuario("usuarioPrueba");
	alergias.setCacahuetes(false);
	alergias.setLeche(false);
	alergias.setHuevo(true);
	alergias.setTrigo(true);
	alergias.setSoja(false);
	alergias.setMariscos(false);
	alergias.setFrutosSecos(true);
	alergias.setPescado(false);
	alergiasRepo.save(alergias);
// Prueba de la creación de una alergia
	Optional<Alergias> alergias2 = alergiasRepo.findById("usuarioPrueba");
	assertEquals(alergias2.get().getNombreUsuario(), alergias.getNombreUsuario());
	assertEquals(alergias2.get().getCacahuetes(),false);
	assertEquals(alergias2.get().getLeche(), false);
	assertEquals(alergias2.get().getHuevo(), true);
	assertEquals(alergias2.get().getTrigo(), true);
// Prueba de la actualización de una alergia
alergias.setSoja(true);
	alergiasRepo.save(alergias);
	alergias2 = alergiasRepo.findById("usuarioPrueba");
	assertNotEquals(alergias2.get().getSoja(), false);	   
// Prueba de la eliminación de un alimento
alergiasRepo.delete(alergias);
alergias2 = alergiasRepo.findById("usuarioPrueba");
assertFalse(alergias2.isPresent());
}



@Test
final void testRegistroComidas() {
	RegistroComidas registro = new RegistroComidas();
	registro.setCodigoDeBarras("");
	registro.setCantidad(100.0);
	registro.setNombreUsuario("usuarioPrueba");
	registro.setFecha("28/04/2023");
	registro.setTipoDeComida("desayuno");
	registro.setNombreAlimento("patata");
	registro.setAlimentos(null);
	registroRepo.save(registro);
	int id = registro.getId();
// Prueba de la creación de un registro
	Optional<RegistroComidas> registro2 = registroRepo.findById(id);
	assertEquals(registro2.get().getNombreUsuario(), registro.getNombreUsuario());
	assertEquals(registro2.get().getCodigoDeBarras(),"");
	assertEquals(registro2.get().getCantidad(), 100.0);
	assertEquals(registro2.get().getFecha(), registro.getFecha());
	assertEquals(registro2.get().getTipoDeComida(), "desayuno");
	assertEquals(registro2.get().getNombreAlimento(), registro.getNombreAlimento());
// Prueba de la actualización de un resgistro
registro.setTipoDeComida("merienda");
	registroRepo.save(registro);
	registro2 = registroRepo.findById(id);
	assertNotEquals(registro2.get().getTipoDeComida(), "desayuno");	   
// Prueba de la eliminación de un alimento
registroRepo.delete(registro);
registro2 = registroRepo.findById(id);
assertFalse(registro2.isPresent());
}

@Test
final void testRecetas() {
    List<String> pasos = new ArrayList<>();
		pasos.add("1.echar");
		pasos.add("2.remover");
	Receta receta = new Receta();
	receta.setNombre("Tarta de queso");
	receta.setPorciones(1);
	receta.setUnidadesMedida("gramos");
	receta.setDescripcion("Tarta de queso casera con mermelada de frambuesa");
	receta.setIngredientes(null);
	receta.setPasos(pasos);
	receta.setImagen("");
	receta.setNombreUsuario("usuarioPrueba");
	recetaRepo.save(receta);
	int id = receta.getId();
// Prueba de la creación de una receta
	Optional<Receta> receta2 = recetaRepo.findById(id);
	assertEquals(receta2.get().getNombreUsuario(), receta.getNombreUsuario());
	assertEquals(receta2.get().getNombre(),"Tarta de queso");
	assertEquals(receta2.get().getNombre(),receta.getNombre());
	assertEquals(receta2.get().getPorciones(), 1);
	assertEquals(receta2.get().getUnidadesMedida(), "gramos");
	assertEquals(receta2.get().getDescripcion(), "Tarta de queso casera con mermelada de frambuesa");
	assertEquals(receta2.get().getImagen(), "");   
// Prueba de la actualización de una receta
receta.setNombre("Tarta de chocolate");
	recetaRepo.save(receta);
	receta2 = recetaRepo.findById(id);
	assertNotEquals(receta2.get().getNombre(), "Tarta de queso");	   
// Prueba de la eliminación de un alimento
recetaRepo.delete(receta);
receta2 = recetaRepo.findById(id);
assertFalse(receta2.isPresent());
// Prueba de la eliminación de un alimento
recetaRepo.delete(receta);
receta2 = recetaRepo.findById(id);
assertFalse(receta2.isPresent());
}

}



