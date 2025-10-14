package org.medical.teleexpertisemedical.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.User;

import java.util.List;

public class SpecialisteDAO {

    private EntityManagerFactory emf;

    public SpecialisteDAO() {
        this.emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    public User findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, id);
            if (user != null && "SPECIALISTE".equals(user.getRole())) {
                return user;
            }
            return null;
        } finally {
            em.close();
        }
    }

    public List<User> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM User u WHERE u.role = 'SPECIALISTE'",
                            User.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }


    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
