package com.demo.nutri.model;

import java.net.URI;
import java.util.List;

import javax.persistence.*;

@Entity
public class Receta {
    @Id
    @GeneratedValue
    private Integer id;
    private String nombre;
    private Integer porciones;
    private String unidadesMedida;
    private String descripcion; 
    @OneToMany(cascade = CascadeType.ALL)
    private List<Alimento> ingredientes; 
    @ElementCollection
    private List<String> pasos;
    private String imagen;
    private String nombreUsuario;
        public Integer getId() {
            return id;
        }
        public void setId(Integer id) {
            this.id = id;
        }
        public String getNombre() {
            return nombre;
        }
        public void setNombre(String nombre) {
            this.nombre = nombre;
        }
        public Integer getPorciones() {
            return porciones;
        }
        public void setPorciones(Integer porciones) {
            this.porciones = porciones;
        }
        public String getUnidadesMedida() {
            return unidadesMedida;
        }
        public void setUnidadesMedida(String unidadesMedida) {
            this.unidadesMedida = unidadesMedida;
        }
        public String getDescripcion() {
            return descripcion;
        }
        public void setDescripcion(String descripcion) {
            this.descripcion = descripcion;
        }
        public List<Alimento> getIngredientes() {
            return ingredientes;
        }
        public void setIngredientes(List<Alimento> ingredientes) {
            this.ingredientes = ingredientes;
        }
        public List<String> getPasos() {
            return pasos;
        }
        public void setPasos(List<String> pasos) {
            this.pasos = pasos;
        }
        public String getImagen() {
            return imagen;
        }
        public void setImagen(String imagen) {
            this.imagen = imagen;
        }
        public String getNombreUsuario() {
            return nombreUsuario;
        }
        public void setNombreUsuario(String nombreUsuario) {
            this.nombreUsuario = nombreUsuario;
        }
    
        
}
