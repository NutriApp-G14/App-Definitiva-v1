package com.demo.nutri.repository;

import com.demo.nutri.model.Receta;

import java.util.List;

import org.springframework.data.repository.CrudRepository;



public interface RecetaRepository extends CrudRepository<Receta, Integer> {
    Receta findByNombre(String nombre);
    List<Receta> findByNombreUsuario(String nombreUsuario);
}
