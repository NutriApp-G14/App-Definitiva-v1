package com.demo.nutri.model;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Usuario {
    @Id
    private String nombreUsuario;
    private String nombre;
    private String password;

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public Usuario () { }
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((nombreUsuario == null) ? 0 : nombreUsuario.hashCode());
        return result;
    }
    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Usuario other = (Usuario) obj;
        if (nombreUsuario == null) {
            if (other.nombreUsuario != null)
                return false;
        } else if (!nombreUsuario.equals(other.nombreUsuario))
            return false;
        return true;
    }
    public String getNombreUsuario() {
        return nombreUsuario;
    }
    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

}
