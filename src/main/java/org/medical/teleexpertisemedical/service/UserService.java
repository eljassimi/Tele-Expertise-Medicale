package org.medical.teleexpertisemedical.service;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManagerFactory;
import org.medical.teleexpertisemedical.dao.UserDAO;
import org.medical.teleexpertisemedical.entity.User;

@Stateless
public class UserService {
    @EJB
    private UserDAO userDAO;

    public UserService(EntityManagerFactory emf) {
    }

    public void register(User user) {
        userDAO.save(user);
    }
}