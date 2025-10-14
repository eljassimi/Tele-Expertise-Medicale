package org.medical.teleexpertisemedical.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.medical.teleexpertisemedical.entity.Specialite;
import org.medical.teleexpertisemedical.entity.User;
import org.medical.teleexpertisemedical.service.CreneauService;
import org.medical.teleexpertisemedical.service.SpecialiteService;
import org.medical.teleexpertisemedical.service.UserService;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService;
    private SpecialiteService specialiteService;
    private CreneauService creneauService;

    @Override
    public void init() {
        userService = new UserService();
        specialiteService = new SpecialiteService();
        creneauService = new CreneauService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        session.setAttribute("csrfToken", UUID.randomUUID().toString());

        List<Specialite> specialites = specialiteService.findAll();
        req.setAttribute("specialites", specialites);

        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String sessionToken = (String) session.getAttribute("csrfToken");
        String formToken = req.getParameter("csrfToken");

        if (sessionToken == null || !sessionToken.equals(formToken)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF Attack Detected");
            return;
        }

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String telephone = req.getParameter("telephone");
        String email = req.getParameter("email");

        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                nom == null || nom.trim().isEmpty() ||
                prenom == null || prenom.trim().isEmpty()) {
            session.setAttribute("error", "Tous les champs doivent etre remplis");
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        try {
            if (userService.usernameExists(username)) {
                session.setAttribute("error", "Ce nom d'utilisateur existe déjà");
                resp.sendRedirect(req.getContextPath() + "/register");
                return;
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            User user = new User();
            user.setUsername(username);
            user.setPassword(hashedPassword);
            user.setRole(role);
            user.setNom(nom);
            user.setPrenom(prenom);
            user.setTelephone(telephone);
            user.setEmail(email);

            if ("SPECIALISTE".equals(role)) {
                String specialiteIdStr = req.getParameter("specialiteId");
                String tarifStr = req.getParameter("tarif");

                if (specialiteIdStr == null || specialiteIdStr.trim().isEmpty() ||
                        tarifStr == null || tarifStr.trim().isEmpty()) {
                    session.setAttribute("error", "Specialite et taris est obligatoire");
                    resp.sendRedirect(req.getContextPath() + "/register");
                    return;
                }

                Long specialiteId = Long.parseLong(specialiteIdStr);
                Double tarif = Double.parseDouble(tarifStr);

                Specialite specialite = specialiteService.findById(specialiteId);
                if (specialite == null) {
                    session.setAttribute("error", "Specilaite invalide");
                    resp.sendRedirect(req.getContextPath() + "/register");
                    return;
                }

                user.setSpecialite(specialite);
                user.setTarif(tarif);
                user.setDisponible(true);
            }

            userService.save(user);

            if ("SPECIALISTE".equals(role)) {
                int creneauxCount = creneauService.generateCreneauxForSpecialist(user);
                session.setAttribute("success",
                        "Inscription reussie ! " + creneauxCount + " créneau auto genereted.");
            } else {
                session.setAttribute("success", "Inscription reussie");
            }

            resp.sendRedirect(req.getContextPath() + "/login.jsp");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Format invalide");
            resp.sendRedirect(req.getContextPath() + "/register");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de l inscription: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/register");
        }
    }

    @Override
    public void destroy() {
        if (userService != null) userService.close();
        if (specialiteService != null) specialiteService.close();
        if (creneauService != null) creneauService.close();
    }
}