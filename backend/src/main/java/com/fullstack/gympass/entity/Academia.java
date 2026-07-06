package com.fullstack.gympass.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.time.LocalTime;

@Getter
@Setter
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "academia")
public class Academia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_academia")
    private Integer idAcademia;

    @Column(name = "bairro", nullable = false, length = 100)
    private String bairro;

    @Column(name = "cep", length = 8)
    private String cep;

    @Column(name = "cnpj", nullable = false, length = 14, unique = true)
    private String cnpj;

    @Column(name = "data_atualizacao", nullable = false)
    private LocalDateTime dataAtualizacao;

    @Column(name = "data_cadastro", nullable = false)
    private LocalDateTime dataCadastro;

    @Column(name = "endereco", nullable = false, length = 255)
    private String endereco;

    @Column(name = "horario_funcionamento", nullable = false, length = 120)
    private String horarioFuncionamento;

    @Column(name = "nome", nullable = false, length = 150)
    private String nome;

    @Column(name = "possui_vestiario", nullable = false)
    private Boolean possuiVestiario;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private StatusAcademia status;

    @Column(name = "telefone", nullable = false, length = 20)
    private String telefone;

    @Column(name = "email", nullable = false, length = 255, unique = true)
    private String email;

    @Column(name = "senha", nullable = false, length = 255)
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String senha;

    @Enumerated(EnumType.STRING)
    @Column(name = "dias_funcionamento", nullable = false)
    private DiasFuncionamento diasFuncionamento;

    @Column(name = "horario_abertura", nullable = false)
    private LocalTime horarioAbertura;

    @Column(name = "horario_fechamento", nullable = false)
    private LocalTime horarioFechamento;

    @PrePersist
    public void prePersist() {
        LocalDateTime agora = LocalDateTime.now();
        if (dataCadastro == null) {
            dataCadastro = agora;
        }
        dataAtualizacao = agora;

        if (status == null) {
            status = StatusAcademia.ATIVA;
        }

        if (horarioFuncionamento == null || horarioFuncionamento.isBlank()) {
            horarioFuncionamento = montarHorarioFuncionamento();
        }
    }

    @PreUpdate
    public void preUpdate() {
        dataAtualizacao = LocalDateTime.now();
        horarioFuncionamento = montarHorarioFuncionamento();
    }

    public String montarHorarioFuncionamento() {
        String dias = diasFuncionamento != null ? diasFuncionamento.name() : "";
        String abertura = horarioAbertura != null ? horarioAbertura.toString() : "";
        String fechamento = horarioFechamento != null ? horarioFechamento.toString() : "";

        if (!dias.isEmpty() && !abertura.isEmpty() && !fechamento.isEmpty()) {
            return dias + " " + abertura + "-" + fechamento;
        }
        if (!abertura.isEmpty() && !fechamento.isEmpty()) {
            return abertura + "-" + fechamento;
        }
        return "HORARIO_NAO_INFORMADO";
    }
}