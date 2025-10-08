package org.medical.teleexpertisemedical.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "patients")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false, length = 100)
    private String prenom;

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;

    @Column(name = "numero_securite_sociale", unique = true, nullable = false, length = 15)
    private String numeroSecuriteSociale;

    @Column(length = 20)
    private String telephone;

    @Column(length = 255)
    private String adresse;

    @Column(length = 100)
    private String mutuelle;

    @Column(columnDefinition = "TEXT")
    private String antecedents;

    @Column(columnDefinition = "TEXT")
    private String allergies;

    @Column(name = "traitements_en_cours", columnDefinition = "TEXT")
    private String traitementsEnCours;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SigneVital> signesVitaux = new ArrayList<>();


    @Column(name = "date_enregistrement", nullable = false)
    private LocalDateTime dateEnregistrement;

    @Column(name = "en_attente")
    private Boolean enAttente = false;

    @PrePersist
    protected void onCreate() {
        dateEnregistrement = LocalDateTime.now();
    }

    public Patient() {}

    public Patient(String nom, String prenom, LocalDate dateNaissance, String numeroSecuriteSociale) {
        this.nom = nom;
        this.prenom = prenom;
        this.dateNaissance = dateNaissance;
        this.numeroSecuriteSociale = numeroSecuriteSociale;
    }

    public void ajouterSigneVital(SigneVital signeVital) {
        signesVitaux.add(signeVital);
        signeVital.setPatient(this);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public LocalDate getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(LocalDate dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public String getNumeroSecuriteSociale() {
        return numeroSecuriteSociale;
    }

    public void setNumeroSecuriteSociale(String numeroSecuriteSociale) {
        this.numeroSecuriteSociale = numeroSecuriteSociale;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getMutuelle() {
        return mutuelle;
    }

    public void setMutuelle(String mutuelle) {
        this.mutuelle = mutuelle;
    }

    public String getAntecedents() {
        return antecedents;
    }

    public void setAntecedents(String antecedents) {
        this.antecedents = antecedents;
    }

    public String getAllergies() {
        return allergies;
    }

    public void setAllergies(String allergies) {
        this.allergies = allergies;
    }

    public String getTraitementsEnCours() {
        return traitementsEnCours;
    }

    public void setTraitementsEnCours(String traitementsEnCours) {
        this.traitementsEnCours = traitementsEnCours;
    }

    public List<SigneVital> getSignesVitaux() {
        return signesVitaux;
    }

    public void setSignesVitaux(List<SigneVital> signesVitaux) {
        this.signesVitaux = signesVitaux;
    }

    public LocalDateTime getDateEnregistrement() {
        return dateEnregistrement;
    }

    public void setDateEnregistrement(LocalDateTime dateEnregistrement) {
        this.dateEnregistrement = dateEnregistrement;
    }

    public Boolean getEnAttente() {
        return enAttente;
    }

    public void setEnAttente(Boolean enAttente) {
        this.enAttente = enAttente;
    }
}
