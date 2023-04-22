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

import com.demo.nutri.model.Alergenos;
import com.demo.nutri.repository.AlergenosRepository;


@RestController
@RequestMapping("/allergens")

public class AlergenosController {
    
    private final AlergenosRepository repository;

    public AlergenosController(AlergenosRepository AlergenosRepository) {
        this.repository = AlergenosRepository;
    }

    @GetMapping
    public List<Alergenos> getAlergenos() {
        return (List<Alergenos>) repository.findAll();
    }

    @PostMapping("/add")
    public ResponseEntity<Alergenos> createAlergenos(@RequestBody Alergenos Alergenos) throws URISyntaxException {
        Alergenos savedAlergenos = repository.save(Alergenos);
        return ResponseEntity.created(new URI(savedAlergenos.getName())).body(savedAlergenos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Alergenos> getAlergenosAlimento(@PathVariable String id) {
        return repository.findById(id).map(
                alergenos -> ResponseEntity.ok().body(alergenos)).orElse(new ResponseEntity<Alergenos>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Alergenos>  deleteAlergenos(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Alergenos>  updateAlergenos(@PathVariable String id, @RequestBody Alergenos Alergenos) {
        return repository.findById(id).map(alergenos -> {
            alergenos.setName(Alergenos.getName());
            alergenos.setCacahuetes(Alergenos.getCacahuetes());
            alergenos.setLeche(Alergenos.getLeche());
            alergenos.setHuevo(Alergenos.getHuevo());
            alergenos.setTrigo(Alergenos.getTrigo());
            alergenos.setSoja(Alergenos.getSoja());
            alergenos.setMariscos(Alergenos.getMariscos());
            alergenos.setFrutosSecos(Alergenos.getFrutosSecos());
            alergenos.setPescado(Alergenos.getPescado());

            repository.save(alergenos);
            return ResponseEntity.ok().body(alergenos);
        }).orElse(new ResponseEntity<Alergenos>(HttpStatus.NOT_FOUND));
    }


    
}