package com.utp.dao.impl;

import com.utp.config.DatabaseConnection;
import com.utp.dao.AlumnoDAO;
import com.utp.dto.AlumnoDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AlumnoDAOImpl implements AlumnoDAO {
    @Override
    public List<AlumnoDTO> listarActivos() throws SQLException {
        String sql = "SELECT id_alumno, codigo, nombres, apellidos, correo, activo "
                + "FROM alumnos WHERE activo = TRUE ORDER BY apellidos, nombres";
        List<AlumnoDTO> alumnos = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {
            while (result.next()) {
                alumnos.add(map(result));
            }
        }
        return alumnos;
    }

    @Override
    public Optional<AlumnoDTO> buscarActivoPorId(Connection connection, Long idAlumno, boolean bloquear)
            throws SQLException {
        String sql = "SELECT id_alumno, codigo, nombres, apellidos, correo, activo "
                + "FROM alumnos WHERE id_alumno = ? AND activo = TRUE" + (bloquear ? " FOR UPDATE" : "");
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, idAlumno);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? Optional.of(map(result)) : Optional.empty();
            }
        }
    }

    private AlumnoDTO map(ResultSet result) throws SQLException {
        return new AlumnoDTO(result.getLong("id_alumno"), result.getString("codigo"),
                result.getString("nombres"), result.getString("apellidos"),
                result.getString("correo"), result.getBoolean("activo"));
    }
}
