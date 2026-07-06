package com.fullstack.gympass.repository;

import com.fullstack.gympass.entity.Academia;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AcademiaRepository extends JpaRepository<Academia, Integer> {
    boolean existsByCnpj(String cnpj);
    Optional<Academia> findByCnpj(String cnpj);
}