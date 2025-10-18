# 🏥 Système de Télé-Expertise Médicale

## 📘 Description du Projet
Le **Système de Télé-Expertise Médicale** est une application web développée en **Java (Jakarta EE)** permettant de faciliter la collaboration entre **médecins généralistes** et **spécialistes**.  
Elle vise à améliorer la **prise en charge des patients** et à **optimiser le parcours de soins** grâce à la coordination médicale à distance.

---

## 🧩 Objectifs
- Permettre aux **infirmiers** d’enregistrer et gérer les patients.
- Permettre aux **médecins généralistes** de créer des consultations et demander des avis spécialisés.
- Permettre aux **spécialistes** de gérer leurs disponibilités et répondre aux demandes d’expertise.
- Offrir une **communication synchrone ou asynchrone** entre médecins.

---

## ⚙️ Technologies Utilisées
- **Langage :** Java
- **Frameworks :** Jakarta EE (Servlet, JSP, JSTL)
- **ORM :** Hibernate / JPA
- **Serveur :** Apache Tomcat
- **Build Tool :** Maven
- **Sécurité :** Bcrypt (hachage des mots de passe), CSRF protection
- **Tests :** JUnit / Mockito
- **Base de données :** MySQL (ou autre SGBD compatible JPA)

---

## 👥 Rôles Utilisateurs
1. **Infirmier :**
    - Enregistrement et suivi des patients
    - Ajout des signes vitaux
    - Gestion de la file d’attente

2. **Médecin Généraliste :**
    - Création et gestion des consultations
    - Demande d’avis à un spécialiste
    - Calcul du coût total (consultation + expertise + actes médicaux)

3. **Médecin Spécialiste :**
    - Configuration du profil (spécialité, tarif, créneaux horaires)
    - Consultation et réponse aux demandes d’expertise

4. **(Optionnel)** Administrateur :
    - Gestion du personnel médical (création, modification, suppression)

---

## 🧠 Fonctionnalités Clés
- Authentification par rôles (sessions stateful)
- Gestion des patients et consultations
- Télé-expertise (synchrone et asynchrone)
- Gestion des créneaux horaires pour les spécialistes
- Calcul du coût total via les **Streams API** et **Lambdas**
- Filtrage et tri (patients, spécialistes, consultations)
- Notifications entre médecins

---

---

## 🧾 Diagramme de Classe

````mermaid
classDiagram
    class User {
        - Long id
        - String username
        - String password
        - String role
        - String nom
        - String prenom
        - String telephone
        - String email
        - Double tarif
        - Boolean disponible
        + login()
        + logout()
    }

    class Infirmier {
        + accueillerPatient(Patient p)
        + enregistrerSignesVitaux(Patient p)
        + affecterPatientAuGeneraliste(Patient p, User generaliste)
    }

    class MedecinGeneraliste {
        - Double tarifConsultation
        + creerConsultation(Patient p, String type)
        + consulterPatient(Patient p)
        + demanderExpertise(Consultation c, Specialiste s)
        + cloturerConsultation(Consultation c)
        + voirReponsesExpertises()
    }

    class MedecinSpecialiste {
        - Double tarifExpertise
        + voirDemandesExpertise()
        + repondreExpertise(DemandeExpertise d, String mode)
        + gererCreneaux()
    }

    class Patient {
        - Long id
        - String nom
        - String prenom
        - LocalDate dateNaissance
        - String numeroSecuriteSociale
        - String telephone
        - String adresse
        - Boolean enAttente
        - LocalDateTime dateEnregistrement
    }

    class SignesVitaux {
        - Long id
        - Double tensionArterielle
        - Integer frequenceCardiaque
        - Double temperature
        - Integer frequenceRespiratoire
        - Double poids
        - LocalDateTime dateEnregistrement
    }

    class Consultation {
        - Long id
        - LocalDateTime dateConsultation
        - String motif
        - String observations
        - String diagnostic
        - String traitement
        - String typeConsultation
        - Double coutConsultation
        - String statut
    }

    class Specialite {
        - Long id
        - String nom
        - String description
    }

    class Creneau {
        - Long id
        - LocalDateTime dateHeure
        - Boolean disponible
        - Integer dureeMinutes
    }

    class DemandeExpertise {
        - Long id
        - LocalDateTime dateDemande
        - String question
        - String donneesAnalyses
        - String priorite
        - String statut
        - String modeReponse
        - String avisMedical
        - String recommandations
        - LocalDateTime dateReponse
    }

    class ActeTechnique {
        - Long id
        - String nom
        - String description
        - Double cout
    }

    %% Héritage
    User <|-- Infirmier : extends
    User <|-- MedecinGeneraliste : extends
    User <|-- MedecinSpecialiste : extends

    %% Relations Patient
    Infirmier "1" --> "0..*" Patient : enregistre >
    Patient "1" --> "0..*" SignesVitaux : possède >
    Patient "1" --> "0..1" User : affecté_à >
    Patient "1" --> "0..*" Consultation : concerné_par >

    %% Relations Consultation
    MedecinGeneraliste "1" --> "0..*" Consultation : effectue >
    Consultation "1" --> "0..*" ActeTechnique : comprend >
    Consultation "0..1" --> "0..*" DemandeExpertise : peut_demander >

    %% Relations Expertise
    DemandeExpertise "1" --> "1" MedecinSpecialiste : assignée_à >
    DemandeExpertise "0..1" --> "0..1" Creneau : réservé_pour >

    %% Relations Spécialiste
    MedecinSpecialiste "1" --> "1" Specialite : a_pour_spécialité >
    MedecinSpecialiste "1" --> "0..*" Creneau : gère >
    MedecinSpecialiste "1" --> "0..*" DemandeExpertise : répond_à >

    %% Annotations
    note for User "Table: users\nRôles: INFIRMIER, GENERALISTE, SPECIALISTE"
    note for Consultation "Types: ECRITE, TELEPHONIQUE"
    note for DemandeExpertise "Statuts: EN_ATTENTE, TERMINEE\nPriorités: URGENTE, NORMALE, NON_URGENTE\nModes: ECRITE, TELEPHONIQUE"

````
---

## 🧪 Tests Unitaires
- Frameworks : **JUnit 5** et **Mockito**
- Tests réalisés :
    - DAO (CRUD des entités)
    - Services (logique métier)
    - Servlets (contrôleurs HTTP)

---

## 🚀 Lancement du Projet
1. Importer le projet dans **IntelliJ IDEA** ou **Eclipse**
2. Vérifier les dépendances dans le fichier `pom.xml`
3. Configurer la base de données dans `persistence.xml`
4. Déployer sur **Apache Tomcat**
5. Accéder à l’application via :   http://localhost:8080/Tele-Expertise-Medical/
