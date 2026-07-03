package com.fullstack.gympass.dto;

import com.fullstack.gympass.entity.StatusAcademia;

public record LoginAcademiaResponse(
        Integer idAcademia,
        String nome,
        String cnpj,
        StatusAcademia status
) {}