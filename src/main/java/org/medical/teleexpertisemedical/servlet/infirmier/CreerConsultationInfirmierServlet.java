package org.medical.teleexpertisemedical.servlet.infirmier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.medical.teleexpertisemedical.entity.Consultation;
import org.medical.teleexpertisemedical.entity.Patient;
import org.medical.teleexpertisemedical.entity.User;
import org.medical.teleexpertisemedical.service.ConsultationService;
import org.medical.teleexpertisemedical.service.PatientService;
import org.medical.teleexpertisemedical.service.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet("/infirmier/creer-consultation")
public class CreerConsultationInfirmierServlet extends HttpServlet {
    private PatientService patientService;
    private UserService userService;
    private ConsultationService consultationService;

    @Override
    public void init() {
        patientService = new PatientService();
        userService = new UserService();
        consultationService = new ConsultationService();
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
            String patientIdParam = req.getParameter("patientId");
            if (patientIdParam == null || patientIdParam.isEmpty()) {
                session.setAttribute("error", "ID du patient manquant");
                resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            Long patientId = Long.parseLong(patientIdParam);
            Patient patient = patientService.findPatientById(patientId);

            if (patient == null) {
                session.setAttribute("error", "Patient introuvable");
                resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            List<User> generalistes = userService.findByRole("GENERALISTE");

            req.setAttribute("patient", patient);
            req.setAttribute("generalistes", generalistes);

            req.getRequestDispatcher("/infirmier/creer-consultation.jsp")
                    .forward(req, resp);

        } catch (NumberFormatException e) {
            session = req.getSession();
            session.setAttribute("error", "ID du patient invalide");
            resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur lors du chargement : " + e.getMessage());
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"INFIRMIER".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String patientIdParam = req.getParameter("patientId");
            String generalisteIdParam = req.getParameter("generalisteId");

            if (patientIdParam == null || patientIdParam.isEmpty() ||
                    generalisteIdParam == null || generalisteIdParam.isEmpty()) {
                session.setAttribute("error", "Paramètres manquants pour créer la consultation");
                resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            Long patientId = Long.parseLong(patientIdParam);
            Long generalisteId = Long.parseLong(generalisteIdParam);


            Patient patient = patientService.findPatientById(patientId);
            User generaliste = userService.findById(generalisteId);

            if (patient == null) {
                session.setAttribute("error", "Patient introuvable");
                resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
                return;
            }

            if (generaliste == null) {
                session.setAttribute("error", "Médecin généraliste introuvable");
                resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
                return;
            }


            Consultation consultation = new Consultation();
            consultation.setPatient(patient);
            consultation.setMedecinGeneraliste(generaliste);
            consultation.setMotif("Consultation créée par l'infirmier " + session.getAttribute("user"));
            consultation.setObservations("En attente d'examen par le médecin généraliste");


            consultationService.save(consultation);

            patient.setEnAttente(false);
            patientService.updatePatient(patient);

            session.setAttribute("success",
                    "Consultation créée avec succès pour " + patient.getNom() + " " + patient.getPrenom() +
                            " avec Dr. " + generaliste.getUsername());

            resp.sendRedirect(req.getContextPath() + "/infirmier/dashboard-infirmier");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Format d'ID invalide");
            resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de la création de la consultation : " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/infirmier/liste-patients");
        }
    }

    @Override
    public void destroy() {
        if (patientService != null) {
            patientService.close();
        }
        if (userService != null) {
            userService.close();
        }
        if (consultationService != null) {
            consultationService.close();
        }
    }
}
