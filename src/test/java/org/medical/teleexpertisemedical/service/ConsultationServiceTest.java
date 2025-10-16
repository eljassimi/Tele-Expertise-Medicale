package org.medical.teleexpertisemedical.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.medical.teleexpertisemedical.dao.ConsultationDAO;
import org.medical.teleexpertisemedical.entity.Consultation;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConsultationServiceTest {

    @Mock
    private ConsultationDAO consultationDAO;

    @InjectMocks
    private ConsultationService consultationService;

    private Consultation testConsultation;

    @BeforeEach
    void setUp() {
        testConsultation = new Consultation();
        testConsultation.setId(1L);
    }

    @Test
    void save_shouldReturnSavedConsultation() {
        when(consultationDAO.save(testConsultation)).thenReturn(testConsultation);

        Consultation result = consultationService.save(testConsultation);

        assertNotNull(result);
        assertEquals(1L, result.getId());
        verify(consultationDAO, times(1)).save(testConsultation);
    }

    @Test
    void findById_shouldReturnConsultation() {
        when(consultationDAO.findById(1L)).thenReturn(testConsultation);

        Consultation result = consultationService.findById(1L);

        assertNotNull(result);
        assertEquals(1L, result.getId());
        verify(consultationDAO, times(1)).findById(1L);
    }

    @Test
    void findAll_shouldReturnAllConsultations() {
        Consultation consultation2 = new Consultation();
        consultation2.setId(2L);
        List<Consultation> consultations = Arrays.asList(testConsultation, consultation2);
        when(consultationDAO.findAll()).thenReturn(consultations);

        List<Consultation> result = consultationService.findAll();

        assertNotNull(result);
        assertEquals(2, result.size());
        verify(consultationDAO, times(1)).findAll();
    }

    @Test
    void findByPatientId_shouldReturnConsultation() {
        Long patientId = 10L;
        when(consultationDAO.findByPatientId(patientId)).thenReturn(testConsultation);

        Consultation result = consultationService.findByPatientId(patientId);

        assertNotNull(result);
        verify(consultationDAO, times(1)).findByPatientId(patientId);
    }

    @Test
    void findByGeneralisteId_shouldReturnConsultations() {
        Long generalisteId = 5L;
        List<Consultation> consultations = Arrays.asList(testConsultation);
        when(consultationDAO.findByGeneralisteId(generalisteId)).thenReturn(consultations);

        List<Consultation> result = consultationService.findByGeneralisteId(generalisteId);

        assertNotNull(result);
        assertEquals(1, result.size());
        verify(consultationDAO, times(1)).findByGeneralisteId(generalisteId);
    }

}