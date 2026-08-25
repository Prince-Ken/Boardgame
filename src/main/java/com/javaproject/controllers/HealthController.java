package com.javaproject.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

//nothing to do here, just a health check endpoint for the service

    @GetMapping("/health")
    public String health() {
        return "OK";
    }
}