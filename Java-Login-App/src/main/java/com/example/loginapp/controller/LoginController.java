package com.example.loginapp.controller;

import com.example.loginapp.model.User;
import com.example.loginapp.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
public class LoginController {

    @Autowired
    UserService service;

    @PostMapping("/register")
    public String register(@RequestBody User user) {
        service.register(user); // optional improvement
        return "User Registered";
    }

    @PostMapping("/login")
    public String login(@RequestBody User user) {
        return service.login(user);
    }

    @GetMapping("/users")
    public List<User> getAllUsers() {
        return service.getAllUsers();
    }
}