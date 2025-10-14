package org.medical.teleexpertisemedical.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.Specialite;

import java.util.List;

public class SpecialiteDAO {
    private final EntityManagerFactory emf;

    public SpecialiteDAO() {
        this.emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    public Specialite findById(Long id) {
        try (EntityManager em = emf.createEntityManager()) {
            return em.find(Specialite.class, id);
        }
    }

    public List<Specialite> findAll() {
        try (EntityManager em = emf.createEntityManager()) {
            return em.createQuery("SELECT s FROM Specialite s ORDER BY s.nom", Specialite.class)
                    .getResultList();
        }
    }

    public void save(Specialite specialite) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (specialite.getId() == null) {
                em.persist(specialite);
            } else {
                em.merge(specialite);
            }
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
