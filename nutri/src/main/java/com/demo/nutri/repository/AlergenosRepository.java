package com.demo.nutri.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.demo.nutri.model.Alergenos;


public interface AlergenosRepository extends CrudRepository<Alergenos, String> {
    List<Alergenos> findByName(String name);

}