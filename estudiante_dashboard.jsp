<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="WEB-INF/lib/conexion.jspf" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Estudiante</title>
    <link rel="stylesheet" href="css/estudiante_dashboard.css">
</head>
<body>
    <div class="dashboard-container">
        <div class="sidebar">
            <div class="welcome-message">
                <h2>Bienvenido</h2>
                <img src="img/avatar.png" alt="Avatar Estudiante" class="avatar">
                <p>${sessionScope.user.nombre_completo}</p>
            </div>
            <nav>
                <ul>
                    <li><a href="#perfil" class="tab-link" data-tab="perfil">Mi Perfil</a></li>
                    <li><a href="#seleccionar-idea" class="tab-link" data-tab="seleccionar-idea">Seleccionar Idea de Proyecto</a></li>
                    <li><a href="#mis-anteproyectos" class="tab-link" data-tab="mis-anteproyectos">Mis Anteproyectos</a></li>
                    <li><a href="#subir-anteproyecto" class="tab-link" data-tab="subir-anteproyecto">Subir Anteproyecto</a></li>
                    <li><a href="#calificaciones" class="tab-link" data-tab="calificaciones">Calificaciones</a></li>
                    <li><a href="#calendario" class="tab-link" data-tab="calendario">Calendario Académico</a></li>
                    <li><a href="#formatos" class="tab-link" data-tab="formatos">Formatos de Grado</a></li>
                </ul>
            </nav>
            <form action="index.jsp" method="post" class="logout-form">
                <button type="submit" name="action" value="logout">Cerrar Sesión</button>
            </form>
        </div>
        <div class="main-content">
            <h1>Panel de Estudiante</h1>
            
            <!-- Perfil del estudiante -->
            <div id="perfil" class="section">
                <h2>Mi Perfil</h2>
                <sql:query var="estudiante" dataSource="${parcial2}">
                    SELECT * FROM Estudiantes WHERE estudiante_id = ?
                    <sql:param value="${sessionScope.user.estudiante_id}" />
                </sql:query>
                <c:if test="${not empty estudiante.rows}">
                    <c:set var="user" value="${estudiante.rows[0]}" />
                    <p><strong>Nombre de Usuario:</strong> ${user.nombre_usuario}</p>
                    <p><strong>Correo:</strong> ${user.correo}</p>
                    <p><strong>Nombre Completo:</strong> ${user.nombre_completo}</p>
                    <p><strong>Código de Estudiante:</strong> ${user.codigo_estudiante}</p>
                </c:if>
            </div>

            <!-- Selección de idea de proyecto -->
            <div id="seleccionar-idea" class="section">
    <h2>Seleccionar Idea de Proyecto</h2>
    <sql:query var="ideas" dataSource="${parcial2}">
        SELECT * FROM IdeasAnteproyecto WHERE estado = 'disponible'
    </sql:query>
    <c:choose>
        <c:when test="${not empty ideas.rows}">
            <table class="ideas-table">
                <tr>
                    <th>Título</th>
                    <th>Descripción</th>
                    <th>Fecha de Creación</th>
                    <th>Acción</th>
                </tr>
                <c:forEach var="idea" items="${ideas.rows}">
                    <tr>
                        <td>${idea.titulo}</td>
                        <td>${idea.descripcion}</td>
                        <td>${idea.fecha_creacion}</td>
                        <td>
                            <form action="estudiante_dashboard.jsp" method="post">
                                <input type="hidden" name="action" value="seleccionar_idea">
                                <input type="hidden" name="idea_id" value="${idea.idea_id}">
                                <button type="submit">Seleccionar</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
        <c:otherwise>
            <p>No hay ideas de proyecto disponibles en este momento.</p>
        </c:otherwise>
    </c:choose>
</div>

            <!-- Mis Anteproyectos -->
