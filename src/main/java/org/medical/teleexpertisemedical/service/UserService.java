package org.medical.teleexpertisemedical.service;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import org.medical.teleexpertisemedical.dao.UserDAO;
import org.medical.teleexpertisemedical.entity.User;

import java.util.List;

@Stateless
public class UserService {
    @EJB
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public void register(User user) {
        userDAO.save(user);
    }

    public User findById(Long id) {
        return userDAO.findById(id);
    }

    public List<User> findByRole(String role) {
        return userDAO.findByRole(role);
    }

    public void close() {
        userDAO.close();
    }
}