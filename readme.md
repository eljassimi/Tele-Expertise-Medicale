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
    }

    class Infirmier {
        + enregistrerPatient()
        + affecterAuGeneraliste()
    }

    class MedecinGeneraliste {
        - Double tarifConsultation
        + creerConsultation()
        + demanderExpertise()
    }

    class MedecinSpecialiste {
        - Double tarifExpertise
        + repondreExpertise()
        + gererCreneaux()
    }

    class Patient {
        - Long id
        - String nom
        - String prenom
        - LocalDate dateNaissance
        - String numeroSecuriteSociale
        - Boolean enAttente
    }

    class SignesVitaux {
        - Long id
        - Double tensionArterielle
        - Integer frequenceCardiaque
        - Double temperature
        - LocalDateTime dateEnregistrement
    }

    class Consultation {
        - Long id
        - LocalDateTime dateConsultation
        - String motif
        - String observations
        - String diagnostic
        - String typeConsultation
        - String statut
    }

    class Specialite {
        - Long id
        - String nom
    }

    class Creneau {
        - Long id
        - LocalDateTime dateHeure
        - Boolean disponible
    }

    class DemandeExpertise {
        - Long id
        - String question
        - String priorite
        - String statut
        - String modeReponse
        - String avisMedical
        - LocalDateTime dateReponse
    }

    class ActeTechnique {
        - Long id
        - String nom
        - Double cout
    }

    %% Héritage
    User <|-- Infirmier
    User <|-- MedecinGeneraliste
    User <|-- MedecinSpecialiste

    %% Relations principales
    Infirmier --> Patient : enregistre
    Patient --> SignesVitaux : possède
    MedecinGeneraliste --> Consultation : effectue
    Patient --> Consultation : concerné_par
    Consultation --> ActeTechnique : comprend
    Consultation --> DemandeExpertise : génère
    DemandeExpertise --> MedecinSpecialiste : assignée_à
    DemandeExpertise --> Creneau : planifiée_sur
    MedecinSpecialiste --> Specialite : a_pour_spécialité
    MedecinSpecialiste --> Creneau : gère


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
