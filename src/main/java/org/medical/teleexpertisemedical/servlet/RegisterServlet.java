package org.medical.teleexpertisemedical.servlet;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.medical.teleexpertisemedical.entity.Creneau;
import org.medical.teleexpertisemedical.entity.Specialite;
import org.medical.teleexpertisemedical.entity.User;
import org.medical.teleexpertisemedical.service.SpecialiteService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private EntityManagerFactory emf;
    private SpecialiteService specialiteService;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("teleExpertisePU");
        specialiteService = new SpecialiteService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        session.setAttribute("csrfToken", UUID.randomUUID().toString());

        // Load specialties for the dropdown
        List<Specialite> specialites = specialiteService.findAll();
        req.setAttribute("specialites", specialites);

        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Validation CSRF
        HttpSession session = req.getSession();
        String sessionToken = (String) session.getAttribute("csrfToken");
        String formToken = req.getParameter("csrfToken");

        if (sessionToken == null || !sessionToken.equals(formToken)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF Attack Detected");
            return;
        }

        // Common fields
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String telephone = req.getParameter("telephone");
        String email = req.getParameter("email");

        // Validation
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                nom == null || nom.trim().isEmpty() ||
                prenom == null || prenom.trim().isEmpty()) {
            session.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());

        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            // Check if username already exists
            Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.username = :username", Long.class)
                    .setParameter("username", username)
                    .getSingleResult();

            if (count > 0) {
                tx.rollback();
                session.setAttribute("error", "Ce nom d'utilisateur existe déjà");
                resp.sendRedirect(req.getContextPath() + "/register");
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(hashed);
            user.setRole(role);
            user.setNom(nom);
            user.setPrenom(prenom);
            user.setTelephone(telephone);
            user.setEmail(email);

            // Handle SPECIALISTE specific fields
            if ("SPECIALISTE".equals(role)) {
                String specialiteIdStr = req.getParameter("specialiteId");
                String tarifStr = req.getParameter("tarif");

                if (specialiteIdStr == null || specialiteIdStr.trim().isEmpty() ||
                        tarifStr == null || tarifStr.trim().isEmpty()) {
                    tx.rollback();
                    session.setAttribute("error", "La spécialité et le tarif sont obligatoires pour un spécialiste");
                    resp.sendRedirect(req.getContextPath() + "/register");
                    return;
                }

                Long specialiteId = Long.parseLong(specialiteIdStr);
                Double tarif = Double.parseDouble(tarifStr);

                Specialite specialite = em.find(Specialite.class, specialiteId);
                if (specialite == null) {
                    tx.rollback();
                    session.setAttribute("error", "Spécialité invalide");
                    resp.sendRedirect(req.getContextPath() + "/register");
                    return;
                }

                user.setSpecialite(specialite);
                user.setTarif(tarif);
                user.setDisponible(true);
            }

            em.persist(user);
            em.flush(); // Force ID generation for the user

            // *** AUTO-GENERATE CRÉNEAUX FOR SPECIALIST ***
            if ("SPECIALISTE".equals(role)) {
                int creneauxCount = generateCreneauxForSpecialist(em, user);
                System.out.println("✓ Generated " + creneauxCount + " créneaux for specialist: " +
                        user.getNom() + " " + user.getPrenom());
                session.setAttribute("success",
                        "Inscription réussie ! " + creneauxCount + " créneaux ont été générés automatiquement. Vous pouvez maintenant vous connecter.");
            } else {
                session.setAttribute("success", "Inscription réussie ! Vous pouvez maintenant vous connecter.");
            }

            tx.commit();
            resp.sendRedirect(req.getContextPath() + "/login.jsp");

        } catch (NumberFormatException e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            session.setAttribute("error", "Format de données invalide");
            resp.sendRedirect(req.getContextPath() + "/register");
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de l'inscription: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/register");
        } finally {
            em.close();
        }
    }

    /**
     * Auto-generate créneaux (time slots) for a newly registered specialist
     * Generates slots for the next 7 days, from 09:00 to 11:30, every 30 minutes
     *
     * @param em EntityManager
     * @param specialist The specialist user
     * @return Number of créneaux generated
     */
    private int generateCreneauxForSpecialist(EntityManager em, User specialist) {
        LocalDate startDate = LocalDate.now().plusDays(1); // Start from tomorrow
        int creneauxCount = 0;

        // Generate créneaux for the next 7 days
        for (int day = 0; day < 7; day++) {
            LocalDate currentDate = startDate.plusDays(day);

            // Time slots from 09:00 to 11:30 (30-minute intervals)
            LocalTime[] timeSlots = {
                    LocalTime.of(9, 0),   // 09:00
                    LocalTime.of(9, 30),  // 09:30
                    LocalTime.of(10, 0),  // 10:00
                    LocalTime.of(10, 30), // 10:30
                    LocalTime.of(11, 0),  // 11:00
                    LocalTime.of(11, 30)  // 11:30
            };

            // Create a creneau for each time slot
            for (LocalTime time : timeSlots) {
                Creneau creneau = new Creneau();
                creneau.setSpecialiste(specialist);
                creneau.setDateHeure(LocalDateTime.of(currentDate, time));
                creneau.setDisponible(true);
                creneau.setDureeMinutes(30);

                em.persist(creneau);
                creneauxCount++;
            }
        }

        return creneauxCount; // Should return 42 créneaux (7 days × 6 slots per day)
    }

    @Override
    public void destroy() {
        if (specialiteService != null) specialiteService.close();
        if (emf != null) emf.close();
    }
}