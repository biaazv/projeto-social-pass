package com.fullstack.gympass.service;

import com.fullstack.gympass.dto.AcademiaRequestDTO;
import com.fullstack.gympass.entity.Academia;
import com.fullstack.gympass.entity.StatusAcademia;
import com.fullstack.gympass.repository.AcademiaRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AcademiaService {

    private final AcademiaRepository academiaRepository;
    private final PasswordEncoder passwordEncoder;

    public AcademiaService(AcademiaRepository academiaRepository, PasswordEncoder passwordEncoder) {
        this.academiaRepository = academiaRepository;
        this.passwordEncoder = passwordEncoder;
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

        if (dto.getSenha() != null && !dto.getSenha().isBlank()) {
            academia.setSenha(passwordEncoder.encode(dto.getSenha().trim()));
        }

        academia.setHorarioFuncionamento(academia.montarHorarioFuncionamento());

        return academiaRepository.save(academia);
    }

    public List<Academia> listar() {
        return academiaRepository.findAll();
    }
}