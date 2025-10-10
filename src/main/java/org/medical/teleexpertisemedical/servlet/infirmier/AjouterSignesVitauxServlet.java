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
import java.time.LocalDateTime;

@WebServlet("/infirmier/ajouter-signes-vitaux")
public class AjouterSignesVitauxServlet extends HttpServlet {
    private PatientService patientService;

    @Override
    public void init() {
        patientService = new PatientService();
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

        String patientIdStr = req.getParameter("patientId");
        if (patientIdStr == null || patientIdStr.isEmpty()) {
            req.setAttribute("error", "ID du patient manquant");
            req.getRequestDispatcher("/infirmier/accueil-patient.jsp")
                    .forward(req, resp);
            return;
        }

        Long patientId = Long.parseLong(patientIdStr);

        try {
            Patient patient = patientService.findPatientById(patientId);

            if (patient == null) {
                req.setAttribute("error", "Patient introuvable");
                req.getRequestDispatcher("/infirmier/accueil-patient.jsp")
                        .forward(req, resp);
                return;
            }

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

            patient.ajouterSigneVital(signeVital);
            patient.setEnAttente(true);
            patient.setDateEnregistrement(LocalDateTime.now());

            patientService.updatePatient(patient);

            session.setAttribute("success", "Signes vitaux enregistrés. Patient ajouté à la file d'attente");
            resp.sendRedirect(req.getContextPath() + "/infirmier/dashboard-infirmier");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur de format dans les données saisies");
            req.getRequestDispatcher("/infirmier/accueil-patient.jsp")
                    .forward(req, resp);

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
