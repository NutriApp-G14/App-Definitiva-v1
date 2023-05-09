package com.demo.nutri.controller;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;


import com.demo.nutri.model.Usuario;
import com.demo.nutri.repository.UsuarioRepository;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@RestController
@RequestMapping("/users")

public class UsuarioController {
    
    private final UsuarioRepository usuarioRepository;

  public UsuarioController(UsuarioRepository usuarioRepository) {
    this.usuarioRepository = usuarioRepository;
  }


    @PostMapping("/login/{nombreUsuario}")
    public ResponseEntity<Usuario> login(@PathVariable String nombreUsuario, @RequestBody Usuario Usuario) {

        String token = getJWTToken(nombreUsuario);

        return usuarioRepository.findById(nombreUsuario).map(
            usuario -> {
                usuario.setToken(token);
                usuarioRepository.save(usuario);
                return ResponseEntity.ok().body(usuario);
            }).orElse(new ResponseEntity<Usuario>(HttpStatus.NOT_FOUND));
  

    }

    private String getJWTToken(String username) {
        String secretKey = "mySecretKey!!!!!111112222233333344444445555556666666677777777777777";
        List<GrantedAuthority> grantedAuthorities = AuthorityUtils
                .commaSeparatedStringToAuthorityList("ROLE_USER");

        String token = Jwts
                .builder()
                .setId("softtekJWT")
                .setSubject(username)
                .claim("authorities",
                        grantedAuthorities.stream()
                                .map(GrantedAuthority::getAuthority)
                                .collect(Collectors.toList()))
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 6000000))
                .signWith(SignatureAlgorithm.HS512,
                        secretKey.getBytes()).compact();

        return "Bearer " + token;
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
            usuario.setImageString(Usuario.getImageString());
            usuarioRepository.save(usuario);
            return ResponseEntity.ok().body(usuario);
        }).orElse(new ResponseEntity<Usuario>(HttpStatus.NOT_FOUND));
    }


    @PutMapping("/password/{id}")
    public ResponseEntity<Usuario>  updateContraseña(@PathVariable String id, @RequestBody Usuario Usuario) {
        return usuarioRepository.findById(id).map(usuario -> {
            usuario.setPassword(Usuario.getPassword());
            usuarioRepository.save(usuario);
            return ResponseEntity.ok().body(usuario);
        }).orElse(new ResponseEntity<Usuario>(HttpStatus.NOT_FOUND));
    }


    @PutMapping("/token/{id}")
    public ResponseEntity<Usuario>  updateToken(@PathVariable String id, @RequestBody Usuario Usuario) {
        return usuarioRepository.findById(id).map(usuario -> {
            usuario.setToken(Usuario.getToken());
            usuarioRepository.save(usuario);
            return ResponseEntity.ok().body(usuario);
        }).orElse(new ResponseEntity<Usuario>(HttpStatus.NOT_FOUND));
    }




    // los demas metodos del controlador se mantienen igual

}


