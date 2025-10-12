package org.medical.teleexpertisemedical.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.Specialite;

import java.util.List;

public class SpecialiteService {
    private EntityManagerFactory emf;

    public SpecialiteService() {
        this.emf = Persistence.createEntityManagerFactory("medical-pu");
    }

    public Specialite findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Specialite.class, id);
        } finally {
            em.close();
        }
    }

    public List<Specialite> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT s FROM Specialite s ORDER BY s.nom", Specialite.class)
                    .getResultList();
        } finally {
            em.close();
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
