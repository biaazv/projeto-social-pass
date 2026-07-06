package com.fullstack.gympass.dto;

import com.fullstack.gympass.entity.DiasFuncionamento;
import com.fullstack.gympass.entity.StatusAcademia;
import java.time.LocalTime;

public record AcademiaLoginResponse(
    Integer idAcademia,
    String nome,
    String cnpj,
    String email,
    String telefone,
    String endereco,
    String bairro,
    String cep,
    DiasFuncionamento diasFuncionamento,
    LocalTime horarioAbertura,
    LocalTime horarioFechamento,
    String horarioFuncionamento,
    Boolean possuiVestiario,
    StatusAcademia status
) {}
