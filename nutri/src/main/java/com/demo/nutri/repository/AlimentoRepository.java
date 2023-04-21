package com.demo.nutri.repository;

import com.demo.nutri.model.Alimento;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

public interface AlimentoRepository extends CrudRepository<Alimento, Integer> {
    Optional<Alimento> findById(Integer id);
    Alimento findByName(String name);
    List<Alimento> findByNombreUsuario(String nombreUsuario);
    Alimento findByCodigoDeBarrasAndNombreUsuario(String codigoDeBarras ,String nombreUsuario);
}
