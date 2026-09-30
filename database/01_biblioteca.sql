CREATE DATABASE biblioteca_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE biblioteca_db;

CREATE TABLE alumnos (
                         id_alumno BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                         codigo VARCHAR(20) NOT NULL,
                         nombres VARCHAR(80) NOT NULL,
                         apellidos VARCHAR(100) NOT NULL,
                         correo VARCHAR(150) NULL,
                         activo BOOLEAN NOT NULL DEFAULT TRUE,
                         creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                             ON UPDATE CURRENT_TIMESTAMP,
                         PRIMARY KEY (id_alumno),
                         CONSTRAINT uk_alumnos_codigo UNIQUE (codigo),
                         CONSTRAINT uk_alumnos_correo UNIQUE (correo),
                         CONSTRAINT ck_alumnos_nombres CHECK (CHAR_LENGTH(TRIM(nombres)) >= 2),
                         CONSTRAINT ck_alumnos_apellidos CHECK (CHAR_LENGTH(TRIM(apellidos)) >= 2)
) ENGINE = INNODB;

CREATE TABLE libros (
                        id_libro BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                        titulo VARCHAR(200) NOT NULL,
                        autor VARCHAR(150) NOT NULL,
                        isbn VARCHAR(20) NOT NULL,
                        estado VARCHAR(15) NOT NULL DEFAULT 'DISPONIBLE',
                        creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                            ON UPDATE CURRENT_TIMESTAMP,
                        PRIMARY KEY (id_libro),
                        CONSTRAINT uk_libros_isbn UNIQUE (isbn),
                        CONSTRAINT ck_libros_titulo CHECK (CHAR_LENGTH(TRIM(titulo)) >= 2),
                        CONSTRAINT ck_libros_autor CHECK (CHAR_LENGTH(TRIM(autor)) >= 2),
                        CONSTRAINT ck_libros_estado CHECK (estado IN ('DISPONIBLE', 'PRESTADO'))
) ENGINE = InnoDB;

CREATE TABLE prestamos (
                           id_prestamo BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                           id_alumno BIGINT UNSIGNED NOT NULL,
                           id_libro BIGINT UNSIGNED NOT NULL,
                           fecha_prestamo DATE NOT NULL,
                           fecha_devolucion DATE NULL,
                           estado VARCHAR(10) NOT NULL DEFAULT 'ACTIVO',
                           creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                               ON UPDATE CURRENT_TIMESTAMP,
                           PRIMARY KEY (id_prestamo),
                           CONSTRAINT fk_prestamos_alumnos
                               FOREIGN KEY (id_alumno)
                                   REFERENCES alumnos (id_alumno)
                                   ON UPDATE CASCADE
                                   ON DELETE RESTRICT,
                           CONSTRAINT fk_prestamos_libros
                               FOREIGN KEY (id_libro)
                                   REFERENCES libros (id_libro)
                                   ON UPDATE CASCADE
                                   ON DELETE RESTRICT,
                           CONSTRAINT ck_prestamos_estado CHECK (estado IN ('ACTIVO', 'DEVUELTO')),
                           CONSTRAINT ck_prestamos_fechas CHECK (
                               fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo
                               ),
                           CONSTRAINT ck_prestamos_coherencia CHECK (
                               (estado = 'ACTIVO' AND fecha_devolucion IS NULL)
                                   OR
                               (estado = 'DEVUELTO' AND fecha_devolucion IS NOT NULL)
                               )
) ENGINE = InnoDB;

CREATE INDEX idx_libros_titulo ON libros (titulo);
CREATE INDEX idx_libros_autor ON libros (autor);
CREATE INDEX idx_libros_estado ON libros (estado);
CREATE INDEX idx_prestamos_alumno_estado ON prestamos (id_alumno, estado);
CREATE INDEX idx_prestamos_libro_estado ON prestamos (id_libro, estado);
CREATE INDEX idx_prestamos_fecha ON prestamos (fecha_prestamo);

CREATE OR REPLACE VIEW v_prestamos_activos AS
SELECT
    p.id_prestamo,
    p.fecha_prestamo,
    a.id_alumno,
    a.codigo AS codigo_alumno,
    CONCAT(a.nombres, ' ', a.apellidos) AS alumno,
    l.id_libro,
    l.titulo,
    l.autor,
    l.isbn
FROM prestamos p
         INNER JOIN alumnos a ON a.id_alumno = p.id_alumno
         INNER JOIN libros l ON l.id_libro = p.id_libro
WHERE p.estado = 'ACTIVO';

INSERT IGNORE INTO alumnos (codigo, nombres, apellidos, correo) VALUES
    ('ALU001', 'Ana', 'García López', 'ana.garcia@ejemplo.com'),
    ('ALU002', 'Luis', 'Pérez Torres', 'luis.perez@ejemplo.com'),
    ('ALU003', 'María', 'Quispe Rojas', 'maria.quispe@ejemplo.com');

INSERT IGNORE INTO libros (titulo, autor, isbn, estado) VALUES
    ('Cien años de soledad', 'Gabriel García Márquez', '9780307474728', 'DISPONIBLE'),
    ('Don Quijote de la Mancha', 'Miguel de Cervantes', '9788420412146', 'DISPONIBLE'),
    ('El principito', 'Antoine de Saint-Exupéry', '9780156012195', 'DISPONIBLE');