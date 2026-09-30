package com.utp.dao.impl;

import com.utp.config.DatabaseConnection;
import com.utp.dao.PrestamoDAO;
import com.utp.dto.PrestamoDTO;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PrestamoDAOImpl implements PrestamoDAO {
    private static final String SELECT_FIELDS = "SELECT p.id_prestamo, p.id_alumno, p.id_libro, " + "a.codigo AS codigo_alumno, CONCAT(a.nombres, ' ', a.apellidos) AS alumno, " + "l.titulo, l.autor, l.isbn, p.fecha_prestamo, p.fecha_devolucion, p.estado " + "FROM prestamos p INNER JOIN alumnos a ON a.id_alumno = p.id_alumno " + "INNER JOIN libros l ON l.id_libro = p.id_libro ";

    @Override
    public void registrar(Connection connection, Long idAlumno, Long idLibro, LocalDate fecha) throws SQLException {
        String sql = "INSERT INTO prestamos (id_alumno, id_libro, fecha_prestamo, estado) " + "VALUES (?, ?, ?, 'ACTIVO')";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, idAlumno);
            statement.setLong(2, idLibro);
            statement.setDate(3, Date.valueOf(fecha));
            statement.executeUpdate();
        }
    }

    @Override
    public List<PrestamoDTO> listarActivos() throws SQLException {
        return listar(SELECT_FIELDS + "WHERE p.estado = 'ACTIVO' ORDER BY p.fecha_prestamo DESC");
    }

    @Override
    public List<PrestamoDTO> listarHistorial() throws SQLException {
        return listar(SELECT_FIELDS + "ORDER BY p.fecha_prestamo DESC, p.id_prestamo DESC");
    }

    @Override
    public Optional<PrestamoDTO> buscarActivoPorId(Connection connection, Long idPrestamo, boolean bloquear) throws SQLException {
        String sql = SELECT_FIELDS + "WHERE p.id_prestamo = ? AND p.estado = 'ACTIVO'" + (bloquear ? " FOR UPDATE" : "");
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, idPrestamo);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? Optional.of(map(result)) : Optional.empty();
            }
        }
    }

    @Override
    public void registrarDevolucion(Connection connection, Long idPrestamo, LocalDate fecha) throws SQLException {
        String sql = "UPDATE prestamos SET estado = 'DEVUELTO', fecha_devolucion = ? " + "WHERE id_prestamo = ? AND estado = 'ACTIVO'";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setDate(1, Date.valueOf(fecha));
            statement.setLong(2, idPrestamo);
            if (statement.executeUpdate() != 1) {
                throw new SQLException("El préstamo ya no está activo.");
            }
        }
    }

    private List<PrestamoDTO> listar(String sql) throws SQLException {
        List<PrestamoDTO> prestamos = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql); ResultSet result = statement.executeQuery()) {
            while (result.next()) {
                prestamos.add(map(result));
            }
        }
        return prestamos;
    }

    private PrestamoDTO map(ResultSet result) throws SQLException {
        PrestamoDTO dto = new PrestamoDTO();
        dto.setIdPrestamo(result.getLong("id_prestamo"));
        dto.setIdAlumno(result.getLong("id_alumno"));
        dto.setIdLibro(result.getLong("id_libro"));
        dto.setCodigoAlumno(result.getString("codigo_alumno"));
        dto.setAlumno(result.getString("alumno"));
        dto.setTitulo(result.getString("titulo"));
        dto.setAutor(result.getString("autor"));
        dto.setIsbn(result.getString("isbn"));
        Date fechaPrestamo = result.getDate("fecha_prestamo");
        Date fechaDevolucion = result.getDate("fecha_devolucion");
        dto.setFechaPrestamo(fechaPrestamo == null ? null : fechaPrestamo.toLocalDate());
        dto.setFechaDevolucion(fechaDevolucion == null ? null : fechaDevolucion.toLocalDate());
        dto.setEstado(result.getString("estado"));
        return dto;
    }
}
