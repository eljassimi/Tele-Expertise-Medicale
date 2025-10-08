package org.medical.teleexpertisemedical.servlet;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.Patient;
import org.medical.teleexpertisemedical.entity.SigneVital;

import java.io.IOException;
import java.time.LocalDate;
import java.util.UUID;

@WebServlet("/infirmier/ajouter-patient")
public class AjouterPatientServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        session.setAttribute("csrfToken", UUID.randomUUID().toString());
        req.getRequestDispatcher("/infirmier/accueil-patient.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String sessionToken = (String) session.getAttribute("csrfToken");
        String formToken = req.getParameter("csrfToken");

        if (sessionToken == null || !sessionToken.equals(formToken)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF Attack Detected");
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            // Récupérer les données personnelles
            String nom = req.getParameter("nom");
            String prenom = req.getParameter("prenom");
            String dateNaissanceStr = req.getParameter("dateNaissance");
            String numeroSecuriteSociale = req.getParameter("numeroSecuriteSociale");
            String telephone = req.getParameter("telephone");
            String adresse = req.getParameter("adresse");
            String mutuelle = req.getParameter("mutuelle");

            // Récupérer les données médicales
            String antecedents = req.getParameter("antecedents");
            String allergies = req.getParameter("allergies");
            String traitementsEnCours = req.getParameter("traitementsEnCours");

            // Créer le patient
            Patient patient = new Patient();
            patient.setNom(nom);
            patient.setPrenom(prenom);
            patient.setDateNaissance(LocalDate.parse(dateNaissanceStr));
            patient.setNumeroSecuriteSociale(numeroSecuriteSociale);
            patient.setTelephone(telephone);
            patient.setAdresse(adresse);
            patient.setMutuelle(mutuelle);
            patient.setAntecedents(antecedents);
            patient.setAllergies(allergies);
            patient.setTraitementsEnCours(traitementsEnCours);
            patient.setEnAttente(true); // Ajouter automatiquement à la file d'attente

            SigneVital signeVital = new SigneVital();

            String tensionArterielle = req.getParameter("tensionArterielle");
            String frequenceCardiaqueStr = req.getParameter("frequenceCardiaque");
            String temperatureStr = req.getParameter("temperature");
            String frequenceRespiratoireStr = req.getParameter("frequenceRespiratoire");
            String poidsStr = req.getParameter("poids");
            String tailleStr = req.getParameter("taille");

            signeVital.setTensionArterielle(tensionArterielle);

            if (frequenceCardiaqueStr != null && !frequenceCardiaqueStr.isEmpty()) {
                signeVital.setFrequenceCardiaque(Integer.parseInt(frequenceCardiaqueStr));
            }

            if (temperatureStr != null && !temperatureStr.isEmpty()) {
                signeVital.setTemperature(Double.parseDouble(temperatureStr));
            }

            if (frequenceRespiratoireStr != null && !frequenceRespiratoireStr.isEmpty()) {
                signeVital.setFrequenceRespiratoire(Integer.parseInt(frequenceRespiratoireStr));
            }

            if (poidsStr != null && !poidsStr.isEmpty()) {
                signeVital.setPoids(Double.parseDouble(poidsStr));
            }

            if (tailleStr != null && !tailleStr.isEmpty()) {
                signeVital.setTaille(Double.parseDouble(tailleStr));
            }

            // Associer le signe vital au patient
            patient.ajouterSigneVital(signeVital);

            // Persister le patient (cascade persistera aussi le signe vital)
            em.persist(patient);

            tx.commit();

            // Redirection avec message de succès
            session.setAttribute("success", "Patient enregistré avec succès et ajouté à la file d'attente");
            resp.sendRedirect(req.getContextPath() + "/infirmier/dashboard-infirmier.jsp");

        } catch (NumberFormatException e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            req.setAttribute("error", "Erreur de format dans les données saisies : " + e.getMessage());
            req.getRequestDispatcher("/infirmier/accueil-patient.jsp").forward(req, resp);

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de l'enregistrement du patient : " + e.getMessage());
            req.getRequestDispatcher("/infirmier/accueil-patient.jsp").forward(req, resp);

        } finally {
            em.close();
        }
    }

    @Override
    public void destroy() {
        if (emf != null) emf.close();
    }
}
