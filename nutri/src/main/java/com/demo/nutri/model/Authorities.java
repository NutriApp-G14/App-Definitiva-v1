package com.demo.nutri.model;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Authorities {
    @Id
    private String nombreUsuario;
    private String roles;
    
}
