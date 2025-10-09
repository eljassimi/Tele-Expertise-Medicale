package org.medical.teleexpertisemedical.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.Patient;

import java.time.LocalDateTime;
import java.util.List;

public class PatientDAO {
    private EntityManagerFactory emf;

    public PatientDAO() {
        this.emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    public PatientDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public List<Patient> findPatientsOfToday() {
        LocalDateTime debutJour = java.time.LocalDate.now().atStartOfDay();
        LocalDateTime finJour = java.time.LocalDate.now().atTime(23, 59, 59);

        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT p FROM Patient p " +
                                    "LEFT JOIN FETCH p.signesVitaux " +
                                    "WHERE p.dateEnregistrement BETWEEN :debut AND :fin " +
                                    "ORDER BY p.dateEnregistrement DESC",
                            Patient.class)
                    .setParameter("debut", debutJour)
                    .setParameter("fin", finJour)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Patient save(Patient patient) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (patient.getId() == null) {
                em.persist(patient);
            } else {
                patient = em.merge(patient);
            }
            em.getTransaction().commit();
            return patient;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public List<Patient> findAll(){
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT p FROM Patient p " +
                                    "LEFT JOIN FETCH p.signesVitaux " +
                                    "ORDER BY p.dateEnregistrement DESC",
                            Patient.class)
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
