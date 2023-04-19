package com.demo.nutri.model;
import javax.persistence.*;

@Entity
public class RegistroComidas {
    @Id
    @GeneratedValue
    private Integer id;
    private Integer codigoDeBarras;
    private Double cantidad;
    private String nombreUsuario;
    private String fecha;
    private String tipoDeComida;
    
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public Integer getCodigoDeBarras() {
        return codigoDeBarras;
    }
    public void setCodigoDeBarras(Integer codigoDeBarras) {
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

}
