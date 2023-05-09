package com.demo.nutri.controller;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.demo.nutri.model.RegistroComidas;
import com.demo.nutri.repository.RegistroComidasRepository;

@RestController
@RequestMapping("/registro")

public class RegistroComidasController {

    private final RegistroComidasRepository registroComidasRepository;

    public RegistroComidasController(RegistroComidasRepository RegistroComidasRepository) {
        this.registroComidasRepository = RegistroComidasRepository;
    }

    @GetMapping
    public List<RegistroComidas> getRegistroComidass() {
        return (List<RegistroComidas>) registroComidasRepository.findAll();
    }

    @PostMapping("/add")
    public ResponseEntity<RegistroComidas> createRegistroComidas(@RequestBody RegistroComidas RegistroComidas)
            throws URISyntaxException {
        RegistroComidas savedRegistroComidas = registroComidasRepository.save(RegistroComidas);
        return ResponseEntity.created(new URI(savedRegistroComidas.getNombreUsuario())).body(savedRegistroComidas);
    }

    @GetMapping("/{id}")
    public ResponseEntity<RegistroComidas> getRegistroComida(@PathVariable Integer id) {
        return registroComidasRepository.findById(id).map(
                registroComidas -> ResponseEntity.ok().body(registroComidas)).orElse(new ResponseEntity<RegistroComidas>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/reg/{id}")
    public ResponseEntity<RegistroComidas> deleteRegistroComidas(@PathVariable Integer id) {
        registroComidasRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    // @DeleteMapping("/{id}")
    // public ResponseEntity<Alimento>  deleteAlimento(@PathVariable Integer id) {
    //     repository.deleteById(id);
    //     return ResponseEntity.ok().build();
    // }

    @PutMapping("/{id}")
    public ResponseEntity<RegistroComidas> updateRegistroComidas(@PathVariable Integer id,
            @RequestBody RegistroComidas RegistroComidas) {
        return registroComidasRepository.findById(id).map(registroComidas -> {
            registroComidas.setNombreUsuario(RegistroComidas.getNombreUsuario());
            registroComidas.setCantidad(RegistroComidas.getCantidad());
            registroComidas.setCodigoDeBarras(RegistroComidas.getCodigoDeBarras());
            registroComidas.setFecha(RegistroComidas.getFecha());
            registroComidas.setTipoDeComida(RegistroComidas.getTipoDeComida());
            registroComidas.setNombreAlimento(RegistroComidas.getNombreAlimento());
            registroComidas.setAlimentos(RegistroComidas.getAlimentos());
            registroComidasRepository.save(registroComidas);
            return ResponseEntity.ok().body(registroComidas);
        }).orElse(new ResponseEntity<RegistroComidas>(HttpStatus.NOT_FOUND));
    }

    @GetMapping("/registros/{fecha}/{tipoDeComida}/{nombreUsuario}")
    public List<RegistroComidas> getRegistrosByFechaAndTipoDeComidaAndNombreUsuario(@PathVariable String fecha, @PathVariable String tipoDeComida, @PathVariable String nombreUsuario ) {
        return (List<RegistroComidas>) registroComidasRepository.findByFechaAndTipoDeComidaAndNombreUsuario(
                fecha, tipoDeComida, nombreUsuario);

    }
    @GetMapping("/registros/{fecha}/{nombreUsuario}")
    public List<RegistroComidas> getRegistrosByFechaAndTipoDeComidaAndNombreUsuario(@PathVariable String fecha,@PathVariable String nombreUsuario ) {
        return (List<RegistroComidas>) registroComidasRepository.findByFechaAndNombreUsuario(
                fecha,nombreUsuario);

    }

    @GetMapping("/user/{nombreUsuario}")
    public List<RegistroComidas> getRegistroUsuario(@PathVariable String nombreUsuario) {
        return (List<RegistroComidas>) registroComidasRepository.findByNombreUsuario(nombreUsuario);
    }

    @PutMapping("/cantidad/{id}")
    public ResponseEntity<RegistroComidas>  updateCantidad(@PathVariable String id, @RequestBody RegistroComidas Registro) {
        return registroComidasRepository.findById(id).map(registro -> {
            registro.setCantidad(Registro.getCantidad());
            registroComidas.save(registro);
            return ResponseEntity.ok().body(registro);
        }).orElse(new ResponseEntity<RegistroComidas>(HttpStatus.NOT_FOUND));
    }
}
