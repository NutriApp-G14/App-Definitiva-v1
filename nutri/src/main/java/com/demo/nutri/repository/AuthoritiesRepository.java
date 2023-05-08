package com.demo.nutri.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.demo.nutri.model.Authorities;

public interface AuthoritiesRepository extends CrudRepository<Authorities, Integer> {

    List<Authorities> findByNombreUsuario(String id);
    
}
