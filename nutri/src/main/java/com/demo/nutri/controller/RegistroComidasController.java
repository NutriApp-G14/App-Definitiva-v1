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
    public ResponseEntity<RegistroComidas> getRegistroComidas(@PathVariable String id) {
        return registroComidasRepository.findById(id).map(
                registroComidas -> ResponseEntity.ok().body(registroComidas))
                .orElse(new ResponseEntity<RegistroComidas>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<RegistroComidas> deleteRegistroComidas(@PathVariable String id) {
        registroComidasRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<RegistroComidas> updateRegistroComidas(@PathVariable String id,
            @RequestBody RegistroComidas RegistroComidas) {
        return registroComidasRepository.findById(id).map(registroComidas -> {
            registroComidas.setNombreUsuario(RegistroComidas.getNombreUsuario());
            registroComidas.setCantidad(RegistroComidas.getCantidad());
            registroComidas.setCodigoDeBarras(RegistroComidas.getCodigoDeBarras());
            registroComidas.setFecha(RegistroComidas.getFecha());
            registroComidas.setTipoDeComida(RegistroComidas.getTipoDeComida());
            registroComidasRepository.save(registroComidas);
            return ResponseEntity.ok().body(registroComidas);
        }).orElse(new ResponseEntity<RegistroComidas>(HttpStatus.NOT_FOUND));
    }

    @GetMapping("/registros/{fecha}/{tipoDeComida}/{nombreUsuario}")
    public List<RegistroComidas> getRegistrosPorDiaYTipoDeComidaYNombreUsuario(@PathVariable String fecha, @PathVariable String tipoDeComida, @PathVariable String nombreUsuario ) {
        return (List<RegistroComidas>) registroComidasRepository.findByFechaAndTipoDeComidaAndNombreUsuario(
                fecha, tipoDeComida, nombreUsuario);

    }
}
