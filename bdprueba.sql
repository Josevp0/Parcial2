-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-10-2024 a las 23:16:03
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bdprueba`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administradores`
--

CREATE TABLE `administradores` (
  `admin_id` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `nombre_completo` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `administradores`
--

INSERT INTO `administradores` (`admin_id`, `nombre_usuario`, `contrasena`, `correo`, `nombre_completo`) VALUES
(3, 'admin', '1234', 'admin@example.com', 'ADMINISTRADOR');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `anteproyectos`
--

CREATE TABLE `anteproyectos` (
  `anteproyecto_id` int(11) NOT NULL,
  `idea_id` int(11) NOT NULL,
  `estudiante_id` int(11) NOT NULL,
  `director_id` int(11) DEFAULT NULL,
  `evaluador_id` int(11) DEFAULT NULL,
  `estado` varchar(50) NOT NULL,
  `url_subida` varchar(255) DEFAULT NULL,
  `nombre_estudiante` varchar(100) DEFAULT NULL,
  `nombre_evaluador` varchar(100) DEFAULT NULL,
  `nombre_director` varchar(100) DEFAULT NULL,
  `calificacion_director` decimal(4,2) DEFAULT NULL,
  `calificacion_evaluador` decimal(4,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificacionesdirector`
--

CREATE TABLE `calificacionesdirector` (
  `calificacion_director_id` int(11) NOT NULL,
  `anteproyecto_id` int(11) NOT NULL,
  `director_id` int(11) NOT NULL,
  `fecha_evaluacion` date NOT NULL,
  `calificacion_director` decimal(4,2) DEFAULT NULL,
  `comentarios_director` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificacionesevaluador`
--

CREATE TABLE `calificacionesevaluador` (
  `calificacion_evaluador_id` int(11) NOT NULL,
  `anteproyecto_id` int(11) NOT NULL,
  `evaluador_id` int(11) NOT NULL,
  `fecha_evaluacion` date NOT NULL,
  `calificacion_evaluador` decimal(4,2) DEFAULT NULL,
  `comentarios_evaluador` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `coordinadores`
--

CREATE TABLE `coordinadores` (
  `coordinador_id` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `nombre_completo` varchar(100) NOT NULL,
  `departamento` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `director`
--

CREATE TABLE `director` (
  `director_id` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `nombre_completo` varchar(100) NOT NULL,
  `departamento` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiantes`
--

CREATE TABLE `estudiantes` (
  `estudiante_id` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `nombre_completo` varchar(100) NOT NULL,
  `codigo_estudiante` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `evaluador`
--

CREATE TABLE `evaluador` (
  `evaluador_id` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `nombre_completo` varchar(100) NOT NULL,
  `departamento` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ideasanteproyecto`
--

CREATE TABLE `ideasanteproyecto` (
  `idea_id` int(11) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `estado` varchar(50) NOT NULL,
  `fecha_creacion` date NOT NULL,
  `coordinador_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administradores`
--
ALTER TABLE `administradores`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `anteproyectos`
--
ALTER TABLE `anteproyectos`
  ADD PRIMARY KEY (`anteproyecto_id`),
  ADD KEY `idea_id` (`idea_id`),
  ADD KEY `estudiante_id` (`estudiante_id`),
  ADD KEY `evaluador_id` (`evaluador_id`),
  ADD KEY `director_id` (`director_id`);

--
-- Indices de la tabla `calificacionesdirector`
--
ALTER TABLE `calificacionesdirector`
  ADD PRIMARY KEY (`calificacion_director_id`),
  ADD KEY `anteproyecto_id` (`anteproyecto_id`),
  ADD KEY `director_id` (`director_id`);

--
-- Indices de la tabla `calificacionesevaluador`
--
ALTER TABLE `calificacionesevaluador`
  ADD PRIMARY KEY (`calificacion_evaluador_id`),
  ADD KEY `anteproyecto_id` (`anteproyecto_id`),
  ADD KEY `evaluador_id` (`evaluador_id`);

--
-- Indices de la tabla `coordinadores`
--
ALTER TABLE `coordinadores`
  ADD PRIMARY KEY (`coordinador_id`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `director`
--
ALTER TABLE `director`
  ADD PRIMARY KEY (`director_id`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`estudiante_id`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD UNIQUE KEY `codigo_estudiante` (`codigo_estudiante`);

--
-- Indices de la tabla `evaluador`
--
ALTER TABLE `evaluador`
  ADD PRIMARY KEY (`evaluador_id`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `ideasanteproyecto`
--
ALTER TABLE `ideasanteproyecto`
  ADD PRIMARY KEY (`idea_id`),
  ADD KEY `coordinador_id` (`coordinador_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `administradores`
--
ALTER TABLE `administradores`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `anteproyectos`
--
ALTER TABLE `anteproyectos`
  MODIFY `anteproyecto_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `calificacionesdirector`
--
ALTER TABLE `calificacionesdirector`
  MODIFY `calificacion_director_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `calificacionesevaluador`
--
ALTER TABLE `calificacionesevaluador`
  MODIFY `calificacion_evaluador_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `coordinadores`
--
ALTER TABLE `coordinadores`
  MODIFY `coordinador_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `director`
--
ALTER TABLE `director`
  MODIFY `director_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  MODIFY `estudiante_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `evaluador`
--
ALTER TABLE `evaluador`
  MODIFY `evaluador_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ideasanteproyecto`
--
ALTER TABLE `ideasanteproyecto`
  MODIFY `idea_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `anteproyectos`
--
ALTER TABLE `anteproyectos`
  ADD CONSTRAINT `anteproyectos_ibfk_1` FOREIGN KEY (`idea_id`) REFERENCES `ideasanteproyecto` (`idea_id`),
  ADD CONSTRAINT `anteproyectos_ibfk_2` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`estudiante_id`),
  ADD CONSTRAINT `anteproyectos_ibfk_3` FOREIGN KEY (`director_id`) REFERENCES `director` (`director_id`),
  ADD CONSTRAINT `anteproyectos_ibfk_4` FOREIGN KEY (`evaluador_id`) REFERENCES `evaluador` (`evaluador_id`),
  ADD CONSTRAINT `anteproyectos_ibfk_5` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`estudiante_id`),
  ADD CONSTRAINT `anteproyectos_ibfk_6` FOREIGN KEY (`evaluador_id`) REFERENCES `evaluador` (`evaluador_id`),
  ADD CONSTRAINT `anteproyectos_ibfk_7` FOREIGN KEY (`director_id`) REFERENCES `director` (`director_id`);

--
-- Filtros para la tabla `calificacionesdirector`
--
ALTER TABLE `calificacionesdirector`
  ADD CONSTRAINT `calificacionesdirector_ibfk_1` FOREIGN KEY (`anteproyecto_id`) REFERENCES `anteproyectos` (`anteproyecto_id`),
  ADD CONSTRAINT `calificacionesdirector_ibfk_2` FOREIGN KEY (`director_id`) REFERENCES `director` (`director_id`);

--
-- Filtros para la tabla `calificacionesevaluador`
--
ALTER TABLE `calificacionesevaluador`
  ADD CONSTRAINT `calificacionesevaluador_ibfk_1` FOREIGN KEY (`anteproyecto_id`) REFERENCES `anteproyectos` (`anteproyecto_id`),
  ADD CONSTRAINT `calificacionesevaluador_ibfk_2` FOREIGN KEY (`evaluador_id`) REFERENCES `evaluador` (`evaluador_id`);

--
-- Filtros para la tabla `ideasanteproyecto`
--
ALTER TABLE `ideasanteproyecto`
  ADD CONSTRAINT `ideasanteproyecto_ibfk_1` FOREIGN KEY (`coordinador_id`) REFERENCES `coordinadores` (`coordinador_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
