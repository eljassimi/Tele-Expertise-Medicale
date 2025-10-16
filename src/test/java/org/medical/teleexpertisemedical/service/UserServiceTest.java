package org.medical.teleexpertisemedical.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.medical.teleexpertisemedical.dao.UserDAO;
import org.medical.teleexpertisemedical.entity.User;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserDAO userDAO;

    @InjectMocks
    private UserService userService;

    private User testUser;

    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setId(1L);
        testUser.setUsername("eljassimi");
        testUser.setRole("GENERALISTE");
    }

    @Test
    void save_shouldReturnSavedUser_whenUserIsValid() {
        when(userDAO.save(testUser)).thenReturn(testUser);

        User result = userService.save(testUser);

        assertNotNull(result);
        assertEquals(testUser.getId(), result.getId());
        assertEquals(testUser.getUsername(), result.getUsername());
        verify(userDAO, times(1)).save(testUser);
    }

    @Test
    void save_shouldReturnNull_whenUserDAOReturnsNull() {
        when(userDAO.save(testUser)).thenReturn(null);

        User result = userService.save(testUser);

        assertNull(result);
        verify(userDAO, times(1)).save(testUser);
    }

    @Test
    void findById_shouldReturnUser_whenUserExists() {

        Long userId = 1L;
        when(userDAO.findById(userId)).thenReturn(testUser);
        
        User result = userService.findById(userId);
        
        assertNotNull(result);
        assertEquals(userId, result.getId());
        assertEquals("eljassimi", result.getUsername());
        verify(userDAO, times(1)).findById(userId);
    }

    @Test
    void findById_shouldReturnNull_whenUserDoesNotExist() {

        Long userId = 999L;
        when(userDAO.findById(userId)).thenReturn(null);
        
        User result = userService.findById(userId);

        assertNull(result);
        verify(userDAO, times(1)).findById(userId);
    }

    @Test
    void findByUsername_shouldReturnUser_whenUsernameExists() {
        String username = "eljassimi";
        when(userDAO.findByUsername(username)).thenReturn(testUser);

        User result = userService.findByUsername(username);

        assertNotNull(result);
        assertEquals(username, result.getUsername());
        verify(userDAO, times(1)).findByUsername(username);
    }

    @Test
    void findByUsername_shouldReturnNull_whenUsernameDoesNotExist() {

        String username = "nonexistentuser";
        when(userDAO.findByUsername(username)).thenReturn(null);

        User result = userService.findByUsername(username);

        assertNull(result);
        verify(userDAO, times(1)).findByUsername(username);
    }

    @Test
    void usernameExists_shouldReturnTrue_whenUsernameExists() {
        String username = "eljassimi";
        when(userDAO.usernameExists(username)).thenReturn(true);

        boolean result = userService.usernameExists(username);

        assertTrue(result);
        verify(userDAO, times(1)).usernameExists(username);
    }

    @Test
    void usernameExists_shouldReturnFalse_whenUsernameDoesNotExist() {

        String username = "nonexistentuser";
        when(userDAO.usernameExists(username)).thenReturn(false);

        boolean result = userService.usernameExists(username);

        assertFalse(result);
        verify(userDAO, times(1)).usernameExists(username);
    }

    @Test
    void findByRole_shouldReturnUserList_whenRoleExists() {

        String role = "GENERALISTE";
        User user2 = new User();
        user2.setId(2L);
        user2.setUsername("ahmed");
        user2.setRole("GENERALISTE");

        List<User> expectedUsers = Arrays.asList(testUser, user2);
        when(userDAO.findByRole(role)).thenReturn(expectedUsers);

        List<User> result = userService.findByRole(role);

        assertNotNull(result);
        assertEquals("GENERALISTE", result.get(0).getRole());
        assertEquals("GENERALISTE", result.get(1).getRole());
        verify(userDAO, times(1)).findByRole(role);
    }

    @Test
    void findByRole_shouldReturnEmptyList_whenNoUsersWithRole() {

        String role = "ADMIN";
        when(userDAO.findByRole(role)).thenReturn(List.of());

        List<User> result = userService.findByRole(role);

        assertNotNull(result);
        assertTrue(result.isEmpty());
        verify(userDAO, times(1)).findByRole(role);
    }

    @Test
    void findAll_shouldReturnAllUsers() {
        User user2 = new User();
        user2.setId(2L);
        user2.setUsername("karim");

        User user3 = new User();
        user3.setId(3L);
        user3.setUsername("hamza");

        List<User> expectedUsers = Arrays.asList(testUser, user2, user3);
        when(userDAO.findAll()).thenReturn(expectedUsers);

        List<User> result = userService.findAll();

        assertNotNull(result);
        assertEquals(3, result.size());
        verify(userDAO, times(1)).findAll();
    }

    @Test
    void findAll_shouldReturnEmptyList_whenNoUsers() {
        when(userDAO.findAll()).thenReturn(List.of());

        List<User> result = userService.findAll();

        assertNotNull(result);
        assertTrue(result.isEmpty());
        verify(userDAO, times(1)).findAll();
    }
}
