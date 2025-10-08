package org.medical.teleexpertisemedical.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "signes_vitaux")
public class SigneVital {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "tension_arterielle", length = 20)
    private String tensionArterielle;

    @Column(name = "frequence_cardiaque")
    private Integer frequenceCardiaque;

    @Column(name = "temperature")
    private Double temperature;

    @Column(name = "frequence_respiratoire")
    private Integer frequenceRespiratoire;

    @Column(name = "poids")
    private Double poids;

    @Column(name = "taille")
    private Double taille;

    @Column(name = "date_mesure", nullable = false)
    private LocalDateTime dateMesure;

    @PrePersist
    protected void onCreate() {
        dateMesure = LocalDateTime.now();
    }

    public SigneVital() {}

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public String getTensionArterielle() {
        return tensionArterielle;
    }

    public void setTensionArterielle(String tensionArterielle) {
        this.tensionArterielle = tensionArterielle;
    }

    public Integer getFrequenceCardiaque() {
        return frequenceCardiaque;
    }

    public void setFrequenceCardiaque(Integer frequenceCardiaque) {
        this.frequenceCardiaque = frequenceCardiaque;
    }

    public Double getTemperature() {
        return temperature;
    }

    public void setTemperature(Double temperature) {
        this.temperature = temperature;
    }

    public Integer getFrequenceRespiratoire() {
        return frequenceRespiratoire;
    }

    public void setFrequenceRespiratoire(Integer frequenceRespiratoire) {
        this.frequenceRespiratoire = frequenceRespiratoire;
    }

    public Double getPoids() {
        return poids;
    }

    public void setPoids(Double poids) {
        this.poids = poids;
    }

    public Double getTaille() {
        return taille;
    }

    public void setTaille(Double taille) {
        this.taille = taille;
    }

    public LocalDateTime getDateMesure() {
        return dateMesure;
    }

    public void setDateMesure(LocalDateTime dateMesure) {
        this.dateMesure = dateMesure;
    }
}
