package org.medical.teleexpertisemedical.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "consultations")
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medecin_generaliste_id", nullable = false)
    private User medecinGeneraliste;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String motif;

    @Column(columnDefinition = "TEXT")
    private String observations;

    @Column(columnDefinition = "TEXT")
    private String diagnostic;

    @Column(columnDefinition = "TEXT")
    private String traitement;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private StatutConsultation statut = StatutConsultation.EN_COURS;

    @Column(name = "cout_consultation", nullable = false)
    private Double coutConsultation = 150.0;

    @Column(name = "cout_actes_techniques")
    private Double coutActesTechniques = 0.0;

    @Column(name = "cout_total")
    private Double coutTotal;

    @Column(name = "date_consultation", nullable = false)
    private LocalDateTime dateConsultation;

    @Column(name = "date_cloture")
    private LocalDateTime dateCloture;

    @ElementCollection
    @CollectionTable(name = "consultation_actes", joinColumns = @JoinColumn(name = "consultation_id"))
    @Enumerated(EnumType.STRING)
    @Column(name = "acte_technique")
    private List<ActeTechnique> actesTechniques = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        dateConsultation = LocalDateTime.now();
        calculerCoutTotal();
    }

    @PreUpdate
    protected void onUpdate() {
        calculerCoutTotal();
    }

    public void calculerCoutTotal() {
        this.coutTotal = this.coutConsultation +
                (this.coutActesTechniques != null ? this.coutActesTechniques : 0.0);
    }

    public void calculerCoutActesTechniques() {
        if (actesTechniques != null && !actesTechniques.isEmpty()) {
            this.coutActesTechniques = actesTechniques.stream()
                    .mapToDouble(ActeTechnique::getCout)
                    .sum();
        } else {
            this.coutActesTechniques = 0.0;
        }
        calculerCoutTotal();
    }

    public void ajouterActeTechnique(ActeTechnique acte) {
        if (this.actesTechniques == null) {
            this.actesTechniques = new ArrayList<>();
        }
        this.actesTechniques.add(acte);
        calculerCoutActesTechniques();
    }

    public void cloturer() {
        this.statut = StatutConsultation.TERMINEE;
        this.dateCloture = LocalDateTime.now();
    }

    public Consultation() {}

    public Consultation(Patient patient, User medecinGeneraliste, String motif) {
        this.patient = patient;
        this.medecinGeneraliste = medecinGeneraliste;
        this.motif = motif;
    }

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

    public User getMedecinGeneraliste() {
        return medecinGeneraliste;
    }

    public void setMedecinGeneraliste(User medecinGeneraliste) {
        this.medecinGeneraliste = medecinGeneraliste;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public String getObservations() {
        return observations;
    }

    public void setObservations(String observations) {
        this.observations = observations;
    }

    public String getDiagnostic() {
        return diagnostic;
    }

    public void setDiagnostic(String diagnostic) {
        this.diagnostic = diagnostic;
    }

    public String getTraitement() {
        return traitement;
    }

    public void setTraitement(String traitement) {
        this.traitement = traitement;
    }

    public StatutConsultation getStatut() {
        return statut;
    }

    public void setStatut(StatutConsultation statut) {
        this.statut = statut;
    }

    public Double getCoutConsultation() {
        return coutConsultation;
    }

    public void setCoutConsultation(Double coutConsultation) {
        this.coutConsultation = coutConsultation;
    }

    public Double getCoutActesTechniques() {
        return coutActesTechniques;
    }

    public void setCoutActesTechniques(Double coutActesTechniques) {
        this.coutActesTechniques = coutActesTechniques;
    }

    public Double getCoutTotal() {
        return coutTotal;
    }

    public void setCoutTotal(Double coutTotal) {
        this.coutTotal = coutTotal;
    }

    public LocalDateTime getDateConsultation() {
        return dateConsultation;
    }

    public void setDateConsultation(LocalDateTime dateConsultation) {
        this.dateConsultation = dateConsultation;
    }

    public LocalDateTime getDateCloture() {
        return dateCloture;
    }

    public void setDateCloture(LocalDateTime dateCloture) {
        this.dateCloture = dateCloture;
    }

    public List<ActeTechnique> getActesTechniques() {
        return actesTechniques;
    }

    public void setActesTechniques(List<ActeTechnique> actesTechniques) {
        this.actesTechniques = actesTechniques;
    }
}
