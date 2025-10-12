package org.medical.teleexpertisemedical.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.Creneau;

import java.util.List;

public class CreneauService {
    private EntityManagerFactory emf;

    public CreneauService() {
        this.emf = Persistence.createEntityManagerFactory("medical-pu");
    }

    public Creneau findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Creneau.class, id);
        } finally {
            em.close();
        }
    }

    public List<Creneau> findBySpecialisteId(Long specialisteId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM Creneau c WHERE c.specialiste.id = :specialisteId ORDER BY c.dateHeure",
                            Creneau.class)
                    .setParameter("specialisteId", specialisteId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void save(Creneau creneau) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (creneau.getId() == null) {
                em.persist(creneau);
            } else {
                em.merge(creneau);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void update(Creneau creneau) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(creneau);
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
