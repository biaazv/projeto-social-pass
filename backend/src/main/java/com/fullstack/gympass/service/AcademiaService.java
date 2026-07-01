package com.fullstack.gympass.service;

import com.fullstack.gympass.entity.Academia;
import com.fullstack.gympass.entity.StatusAcademia;
import com.fullstack.gympass.repository.AcademiaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AcademiaService {

    private final AcademiaRepository repository;

    public List<Academia> listarTodos() {
        return repository.findAll();
    }

    public Academia buscarPorId(Integer id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Academia não encontrada: " + id));
    }

    public Academia criar(Academia academia) {
        validarAcademia(academia);
        normalizarAcademia(academia);

        if (repository.existsByCnpj(academia.getCnpj())) {
            throw new IllegalArgumentException("Já existe academia cadastrada com este CNPJ.");
        }

        academia.setStatus(StatusAcademia.ATIVA);
        return repository.save(academia);
    }

    public Academia atualizar(Integer id, Academia dados) {
        Academia existente = buscarPorId(id);

        validarAcademia(dados);
        normalizarAcademia(dados);

        if (!existente.getCnpj().equals(dados.getCnpj()) && repository.existsByCnpj(dados.getCnpj())) {
            throw new IllegalArgumentException("Já existe academia cadastrada com este CNPJ.");
        }

        existente.setNome(dados.getNome());
        existente.setEndereco(dados.getEndereco());
        existente.setBairro(dados.getBairro());
        existente.setCep(dados.getCep());
        existente.setCnpj(dados.getCnpj());
        existente.setTelefone(dados.getTelefone());
        existente.setDiasFuncionamento(dados.getDiasFuncionamento());
        existente.setHorarioAbertura(dados.getHorarioAbertura());
        existente.setHorarioFechamento(dados.getHorarioFechamento());
        existente.setPossuiVestiario(dados.getPossuiVestiario());
        existente.setTipoAtividade(dados.getTipoAtividade());

        if (dados.getStatus() != null) {
            existente.setStatus(dados.getStatus());
        }

        return repository.save(existente);
    }

    public void deletar(Integer id) {
        repository.deleteById(id);
    }

    private void validarAcademia(Academia academia) {
        if (academia.getNome() == null || academia.getNome().isBlank()) {
            throw new IllegalArgumentException("Nome da academia é obrigatório.");
        }
        if (academia.getEndereco() == null || academia.getEndereco().isBlank()) {
            throw new IllegalArgumentException("Endereço é obrigatório.");
        }
        if (academia.getBairro() == null || academia.getBairro().isBlank()) {
            throw new IllegalArgumentException("Bairro é obrigatório.");
        }
        if (academia.getTelefone() == null || academia.getTelefone().isBlank()) {
            throw new IllegalArgumentException("Telefone é obrigatório.");
        }
        if (academia.getCnpj() == null || academia.getCnpj().isBlank()) {
            throw new IllegalArgumentException("CNPJ é obrigatório.");
        }
        if (academia.getDiasFuncionamento() == null) {
            throw new IllegalArgumentException("Dias de funcionamento é obrigatório.");
        }
        if (academia.getHorarioAbertura() == null) {
            throw new IllegalArgumentException("Horário de abertura é obrigatório.");
        }
        if (academia.getHorarioFechamento() == null) {
            throw new IllegalArgumentException("Horário de fechamento é obrigatório.");
        }
        if (!academia.getHorarioAbertura().isBefore(academia.getHorarioFechamento())) {
            throw new IllegalArgumentException("Horário de abertura deve ser menor que o horário de fechamento.");
        }
        if (academia.getPossuiVestiario() == null) {
            throw new IllegalArgumentException("Informe se a academia possui vestiário.");
        }
        if (academia.getTipoAtividade() == null || academia.getTipoAtividade().isEmpty()) {
            throw new IllegalArgumentException("Informe pelo menos um tipo de atividade.");
        }
    }

    private void normalizarAcademia(Academia academia) {
        academia.setNome(academia.getNome().trim());
        academia.setEndereco(academia.getEndereco().trim());
        academia.setBairro(academia.getBairro().trim());
        academia.setCep(limparNaoDigitos(academia.getCep()));
        academia.setCnpj(limparNaoDigitos(academia.getCnpj()));
        academia.setTelefone(limparNaoDigitos(academia.getTelefone()));
    }

    private String limparNaoDigitos(String valor) {
        return valor == null ? null : valor.replaceAll("\\D", "");
    }
}