package org.medical.teleexpertisemedical.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.Consultation;
import org.medical.teleexpertisemedical.entity.StatutConsultation;

import java.util.List;

public class ConsultationDAO {
    private EntityManagerFactory emf;

    public ConsultationDAO() {
        this.emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    public Consultation save(Consultation consultation) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            if (consultation.getId() == null) {
                em.persist(consultation);
            } else {
                consultation = em.merge(consultation);
            }

            em.getTransaction().commit();
            return consultation;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde de la consultation", e);
        } finally {
            em.close();
        }
    }

    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }

    public List<Consultation> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.medecinGeneraliste " +
                                    "ORDER BY c.dateConsultation DESC",
                            Consultation.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Consultation findByPatientId(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.medecinGeneraliste " +
                                    "WHERE c.patient.id = :patientId AND c.statut = :statut",
                            Consultation.class)
                    .setParameter("patientId", patientId)
                    .setParameter("statut", StatutConsultation.EN_COURS)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }
}