<div id="mis-anteproyectos" class="section">
                <h2>Mis Anteproyectos</h2>
                <sql:query var="anteproyectos" dataSource="${parcial2}">
                    SELECT a.*, i.titulo, i.descripcion,
                           d.nombre_completo AS nombre_director, cd.calificacion_director,
                           e.nombre_completo AS nombre_evaluador, ce.calificacion_evaluador
                    FROM Anteproyectos a
                    INNER JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
                    LEFT JOIN Director d ON a.director_id = d.director_id
                    LEFT JOIN CalificacionesDirector cd ON a.anteproyecto_id = cd.anteproyecto_id
                    LEFT JOIN Evaluador e ON a.evaluador_id = e.evaluador_id
                    LEFT JOIN CalificacionesEvaluador ce ON a.anteproyecto_id = ce.anteproyecto_id
                    WHERE a.estudiante_id = ?
                    <sql:param value="${sessionScope.user.estudiante_id}" />
                </sql:query>
                <c:choose>
                    <c:when test="${not empty anteproyectos.rows}">
                        <h3>Evaluación del Director</h3>
                        <table>
                            <tr>
                                <th>Título</th>
                                <th>Estado</th>
                                <th>Director</th>
                                <th>Calificación</th>
                                <th>Documento</th>
                            </tr>
                            <c:forEach var="anteproyecto" items="${anteproyectos.rows}">
                                <tr>
                                    <td>${anteproyecto.titulo}</td>
                                    <td>${anteproyecto.estado}</td>
                                    <td>${anteproyecto.nombre_director}</td>
                                    <td>${anteproyecto.calificacion_director}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty anteproyecto.url_subida}">
                                                <a href="${anteproyecto.url_subida}" target="_blank">Ver Documento</a>
                                            </c:when>
                                            <c:otherwise>
                                                No subido
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>

                        <h3>Evaluación del Evaluador</h3>
                        <table>
                            <tr>
                                <th>Título</th>
                                <th>Estado</th>
                                <th>Evaluador</th>
                                <th>Calificación</th>
                                <th>Documento</th>
                            </tr>
                            <c:forEach var="anteproyecto" items="${anteproyectos.rows}">
                                <tr>
                                    <td>${anteproyecto.titulo}</td>
                                    <td>${anteproyecto.estado}</td>
                                    <td>${anteproyecto.nombre_evaluador}</td>
                                    <td>${anteproyecto.calificacion_evaluador}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty anteproyecto.url_subida}">
                                                <a href="${anteproyecto.url_subida}" target="_blank">Ver Documento</a>
                                            </c:when>
                                            <c:otherwise>
                                                No subido
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p>No tienes anteproyectos asignados actualmente.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Subir Anteproyecto -->
            <div id="subir-anteproyecto" class="section">
                <h2>Subir Anteproyecto</h2>
                <form action="estudiante_dashboard.jsp" method="post">
                    <input type="hidden" name="action" value="subir_anteproyecto">
                    <label for="anteproyecto_url">URL del Anteproyecto:</label>
                    <input type="url" id="anteproyecto_url" name="anteproyecto_url" required>
                    <button type="submit">Subir Anteproyecto</button>
                </form>
            </div>

            <!-- Calificaciones -->
            <div id="calificaciones" class="section">
    <h2>Calificaciones de Anteproyectos</h2>
    <sql:query var="calificaciones" dataSource="${parcial2}">
        SELECT a.anteproyecto_id, i.titulo,
               cd.calificacion_director, cd.comentarios_director,
               ce.calificacion_evaluador, ce.comentarios_evaluador
        FROM Anteproyectos a
        JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
        LEFT JOIN CalificacionesDirector cd ON a.anteproyecto_id = cd.anteproyecto_id
        LEFT JOIN CalificacionesEvaluador ce ON a.anteproyecto_id = ce.anteproyecto_id
        WHERE a.estudiante_id = ?
        <sql:param value="${sessionScope.user.estudiante_id}" />
    </sql:query>

    <h3>Calificaciones del Director</h3>
    <c:choose>
        <c:when test="${not empty calificaciones.rows}">
            <table border="1">
                <tr>
                    <th>Anteproyecto</th>
                    <th>Calificación</th>
                    <th>Comentarios</th>
                </tr>
                <c:forEach var="calificacion" items="${calificaciones.rows}">
                    <tr>
                        <td>${calificacion.titulo}</td>
                        <td>${calificacion.calificacion_director}</td>
                        <td>${calificacion.comentarios_director}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
        <c:otherwise>
            <p>No hay calificaciones del director disponibles en este momento.</p>
        </c:otherwise>
    </c:choose>

    <h3>Calificaciones del Evaluador</h3>
    <c:choose>
        <c:when test="${not empty calificaciones.rows}">
            <table border="1">
                <tr>
                    <th>Anteproyecto</th>
                    <th>Calificación</th>
                    <th>Comentarios</th>
                </tr>
                <c:forEach var="calificacion" items="${calificaciones.rows}">
                    <tr>
                        <td>${calificacion.titulo}</td>
                        <td>${calificacion.calificacion_evaluador}</td>
                        <td>${calificacion.comentarios_evaluador}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
        <c:otherwise>
            <p>No hay calificaciones del evaluador disponibles en este momento.</p>
        </c:otherwise>
    </c:choose>
