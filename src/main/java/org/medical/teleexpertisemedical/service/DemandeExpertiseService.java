package org.medical.teleexpertisemedical.service;

import org.medical.teleexpertisemedical.dao.DemandeExpertiseDAO;
import org.medical.teleexpertisemedical.entity.DemandeExpertise;

import java.util.List;

public class DemandeExpertiseService {
    private DemandeExpertiseDAO dao;

    public DemandeExpertiseService() {
        this.dao = new DemandeExpertiseDAO();
    }

    public DemandeExpertise findById(Long id) {
        return dao.findById(id);
    }

    public List<DemandeExpertise> findBySpecialisteId(Long specialisteId) {
        return dao.findBySpecialisteId(specialisteId);
    }


    public List<DemandeExpertise> findByConsultationId(Long consultationId) {
        return dao.findByConsultationId(consultationId);
    }

    public List<DemandeExpertise> findAll() {
        return dao.findAll();
    }

    public void save(DemandeExpertise demande) {
        dao.save(demande);
    }

    public void update(DemandeExpertise demande) {
        dao.update(demande);
    }

    public void close() {
        if (dao != null) {
            dao.close();
        }
    }
}