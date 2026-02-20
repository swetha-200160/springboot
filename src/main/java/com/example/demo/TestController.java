package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    public TestController() {
        System.out.println(">>> TestController LOADED <<<");
    }

    @GetMapping("/")
    public String home() {
        return "Great question 👍 — this is exactly the right mindset for DevOps.

Let’s make this very concrete and provable, not hand-wavy.!";
    }

    @GetMapping("/health")
    public String health() {
        return "OK";
    }
}
