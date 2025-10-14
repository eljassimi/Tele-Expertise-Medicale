package org.medical.teleexpertisemedical.servlet.specialiste;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.DemandeExpertise;
import org.medical.teleexpertisemedical.entity.User;
import org.medical.teleexpertisemedical.service.CreneauService;
import org.medical.teleexpertisemedical.service.DemandeExpertiseService;
import org.medical.teleexpertisemedical.service.UserService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/specialiste/dashboard-specialiste")
public class DashboardSpecialisteServlet extends HttpServlet {
    private UserService userService;
    private DemandeExpertiseService demandeExpertiseService;
    private CreneauService creneauService;

    @Override
    public void init() {
        userService = new UserService();
        demandeExpertiseService = new DemandeExpertiseService();
        creneauService = new CreneauService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"SPECIALISTE".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String username = (String) session.getAttribute("user");
            User specialiste = userService.findByUsername(username);

            if (specialiste == null) {
                session.setAttribute("error", "Utilisateur introuvable");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            List<DemandeExpertise> allDemandes = demandeExpertiseService.findBySpecialisteId(specialiste.getId());

            String filter = req.getParameter("filter");
            List<DemandeExpertise> demandes;

            if ("EN_ATTENTE".equals(filter)) {
                demandes = allDemandes.stream()
                        .filter(d -> "EN_ATTENTE".equals(d.getStatut()))
                        .sorted((d1, d2) -> {
                            int priority1 = getPriorityOrder(d1.getPriorite());
                            int priority2 = getPriorityOrder(d2.getPriorite());
                            return Integer.compare(priority1, priority2);
                        })
                        .collect(Collectors.toList());
            } else if ("TERMINEE".equals(filter)) {
                demandes = allDemandes.stream()
                        .filter(d -> "TERMINEE".equals(d.getStatut()))
                        .collect(Collectors.toList());
            } else {
                demandes = allDemandes;
            }

            long enAttenteCount = allDemandes.stream()
                    .filter(d -> "EN_ATTENTE".equals(d.getStatut()))
                    .count();

            long termineesCount = allDemandes.stream()
                    .filter(d -> "TERMINEE".equals(d.getStatut()))
                    .count();

            long creneauxLibres = creneauService.findBySpecialisteId(specialiste.getId())
                    .stream()
                    .filter(c -> c.getDisponible() && c.getDateHeure().isAfter(LocalDateTime.now()))
                    .count();

            req.setAttribute("specialiste", specialiste);
            req.setAttribute("demandes", demandes);
            req.setAttribute("totalDemandes", allDemandes.size());
            req.setAttribute("enAttenteCount", enAttenteCount);
            req.setAttribute("termineesCount", termineesCount);
            req.setAttribute("creneauxLibres", creneauxLibres);

            req.getRequestDispatcher("/specialiste/dashboard-specialiste.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        }
    }

    private int getPriorityOrder(String priorite) {
        switch (priorite) {
            case "URGENTE": return 1;
            case "NORMALE": return 2;
            case "NON_URGENTE": return 3;
            default: return 4;
        }
    }

    @Override
    public void destroy() {
        if (userService != null) userService.close();
        if (demandeExpertiseService != null) demandeExpertiseService.close();
        if (creneauService != null) creneauService.close();
    }
}
