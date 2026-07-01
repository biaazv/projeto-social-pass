package com.fullstack.gympass.service;

import com.fullstack.gympass.dto.LoginRequest;
import com.fullstack.gympass.dto.LoginResponse;
import com.fullstack.gympass.entity.StatusConta;
import com.fullstack.gympass.entity.Usuario;
import com.fullstack.gympass.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository repository;

    public LoginResponse login(LoginRequest request) {
        if (request.cpf() == null || request.senha() == null) {
            throw new IllegalArgumentException("CPF e senha são obrigatórios.");
        }

        String cpfLimpo = request.cpf().replaceAll("\\D", "").trim();
        String senha = request.senha().trim();

        if (cpfLimpo.isEmpty() || senha.isEmpty()) {
            throw new IllegalArgumentException("CPF e senha são obrigatórios.");
        }

        Usuario usuario = repository.findByCpf(cpfLimpo)
                .orElseThrow(() -> new IllegalArgumentException("CPF ou senha inválidos."));

        if (!usuario.getSenha().equals(senha)) {
            throw new IllegalArgumentException("CPF ou senha inválidos.");
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
}