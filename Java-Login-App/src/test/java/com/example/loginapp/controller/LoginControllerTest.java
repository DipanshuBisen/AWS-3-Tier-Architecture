package com.example.loginapp.controller;

import com.example.loginapp.model.User;
import com.example.loginapp.service.UserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class LoginControllerTest {

    @Mock
    private UserService service;

    @InjectMocks
    private LoginController controller;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testRegister() {
        User user = new User();
        user.setUsername("dipanshu");
        user.setPassword("password123");

        doNothing().when(service).register(user);

        String result = controller.register(user);

        assertEquals("User Registered", result);
        verify(service, times(1)).register(user);
    }

    @Test
    void testLoginSuccess() {
        User user = new User();
        user.setUsername("dipanshu");
        user.setPassword("password123");

        when(service.login(user)).thenReturn("Login Successful");

        String result = controller.login(user);

        assertEquals("Login Successful", result);
        verify(service, times(1)).login(user);
    }

    @Test
    void testGetAllUsers() {
        User user1 = new User();
        user1.setUsername("user1");

        User user2 = new User();
        user2.setUsername("user2");

        List<User> users = Arrays.asList(user1, user2);

        when(service.getAllUsers()).thenReturn(users);

        List<User> result = controller.getAllUsers();

        assertEquals(2, result.size());
        verify(service, times(1)).getAllUsers();
    }
}