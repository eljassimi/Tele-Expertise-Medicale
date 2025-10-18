package org.medical.teleexpertisemedical.servlet.specialiste;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.User;
import org.medical.teleexpertisemedical.service.CreneauService;
import org.medical.teleexpertisemedical.service.UserService;

import java.io.IOException;

@WebServlet("/specialiste/generer-creneaux")
public class GenererCreneauxServlet extends HttpServlet {
    private CreneauService creneauService;
    private UserService userService;

    @Override
    public void init() {
        creneauService = new CreneauService();
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
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
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            int creneauxCount = creneauService.generateCreneauxForSpecialist(specialiste);

            session.setAttribute("success",
                    "✓ " + creneauxCount + " nouveaux créneaux ont été générés avec succès pour les 7 prochains jours !");

            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de la génération des créneaux : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        }
    }

    @Override
    public void destroy() {
        if (creneauService != null) creneauService.close();
        if (userService != null) userService.close();
    }
}
