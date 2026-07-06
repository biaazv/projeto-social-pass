package com.fullstack.gympass.service;

import com.fullstack.gympass.dto.AcademiaRequestDTO;
import com.fullstack.gympass.entity.Academia;
import com.fullstack.gympass.entity.StatusAcademia;
import com.fullstack.gympass.repository.AcademiaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AcademiaService {

    private final AcademiaRepository academiaRepository;

    public AcademiaService(AcademiaRepository academiaRepository) {
        this.academiaRepository = academiaRepository;
    }

    public Academia cadastrar(AcademiaRequestDTO dto) {
        if (academiaRepository.existsByCnpj(dto.getCnpj())) {
            throw new IllegalArgumentException("CNPJ ja cadastrado.");
        }

        Academia academia = new Academia();
        academia.setBairro(dto.getBairro());
        academia.setCep(dto.getCep());
        academia.setCnpj(dto.getCnpj());
        academia.setEndereco(dto.getEndereco());
        academia.setNome(dto.getNome());
        academia.setPossuiVestiario(dto.getPossuiVestiario() != null ? dto.getPossuiVestiario() : Boolean.FALSE);
        academia.setTelefone(dto.getTelefone());
        academia.setEmail(dto.getEmail());
        academia.setDiasFuncionamento(dto.getDiasFuncionamento());
        academia.setHorarioAbertura(dto.getHorarioAbertura());
        academia.setHorarioFechamento(dto.getHorarioFechamento());
        academia.setStatus(dto.getStatus() != null ? dto.getStatus() : StatusAcademia.ATIVA);

        // Salva senha em texto plano
        academia.setSenha(dto.getSenha());

        academia.setHorarioFuncionamento(academia.montarHorarioFuncionamento());

        return academiaRepository.save(academia);
    }

    public List<Academia> listar() {
        return academiaRepository.findAll();
    }
}