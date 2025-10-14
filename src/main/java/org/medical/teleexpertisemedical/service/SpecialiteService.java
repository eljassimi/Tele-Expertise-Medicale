package org.medical.teleexpertisemedical.service;

import org.medical.teleexpertisemedical.dao.SpecialiteDAO;
import org.medical.teleexpertisemedical.entity.Specialite;

import java.util.List;

public class SpecialiteService {
    private SpecialiteDAO specialiteDAO;

    public SpecialiteService() {
           this.specialiteDAO = new SpecialiteDAO();
    }

    public Specialite findById(Long id) {
        return specialiteDAO.findById(id);
    }

    public List<Specialite> findAll() {
        return specialiteDAO.findAll();
    }

    public void save(Specialite specialite) {
        specialiteDAO.save(specialite);
    }

    public void close() {
       specialiteDAO.close();
    }
}
