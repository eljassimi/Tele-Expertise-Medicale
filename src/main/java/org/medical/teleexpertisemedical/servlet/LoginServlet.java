package org.medical.teleexpertisemedical.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.medical.teleexpertisemedical.entity.User;
import org.medical.teleexpertisemedical.service.UserService;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
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

        HttpSession session = req.getSession();
        String sessionToken = (String) session.getAttribute("csrfToken");
        String formToken = req.getParameter("csrfToken");

        if (sessionToken == null || !sessionToken.equals(formToken)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF Attack Detected");
            return;
        }

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            User user = userService.findByUsername(username);

            if (user != null && BCrypt.checkpw(password, user.getPassword())) {
                session = req.getSession(true);
                session.setAttribute("user", user.getUsername());
                session.setAttribute("userId", user.getId());
                session.setAttribute("role", user.getRole());
                session.setMaxInactiveInterval(30 * 60);

                redirectByRole(user.getRole(), req, resp);
            } else {
                req.setAttribute("error", "Nom d'utilisateur ou mot de passe incorrect");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de la connexion");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private void redirectByRole(String role, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String contextPath = req.getContextPath();

        switch (role) {
            case "GENERALISTE":
                resp.sendRedirect(contextPath + "/generaliste/dashboard-generaliste");
                break;
            case "SPECIALISTE":
                resp.sendRedirect(contextPath + "/specialiste/dashboard-specialiste");
                break;
            case "INFIRMIER":
                resp.sendRedirect(contextPath + "/infirmier/dashboard-infirmier");
                break;
            default:
                resp.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
        if (userService != null) userService.close();
    }
}
