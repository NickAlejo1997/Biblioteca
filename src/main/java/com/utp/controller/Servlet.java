package com.utp.controller;

import com.utp.dto.LibroDTO;
import com.utp.exception.BusinessException;
import com.utp.facade.BibliotecaFacade;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet(name = "BibliotecaServlet", urlPatterns = {"/", "/app", "/app/*"})
public class Servlet extends HttpServlet {
    private final BibliotecaFacade facade = new BibliotecaFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            switch (path(request)) {
                case "/", "/inicio" -> mostrarInicio(request, response);
                case "/libros" -> mostrarLibros(request, response);
                case "/libros/nuevo" -> forward(request, response, "/views/libro-form.jsp");
                case "/prestamos/nuevo" -> mostrarFormularioPrestamo(request, response);
                case "/prestamos" -> mostrarPrestamos(request, response);
                default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (BusinessException exception) {
            mostrarError(request, response, exception.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = path(request);
        try {
            switch (path) {
                case "/libros/guardar" -> guardarLibro(request, response);
                case "/prestamos/guardar" -> guardarPrestamo(request, response);
                case "/prestamos/devolver" -> devolverPrestamo(request, response);
                default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (BusinessException exception) {
            request.setAttribute("error", exception.getMessage());
            if ("/libros/guardar".equals(path)) {
                request.setAttribute("libro", libroDesdeRequest(request));
                forward(request, response, "/views/libro-form.jsp");
            } else if ("/prestamos/guardar".equals(path)) {
                try {
                    mostrarFormularioPrestamo(request, response);
                } catch (BusinessException reloadException) {
                    mostrarError(request, response, reloadException.getMessage());
                }
            } else {
                try {
                    mostrarPrestamos(request, response);
                } catch (BusinessException reloadException) {
                    mostrarError(request, response, reloadException.getMessage());
                }
            }
        }
    }

    private void mostrarInicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, BusinessException {
        var libros = facade.listarLibros("");
        var prestamosActivos = facade.listarPrestamosActivos();
        request.setAttribute("libros", libros);
        request.setAttribute("prestamosActivos", prestamosActivos);
        request.setAttribute("totalLibros", libros.size());
        request.setAttribute("totalPrestamosActivos", prestamosActivos.size());
        forward(request, response, "/index.jsp");
    }

    private void mostrarLibros(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, BusinessException {
        request.setAttribute("libros", facade.listarLibros(request.getParameter("q")));
        request.setAttribute("busqueda", request.getParameter("q"));
        forward(request, response, "/views/libros.jsp");
    }

    private void mostrarFormularioPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, BusinessException {
        request.setAttribute("libros", facade.listarLibrosDisponibles());
        request.setAttribute("alumnos", facade.listarAlumnosActivos());
        request.setAttribute("hoy", LocalDate.now());
        forward(request, response, "/views/prestamo-form.jsp");
    }

    private void mostrarPrestamos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, BusinessException {
        request.setAttribute("prestamosActivos", facade.listarPrestamosActivos());
        request.setAttribute("historial", facade.listarHistorialPrestamos());
        request.setAttribute("hoy", LocalDate.now());
        forward(request, response, "/views/prestamos.jsp");
    }

    private void guardarLibro(HttpServletRequest request, HttpServletResponse response)
            throws IOException, BusinessException {
        facade.registrarLibro(libroDesdeRequest(request));
        response.sendRedirect(request.getContextPath() + "/app/libros?ok=libro");
    }

    private void guardarPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws IOException, BusinessException {
        facade.registrarPrestamo(parseLong(request.getParameter("idAlumno")),
                parseLong(request.getParameter("idLibro")), parseDate(request.getParameter("fechaPrestamo")));
        response.sendRedirect(request.getContextPath() + "/app/prestamos?ok=prestamo");
    }

    private void devolverPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws IOException, BusinessException {
        facade.devolverPrestamo(parseLong(request.getParameter("idPrestamo")),
                parseDate(request.getParameter("fechaDevolucion")));
        response.sendRedirect(request.getContextPath() + "/app/prestamos?ok=devolucion");
    }

    private LibroDTO libroDesdeRequest(HttpServletRequest request) {
        return new LibroDTO(null, request.getParameter("titulo"), request.getParameter("autor"),
                request.getParameter("isbn"), "DISPONIBLE");
    }

    private Long parseLong(String value) throws BusinessException {
        try {
            return value == null || value.isBlank() ? null : Long.valueOf(value);
        } catch (NumberFormatException exception) {
            throw new BusinessException("El identificador enviado no es válido.");
        }
    }

    private LocalDate parseDate(String value) throws BusinessException {
        try {
            return value == null || value.isBlank() ? null : LocalDate.parse(value);
        } catch (Exception exception) {
            throw new BusinessException("La fecha enviada no es válida.");
        }
    }

    private String path(HttpServletRequest request) {
        String path = request.getPathInfo();
        return path == null || path.isBlank() ? "/" : path;
    }

    private void mostrarError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        forward(request, response, "/views/error.jsp");
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String view)
            throws ServletException, IOException {
        request.getRequestDispatcher(view).forward(request, response);
    }
}
