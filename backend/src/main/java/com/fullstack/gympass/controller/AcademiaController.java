package com.fullstack.gympass.controller;

import com.fullstack.gympass.entity.Academia;
import com.fullstack.gympass.service.AcademiaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/academias")
@RequiredArgsConstructor
public class AcademiaController {

    private final AcademiaService service;

    @GetMapping
    public List<Academia> listarTodos() {
        return service.listarTodos();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Academia> buscarPorId(@PathVariable Integer id) {
        return ResponseEntity.ok(service.buscarPorId(id));
    }

    @PostMapping
    public ResponseEntity<Academia> criar(@RequestBody Academia academia) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.criar(academia));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Academia> atualizar(@PathVariable Integer id, @RequestBody Academia academia) {
        return ResponseEntity.ok(service.atualizar(id, academia));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Integer id) {
        service.deletar(id);
        return ResponseEntity.noContent().build();
    }
}