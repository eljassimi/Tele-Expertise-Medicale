package org.medical.teleexpertisemedical.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.Creneau;
import org.medical.teleexpertisemedical.entity.User;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public class CreneauService {
    private EntityManagerFactory emf;

    public CreneauService() {
        this.emf = Persistence.createEntityManagerFactory("teleExpertisePU");
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

    public int generateCreneauxForSpecialist(User specialist) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            LocalDate startDate = LocalDate.now();
            int creneauxCount = 0;

            for (int day = 0; day < 7; day++) {
                LocalDate currentDate = startDate.plusDays(day);

                LocalTime[] timeSlots = {
                        LocalTime.of(9, 0),
                        LocalTime.of(9, 30),
                        LocalTime.of(10, 0),
                        LocalTime.of(10, 30),
                        LocalTime.of(11, 0),
                        LocalTime.of(11, 30)
                };

                for (LocalTime time : timeSlots) {
                    Creneau creneau = new Creneau();
                    creneau.setSpecialiste(specialist);
                    creneau.setDateHeure(LocalDateTime.of(currentDate, time));
                    creneau.setDisponible(true);
                    creneau.setDureeMinutes(30);

                    em.persist(creneau);
                    creneauxCount++;
                }
            }

            em.getTransaction().commit();
            return creneauxCount;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors du creation de creneaux", e);
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
