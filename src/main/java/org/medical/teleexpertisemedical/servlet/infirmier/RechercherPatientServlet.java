package org.medical.teleexpertisemedical.servlet.infirmier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.Patient;
import org.medical.teleexpertisemedical.service.PatientService;

import java.io.IOException;

@WebServlet("/infirmier/rechercher-patient")
public class RechercherPatientServlet extends HttpServlet {
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

        String numeroSecuriteSociale = req.getParameter("numeroSecuriteSociale");

        try {
            Patient patient = patientService.findPatientByNumeroSS(numeroSecuriteSociale);

            if (patient != null) {
                req.setAttribute("patientTrouve", patient);
            } else {
                req.setAttribute("error", "Aucun patient trouvé avec ce numéro de sécurité sociale");
            }

            req.getRequestDispatcher("/infirmier/accueil-patient.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de la recherche : " + e.getMessage());
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
