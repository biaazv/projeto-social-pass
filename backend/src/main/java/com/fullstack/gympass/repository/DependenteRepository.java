package com.fullstack.gympass.repository;

import com.fullstack.gympass.entity.Dependente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DependenteRepository extends JpaRepository<Dependente, Integer> {
    List<Dependente> findByUsuarioIdUsuario(Integer idUsuario);
}
