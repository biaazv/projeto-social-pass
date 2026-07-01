package com.fullstack.gympass.dto;

import com.fullstack.gympass.entity.StatusConta;

public record LoginResponse(
        Integer idUsuario,
        String nomeCompleto,
        String nomeUsuario,
        String email,
        String cpf,
        StatusConta statusConta
) {}