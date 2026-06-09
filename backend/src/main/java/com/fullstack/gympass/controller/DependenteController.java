package com.fullstack.gympass.controller;

import com.fullstack.gympass.entity.Dependente;
import com.fullstack.gympass.service.DependenteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dependentes")
@RequiredArgsConstructor
public class DependenteController {

    private final DependenteService service;

    @GetMapping
    public List<Dependente> listarTodos() {
        return service.listarTodos();
    }

    @GetMapping("/usuario/{idUsuario}")
    public List<Dependente> listarPorUsuario(@PathVariable Integer idUsuario) {
        return service.listarPorUsuario(idUsuario);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Dependente> buscarPorId(@PathVariable Integer id) {
        return ResponseEntity.ok(service.buscarPorId(id));
    }

    @PostMapping("/usuario/{idUsuario}")
    public ResponseEntity<Dependente> criar(@PathVariable Integer idUsuario,
                                             @RequestBody Dependente dependente) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.criar(idUsuario, dependente));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Dependente> atualizar(@PathVariable Integer id,
                                                 @RequestBody Dependente dependente) {
        return ResponseEntity.ok(service.atualizar(id, dependente));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Integer id) {
        service.deletar(id);
        return ResponseEntity.noContent().build();
    }
}
