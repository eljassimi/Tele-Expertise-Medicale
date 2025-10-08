package org.medical.teleexpertisemedical.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.PersistenceContext;

@Stateless
public class UserDAO {
    @PersistenceContext(unitName = "teleExpertisePU")
    private EntityManager em;

    public void save(Object user) {
        EntityTransaction tx = em.getTransaction();
        tx.begin();
        em.persist(user);
        tx.commit();
    }

    public Object findByUsername(String username) {
        return em.createQuery("SELECT u FROM User u WHERE u.username = :username", Object.class)
                .setParameter("username", username)
                .getSingleResult();
    }
}