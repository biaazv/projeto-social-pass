package com.fullstack.gympass.controller;

import com.fullstack.gympass.dto.AcademiaRequestDTO;
import com.fullstack.gympass.entity.Academia;
import com.fullstack.gympass.service.AcademiaService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/academias")
public class AcademiaController {

    private final AcademiaService academiaService;

    public AcademiaController(AcademiaService academiaService) {
        this.academiaService = academiaService;
    }

    @PostMapping
    public ResponseEntity<?> cadastrar(@RequestBody AcademiaRequestDTO dto) {
        try {
            Academia academia = academiaService.cadastrar(dto);
            return ResponseEntity.status(HttpStatus.CREATED).body(academia);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<List<Academia>> listar() {
        return ResponseEntity.ok(academiaService.listar());
    }
}