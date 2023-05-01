package com.demo.nutri.repository;

import java.util.*;

import org.springframework.data.repository.CrudRepository;

import com.demo.nutri.model.RegistroComidas;

public interface RegistroComidasRepository extends CrudRepository<RegistroComidas, Integer> {

    List<RegistroComidas> findByNombreUsuario(String nombreUsuario);
    Optional<RegistroComidas> findById(Integer id);
    List<RegistroComidas> findByFecha(String fecha);
    List<RegistroComidas> findByTipoDeComida(String tipoDeComida);
    List<RegistroComidas> findByFechaAndTipoDeComidaAndNombreUsuario(String fecha, String tipoDeComida, String nombreUsuario);
    List<RegistroComidas> findByFechaAndNombreUsuario(String fecha, String nombreUsuario);
    
}
