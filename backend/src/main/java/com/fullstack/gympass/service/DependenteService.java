package com.fullstack.gympass.service;

import com.fullstack.gympass.entity.Dependente;
import com.fullstack.gympass.entity.Usuario;
import com.fullstack.gympass.repository.DependenteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DependenteService {

    private final DependenteRepository repository;
    private final UsuarioService usuarioService;

    public List<Dependente> listarTodos() {
        return repository.findAll();
    }

    public List<Dependente> listarPorUsuario(Integer idUsuario) {
        return repository.findByUsuarioIdUsuario(idUsuario);
    }

    public Dependente buscarPorId(Integer id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Dependente não encontrado: " + id));
    }

    public Dependente criar(Integer idUsuario, Dependente dependente) {
        Usuario usuario = usuarioService.buscarPorId(idUsuario);
        dependente.setUsuario(usuario);
        return repository.save(dependente);
    }

    public Dependente atualizar(Integer id, Dependente dados) {
        Dependente existente = buscarPorId(id);
        existente.setNome(dados.getNome());
        existente.setCpf(dados.getCpf());
        existente.setDataNascimento(dados.getDataNascimento());
        existente.setParentesco(dados.getParentesco());
        existente.setStatus(dados.getStatus());
        return repository.save(existente);
    }

    public void deletar(Integer id) {
        repository.deleteById(id);
    }
}
