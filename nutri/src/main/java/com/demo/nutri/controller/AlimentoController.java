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

import com.demo.nutri.model.Alimento;
import com.demo.nutri.repository.AlimentoRepository;

@RestController
@RequestMapping("/foods")

public class AlimentoController {
    
    private final AlimentoRepository repository;

    public AlimentoController(AlimentoRepository AlimentoRepository) {
        this.repository = AlimentoRepository;
    }

    @GetMapping
    public List<Alimento> getAlimentos() {
        return (List<Alimento>) repository.findAll();
    }

    @GetMapping("/user/{nombreUsuario}")
    public List<Alimento> getAlimentosUsuario(@PathVariable String nombreUsuario) {
        return (List<Alimento>) repository.findByNombreUsuario(nombreUsuario);
    }

    @PostMapping("/add")
    public ResponseEntity<Alimento> createAlimento(@RequestBody Alimento Alimento) throws URISyntaxException {
        Alimento savedAlimento = repository.save(Alimento);
        return ResponseEntity.created(new URI( savedAlimento.getId().toString())).body(savedAlimento);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Alimento>  getAlimento(@PathVariable Integer id) {
        return repository.findById(id).map(
                alimento -> ResponseEntity.ok().body(alimento)).orElse(new ResponseEntity<Alimento>(HttpStatus.NOT_FOUND));
                
    }

    @GetMapping("/{nombreUsuario}/{codigoDeBarras}")
    public Alimento getAlimento(@PathVariable String nombreUsuario,@PathVariable String codigoDeBarras) {
                return (Alimento) repository.findByCodigoDeBarrasAndNombreUsuario(codigoDeBarras, nombreUsuario);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Alimento>  deleteAlimento(@PathVariable Integer id) {
        repository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Alimento>  updateAlimento(@PathVariable Integer id, @RequestBody Alimento Alimento) {
        return repository.findById(id).map(alimento -> {
            alimento.setCodigoDeBarras(Alimento.getCodigoDeBarras());
            alimento.setName(Alimento.getName());
            alimento.setCalorias(Alimento.getCalorias());
            alimento.setCantidad(Alimento.getCantidad());
            alimento.setUnidadesCantidad(Alimento.getUnidadesCantidad());
            alimento.setCarbohidratos(Alimento.getCarbohidratos());
            alimento.setGrasas(Alimento.getGrasas());
            alimento.setProteinas(Alimento.getProteinas());
            alimento.setAzucar(Alimento.getAzucar());
            alimento.setFibra(Alimento.getFibra());
            alimento.setSodio(Alimento.getSodio());
            alimento.setImage(Alimento.getImage());
            alimento.setReceta(Alimento.getReceta());
            alimento.setRegistroComidas(Alimento.getRegistroComidas());
            alimento.setAlergenos(Alimento.getAlergenos());
            repository.save(alimento);
            return ResponseEntity.ok().body(alimento);
        }).orElse(new ResponseEntity<Alimento>(HttpStatus.NOT_FOUND));
    }

    @PostMapping("/insert")
    public ResponseEntity<Alimento> insertarAlimento(@RequestBody Alimento nuevoAlimento) {
            Alimento alimentoGuardado = repository.save(nuevoAlimento);
            return ResponseEntity.status(HttpStatus.CREATED).body(alimentoGuardado);
}





}
