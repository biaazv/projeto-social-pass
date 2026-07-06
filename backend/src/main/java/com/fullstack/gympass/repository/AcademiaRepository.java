package com.fullstack.gympass.repository;

import com.fullstack.gympass.entity.Academia;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AcademiaRepository extends JpaRepository<Academia, Integer> {
    boolean existsByCnpj(String cnpj);
}