package org.medical.teleexpertisemedical.servlet.generaliste;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.Consultation;
import org.medical.teleexpertisemedical.entity.DemandeExpertise;
import org.medical.teleexpertisemedical.entity.User;
import org.medical.teleexpertisemedical.service.ConsultationService;
import org.medical.teleexpertisemedical.service.DemandeExpertiseService;
import org.medical.teleexpertisemedical.service.UserService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/generaliste/dashboard-generaliste")
public class DashboardGeneralisteServlet extends HttpServlet {
    private ConsultationService consultationService;
    private DemandeExpertiseService demandeExpertiseService;
    private UserService userService;

    @Override
    public void init() {
        consultationService = new ConsultationService();
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
            String username = (String) session.getAttribute("user");
            User generaliste = userService.findByUsername(username);

            if (generaliste == null) {
                session.setAttribute("error", "Utilisateur introuvable");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            List<Consultation> allConsultations = consultationService.findByGeneralisteId(generaliste.getId());


            List<Consultation> consultationsEnCours = allConsultations.stream()
                    .filter(c -> c.getDateConsultation() != null)
                    .collect(Collectors.toList());

            int totalConsultations = allConsultations.size();
            int enCours = consultationsEnCours.size();
            int terminees = totalConsultations - enCours;

            List<DemandeExpertise> allDemandes = new ArrayList<>();
            for (Consultation consultation : allConsultations) {
                List<DemandeExpertise> demandes = demandeExpertiseService.findByConsultationId(consultation.getId());
                if (demandes != null && !demandes.isEmpty()) {
                    allDemandes.addAll(demandes);
                }
            }

            // Force load expertise related data
            for (DemandeExpertise demande : allDemandes) {
                if (demande.getSpecialiste() != null) {
                    demande.getSpecialiste().getNom();
                    demande.getSpecialiste().getPrenom();
                    if (demande.getSpecialiste().getSpecialite() != null) {
                        demande.getSpecialiste().getSpecialite().getNom();
                    }
                }
                if (demande.getConsultation() != null && demande.getConsultation().getPatient() != null) {
                    demande.getConsultation().getPatient().getId();
                }
            }

            // Filter demandes
            List<DemandeExpertise> demandesEnAttente = allDemandes.stream()
                    .filter(d -> "EN_ATTENTE".equals(d.getStatut()))
                    .collect(Collectors.toList());

            List<DemandeExpertise> reponses = allDemandes.stream()
                    .filter(d -> "TERMINEE".equals(d.getStatut()))
                    .sorted((d1, d2) -> d2.getDateReponse().compareTo(d1.getDateReponse())) // Most recent first
                    .collect(Collectors.toList());

            req.setAttribute("consultations", consultationsEnCours);
            req.setAttribute("totalConsultations", totalConsultations);
            req.setAttribute("consultationsEnCours", enCours);
            req.setAttribute("consultationsTerminees", terminees);
            req.setAttribute("demandesEnAttente", demandesEnAttente);
            req.setAttribute("reponses", reponses);
            req.setAttribute("totalDemandes", allDemandes.size());

            req.getRequestDispatcher("/generaliste/dashboard-generaliste.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur : " + e.getMessage());
        }
    }

    @Override
    public void destroy() {
        if (consultationService != null) consultationService.close();
        if (demandeExpertiseService != null) demandeExpertiseService.close();
        if (userService != null) userService.close();
    }
}