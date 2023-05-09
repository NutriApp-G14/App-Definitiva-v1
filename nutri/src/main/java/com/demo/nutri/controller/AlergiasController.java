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

import com.demo.nutri.model.Alergias;
import com.demo.nutri.repository.AlergiasRepository;


@RestController
@RequestMapping("/allergies")

public class AlergiasController {
    
    private final AlergiasRepository repository;

    public AlergiasController(AlergiasRepository AlergiasRepository) {
        this.repository = AlergiasRepository;
    }

    @GetMapping
    public List<Alergias> getAlergias() {
        return (List<Alergias>) repository.findAll();
    }

    @PostMapping("/add")
    public ResponseEntity<Alergias> createAlergias(@RequestBody Alergias Alergias) throws URISyntaxException {
        Alergias savedAlergias = repository.save(Alergias);
        return ResponseEntity.created(new URI(savedAlergias.getNombreUsuario())).body(savedAlergias);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Alergias> getAlergiasUsuario(@PathVariable String id) {
        return repository.findById(id).map(
                alergias -> ResponseEntity.ok().body(alergias)).orElse(new ResponseEntity<Alergias>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Alergias> deleteAlergias(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Alergias>  updateAlergias(@PathVariable String id, @RequestBody Alergias Alergias) {
        return repository.findById(id).map(alergias -> {
            alergias.setNombreUsuario(Alergias.getNombreUsuario());
            alergias.setCacahuetes(Alergias.getCacahuetes());
            alergias.setLeche(Alergias.getLeche());
            alergias.setHuevo(Alergias.getHuevo());
            alergias.setTrigo(Alergias.getTrigo());
            alergias.setSoja(Alergias.getSoja());
            alergias.setMariscos(Alergias.getMariscos());
            alergias.setFrutosSecos(Alergias.getFrutosSecos());
            alergias.setPescado(Alergias.getPescado());

            repository.save(alergias);
            return ResponseEntity.ok().body(alergias);
        }).orElse(new ResponseEntity<Alergias>(HttpStatus.NOT_FOUND));
    }


    
}