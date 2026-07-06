package com.fullstack.gympass.repository;

import com.fullstack.gympass.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
	boolean existsByEmailIgnoreCase(String email);
	boolean existsByNomeUsuarioIgnoreCase(String nomeUsuario);
	boolean existsByCpf(String cpf);
	boolean existsByEmailIgnoreCaseAndIdUsuarioNot(String email, Integer idUsuario);
	boolean existsByNomeUsuarioIgnoreCaseAndIdUsuarioNot(String nomeUsuario, Integer idUsuario);
	boolean existsByCpfAndIdUsuarioNot(String cpf, Integer idUsuario);
	Optional<Usuario> findByEmailIgnoreCase(String email);
}