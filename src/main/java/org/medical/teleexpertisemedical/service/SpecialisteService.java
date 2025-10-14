package org.medical.teleexpertisemedical.service;

import org.medical.teleexpertisemedical.dao.SpecialisteDAO;
import org.medical.teleexpertisemedical.entity.User;

import java.util.List;

public class SpecialisteService {
    private SpecialisteDAO specialisteDAO;

    public SpecialisteService() {
    this.specialisteDAO = new SpecialisteDAO();
    }

    public User findById(Long id) {
      return specialisteDAO.findById(id);
    }

    public List<User> findAll() {
        return specialisteDAO.findAll();
    }


    public void close() {
        specialisteDAO.close();
    }
}
