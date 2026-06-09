package com.fullstack.gympass.service;

import com.fullstack.gympass.entity.Usuario;
import com.fullstack.gympass.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository repository;
    private final PasswordEncoder passwordEncoder;

    public List<Usuario> listarTodos() {
        return repository.findAll();
    }

    public Usuario buscarPorId(Integer id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado: " + id));
    }

    public Usuario criar(Usuario usuario) {
        validarCamposObrigatorios(
                usuario.getNomeCompleto(),
                usuario.getEmail(),
                usuario.getNomeUsuario(),
                usuario.getSenha(),
                usuario.getCpf(),
                usuario.getDataNascimento()
        );
        validarDuplicidadeCadastro(usuario.getEmail(), usuario.getNomeUsuario(), usuario.getCpf());

        normalizarUsuario(usuario);
        return repository.save(usuario);
    }

    public Usuario atualizar(Integer id, Usuario dados) {
        Usuario existente = buscarPorId(id);

        validarCamposObrigatorios(dados.getNomeCompleto(), dados.getEmail(), dados.getNomeUsuario(), "senha-opcional", dados.getCpf(), dados.getDataNascimento());
        validarDuplicidadeAtualizacao(id, dados.getEmail(), dados.getNomeUsuario(), dados.getCpf());

        existente.setNomeCompleto(dados.getNomeCompleto().trim());
        existente.setEmail(normalizarEmail(dados.getEmail()));
        existente.setNomeUsuario(dados.getNomeUsuario().trim());
        existente.setTelefone(normalizarTelefone(dados.getTelefone()));
        existente.setCpf(normalizarCpf(dados.getCpf()));
        existente.setDataNascimento(dados.getDataNascimento());

        if (dados.getStatusConta() != null) {
            existente.setStatusConta(dados.getStatusConta());
        }
        if (dados.getSenha() != null && !dados.getSenha().isBlank()) {
            existente.setSenha(passwordEncoder.encode(dados.getSenha().trim()));
        }

        return repository.save(existente);
    }

    public void deletar(Integer id) {
        repository.deleteById(id);
    }

    public boolean emailDisponivel(String email) {
        return !repository.existsByEmailIgnoreCase(normalizarEmail(email));
    }

    public boolean nomeUsuarioDisponivel(String nomeUsuario) {
        return !repository.existsByNomeUsuarioIgnoreCase(normalizarNomeUsuario(nomeUsuario));
    }

    public boolean cpfDisponivel(String cpf) {
        return !repository.existsByCpf(normalizarCpf(cpf));
    }

    private void normalizarUsuario(Usuario usuario) {
        usuario.setNomeCompleto(usuario.getNomeCompleto().trim());
        usuario.setEmail(normalizarEmail(usuario.getEmail()));
        usuario.setNomeUsuario(usuario.getNomeUsuario().trim());
        usuario.setSenha(passwordEncoder.encode(usuario.getSenha().trim()));
        usuario.setTelefone(normalizarTelefone(usuario.getTelefone()));
        usuario.setCpf(normalizarCpf(usuario.getCpf()));
    }

    private void validarCamposObrigatorios(String nomeCompleto, String email, String nomeUsuario, String senha, String cpf, LocalDate dataNascimento) {
        if (isBlank(nomeCompleto) || isBlank(email) || isBlank(nomeUsuario) || isBlank(cpf)) {
            throw new IllegalArgumentException("Nome completo, email, nome de usuário e CPF são obrigatórios.");
        }
        if (dataNascimento == null) {
            throw new IllegalArgumentException("Data de nascimento é obrigatória.");
        }
        if (dataNascimento.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Data de nascimento não pode ser no futuro.");
        }

        if (!"senha-opcional".equals(senha) && isBlank(senha)) {
            throw new IllegalArgumentException("Senha é obrigatória para criação.");
        }
    }

    private void validarDuplicidadeCadastro(String email, String nomeUsuario, String cpf) {
        if (repository.existsByEmailIgnoreCase(normalizarEmail(email))) {
            throw new IllegalArgumentException("Já existe usuário com este email.");
        }
        if (repository.existsByNomeUsuarioIgnoreCase(nomeUsuario.trim())) {
            throw new IllegalArgumentException("Já existe usuário com este nome de usuário.");
        }
        if (repository.existsByCpf(normalizarCpf(cpf))) {
            throw new IllegalArgumentException("Já existe usuário com este CPF.");
        }
    }

    private void validarDuplicidadeAtualizacao(Integer id, String email, String nomeUsuario, String cpf) {
        if (repository.existsByEmailIgnoreCaseAndIdUsuarioNot(normalizarEmail(email), id)) {
            throw new IllegalArgumentException("Já existe usuário com este email.");
        }
        if (repository.existsByNomeUsuarioIgnoreCaseAndIdUsuarioNot(nomeUsuario.trim(), id)) {
            throw new IllegalArgumentException("Já existe usuário com este nome de usuário.");
        }
        if (repository.existsByCpfAndIdUsuarioNot(normalizarCpf(cpf), id)) {
            throw new IllegalArgumentException("Já existe usuário com este CPF.");
        }
    }

    private String normalizarEmail(String email) {
        return email == null ? null : email.trim().toLowerCase();
    }

    private String normalizarTelefone(String telefone) {
        return telefone == null ? null : telefone.trim();
    }

    private String normalizarNomeUsuario(String nomeUsuario) {
        return nomeUsuario == null ? null : nomeUsuario.trim();
    }

    private String normalizarCpf(String cpf) {
        return cpf == null ? null : cpf.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
