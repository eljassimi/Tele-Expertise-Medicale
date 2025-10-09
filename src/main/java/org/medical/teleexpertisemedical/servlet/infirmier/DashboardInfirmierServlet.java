package org.medical.teleexpertisemedical.servlet.infirmier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.Patient;
import org.medical.teleexpertisemedical.service.PatientService;
import org.medical.teleexpertisemedical.service.PatientService.PatientStatistics;

import java.io.IOException;
import java.util.List;

@WebServlet("/infirmier/dashboard-infirmier")
public class DashboardInfirmierServlet extends HttpServlet {
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
            PatientStatistics stats = patientService.getStatisticsForToday();

            List<Patient> patientsRecents = patientService.getRecentPatients(10);

            req.setAttribute("patientsCount", stats.getTotal());
            req.setAttribute("enAttenteCount", stats.getEnAttente());
            req.setAttribute("consultesCount", stats.getConsultes());
            req.setAttribute("patients", patientsRecents);

            req.getRequestDispatcher("/infirmier/dashboard-infirmier.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur lors du chargement du dashboard : " + e.getMessage());
        }
    }

    @Override
    public void destroy() {
        if (patientService != null) {
            patientService.close();
        }
    }
}
