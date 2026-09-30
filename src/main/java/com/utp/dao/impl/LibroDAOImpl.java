package com.utp.dao.impl;

import com.utp.config.DatabaseConnection;
import com.utp.dao.LibroDAO;
import com.utp.dto.LibroDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class LibroDAOImpl implements LibroDAO {
    private static final String SELECT_FIELDS = "SELECT id_libro, titulo, autor, isbn, estado FROM libros ";

    @Override
    public List<LibroDTO> listar(String busqueda) throws SQLException {
        String sql = SELECT_FIELDS + "WHERE (? = '' OR LOWER(titulo) LIKE ? OR LOWER(autor) LIKE ? OR isbn LIKE ?) "
                + "ORDER BY titulo";
        String filtro = busqueda == null ? "" : busqueda.trim().toLowerCase();
        String like = "%" + filtro + "%";
        List<LibroDTO> libros = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, filtro);
            statement.setString(2, like);
            statement.setString(3, like);
            statement.setString(4, like);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    libros.add(map(result));
                }
            }
        }
        return libros;
    }

    @Override
    public List<LibroDTO> listarDisponibles() throws SQLException {
        String sql = SELECT_FIELDS + "WHERE estado = 'DISPONIBLE' ORDER BY titulo";
        List<LibroDTO> libros = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {
            while (result.next()) {
                libros.add(map(result));
            }
        }
        return libros;
    }

    @Override
    public Optional<LibroDTO> buscarPorId(Connection connection, Long idLibro, boolean bloquear) throws SQLException {
        String sql = SELECT_FIELDS + "WHERE id_libro = ?" + (bloquear ? " FOR UPDATE" : "");
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, idLibro);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? Optional.of(map(result)) : Optional.empty();
            }
        }
    }

    @Override
    public void registrar(LibroDTO libro) throws SQLException {
        String sql = "INSERT INTO libros (titulo, autor, isbn, estado) VALUES (?, ?, ?, 'DISPONIBLE')";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, libro.getTitulo());
            statement.setString(2, libro.getAutor());
            statement.setString(3, libro.getIsbn());
            statement.executeUpdate();
        }
    }

    @Override
    public void actualizarEstado(Connection connection, Long idLibro, String estado) throws SQLException {
        String sql = "UPDATE libros SET estado = ? WHERE id_libro = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, estado);
            statement.setLong(2, idLibro);
            statement.executeUpdate();
        }
    }

    private LibroDTO map(ResultSet result) throws SQLException {
        return new LibroDTO(result.getLong("id_libro"), result.getString("titulo"),
                result.getString("autor"), result.getString("isbn"), result.getString("estado"));
    }
}
