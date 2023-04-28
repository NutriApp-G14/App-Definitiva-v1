package com.demo.nutri.model;

import java.net.URI;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Alergias {
    @Id
    private String nombreUsuario;
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
        Alergias other = (Alergias) obj;
        if (nombreUsuario == null) {
            if (other.nombreUsuario != null)
                return false;
        } else if (!nombreUsuario.equals(other.nombreUsuario))
            return false;
        return true;
    }
    private Boolean cacahuetes;
    private Boolean leche;
    private Boolean huevo;
    private Boolean trigo;
    private Boolean soja;
    private Boolean mariscos;
    private Boolean frutosSecos;
    private Boolean pescado;
    
    public String getNombreUsuario() {
        return nombreUsuario;
    }
    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }
    public Boolean getCacahuetes() {
        return cacahuetes;
    }
    public void setCacahuetes(Boolean cacahuetes) {
        this.cacahuetes = cacahuetes;
    }
    public Boolean getLeche() {
        return leche;
    }
    public void setLeche(Boolean leche) {
        this.leche = leche;
    }
    public Boolean getHuevo() {
        return huevo;
    }
    public void setHuevo(Boolean huevo) {
        this.huevo = huevo;
    }
    public Boolean getTrigo() {
        return trigo;
    }
    public void setTrigo(Boolean trigo) {
        this.trigo = trigo;
    }
    public Boolean getSoja() {
        return soja;
    }
    public void setSoja(Boolean soja) {
        this.soja = soja;
    }
    public Boolean getMariscos() {
        return mariscos;
    }
    public void setMariscos(Boolean mariscos) {
        this.mariscos = mariscos;
    }
    public Boolean getFrutosSecos() {
        return frutosSecos;
    }
    public void setFrutosSecos(Boolean frutosSecos) {
        this.frutosSecos = frutosSecos;
    }
    public Boolean getPescado() {
        return pescado;
    }
    public void setPescado(Boolean pescado) {
        this.pescado = pescado;
    }
    
}



