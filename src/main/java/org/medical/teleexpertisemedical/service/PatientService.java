package org.medical.teleexpertisemedical.service;

import org.medical.teleexpertisemedical.dao.PatientDAO;
import org.medical.teleexpertisemedical.entity.Patient;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class PatientService {
    private PatientDAO patientDAO;

    public PatientService() {
        this.patientDAO = new PatientDAO();
    }

    public PatientService(PatientDAO patientDAO) {
        this.patientDAO = patientDAO;
    }

    public PatientStatistics getStatisticsForToday() {
        List<Patient> patientsJour = patientDAO.findPatientsOfToday();

        long total = patientsJour.size();
        long enAttente = patientsJour.stream()
                .filter(p -> Boolean.TRUE.equals(p.getEnAttente()))
                .count();
        long consultes = total - enAttente;

        return new PatientStatistics(total, enAttente, consultes);
    }


    public List<Patient> getRecentPatients(int limit) {
        List<Patient> patients = patientDAO.findPatientsOfToday()
                .stream()
                .limit(limit)
                .collect(Collectors.toList());

        for (Patient p : patients) {
            p.getSignesVitaux().size();
        }

        return patients;
    }

    public Patient savePatient(Patient patient) {
        return patientDAO.save(patient);
    }
    public List<Patient> findAll() {return patientDAO.findAll();}

    public Patient findPatientByNumeroSS(String numero) {
        return patientDAO.findByNumeroSecuriteSociale(numero);
    }

    public Patient findPatientById(Long id){
        return patientDAO.findPatientById(id);
    }

    public Patient updatePatient(Patient patient) { return patientDAO.update(patient);}

    public void close() {
        if (patientDAO != null) {
            patientDAO.close();
        }
    }

    public static class PatientStatistics {
        private final long total;
        private final long enAttente;
        private final long consultes;

        public PatientStatistics(long total, long enAttente, long consultes) {
            this.total = total;
            this.enAttente = enAttente;
            this.consultes = consultes;
        }

        public long getTotal() {
            return total;
        }

        public long getEnAttente() {
            return enAttente;
        }

        public long getConsultes() {
            return consultes;
        }
    }
}
