package com.demo.nutri.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.demo.nutri.model.Alergias;

public interface AlergiasRepository extends CrudRepository<Alergias, String> {
    List<Alergias> findByNombreUsuario(String nombreUsuario);
}