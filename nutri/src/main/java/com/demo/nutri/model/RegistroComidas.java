package com.demo.nutri.model;
import java.util.List;

import javax.persistence.*;

@Entity
public class RegistroComidas {
    @Id
    @GeneratedValue
    private Integer id;
    private String codigoDeBarras;
    private Double cantidad;
    private String nombreUsuario;
    private String fecha;
    private String tipoDeComida;
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((nombreUsuario == null) ? 0 : nombreUsuario.hashCode());
        result = prime * result + ((fecha == null) ? 0 : fecha.hashCode());
        result = prime * result + ((tipoDeComida == null) ? 0 : tipoDeComida.hashCode());
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
        RegistroComidas other = (RegistroComidas) obj;
        if (nombreUsuario == null) {
            if (other.nombreUsuario != null)
                return false;
        } else if (!nombreUsuario.equals(other.nombreUsuario))
            return false;
        if (fecha == null) {
            if (other.fecha != null)
                return false;
        } else if (!fecha.equals(other.fecha))
            return false;
        if (tipoDeComida == null) {
            if (other.tipoDeComida != null)
                return false;
        } else if (!tipoDeComida.equals(other.tipoDeComida))
            return false;
        return true;
    }
    private String nombreAlimento;
    @OneToMany(cascade = CascadeType.ALL)
    private List<Alimento> alimentos;
    
    public String getNombreAlimento() {
        return nombreAlimento;
    }
    public void setNombreAlimento(String nombreAlimento) {
        this.nombreAlimento = nombreAlimento;
    }
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getCodigoDeBarras() {
        return codigoDeBarras;
    }
    public void setCodigoDeBarras(String codigoDeBarras) {
        this.codigoDeBarras = codigoDeBarras;
    }
    public Double getCantidad() {
        return cantidad;
    }
    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }
    public String getNombreUsuario() {
        return nombreUsuario;
    }
    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }
    public String getFecha() {
        return fecha;
    }
    public void setFecha(String fecha) {
        this.fecha = fecha;
    }
    public String getTipoDeComida() {
        return tipoDeComida;
    }
    public void setTipoDeComida(String tipoDeComida) {
        this.tipoDeComida = tipoDeComida;
    }
    public List<Alimento> getAlimentos() {
        return alimentos;
    }
    public void setAlimentos(List<Alimento> alimentos) {
        this.alimentos = alimentos;
    }


}
