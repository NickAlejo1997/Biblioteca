package com.utp.dao;

import com.utp.dto.PrestamoDTO;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PrestamoDAO {
    void registrar(Connection connection, Long idAlumno, Long idLibro, LocalDate fecha) throws SQLException;

    List<PrestamoDTO> listarActivos() throws SQLException;

    List<PrestamoDTO> listarHistorial() throws SQLException;

    Optional<PrestamoDTO> buscarActivoPorId(Connection connection, Long idPrestamo, boolean bloquear) throws SQLException;

    void registrarDevolucion(Connection connection, Long idPrestamo, LocalDate fecha) throws SQLException;
}
