package org.medical.teleexpertisemedical.entity;

public enum ActeTechnique {
    RADIOGRAPHIE("Radiographie", 200.0),
    ECHOGRAPHIE("Échographie", 300.0),
    IRM("IRM", 800.0),
    ELECTROCARDIOGRAMME("Électrocardiogramme", 150.0),
    DERMATOLOGIQUE_LASER("Laser dermatologique", 400.0),
    FOND_OEIL("Fond d'œil", 180.0),
    ANALYSE_SANG("Analyse de sang", 120.0),
    ANALYSE_URINE("Analyse d'urine", 80.0);

    private final String libelle;
    private final Double cout;

    ActeTechnique(String libelle, Double cout) {
        this.libelle = libelle;
        this.cout = cout;
    }

    public String getLibelle() {
        return libelle;
    }

    public Double getCout() {
        return cout;
    }
}
