package org.medical.teleexpertisemedical.servlet.generaliste;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.DemandeExpertise;
import org.medical.teleexpertisemedical.entity.User;
import org.medical.teleexpertisemedical.service.DemandeExpertiseService;
import org.medical.teleexpertisemedical.service.UserService;

import java.io.IOException;

@WebServlet("/generaliste/voir-expertise")
public class VoirExpertiseServlet extends HttpServlet {
    private DemandeExpertiseService demandeExpertiseService;
    private UserService userService;

    @Override
    public void init() {
        demandeExpertiseService = new DemandeExpertiseService();
        userService = new UserService();
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
            String demandeIdParam = req.getParameter("demandeId");
            if (demandeIdParam == null || demandeIdParam.isEmpty()) {
                session.setAttribute("error", "ID de demande manquant");
                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
                return;
            }

            Long demandeId = Long.parseLong(demandeIdParam);
            DemandeExpertise demande = demandeExpertiseService.findById(demandeId);

            if (demande == null) {
                session.setAttribute("error", "Demande d expertise introuvable");
                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
                return;
            }

            String username = (String) session.getAttribute("user");
            User generaliste = userService.findByUsername(username);

            req.setAttribute("demande", demande);
            req.setAttribute("generaliste", generaliste);

            req.getRequestDispatcher("/generaliste/voir-expertise.jsp")
                    .forward(req, resp);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de demande invalide");
            resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
        }
    }

    @Override
    public void destroy() {
        if (demandeExpertiseService != null) demandeExpertiseService.close();
        if (userService != null) userService.close();
    }
}