<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="WEB-INF/lib/conexion.jspf" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Evaluador</title>
    <link rel="stylesheet" href="css/evaluador_dashboard.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="welcome-message">
                <h2>Bienvenido</h2>
                <img src="img/avatar.png" alt="Avatar Evaluador" class="avatar">
                <p>${sessionScope.user.nombre_completo}</p>
            </div>
            <nav>
                <ul>
                    <li><a href="#anteproyectos" class="tab-link" data-tab="anteproyectos">Anteproyectos</a></li>
                    <li><a href="#crud-informacion-alumno" class="tab-link" data-tab="crud-informacion-alumno">Información de Alumnos</a></li>
                    <li><a href="#calendario-formatos" class="tab-link" data-tab="calendario-formatos">Calendario y Formatos</a></li>
                    <li><a href="#calificar-anteproyecto" class="tab-link" data-tab="calificar-anteproyecto">Calificar Anteproyecto</a></li>
                </ul>
            </nav>
            <form action="index.jsp" method="post" class="logout-form">
                <button type="submit" name="action" value="logout">Cerrar Sesión</button>
            </form>
        </div>

        <div class="main-content">
            <c:if test="${param.action == 'calificar_anteproyecto'}">
                <sql:update dataSource="${parcial2}">
                    INSERT INTO CalificacionesEvaluador (anteproyecto_id, evaluador_id, fecha_evaluacion, calificacion_evaluador, comentarios_evaluador)
                    VALUES (?, ?, CURDATE(), ?, ?)
                    ON DUPLICATE KEY UPDATE
                    calificacion_evaluador = VALUES(calificacion_evaluador),
                    comentarios_evaluador = VALUES(comentarios_evaluador),
                    fecha_evaluacion = CURDATE()
                    <sql:param value="${param.anteproyecto_id}" />
                    <sql:param value="${sessionScope.user.evaluador_id}" />
                    <sql:param value="${param.calificacion_evaluador}" />
                    <sql:param value="${param.comentarios_evaluador}" />
                </sql:update>
                <p class="success-message">Calificación del evaluador guardada exitosamente.</p>
                <script>
                    setTimeout(function() {
                        showTab('anteproyectos');
                    }, 2000); // Redirect after 2 seconds
                </script>
            </c:if>

            <c:if test="${param.action == 'aprobar_anteproyecto'}">
                <sql:update dataSource="${parcial2}">
                    UPDATE Anteproyectos SET estado = 'aprobado' WHERE anteproyecto_id = ?
                    <sql:param value="${param.anteproyecto_id}" />
                </sql:update>
                <p class="success-message">Anteproyecto aprobado exitosamente.</p>
            </c:if>

            <div id="anteproyectos" class="tab-content">
                <h2>Anteproyectos</h2>
                <sql:query var="anteproyectos" dataSource="${parcial2}">
                    SELECT a.anteproyecto_id, i.titulo, i.descripcion, a.estado, a.url_subida, 
                           a.nombre_estudiante, e.codigo_estudiante,
                           ce.calificacion_evaluador, ce.comentarios_evaluador
                    FROM Anteproyectos a
                    INNER JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
                    JOIN Estudiantes e ON a.estudiante_id = e.estudiante_id
                    LEFT JOIN CalificacionesEvaluador ce ON a.anteproyecto_id = ce.anteproyecto_id AND ce.evaluador_id = ?
                    WHERE a.evaluador_id = ?
                    <sql:param value="${sessionScope.user.evaluador_id}" />
                    <sql:param value="${sessionScope.user.evaluador_id}" />
                </sql:query>

                <table>
                    <tr>
                        <th>ID</th>
                        <th>Título</th>
                        <th>Estudiante</th>
                        <th>Código</th>
                        <th>Estado</th>
                        <th>Documento</th>
                        <th>Calificación del Evaluador</th>
                        <th>Acciones</th>
                    </tr>
                    <c:forEach var="anteproyecto" items="${anteproyectos.rows}">
                        <tr>
                            <td>${anteproyecto.anteproyecto_id}</td>
                            <td>${anteproyecto.titulo}</td>
                            <td>${anteproyecto.nombre_estudiante}</td>
                            <td>${anteproyecto.codigo_estudiante}</td>
                            <td>${anteproyecto.estado}</td>
                            <td>
                                <a href="${anteproyecto.url_subida}" target="_blank">Ver Documento</a>
                            </td>
                            <td>${anteproyecto.calificacion_evaluador}</td>
                            <td>
                                <button onclick="mostrarCalificarAnteproyecto(${anteproyecto.anteproyecto_id}, '${anteproyecto.titulo}')">
                                    Calificar
                                </button>
                                <form action="evaluador_dashboard.jsp" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="aprobar_anteproyecto">
                                    <input type="hidden" name="anteproyecto_id" value="${anteproyecto.anteproyecto_id}">
                                    <button type="submit" ${anteproyecto.estado eq 'aprobado' ? 'disabled' : ''}>
                                        Aprobar
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>

            <div id="calificar-anteproyecto" class="tab-content">
                <h2>Calificar Anteproyecto</h2>
                <form action="evaluador_dashboard.jsp" method="post">
                    <input type="hidden" name="action" value="calificar_anteproyecto">
                    <input type="hidden" id="anteproyecto_id_calificar" name="anteproyecto_id">
                    <label for="titulo_anteproyecto_calificar">Título:</label>
                    <input type="text" id="titulo_anteproyecto_calificar" readonly>
                    <label for="calificacion_evaluador">Calificación del Evaluador:</label>
                    <input type="number" id="calificacion_evaluador" name="calificacion_evaluador" min="0" max="5" step="0.1" required>
                    <label for="comentarios_evaluador">Comentarios del Evaluador:</label>
                    <textarea id="comentarios_evaluador" name="comentarios_evaluador" rows="4"></textarea>
                    <button type="submit">Guardar Calificación del Evaluador</button>
                </form>
            </div>

            <div id="crud-informacion-alumno" class="tab-content">
                <h2>Información de Alumnos</h2>
                <sql:query var="estudiantes" dataSource="${parcial2}">
                    SELECT e.estudiante_id, e.nombre_completo, e.correo, e.codigo_estudiante, i.titulo
                    FROM Estudiantes e
                    JOIN Anteproyectos a ON e.estudiante_id = a.estudiante_id
                    INNER JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
                    WHERE a.evaluador_id = ?
                    <sql:param value="${sessionScope.user.evaluador_id}" />
                </sql:query>

                <table>
                    <tr>
                        <th>ID</th>
                        <th>Nombre Completo</th>
                        <th>Correo</th>
                        <th>Código del Estudiante</th>
                        <th>Título del Proyecto</th>
                    </tr>
                    <c:forEach var="estudiante" items="${estudiantes.rows}">
                        <tr>
                            <td>${estudiante.estudiante_id}</td>
                            <td>${estudiante.nombre_completo}</td>
                            <td>${estudiante.correo}</td>
                            <td>${estudiante.codigo_estudiante}</td>
                            <td>${estudiante.titulo}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>

            <div id="calendario-formatos" class="tab-content">
                <h2>Calendario Académico y Formatos de Grado</h2>
                <a href="https://www.uts.edu.co/sitio/calendario-academico/" target="_blank" class="btn">Calendario Académico</a>
                <a href="https://www.uts.edu.co/sitio/conozca-la-actualizacion-del-procedimiento-de-grado/" target="_blank" class="btn">Procedimiento de Grado</a>
            </div>
        </div>
    </div>

    <script>
        function mostrarCalificarAnteproyecto(anteproyectoId, titulo) {
            document.getElementById('anteproyecto_id_calificar').value = anteproyectoId;
            document.getElementById('titulo_anteproyecto_calificar').value = titulo;
            showTab('calificar-anteproyecto');
        }

        document.addEventListener('DOMContentLoaded', function() {
            const links = document.querySelectorAll('.tab-link');
            const sections = document.querySelectorAll('.tab-content');

            function showTab(tabId) {
                sections.forEach(section => {
                    section.style.display = 'none';
                });
                document.getElementById(tabId).style.display = 'block';

                links.forEach(link => {
                    link.classList.remove('active');
                    if(link.getAttribute('data-tab') === tabId) {
                        link.classList.add('active');
                    }
                });
            }

            links.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const tabId = this.getAttribute('data-tab');
                    showTab(tabId);
                });
            });

            showTab('anteproyectos');
        });
    </script>
</body>
</html>