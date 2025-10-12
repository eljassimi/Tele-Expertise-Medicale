package org.medical.teleexpertisemedical.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.DemandeExpertise;

import java.util.List;

public class DemandeExpertiseService {
    private EntityManagerFactory emf;

    public DemandeExpertiseService() {
        this.emf = Persistence.createEntityManagerFactory("medical-pu");
    }

    public DemandeExpertise findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(DemandeExpertise.class, id);
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findBySpecialisteId(Long specialisteId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT d FROM DemandeExpertise d WHERE d.specialiste.id = :specialisteId ORDER BY d.dateDemande DESC",
                            DemandeExpertise.class)
                    .setParameter("specialisteId", specialisteId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findBySpecialisteIdAndStatut(Long specialisteId, String statut) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT d FROM DemandeExpertise d WHERE d.specialiste.id = :specialisteId AND d.statut = :statut ORDER BY d.dateDemande DESC",
                            DemandeExpertise.class)
                    .setParameter("specialisteId", specialisteId)
                    .setParameter("statut", statut)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void save(DemandeExpertise demande) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (demande.getId() == null) {
                em.persist(demande);
            } else {
                em.merge(demande);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void update(DemandeExpertise demande) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(demande);
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
