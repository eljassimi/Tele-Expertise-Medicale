package org.medical.teleexpertisemedical.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Persistence;
import org.medical.teleexpertisemedical.entity.User;

import java.util.List;

public class UserDAO {
    private EntityManagerFactory emf;

    public UserDAO() {
        this.emf = Persistence.createEntityManagerFactory("teleExpertisePU");
    }

    public UserDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public User findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }


    public User findByUsername(String username) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM User u WHERE u.username = :username",
                            User.class)
                    .setParameter("username", username)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }


    public User findByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM User u WHERE u.email = :email",
                            User.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }


    public List<User> findByRole(String role) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM User u WHERE u.role = :role ORDER BY u.username ASC",
                            User.class)
                    .setParameter("role", role)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Trouve tous les utilisateurs
     */
    public List<User> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM User u ORDER BY u.username ASC",
                            User.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Sauvegarde ou met à jour un utilisateur
     */
    public User save(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            if (user.getId() == null) {
                em.persist(user);
            } else {
                user = em.merge(user);
            }

            em.getTransaction().commit();
            return user;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde de l'utilisateur", e);
        } finally {
            em.close();
        }
    }

    /**
     * Supprime un utilisateur par ID
     */
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            User user = em.find(User.class, id);
            if (user != null) {
                em.remove(user);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de l'utilisateur", e);
        } finally {
            em.close();
        }
    }

    /**
     * Vérifie si un username existe déjà
     */
    public boolean usernameExists(String username) {
        EntityManager em = emf.createEntityManager();
        try {
            Long count = em.createQuery(
                            "SELECT COUNT(u) FROM User u WHERE u.username = :username",
                            Long.class)
                    .setParameter("username", username)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }

    /**
     * Vérifie si un email existe déjà
     */
    public boolean emailExists(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            Long count = em.createQuery(
                            "SELECT COUNT(u) FROM User u WHERE u.email = :email",
                            Long.class)
                    .setParameter("email", email)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }

    /**
     * Compte le nombre d'utilisateurs par rôle
     */
    public long countByRole(String role) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT COUNT(u) FROM User u WHERE u.role = :role",
                            Long.class)
                    .setParameter("role", role)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    /**
     * Ferme l'EntityManagerFactory
     */
    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
