package org.medical.teleexpertisemedical.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "demandes_expertise")
public class DemandeExpertise {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "consultation_id", nullable = false)
    private Consultation consultation;

    @ManyToOne
    @JoinColumn(name = "specialiste_id", nullable = false)
    private User specialiste; // Référence vers User avec role=SPECIALISTE

    @ManyToOne
    @JoinColumn(name = "creneau_id")
    private Creneau creneau;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String question;

    @Column(name = "donnees_analyses", columnDefinition = "TEXT")
    private String donneesAnalyses;

    @Column(nullable = false)
    private String priorite; // URGENTE, NORMALE, NON_URGENTE

    @Column(nullable = false)
    private String statut = "EN_ATTENTE"; // EN_ATTENTE, TERMINEE

    @Column(name = "date_demande", nullable = false)
    private LocalDateTime dateDemande;

    @Column(name = "avis_medical", columnDefinition = "TEXT")
    private String avisMedical;

    @Column(columnDefinition = "TEXT")
    private String recommandations;

    @Column(name = "date_reponse")
    private LocalDateTime dateReponse;

    @Column(name = "mode_reponse")
    private String modeReponse; // "ECRITE" ou "TELEPHONIQUE"

    // Getters et Setters
    public String getModeReponse() {
        return modeReponse;
    }

    public void setModeReponse(String modeReponse) {
        this.modeReponse = modeReponse;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Consultation getConsultation() { return consultation; }
    public void setConsultation(Consultation consultation) { this.consultation = consultation; }

    public User getSpecialiste() { return specialiste; }
    public void setSpecialiste(User specialiste) { this.specialiste = specialiste; }

    public Creneau getCreneau() { return creneau; }
    public void setCreneau(Creneau creneau) { this.creneau = creneau; }

    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }

    public String getDonneesAnalyses() { return donneesAnalyses; }
    public void setDonneesAnalyses(String donneesAnalyses) { this.donneesAnalyses = donneesAnalyses; }

    public String getPriorite() { return priorite; }
    public void setPriorite(String priorite) { this.priorite = priorite; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public LocalDateTime getDateDemande() { return dateDemande; }
    public void setDateDemande(LocalDateTime dateDemande) { this.dateDemande = dateDemande; }

    public String getAvisMedical() { return avisMedical; }
    public void setAvisMedical(String avisMedical) { this.avisMedical = avisMedical; }

    public String getRecommandations() { return recommandations; }
    public void setRecommandations(String recommandations) { this.recommandations = recommandations; }

    public LocalDateTime getDateReponse() { return dateReponse; }
    public void setDateReponse(LocalDateTime dateReponse) { this.dateReponse = dateReponse; }
}
