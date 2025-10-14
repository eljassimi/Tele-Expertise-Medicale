package org.medical.teleexpertisemedical.servlet.generaliste;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.*;
import org.medical.teleexpertisemedical.service.ConsultationService;
import org.medical.teleexpertisemedical.service.PatientService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/generaliste/consultation")
public class ConsultationGeneralisteServlet extends HttpServlet {
    private ConsultationService consultationService;
    private PatientService patientService;

    @Override
    public void init() {
        consultationService = new ConsultationService();
        patientService = new PatientService();
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
            Long patientId = Long.parseLong(req.getParameter("patientId"));
            Patient patient = patientService.findPatientById(patientId);

            if (patient == null) {
                session.setAttribute("error", "Patient introuvable");
                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
                return;
            }

            req.setAttribute("patient", patient);
            req.setAttribute("actesTechniques", ActeTechnique.values());

            req.getRequestDispatcher("/generaliste/consultation.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur : " + e.getMessage());
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
            String action = req.getParameter("action");

            Long patientId = Long.parseLong(req.getParameter("patientId"));
            Patient patient = patientService.findPatientById(patientId);

            if (patient == null) {
                session.setAttribute("error", "Patient introuvable");
                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
                return;
            }

            String motif = req.getParameter("motif");
            String observations = req.getParameter("observations");
            String diagnostic = req.getParameter("diagnostic");
            String traitement = req.getParameter("traitement");

            String[] actesSelectionnes = req.getParameterValues("actesTechniques");
            List<ActeTechnique> actesTechniques = new ArrayList<>();
            if (actesSelectionnes != null) {
                for (String acte : actesSelectionnes) {
                    actesTechniques.add(ActeTechnique.valueOf(acte));
                }
            }

            Consultation consultation = consultationService.findByPatientId(patientId);

            if (consultation == null) {
                consultation = new Consultation();
                consultation.setPatient(patient);
                consultation.setMedecinGeneraliste(null);
            }

            consultation.setMotif(motif);
            consultation.setObservations(observations);
            consultation.setDiagnostic(diagnostic);
            consultation.setTraitement(traitement);
            consultation.setActesTechniques(actesTechniques);
            consultation.calculerCoutActesTechniques();

            if ("cloturer".equals(action)) {
                if (diagnostic == null || diagnostic.trim().isEmpty() ||
                        traitement == null || traitement.trim().isEmpty()) {
                    session.setAttribute("error",
                            "Le diagnostic et le traitement sont obligatoires pour cloturer la consultation");
                    resp.sendRedirect(req.getContextPath() + "/generaliste/consultation?patientId=" + patientId);
                    return;
                }

                consultation.cloturer();
                consultationService.save(consultation);
                patient.setEnAttente(false);
                patientService.updatePatient(patient);

                session.setAttribute("success",
                        "Consultation cloturee avec succes pour " +
                                patient.getNom() + " " + patient.getPrenom());

                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
            }
            else if ("demander_avis".equals(action)) {
                consultationService.save(consultation);

                session.setAttribute("consultationId", consultation.getId());
                session.setAttribute("info",
                        "Consultation enregistree");

                resp.sendRedirect(req.getContextPath() +
                        "/generaliste/demander-expertise?consultationId=" + consultation.getId());
            }

            else {
                session.setAttribute("error", "Action non reconnue");
                resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de l enregistrement : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/generaliste/dashboard-generaliste");
        }
    }

    @Override
    public void destroy() {
        if (consultationService != null) consultationService.close();
        if (patientService != null) patientService.close();
    }
}