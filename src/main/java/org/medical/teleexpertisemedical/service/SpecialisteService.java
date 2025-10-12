package org.medical.teleexpertisemedical.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.User;

import java.util.List;

public class SpecialisteService {
    private EntityManagerFactory emf;

    public SpecialisteService() {
        this.emf = Persistence.createEntityManagerFactory("medical-pu");
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

    public List<User> findBySpecialiteId(Long specialiteId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM User u WHERE u.role = 'SPECIALISTE' AND u.specialite.id = :specialiteId",
                            User.class)
                    .setParameter("specialiteId", specialiteId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void update(User specialiste) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(specialiste);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
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
