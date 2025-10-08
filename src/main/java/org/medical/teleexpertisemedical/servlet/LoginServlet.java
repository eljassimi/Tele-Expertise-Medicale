package org.medical.teleexpertisemedical.servlet;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.medical.teleexpertisemedical.entity.User;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        session.setAttribute("csrfToken", UUID.randomUUID().toString());
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
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

        // Récupérer les paramètres
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        EntityManager em = emf.createEntityManager();

        try {
            // Rechercher l'utilisateur par nom d'utilisateur
            User user = em.createQuery(
                            "SELECT u FROM User u WHERE u.username = :username", User.class)
                    .setParameter("username", username)
                    .getSingleResult();

            // Vérifier le mot de passe avec BCrypt
            if (BCrypt.checkpw(password, user.getPassword())) {
                // Authentification réussie
                session = req.getSession(true);
                session.setAttribute("user", user.getUsername());
                session.setAttribute("userId", user.getId());
                session.setAttribute("role", user.getRole());
                session.setMaxInactiveInterval(30 * 60); // Session de 30 minutes

                // Redirection selon le rôle
                redirectByRole(user.getRole(), req, resp);
            } else {
                // Mot de passe incorrect
                req.setAttribute("error", "Nom d'utilisateur ou mot de passe incorrect");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }

        } catch (NoResultException e) {
            // Utilisateur non trouvé
            req.setAttribute("error", "Nom d'utilisateur ou mot de passe incorrect");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de la connexion");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } finally {
            em.close();
        }
    }

    private void redirectByRole(String role, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String contextPath = req.getContextPath();

        switch (role) {
            case "GENERALISTE":
                resp.sendRedirect(contextPath + "/dashboard-generaliste.jsp");
                break;
            case "SPECIALISTE":
                resp.sendRedirect(contextPath + "/dashboard-specialiste.jsp");
                break;
            case "INFIRMIER":
                resp.sendRedirect(contextPath + "/infirmier/dashboard-infirmier.jsp");
                break;
            default:
                resp.sendRedirect(contextPath + "/dashboard.jsp");
        }
    }

    @Override
    public void destroy() {
        if (emf != null) emf.close();
    }
}
