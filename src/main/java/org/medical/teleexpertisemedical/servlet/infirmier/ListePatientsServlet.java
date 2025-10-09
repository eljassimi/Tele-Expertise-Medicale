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
import java.util.List;

@WebServlet("/infirmier/liste-patients")
public class ListePatientsServlet extends HttpServlet {
    private PatientService patientService;

    @Override
    public void init() {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"INFIRMIER".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Patient> patients = patientService.findAll();

            String statutParam = req.getParameter("statut");
            if (statutParam != null && !statutParam.isEmpty()) {
                if ("EN_ATTENTE".equals(statutParam)) {
                    patients = patients.stream()
                            .filter(p -> Boolean.TRUE.equals(p.getEnAttente()))
                            .collect(java.util.stream.Collectors.toList());
                } else if ("CONSULTE".equals(statutParam)) {
                    patients = patients.stream()
                            .filter(p -> !Boolean.TRUE.equals(p.getEnAttente()))
                            .collect(java.util.stream.Collectors.toList());
                }
            }

            req.setAttribute("patients", patients);
            req.getRequestDispatcher("/infirmier/liste-patients.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur lors du chargement de la liste");
        }
    }

    @Override
    public void destroy() {
        if (patientService != null) {
            patientService.close();
        }
    }
}