package com.demo.nutri.controller;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
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
import com.demo.nutri.model.Receta;
import com.demo.nutri.repository.RecetaRepository;

@RestController
@RequestMapping("/recipes")

public class RecetaController {
    
    private final RecetaRepository repository;

    public RecetaController(RecetaRepository RecetaRepository) {
        this.repository = RecetaRepository;
    }

    @GetMapping
    public List<Receta> getRecetas() {
        return (List<Receta>) repository.findAll();
    }

    @GetMapping("/user/{nombreUsuario}")
    public List<Receta> getRecetasUsuario(@PathVariable String nombreUsuario) {
        return (List<Receta>) repository.findByNombreUsuario(nombreUsuario);
    }

    @PostMapping("/add")
    public ResponseEntity<Receta> createReceta(@RequestBody Receta receta) throws URISyntaxException {
        Receta savedReceta = repository.save(receta);
        return ResponseEntity.created(new URI(savedReceta.getNombre())).body(savedReceta);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Receta>  getReceta(@PathVariable Integer id) {
        return repository.findById(id).map(
                Receta -> ResponseEntity.ok().body(Receta)).orElse(new ResponseEntity<Receta>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Receta>  deleteReceta(@PathVariable Integer id) {
        repository.deleteById(id);
        return ResponseEntity.ok().build();
    }


    
    @PutMapping("/{id}")
    public ResponseEntity<Receta> updateReceta(@PathVariable Integer id, @RequestBody Receta updatedReceta) {
        return repository.findById(id).map(receta -> {
            receta.setNombre(updatedReceta.getNombre());
            receta.setPorciones(updatedReceta.getPorciones());
            receta.setUnidadesMedida(updatedReceta.getUnidadesMedida());
            receta.setDescripcion(updatedReceta.getDescripcion());
            receta.setIngredientes(updatedReceta.getIngredientes());
            receta.setPasos(updatedReceta.getPasos());
            receta.setImagen(updatedReceta.getImagen());
            receta.setNombreUsuario(updatedReceta.getNombreUsuario());
            repository.save(receta);
            return ResponseEntity.ok().body(receta);
        }).orElse(new ResponseEntity<Receta>(HttpStatus.NOT_FOUND));
    }
    
    @PostMapping("/{id}/addIngrediente")
    public ResponseEntity<Receta> addIngrediente(@PathVariable Integer idReceta, @RequestBody Alimento alimento) {
        Receta receta = repository.findById(idReceta).orElseThrow(() -> new RuntimeException("Receta no encontrada con el id: " + idReceta));
        List<Alimento> ingredientes = receta.getIngredientes();
        if (ingredientes == null) {
            ingredientes = new ArrayList<>();   
        }
        ingredientes.add(alimento);
        receta.setIngredientes(ingredientes);
        Receta recetaActualizada = repository.save(receta);
        return ResponseEntity.ok().body(recetaActualizada);
    }

    @PostMapping("/insert")
    public ResponseEntity<Receta> insertarReceta(@RequestBody Receta nuevoReceta) {
            Receta RecetaGuardado = repository.save(nuevoReceta);
            return ResponseEntity.status(HttpStatus.CREATED).body(RecetaGuardado);
}

}