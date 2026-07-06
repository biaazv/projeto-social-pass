package com.fullstack.gympass.controller;

import com.fullstack.gympass.dto.AcademiaLoginRequest;
import com.fullstack.gympass.dto.AcademiaLoginResponse;
import com.fullstack.gympass.dto.LoginRequest;
import com.fullstack.gympass.dto.LoginResponse;
import com.fullstack.gympass.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService service;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(service.login(request));
    }

    @PostMapping("/academias/login")
    public ResponseEntity<AcademiaLoginResponse> loginAcademia(@RequestBody AcademiaLoginRequest request) {
        return ResponseEntity.ok(service.loginAcademia(request));
    }
}