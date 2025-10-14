package org.medical.teleexpertisemedical.servlet.generaliste;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.*;
import org.medical.teleexpertisemedical.service.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/generaliste/demander-expertise")
public class DemanderExpertiseServlet extends HttpServlet {
    private ConsultationService consultationService;
    private SpecialisteService specialisteService;
    private SpecialiteService specialiteService;
    private CreneauService creneauService;
    private DemandeExpertiseService demandeExpertiseService;

    @Override
    public void init() {
        consultationService = new ConsultationService();
        specialisteService = new SpecialisteService();
        specialiteService = new SpecialiteService();
        creneauService = new CreneauService();
        demandeExpertiseService = new DemandeExpertiseService();
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
            String consultationIdParam = req.getParameter("consultationId");
            if (consultationIdParam == null || consultationIdParam.isEmpty()) {
                session.setAttribute("error", "ID de consultation manquant");
                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
                return;
            }

            Long consultationId = Long.parseLong(consultationIdParam);
            Consultation consultation = consultationService.findById(consultationId);

            if (consultation == null) {
                session.setAttribute("error", "Consultation introuvable");
                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
                return;
            }

            // Force load patient data
            if (consultation.getPatient() != null) {
                consultation.getPatient().getNom();
                consultation.getPatient().getPrenom();
            }

            // Récupérer toutes les spécialités
            List<Specialite> specialites = specialiteService.findAll();
            req.setAttribute("specialites", specialites);
            req.setAttribute("consultation", consultation);

            System.out.println("=== DEBUG INFO ===");
            System.out.println("Consultation ID: " + consultationId);

            // Si une spécialité est sélectionnée
            String specialiteIdParam = req.getParameter("specialiteId");
            if (specialiteIdParam != null && !specialiteIdParam.isEmpty()) {
                Long specialiteId = Long.parseLong(specialiteIdParam);
                System.out.println("Specialite ID selected: " + specialiteId);

                // US3 : Utilisation Stream API
                List<User> specialistes = specialisteService.findAll()
                        .stream()
                        .filter(s -> s.getSpecialite() != null &&
                                s.getSpecialite().getId().equals(specialiteId))
                        .filter(s -> s.getDisponible() != null && s.getDisponible())
                        .sorted((s1, s2) -> Double.compare(
                                s1.getTarif() != null ? s1.getTarif() : 0.0,
                                s2.getTarif() != null ? s2.getTarif() : 0.0))
                        .collect(Collectors.toList());

                System.out.println("Specialistes found: " + specialistes.size());
                req.setAttribute("specialistes", specialistes);
                req.setAttribute("specialiteSelectionnee", specialiteId);
            }

            // Si un spécialiste est sélectionné
            String specialisteIdParam = req.getParameter("specialisteId");
            if (specialisteIdParam != null && !specialisteIdParam.isEmpty()) {
                Long specialisteId = Long.parseLong(specialisteIdParam);
                System.out.println("Specialiste ID selected: " + specialisteId);

                User specialiste = specialisteService.findById(specialisteId);

                if (specialiste != null) {
                    System.out.println("Specialiste found: " + specialiste.getNom() + " " + specialiste.getPrenom());

                    // Récupérer les créneaux
                    List<Creneau> allCreneaux = creneauService.findBySpecialisteId(specialisteId);
                    System.out.println("Total creneaux in DB: " + allCreneaux.size());

                    // Filtrer les créneaux disponibles et futurs
                    List<Creneau> creneaux = allCreneaux.stream()
                            .filter(c -> {
                                boolean isFuture = c.getDateHeure().isAfter(LocalDateTime.now());
                                System.out.println("Creneau " + c.getId() + ": " + c.getDateHeure() +
                                        " - Future: " + isFuture + ", Disponible: " + c.getDisponible());
                                return isFuture;
                            })
                            .sorted((c1, c2) -> c1.getDateHeure().compareTo(c2.getDateHeure()))
                            .collect(Collectors.toList());

                    System.out.println("Filtered creneaux (future): " + creneaux.size());

                    req.setAttribute("creneaux", creneaux);
                    req.setAttribute("specialisteSelectionne", specialiste);

                    // If no creneaux, add info message
                    if (creneaux.isEmpty()) {
                        session.setAttribute("info",
                                "Aucun créneau disponible pour ce spécialiste. Veuillez en créer ou choisir un autre spécialiste.");
                    }
                } else {
                    System.out.println("Specialiste NOT found!");
                }
            }

            System.out.println("=== END DEBUG ===");

            req.getRequestDispatcher("/generaliste/demander-expertise.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"GENERALISTE".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {

            Long consultationId = Long.parseLong(req.getParameter("consultationId"));
            Long specialisteId = Long.parseLong(req.getParameter("specialisteId"));
            Long creneauId = Long.parseLong(req.getParameter("creneauId"));
            String question = req.getParameter("question");
            String donneesAnalyses = req.getParameter("donneesAnalyses");
            String priorite = req.getParameter("priorite");

            // Validation
            if (question == null || question.trim().isEmpty()) {
                session.setAttribute("error", "La question au specialiste est obligatoire");
                resp.sendRedirect(req.getContextPath() +
                        "/generaliste/demander-expertise?consultationId=" + consultationId);
                return;
            }

            if (priorite == null || priorite.trim().isEmpty()) {
                session.setAttribute("error", "Le niveau de priorite est obligatoire");
                resp.sendRedirect(req.getContextPath() +
                        "/generaliste/demander-expertise?consultationId=" + consultationId);
                return;
            }

            Consultation consultation = consultationService.findById(consultationId);
            User specialiste = specialisteService.findById(specialisteId);
            Creneau creneau = creneauService.findById(creneauId);

            if (consultation == null || specialiste == null || creneau == null) {
                session.setAttribute("error", "Données invalides");
                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
                return;
            }

            if (!creneau.getDisponible() || creneau.getDateHeure().isBefore(LocalDateTime.now())) {
                session.setAttribute("error", "Ce creneau n'est plus disponible");
                resp.sendRedirect(req.getContextPath() +
                        "/generaliste/demander-expertise?consultationId=" + consultationId +
                        "&specialiteId=" + specialiste.getSpecialite().getId() +
                        "&specialisteId=" + specialisteId);
                return;
            }

            DemandeExpertise demande = new DemandeExpertise();
            demande.setConsultation(consultation);
            demande.setSpecialiste(specialiste);
            demande.setCreneau(creneau);
            demande.setQuestion(question);
            demande.setDonneesAnalyses(donneesAnalyses);
            demande.setPriorite(priorite);
            demande.setStatut("EN_ATTENTE");
            demande.setDateDemande(LocalDateTime.now());

            creneau.setDisponible(false);
            creneauService.update(creneau);

            demandeExpertiseService.save(demande);


            resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Parametres invalides");
            resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de la creation de la demande : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
        }
    }

    @Override
    public void destroy() {
        if (consultationService != null) consultationService.close();
        if (specialisteService != null) specialisteService.close();
        if (specialiteService != null) specialiteService.close();
        if (creneauService != null) creneauService.close();
        if (demandeExpertiseService != null) demandeExpertiseService.close();
    }
}
