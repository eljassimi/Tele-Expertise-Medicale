package org.medical.teleexpertisemedical.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.DemandeExpertise;

import java.util.ArrayList;
import java.util.List;

public class DemandeExpertiseDAO {
    private EntityManagerFactory emf;

    public DemandeExpertiseDAO() {
        this.emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    public DemandeExpertise findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT d FROM DemandeExpertise d " +
                                    "LEFT JOIN FETCH d.consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH d.specialiste s " +
                                    "LEFT JOIN FETCH s.specialite " +
                                    "LEFT JOIN FETCH d.creneau " +
                                    "WHERE d.id = :id",
                            DemandeExpertise.class)
                    .setParameter("id", id)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findBySpecialisteId(Long specialisteId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT d FROM DemandeExpertise d " +
                                    "LEFT JOIN FETCH d.consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH d.specialiste s " +
                                    "LEFT JOIN FETCH s.specialite " +
                                    "LEFT JOIN FETCH d.creneau " +
                                    "WHERE d.specialiste.id = :specialisteId " +
                                    "ORDER BY d.dateDemande DESC",
                            DemandeExpertise.class)
                    .setParameter("specialisteId", specialisteId)
                    .getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findBySpecialisteIdAndStatut(Long specialisteId, String statut) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT d FROM DemandeExpertise d " +
                                    "LEFT JOIN FETCH d.consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH d.specialiste s " +
                                    "LEFT JOIN FETCH s.specialite " +
                                    "LEFT JOIN FETCH d.creneau " +
                                    "WHERE d.specialiste.id = :specialisteId AND d.statut = :statut " +
                                    "ORDER BY d.dateDemande DESC",
                            DemandeExpertise.class)
                    .setParameter("specialisteId", specialisteId)
                    .setParameter("statut", statut)
                    .getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findByConsultationId(Long consultationId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT d FROM DemandeExpertise d " +
                                    "LEFT JOIN FETCH d.consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH d.specialiste s " +
                                    "LEFT JOIN FETCH s.specialite " +
                                    "LEFT JOIN FETCH d.creneau " +
                                    "WHERE d.consultation.id = :consultationId " +
                                    "ORDER BY d.dateDemande DESC",
                            DemandeExpertise.class)
                    .setParameter("consultationId", consultationId)
                    .getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<DemandeExpertise> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT d FROM DemandeExpertise d " +
                                    "LEFT JOIN FETCH d.consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH d.specialiste s " +
                                    "LEFT JOIN FETCH s.specialite " +
                                    "LEFT JOIN FETCH d.creneau " +
                                    "ORDER BY d.dateDemande DESC",
                            DemandeExpertise.class)
                    .getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public DemandeExpertise save(DemandeExpertise demande) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (demande.getId() == null) {
                em.persist(demande);
            } else {
                demande = em.merge(demande);
            }
            em.getTransaction().commit();
            return demande;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde de la demande d'expertise", e);
        } finally {
            em.close();
        }
    }

    public DemandeExpertise update(DemandeExpertise demande) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            demande = em.merge(demande);
            em.getTransaction().commit();
            return demande;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de la demande d'expertise", e);
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            DemandeExpertise demande = em.find(DemandeExpertise.class, id);
            if (demande != null) {
                em.remove(demande);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de la demande d'expertise", e);
        } finally {
            em.close();
        }
    }

    public long countBySpecialisteId(Long specialisteId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT COUNT(d) FROM DemandeExpertise d WHERE d.specialiste.id = :specialisteId",
                            Long.class)
                    .setParameter("specialisteId", specialisteId)
                    .getSingleResult();
        } catch (Exception e) {
            return 0L;
        } finally {
            em.close();
        }
    }

    public long countBySpecialisteIdAndStatut(Long specialisteId, String statut) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT COUNT(d) FROM DemandeExpertise d WHERE d.specialiste.id = :specialisteId AND d.statut = :statut",
                            Long.class)
                    .setParameter("specialisteId", specialisteId)
                    .setParameter("statut", statut)
                    .getSingleResult();
        } catch (Exception e) {
            return 0L;
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