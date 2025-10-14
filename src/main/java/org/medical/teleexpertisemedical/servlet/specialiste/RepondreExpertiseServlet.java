package org.medical.teleexpertisemedical.servlet.specialiste;

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
import java.time.LocalDateTime;

@WebServlet("/specialiste/repondre-expertise")
public class RepondreExpertiseServlet extends HttpServlet {
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
                !"SPECIALISTE".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String demandeIdParam = req.getParameter("demandeId");
            if (demandeIdParam == null || demandeIdParam.isEmpty()) {
                session.setAttribute("error", "ID de demande manquant");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            Long demandeId = Long.parseLong(demandeIdParam);
            DemandeExpertise demande = demandeExpertiseService.findById(demandeId);

            if (demande == null) {
                session.setAttribute("error", "Demande dexpertise introuvable");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            String username = (String) session.getAttribute("user");
            User specialiste = userService.findByUsername(username);


            if (!"EN_ATTENTE".equals(demande.getStatut())) {
                session.setAttribute("error", "Cette demande a deja ete traite");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            req.setAttribute("demande", demande);
            req.setAttribute("specialiste", specialiste);

            req.getRequestDispatcher("/specialiste/repondre-expertise.jsp")
                    .forward(req, resp);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de demande invalide");
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        }
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
            Long demandeId = Long.parseLong(req.getParameter("demandeId"));
            String avisMedical = req.getParameter("avisMedical");
            String recommandations = req.getParameter("recommandations");

            if (avisMedical == null || avisMedical.trim().isEmpty()) {
                session.setAttribute("error", "L'avis medical est obligatoire");
                resp.sendRedirect(req.getContextPath() +
                        "/specialiste/repondre-expertise?demandeId=" + demandeId);
                return;
            }

            DemandeExpertise demande = demandeExpertiseService.findById(demandeId);

            if (demande == null) {
                session.setAttribute("error", "Demande introuvable");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            String username = (String) session.getAttribute("user");
            User specialiste = userService.findByUsername(username);

            if (!demande.getSpecialiste().getId().equals(specialiste.getId())) {
                session.setAttribute("error", "Cette demande n est pas pour vous");
                resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
                return;
            }

            demande.setAvisMedical(avisMedical);
            demande.setRecommandations(recommandations);
            demande.setStatut("TERMINEE");
            demande.setDateReponse(LocalDateTime.now());

            demandeExpertiseService.update(demande);

            session.setAttribute("success",
                    "Avis médical envoye avec succes pour le patient #" +
                            demande.getConsultation().getPatient().getId());

            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Données invalides");
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/specialiste/dashboard-specialiste");
        }
    }

    @Override
    public void destroy() {
        if (demandeExpertiseService != null) demandeExpertiseService.close();
        if (userService != null) userService.close();
    }
}