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
    private String nombreAlimento;
    private Alimento alimentos;
    
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
    public Alimento getAlimentos() {
        return alimentos;
    }
    public void setAlimentos(Alimento alimentos) {
        this.alimentos = alimentos;
    }

}