</div>

            <!-- Calendario Académico -->
            <div id="calendario" class="section">
                <h2>Calendario Académico</h2>
                <a href="https://www.uts.edu.co/sitio/calendario-academico/" class="button" target="_blank">Ver Calendario Académico</a>
            </div>

            <!-- Formatos de Grado -->
            <div id="formatos" class="section">
                <h2>Formatos de Grado</h2>
                <a href="https://www.uts.edu.co/sitio/conozca-la-actualizacion-del-procedimiento-de-grado/" class="button" target="_blank">Ver Formatos de Grado</a>
            </div>
        </div>
    </div>

    <!-- Lógica para seleccionar idea y crear anteproyecto -->
    <c:if test="${param.action == 'seleccionar_idea' && not empty param.idea_id}">
    <sql:transaction dataSource="${parcial2}">
        <sql:query var="ideaExistente">
            SELECT * FROM Anteproyectos WHERE idea_id = ? AND estudiante_id = ?
            <sql:param value="${param.idea_id}" />
            <sql:param value="${sessionScope.user.estudiante_id}" />
        </sql:query>
        
        <c:if test="${empty ideaExistente.rows}">
            <sql:update>
                INSERT INTO Anteproyectos (idea_id, estudiante_id, estado, nombre_estudiante)
                VALUES (?, ?, 'En desarrollo', ?)
                <sql:param value="${param.idea_id}" />
                <sql:param value="${sessionScope.user.estudiante_id}" />
                <sql:param value="${sessionScope.user.nombre_completo}" />
            </sql:update>
            
            <sql:update>
                UPDATE IdeasAnteproyecto SET estado = 'aprobado' WHERE idea_id = ?
                <sql:param value="${param.idea_id}" />
            </sql:update>
            <script>alert('Idea de proyecto seleccionada y anteproyecto creado exitosamente.');</script>
        </c:if>
    </sql:transaction>
</c:if>

    <!-- Lógica para subir anteproyecto -->
    <c:if test="${param.action == 'subir_anteproyecto' && not empty param.anteproyecto_url}">
        <sql:update dataSource="${parcial2}">
            UPDATE Anteproyectos 
            SET url_subida = ?, estado = 'Subido'
            WHERE estudiante_id  = ?
            <sql:param value="${param.anteproyecto_url}" />
            <sql:param value="${sessionScope.user.estudiante_id}" />
        </sql:update>
        <script>alert('URL del anteproyecto actualizada exitosamente.');</script>
    </c:if>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const links = document.querySelectorAll('.tab-link');
        const sections = document.querySelectorAll('.section');

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

        showTab('perfil');
    });
    </script>
</body>
</html>