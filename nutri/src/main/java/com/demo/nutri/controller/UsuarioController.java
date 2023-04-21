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

import com.demo.nutri.model.Usuario;
import com.demo.nutri.repository.UsuarioRepository;


@RestController
@RequestMapping("/users")

public class UsuarioController {
    private final UsuarioRepository usuarioRepository;

    public UsuarioController(UsuarioRepository UsuarioRepository) {
        this.usuarioRepository = UsuarioRepository;
    }

    @GetMapping
    public List<Usuario> getUsuarios() {
        return (List<Usuario>) usuarioRepository.findAll();
    }

    @PostMapping("/add")
    public ResponseEntity<Usuario> createUsuario(@RequestBody Usuario Usuario) throws URISyntaxException {
        Usuario savedUsuario = usuarioRepository.save(Usuario);
        return ResponseEntity.created(new URI("/users/" + savedUsuario.getNombreUsuario())).body(savedUsuario);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Usuario> getUsuario(@PathVariable String id) {
        return usuarioRepository.findById(id).map(
                usuario -> ResponseEntity.ok().body(usuario)).orElse(new ResponseEntity<Usuario>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Usuario>  deleteUsuario(@PathVariable String id) {
        usuarioRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Usuario>  updateUsuario(@PathVariable String id, @RequestBody Usuario Usuario) {
        return usuarioRepository.findById(id).map(usuario -> {
            usuario.setNombre(Usuario.getNombre());
            usuario.setPassword(Usuario.getPassword());
            usuario.setAge(Usuario.getAge());
            usuario.setHeight(Usuario.getHeight());
            usuario.setWeight(Usuario.getWeight());
            usuario.setGender(Usuario.getGender());
            usuario.setActivity(Usuario.getActivity());
            usuario.setObjective(Usuario.getObjective());
            usuario.setImageProfile(Usuario.getImageProfile());
            usuarioRepository.save(usuario);
            return ResponseEntity.ok().body(usuario);
        }).orElse(new ResponseEntity<Usuario>(HttpStatus.NOT_FOUND));
    }


}