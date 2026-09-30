package com.utp.dao;

import com.utp.dto.LibroDTO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface LibroDAO {
    List<LibroDTO> listar(String busqueda) throws SQLException;

    List<LibroDTO> listarDisponibles() throws SQLException;

    Optional<LibroDTO> buscarPorId(Connection connection, Long idLibro, boolean bloquear) throws SQLException;

    void registrar(LibroDTO libro) throws SQLException;

    void actualizarEstado(Connection connection, Long idLibro, String estado) throws SQLException;
}
