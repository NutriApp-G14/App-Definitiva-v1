package com.demo.nutri.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.demo.nutri.model.Usuario;

public interface UsuarioRepository extends CrudRepository<Usuario, String> {
    List<Usuario> findByNombre(String nombre);
}
