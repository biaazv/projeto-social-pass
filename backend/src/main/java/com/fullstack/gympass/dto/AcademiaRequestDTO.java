package com.fullstack.gympass.dto;

import com.fullstack.gympass.entity.DiasFuncionamento;
import com.fullstack.gympass.entity.StatusAcademia;
import java.time.LocalTime;

public class AcademiaRequestDTO {
    private String bairro;
    private String cep;
    private String cnpj;
    private String endereco;
    private String nome;
    private Boolean possuiVestiario;
    private String telefone;
    private String email;
    private DiasFuncionamento diasFuncionamento;
    private LocalTime horarioAbertura;
    private LocalTime horarioFechamento;
    private StatusAcademia status;
    private String senha;

    public String getBairro() { return bairro; }
    public void setBairro(String bairro) { this.bairro = bairro; }

    public String getCep() { return cep; }
    public void setCep(String cep) { this.cep = cep; }

    public String getCnpj() { return cnpj; }
    public void setCnpj(String cnpj) { this.cnpj = cnpj; }

    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public Boolean getPossuiVestiario() { return possuiVestiario; }
    public void setPossuiVestiario(Boolean possuiVestiario) { this.possuiVestiario = possuiVestiario; }

    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public DiasFuncionamento getDiasFuncionamento() { return diasFuncionamento; }
    public void setDiasFuncionamento(DiasFuncionamento diasFuncionamento) { this.diasFuncionamento = diasFuncionamento; }

    public LocalTime getHorarioAbertura() { return horarioAbertura; }
    public void setHorarioAbertura(LocalTime horarioAbertura) { this.horarioAbertura = horarioAbertura; }

    public LocalTime getHorarioFechamento() { return horarioFechamento; }
    public void setHorarioFechamento(LocalTime horarioFechamento) { this.horarioFechamento = horarioFechamento; }

    public StatusAcademia getStatus() { return status; }
    public void setStatus(StatusAcademia status) { this.status = status; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }
}