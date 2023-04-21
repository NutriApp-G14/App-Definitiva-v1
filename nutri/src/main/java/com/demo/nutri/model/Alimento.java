package com.demo.nutri.model;

<<<<<<< HEAD
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
=======
import java.net.URI;

import javax.persistence.*;
>>>>>>> antonio

@Entity
public class Alimento {
    @Id
    @GeneratedValue
    private Integer id;
    private String name;
    private Double cantidad;
    private String unidadesCantidad; 
    private Double calorias;
    private Double grasas;
    private Double proteinas;
    private Double carbohidratos;
    private String image; 
    private String nombreUsuario; 
<<<<<<< HEAD
    private String codigoDeBarras;

    public String getCodigoDeBarras() {
        return codigoDeBarras;
    }
    public void setCodigoDeBarras(String codigoDeBarras) {
        this.codigoDeBarras = codigoDeBarras;
    }
    public String getUnidadesCantidad() {
        return unidadesCantidad;
    }
    public void setUnidadesCantidad(String unidadesCantidad) {
        this.unidadesCantidad = unidadesCantidad;
    }
    public String getNombreUsuario() {
        return nombreUsuario;
    }
    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }
    public String getImage() {
        return image;
    }
    public void setImage(String image) {
        this.image = image;
    }
=======
    @ManyToOne
    private Receta receta;
>>>>>>> antonio
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Double getCantidad() {
        return cantidad;
    }
    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }
    public String getUnidadesCantidad() {
        return unidadesCantidad;
    }
    public void setUnidadesCantidad(String unidadesCantidad) {
        this.unidadesCantidad = unidadesCantidad;
    }
    public Double getCalorias() {
        return calorias;
    }
    public void setCalorias(Double calorias) {
        this.calorias = calorias;
    }
    public Double getGrasas() {
        return grasas;
    }
    public void setGrasas(Double grasas) {
        this.grasas = grasas;
    }
    public Double getProteinas() {
        return proteinas;
    }
    public void setProteinas(Double proteinas) {
        this.proteinas = proteinas;
    }
    public Double getCarbohidratos() {
        return carbohidratos;
    }
    public void setCarbohidratos(Double carbohidratos) {
        this.carbohidratos = carbohidratos;
    }
    public String getImage() {
        return image;
    }
    public void setImage(String image) {
        this.image = image;
    }
    public String getNombreUsuario() {
        return nombreUsuario;
    }
    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }
    public Receta getReceta() {
        return receta;
    }
    public void setReceta(Receta receta) {
        this.receta = receta;
    }




}




 
