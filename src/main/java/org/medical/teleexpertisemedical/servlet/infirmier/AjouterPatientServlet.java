package org.medical.teleexpertisemedical.servlet.infirmier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.Patient;
import org.medical.teleexpertisemedical.entity.SigneVital;
import org.medical.teleexpertisemedical.service.PatientService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.UUID;

@WebServlet("/infirmier/ajouter-patient")
public class AjouterPatientServlet extends HttpServlet {
    private PatientService patientService;

    @Override
    public void init() {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        session.setAttribute("csrfToken", UUID.randomUUID().toString());
        req.getRequestDispatcher("/infirmier/accueil-patient.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Validation CSRF
        HttpSession session = req.getSession();
        String sessionToken = (String) session.getAttribute("csrfToken");
        String formToken = req.getParameter("csrfToken");

        if (sessionToken == null || !sessionToken.equals(formToken)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF Attack Detected");
            return;
        }

        try {
            Patient patient = new Patient();
            patient.setNom(req.getParameter("nom"));
            patient.setPrenom(req.getParameter("prenom"));
            patient.setDateNaissance(LocalDate.parse(req.getParameter("dateNaissance")));
            patient.setNumeroSecuriteSociale(req.getParameter("numeroSecuriteSociale"));
            patient.setTelephone(req.getParameter("telephone"));
            patient.setAdresse(req.getParameter("adresse"));
            patient.setMutuelle(req.getParameter("mutuelle"));
            patient.setAntecedents(req.getParameter("antecedents"));
            patient.setAllergies(req.getParameter("allergies"));
            patient.setTraitementsEnCours(req.getParameter("traitementsEnCours"));
            patient.setEnAttente(true);


            SigneVital signeVital = new SigneVital();
            signeVital.setTensionArterielle(req.getParameter("tensionArterielle"));

            String fcStr = req.getParameter("frequenceCardiaque");
            if (fcStr != null && !fcStr.isEmpty()) {
                signeVital.setFrequenceCardiaque(Integer.parseInt(fcStr));
            }

            String tempStr = req.getParameter("temperature");
            if (tempStr != null && !tempStr.isEmpty()) {
                signeVital.setTemperature(Double.parseDouble(tempStr));
            }

            String frStr = req.getParameter("frequenceRespiratoire");
            if (frStr != null && !frStr.isEmpty()) {
                signeVital.setFrequenceRespiratoire(Integer.parseInt(frStr));
            }

            String poidsStr = req.getParameter("poids");
            if (poidsStr != null && !poidsStr.isEmpty()) {
                signeVital.setPoids(Double.parseDouble(poidsStr));
            }

            String tailleStr = req.getParameter("taille");
            if (tailleStr != null && !tailleStr.isEmpty()) {
                signeVital.setTaille(Double.parseDouble(tailleStr));
            }

            patient.ajouterSigneVital(signeVital);

            patientService.savePatient(patient);

            session.setAttribute("success", "Patient enregistré avec succès et ajouté à la file d'attente");
            resp.sendRedirect(req.getContextPath() + "/infirmier/dashboard-infirmier");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            req.getRequestDispatcher("/infirmier/accueil-patient.jsp")
                    .forward(req, resp);
        }
    }

    @Override
    public void destroy() {
        if (patientService != null) {
            patientService.close();
        }
    }
}
