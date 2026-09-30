package com.utp.dao;

import com.utp.dto.AlumnoDTO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface AlumnoDAO {
    List<AlumnoDTO> listarActivos() throws SQLException;

    Optional<AlumnoDTO> buscarActivoPorId(Connection connection, Long idAlumno, boolean bloquear) throws SQLException;
}
