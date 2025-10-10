package org.medical.teleexpertisemedical.service;

import org.medical.teleexpertisemedical.dao.ConsultationDAO;
import org.medical.teleexpertisemedical.entity.Consultation;

import java.util.List;

public class ConsultationService {
    private ConsultationDAO consultationDAO;

    public ConsultationService() {
        this.consultationDAO = new ConsultationDAO();
    }

    public Consultation save(Consultation consultation) {
        return consultationDAO.save(consultation);
    }

    public void close() {
        if (consultationDAO != null) {
            consultationDAO.close();
        }
    }

    public List<Consultation> findAll() {
        return consultationDAO.findAll();
    }
}
