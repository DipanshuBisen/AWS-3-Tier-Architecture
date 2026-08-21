package com.example.loginapp.service;

import com.example.loginapp.model.User;
import com.example.loginapp.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testRegister() {
        User user = new User();
        user.setUsername("dipanshu");
        user.setPassword("password123");

        userService.register(user);

        verify(userRepository, times(1)).save(user);
    }

    @Test
    void testLoginSuccess() {

        User inputUser = new User();
        inputUser.setUsername("dipanshu");
        inputUser.setPassword("password123");

        User dbUser = new User();
        dbUser.setUsername("dipanshu");
        dbUser.setPassword("password123");

        when(userRepository.findByUsername("dipanshu")).thenReturn(dbUser);

        String result = userService.login(inputUser);

        assertEquals("Login Successful", result);
    }

    @Test
    void testLoginInvalidPassword() {

        User inputUser = new User();
        inputUser.setUsername("dipanshu");
        inputUser.setPassword("wrongpassword");

        User dbUser = new User();
        dbUser.setUsername("dipanshu");
        dbUser.setPassword("password123");

        when(userRepository.findByUsername("dipanshu")).thenReturn(dbUser);

        String result = userService.login(inputUser);

        assertEquals("Invalid Credentials", result);
    }

    @Test
    void testLoginUserNotFound() {

        User inputUser = new User();
        inputUser.setUsername("unknown");
        inputUser.setPassword("password");

        when(userRepository.findByUsername("unknown")).thenReturn(null);

        String result = userService.login(inputUser);

        assertEquals("Invalid Credentials", result);
    }

    @Test
    void testGetAllUsers() {

        User user1 = new User();
        user1.setUsername("user1");

        User user2 = new User();
        user2.setUsername("user2");

        List<User> users = Arrays.asList(user1, user2);

        when(userRepository.findAll()).thenReturn(users);

        List<User> result = userService.getAllUsers();

        assertEquals(2, result.size());
        verify(userRepository, times(1)).findAll();
    }
}