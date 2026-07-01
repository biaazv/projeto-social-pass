package com.fullstack.gympass.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Entity
@Table(name = "academia")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@SuppressWarnings("JpaDataSourceORMInspection")
public class Academia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_academia")
    private Integer idAcademia;

    @Column(nullable = false, length = 150)
    private String nome;

    @Column(nullable = false, length = 255)
    private String endereco;

    @Column(nullable = false, length = 100)
    private String bairro;

    @Column(length = 8)
    private String cep;

    @Column(nullable = false, unique = true, length = 14)
    private String cnpj;

    @Column(nullable = false, length = 20)
    private String telefone;

    @Enumerated(EnumType.STRING)
    @Column(name = "dias_funcionamento", nullable = false, length = 30)
    private DiasFuncionamento diasFuncionamento;

    @Column(name = "horario_abertura", nullable = false)
    private LocalTime horarioAbertura;

    @Column(name = "horario_fechamento", nullable = false)
    private LocalTime horarioFechamento;

    @Column(name = "possui_vestiario", nullable = false)
    private Boolean possuiVestiario;

    @ElementCollection
    @CollectionTable(
            name = "academia_tipo_atividade",
            joinColumns = @JoinColumn(name = "id_academia")
    )
    @Column(name = "tipo_atividade", nullable = false, length = 50)
    private List<String> tipoAtividade;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatusAcademia status;

    @Column(name = "data_cadastro", nullable = false, updatable = false)
    private LocalDateTime dataCadastro;

    @Column(name = "data_atualizacao", nullable = false)
    private LocalDateTime dataAtualizacao;

    @PrePersist
    public void prePersist() {
        LocalDateTime agora = LocalDateTime.now();
        this.dataCadastro = agora;
        this.dataAtualizacao = agora;

        if (this.status == null) {
            this.status = StatusAcademia.ATIVA;
        }
    }

    @PreUpdate
    public void preUpdate() {
        this.dataAtualizacao = LocalDateTime.now();
    }
}