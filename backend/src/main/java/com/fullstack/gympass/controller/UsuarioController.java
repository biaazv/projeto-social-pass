package com.fullstack.gympass.controller;

import com.fullstack.gympass.entity.Usuario;
import com.fullstack.gympass.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioService service;

    @GetMapping
    public List<Usuario> listarTodos() {
        return service.listarTodos();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Usuario> buscarPorId(@PathVariable Integer id) {
        return ResponseEntity.ok(service.buscarPorId(id));
    }

    @PostMapping
    public ResponseEntity<Usuario> criar(@RequestBody Usuario usuario) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.criar(usuario));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Usuario> atualizar(@PathVariable Integer id, @RequestBody Usuario usuario) {
        return ResponseEntity.ok(service.atualizar(id, usuario));
    }

    @GetMapping("/checar/{campo}")
    public ResponseEntity<Map<String, Boolean>> checarDisponibilidade(@PathVariable String campo, @RequestParam String valor) {
        boolean disponivel = switch (campo.toLowerCase()) {
            case "email" -> service.emailDisponivel(valor);
            case "nomeusuario" -> service.nomeUsuarioDisponivel(valor);
            case "cpf" -> service.cpfDisponivel(valor);
            default -> throw new IllegalArgumentException("Campo inválido para checagem: " + campo);
        };

        return ResponseEntity.ok(Map.of("disponivel", disponivel));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Integer id) {
        service.deletar(id);
        return ResponseEntity.noContent().build();
    }
}
