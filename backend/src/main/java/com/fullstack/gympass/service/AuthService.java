package com.fullstack.gympass.service;

import com.fullstack.gympass.dto.AcademiaLoginRequest;
import com.fullstack.gympass.dto.LoginRequest;
import com.fullstack.gympass.dto.LoginResponse;
import com.fullstack.gympass.entity.Academia;
import com.fullstack.gympass.entity.StatusAcademia;
import com.fullstack.gympass.entity.StatusConta;
import com.fullstack.gympass.entity.Usuario;
import com.fullstack.gympass.repository.AcademiaRepository;
import com.fullstack.gympass.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository repository;
    private final AcademiaRepository academiaRepository;
    private final PasswordEncoder passwordEncoder;

    public LoginResponse login(LoginRequest request) {
        if (request == null || request.email() == null || request.senha() == null) {
            throw new IllegalArgumentException("Email e senha são obrigatórios.");
        }

        String email = request.email().trim().toLowerCase();
        String senha = request.senha().trim();

        if (email.isEmpty() || senha.isEmpty()) {
            throw new IllegalArgumentException("Email e senha são obrigatórios.");
        }

        Usuario usuario = repository.findByEmailIgnoreCase(email)
                .orElseThrow(() -> new IllegalArgumentException("Email ou senha inválidos."));

        if (!passwordEncoder.matches(senha, usuario.getSenha())) {
            throw new IllegalArgumentException("Email ou senha inválidos.");
        }

        if (usuario.getStatusConta() == StatusConta.BLOQUEADO) {
            throw new IllegalArgumentException("Conta bloqueada. Entre em contato com o suporte.");
        }

        if (usuario.getStatusConta() == StatusConta.INATIVO) {
            throw new IllegalArgumentException("Conta inativa.");
        }

        if (usuario.getStatusConta() == StatusConta.PENDENTE_VERIFICACAO) {
            throw new IllegalArgumentException("Conta pendente de verificação. Aguarde a ativação.");
        }

        return new LoginResponse(
                usuario.getIdUsuario(),
                usuario.getNomeCompleto(),
                usuario.getNomeUsuario(),
                usuario.getEmail(),
                usuario.getCpf(),
                usuario.getStatusConta()
        );
    }

    public Academia loginAcademia(AcademiaLoginRequest request) {
        if (request == null || request.cnpj() == null || request.senha() == null) {
            throw new IllegalArgumentException("CNPJ e senha são obrigatórios.");
        }

        String cnpj = request.cnpj().replaceAll("\\D", "");
        String senha = request.senha().trim();

        if (cnpj.isEmpty() || senha.isEmpty()) {
            throw new IllegalArgumentException("CNPJ e senha são obrigatórios.");
        }

        Academia academia = academiaRepository.findByCnpj(cnpj)
                .orElseThrow(() -> new IllegalArgumentException("CNPJ ou senha inválidos."));

        if (!passwordEncoder.matches(senha, academia.getSenha())) {
            throw new IllegalArgumentException("CNPJ ou senha inválidos.");
        }

        if (academia.getStatus() == StatusAcademia.INATIVA) {
            throw new IllegalArgumentException("Academia inativa.");
        }

        return academia;
    }
}