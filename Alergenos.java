
package com.demo.nutri.model;



import javax.persistence.Entity;
import javax.persistence.Id;


@Entity
public class Alergenos {
 
    @Id
    private String name;
    private Boolean cacahuetes;
    private Boolean leche;
    private Boolean huevo;
    private Boolean trigo;
    private Boolean soja;
    private Boolean mariscos;
    private Boolean frutosSecos;
    private Boolean pescado;
    
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
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
