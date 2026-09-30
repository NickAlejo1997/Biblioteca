package com.utp.facade;

import com.utp.config.DatabaseConnection;
import com.utp.dao.AlumnoDAO;
import com.utp.dao.LibroDAO;
import com.utp.dao.PrestamoDAO;
import com.utp.dao.impl.AlumnoDAOImpl;
import com.utp.dao.impl.LibroDAOImpl;
import com.utp.dao.impl.PrestamoDAOImpl;
import com.utp.dto.AlumnoDTO;
import com.utp.dto.LibroDTO;
import com.utp.dto.PrestamoDTO;
import com.utp.exception.BusinessException;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;


public class BibliotecaFacade {
    private final LibroDAO libroDAO = new LibroDAOImpl();
    private final AlumnoDAO alumnoDAO = new AlumnoDAOImpl();
    private final PrestamoDAO prestamoDAO = new PrestamoDAOImpl();

    public List<LibroDTO> listarLibros(String busqueda) throws BusinessException {
        try {
            return libroDAO.listar(busqueda);
        } catch (SQLException exception) {
            throw databaseError("No se pudieron consultar los libros.", exception);
        }
    }

    public List<LibroDTO> listarLibrosDisponibles() throws BusinessException {
        try {
            return libroDAO.listarDisponibles();
        } catch (SQLException exception) {
            throw databaseError("No se pudieron consultar los libros disponibles.", exception);
        }
    }

    public void registrarLibro(LibroDTO libro) throws BusinessException {
        validarTexto(libro.getTitulo(), "El título es obligatorio.");
        validarTexto(libro.getAutor(), "El autor es obligatorio.");
        validarTexto(libro.getIsbn(), "El ISBN es obligatorio.");
        try {
            libroDAO.registrar(libro);
        } catch (SQLException exception) {
            if (exception.getMessage() != null && exception.getMessage().contains("Duplicate")) {
                throw new BusinessException("Ya existe un libro con ese ISBN.");
            }
            throw databaseError("No se pudo registrar el libro.", exception);
        }
    }

    public List<AlumnoDTO> listarAlumnosActivos() throws BusinessException {
        try {
            return alumnoDAO.listarActivos();
        } catch (SQLException exception) {
            throw databaseError("No se pudieron consultar los alumnos.", exception);
        }
    }

    public List<PrestamoDTO> listarPrestamosActivos() throws BusinessException {
        try {
            return prestamoDAO.listarActivos();
        } catch (SQLException exception) {
            throw databaseError("No se pudieron consultar los préstamos activos.", exception);
        }
    }

    public List<PrestamoDTO> listarHistorialPrestamos() throws BusinessException {
        try {
            return prestamoDAO.listarHistorial();
        } catch (SQLException exception) {
            throw databaseError("No se pudo consultar el historial de préstamos.", exception);
        }
    }

    public void registrarPrestamo(Long idAlumno, Long idLibro, LocalDate fecha) throws BusinessException {
        if (idAlumno == null || idLibro == null) throw new BusinessException("Debe seleccionar un alumno y un libro.");
        if (fecha == null) throw new BusinessException("La fecha del préstamo es obligatoria.");
        if (fecha.isAfter(LocalDate.now())) throw new BusinessException("La fecha del préstamo no puede ser futura.");

        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                alumnoDAO.buscarActivoPorId(connection, idAlumno, true)
                        .orElseThrow(() -> new BusinessException("El alumno seleccionado no existe o está inactivo."));
                LibroDTO libro = libroDAO.buscarPorId(connection, idLibro, true)
                        .orElseThrow(() -> new BusinessException("El libro seleccionado no existe."));
                if (!"DISPONIBLE".equals(libro.getEstado())) {
                    throw new BusinessException("El libro seleccionado ya tiene un préstamo activo.");
                }
                prestamoDAO.registrar(connection, idAlumno, idLibro, fecha);
                libroDAO.actualizarEstado(connection, idLibro, "PRESTADO");
                connection.commit();
            } catch (Exception exception) {
                connection.rollback();
                if (exception instanceof BusinessException businessException) throw businessException;
                throw exception;
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (BusinessException exception) {
            throw exception;
        } catch (SQLException exception) {
            throw databaseError("No se pudo registrar el préstamo.", exception);
        }
    }

    public void devolverPrestamo(Long idPrestamo, LocalDate fecha) throws BusinessException {
        if (idPrestamo == null || fecha == null) {
            throw new BusinessException("El préstamo y la fecha de devolución son obligatorios.");
        }
        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                PrestamoDTO prestamo = prestamoDAO.buscarActivoPorId(connection, idPrestamo, true)
                        .orElseThrow(() -> new BusinessException("El préstamo no existe o ya fue devuelto."));
                if (fecha.isBefore(prestamo.getFechaPrestamo())) {
                    throw new BusinessException("La devolución no puede ser anterior al préstamo.");
                }
                prestamoDAO.registrarDevolucion(connection, idPrestamo, fecha);
                libroDAO.actualizarEstado(connection, prestamo.getIdLibro(), "DISPONIBLE");
                connection.commit();
            } catch (Exception exception) {
                connection.rollback();
                if (exception instanceof BusinessException businessException) throw businessException;
                throw exception;
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (BusinessException exception) {
            throw exception;
        } catch (SQLException exception) {
            throw databaseError("No se pudo registrar la devolución.", exception);
        }
    }

    private void validarTexto(String valor, String mensaje) throws BusinessException {
        if (valor == null || valor.isBlank()) throw new BusinessException(mensaje);
    }

    private BusinessException databaseError(String message, SQLException cause) {
        return new BusinessException(message + " Verifica que MySQL esté activo y que la configuración sea correcta.", cause);
    }
}
