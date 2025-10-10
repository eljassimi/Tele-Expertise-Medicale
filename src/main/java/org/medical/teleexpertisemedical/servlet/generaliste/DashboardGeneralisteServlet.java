package org.medical.teleexpertisemedical.servlet.generaliste;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.Consultation;
import org.medical.teleexpertisemedical.service.ConsultationService;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/generaliste/dashboard-generaliste")
public class DashboardGeneralisteServlet extends HttpServlet {
    private ConsultationService consultationService;

    @Override
    public void init() {
        consultationService = new ConsultationService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"GENERALISTE".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Consultation> consultations = consultationService.findAll();

            long consultationsEnCours = consultations.stream()
                    .filter(c -> "EN_COURS".equals(c.getStatut().name()))
                    .count();

            long consultationsTerminees = consultations.stream()
                    .filter(c -> "TERMINEE".equals(c.getStatut().name()))
                    .count();

            List<Consultation> consultationsEnCoursListe = consultations.stream()
                    .filter(c -> "EN_COURS".equals(c.getStatut().name()))
                    .collect(Collectors.toList());

            req.setAttribute("consultations", consultationsEnCoursListe);
            req.setAttribute("consultationsEnCours", consultationsEnCours);
            req.setAttribute("consultationsTerminees", consultationsTerminees);
            req.setAttribute("totalConsultations", consultations.size());

            req.getRequestDispatcher("/generaliste/dashboard-generaliste.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur lors du chargement du dashboard : " + e.getMessage());
        }
    }

    @Override
    public void destroy() {
        if (consultationService != null) {
            consultationService.close();
        }
    }
}
