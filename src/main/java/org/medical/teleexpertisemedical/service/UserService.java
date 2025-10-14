package org.medical.teleexpertisemedical.service;

import org.medical.teleexpertisemedical.dao.UserDAO;
import org.medical.teleexpertisemedical.entity.User;

import java.util.List;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public User save(User user) {
        return userDAO.save(user);
    }

    public User findById(Long id) {
        return userDAO.findById(id);
    }

    public User findByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    public boolean usernameExists(String username) {
        return userDAO.usernameExists(username);
    }

    public List<User> findByRole(String role) {
        return userDAO.findByRole(role);
    }

    public List<User> findAll() {
        return userDAO.findAll();
    }

    public void close() {
        if (userDAO != null) {
            userDAO.close();
        }
    }
}