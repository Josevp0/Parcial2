<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ include file="WEB-INF/lib/conexion.jspf" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Coordinador</title>
    <link rel="stylesheet" href="css/coordinador_dashboard.css">
</head>
<body>
    <div class="dashboard-container">
        <div class="sidebar">
            <div class="welcome-message">
                <h2>Bienvenido</h2>
                <img src="img/avatar.png" alt="Avatar Coordinador" class="avatar">
                <p>${sessionScope.user.nombre_completo}</p>
            </div>
            <nav>
                <ul>
                    <li><a href="#agregar-idea" class="tab-link" data-tab="agregar-idea">Agregar Idea de Anteproyecto</a></li>
                    <li><a href="#lista-ideas" class="tab-link" data-tab="lista-ideas">Lista de Ideas</a></li>
                    <li><a href="#editar-idea" class="tab-link" data-tab="editar-idea">Editar Idea</a></li>
                    <li><a href="#asignar-director" class="tab-link" data-tab="asignar-director">Asignar Director</a></li>
                    <li><a href="#asignar-evaluador" class="tab-link" data-tab="asignar-evaluador">Asignar Evaluador</a></li>
                    <li><a href="#buscar-proyecto" class="tab-link" data-tab="buscar-proyecto">Buscar Proyecto</a></li>
                    <li><a href="#informes" class="tab-link" data-tab="informes">Informes</a></li>
                    <li><a href="#calendario-formatos" class="tab-link" data-tab="calendario-formatos">Calendario y Formatos</a></li>
                </ul>
            </nav>
            <form action="index.jsp" method="post" class="logout-form">
                <button type="submit" name="action" value="logout">Cerrar Sesión</button>
            </form>
        </div>
        <div class="main-content">
            <h1>Panel de Coordinador</h1>
            
            <div id="agregar-idea" class="section">
    <h2>Agregar Nueva Idea de Anteproyecto</h2>
    <form action="coordinador_dashboard.jsp" method="post">
        <input type="text" name="titulo" placeholder="Título" required>
        <textarea name="descripcion" placeholder="Descripción" required></textarea>
        <select name="estado" required>
            <option value="disponible">Disponible</option>
            <option value="no_disponible">No disponible</option>
        </select>
        <button type="submit" name="action" value="agregar_idea">Agregar Idea</button>
    </form>
</div>

            <c:if test="${param.action == 'agregar_idea'}">
                <sql:update dataSource="${parcial2}">
                    INSERT INTO IdeasAnteproyecto (titulo, descripcion, coordinador_id, estado, fecha_creacion)
                    VALUES (?, ?, ?, ?, CURDATE())
                    <sql:param value="${param.titulo}" />
                    <sql:param value="${param.descripcion}" />
                    <sql:param value="${sessionScope.user.coordinador_id}" />
                    <sql:param value="${param.estado}" />
                </sql:update>
                <p class="success">Idea de anteproyecto agregada exitosamente.</p>
            </c:if>

            <div id="lista-ideas" class="section">
                <h2>Lista de Ideas de Anteproyecto</h2>
                <sql:query var="ideas" dataSource="${parcial2}">
                    SELECT * FROM IdeasAnteproyecto WHERE coordinador_id = ?
                    <sql:param value="${sessionScope.user.coordinador_id}" />
                </sql:query>
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Título</th>
                        <th>Descripción</th>
                        <th>Estado</th>
                        <th>Fecha de Creación</th>
                        <th>Acciones</th>
                    </tr>
                    <c:forEach var="idea" items="${ideas.rows}">
                        <tr>
                            <td>${idea.idea_id}</td>
                            <td>${idea.titulo}</td>
                            <td>${idea.descripcion}</td>
                            <td>${idea.estado}</td>
                            <td>${idea.fecha_creacion}</td>
                            <td>
                                <a href="coordinador_dashboard.jsp?action=editar&id=${idea.idea_id}&tab=editar-idea">Editar</a>
                                <a href="coordinador_dashboard.jsp?action=eliminar&id=${idea.idea_id}&tab=lista-ideas" onclick="return confirm('¿Está seguro de que desea eliminar esta idea?')">Eliminar</a>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>

            <div id="editar-idea" class="section">
    <h2>Editar Idea de Anteproyecto</h2>
    <c:if test="${param.action == 'editar' and not empty param.id}">
        <sql:query var="idea" dataSource="${parcial2}">
            SELECT * FROM IdeasAnteproyecto WHERE idea_id = ?
            <sql:param value="${param.id}" />
        </sql:query>
        <c:if test="${not empty idea.rows}">
            <c:set var="ideaActual" value="${idea.rows[0]}" />
            <form action="coordinador_dashboard.jsp" method="post">
                <input type="hidden" name="idea_id" value="${param.id}">
                <input type="text" name="titulo" value="${ideaActual.titulo}" placeholder="Título" required>
                <textarea name="descripcion" placeholder="Descripción" required>${ideaActual.descripcion}</textarea>
                <select name="estado" required>
                    <option value="disponible" ${ideaActual.estado == 'disponible' ? 'selected' : ''}>Disponible</option>
                    <option value="no_disponible" ${ideaActual.estado == 'no_disponible' ? 'selected' : ''}>No disponible</option>
                </select>
                <button type="submit" name="action" value="actualizar_idea">Actualizar Idea</button>
            </form>
        </c:if>
    </c:if>
</div>

            <c:if test="${param.action == 'actualizar_idea'}">
                <sql:update dataSource="${parcial2}">
                    UPDATE IdeasAnteproyecto
                    SET titulo = ?, descripcion = ?, estado = ?
                    WHERE idea_id = ?
                    <sql:param value="${param.titulo}" />
                    <sql:param value="${param.descripcion}" />
                    <sql:param value="${param.estado}" />
                    <sql:param value="${param.idea_id}" />
                </sql:update>
                <p class="success">Idea de anteproyecto actualizada exitosamente.</p>
                <script>
                    setTimeout(function() {
                        window.location.href = 'coordinador_dashboard.jsp?tab=lista-ideas';
                    }, 2000);
                </script>
            </c:if>

            <c:if test="${param.action == 'eliminar'}">
                <sql:query var="verificarAsignacion" dataSource="${parcial2}">
                    SELECT COUNT(*) AS total FROM Anteproyectos WHERE idea_id = ?
                    <sql:param value="${param.id}" />
                </sql:query>

                <c:if test="${verificarAsignacion.rows[0].total > 0}">
                    <p class="error">La idea ya ha sido asignada a un estudiante y no se puede eliminar.</p>
                </c:if>

                <c:if test="${verificarAsignacion.rows[0].total == 0}">
                    <sql:update dataSource="${parcial2}">
                        DELETE FROM IdeasAnteproyecto WHERE idea_id = ?
                        <sql:param value="${param.id}" />
                    </sql:update>
                    <p class="success">Idea de anteproyecto eliminada exitosamente.</p>
                </c:if>
            </c:if>

            <!-- Asignar Director section -->
<div id="asignar-director" class="section">
    <h2>Asignar Director a Anteproyecto</h2>

    <sql:query var="anteproyectos" dataSource="${parcial2}">
        SELECT a.anteproyecto_id, i.titulo, i.descripcion 
        FROM Anteproyectos a
        JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
        WHERE a.director_id IS NULL
    </sql:query>

    <sql:query var="directores" dataSource="${parcial2}">
        SELECT director_id, nombre_completo FROM Director
    </sql:query>

    <form action="coordinador_dashboard.jsp" method="post">
        <label for="anteproyecto_id">Selecciona Anteproyecto:</label>
        <select name="anteproyecto_id" required>
            <c:forEach var="anteproyecto" items="${anteproyectos.rows}">
                <option value="${anteproyecto.anteproyecto_id}">${anteproyecto.titulo} - ${anteproyecto.descripcion}</option>
            </c:forEach>
        </select>

        <label for="director_id">Selecciona Director:</label>
        <select name="director_id" required>
            <c:forEach var="director" items="${directores.rows}">
                <option value="${director.director_id}">${director.nombre_completo}</option>
            </c:forEach>
        </select>

        <button type="submit" name="action" value="asignar_director">Asignar Director</button>
    </form>
</div>

<c:if test="${param.action == 'asignar_director'}">
    <sql:query var="directorInfo" dataSource="${parcial2}">
        SELECT nombre_completo FROM Director WHERE director_id = ?
        <sql:param value="${param.director_id}" />
    </sql:query>
    <c:set var="nombreDirector" value="${directorInfo.rows[0].nombre_completo}" />

    <sql:update dataSource="${parcial2}">
        UPDATE Anteproyectos
        SET director_id = ?, nombre_director = ?
        WHERE anteproyecto_id = ?
        <sql:param value="${param.director_id}" />
        <sql:param value="${nombreDirector}" />
        <sql:param value="${param.anteproyecto_id}" />
    </sql:update>
    <p class="success">Director asignado exitosamente al anteproyecto.</p>
</c:if>

<!-- Asignar Evaluador section -->
<div id="asignar-evaluador" class="section">
    <h2>Asignar Evaluador a Anteproyecto</h2>

    <sql:query var="anteproyectos" dataSource="${parcial2}">
        SELECT a.anteproyecto_id, i.titulo, i.descripcion 
        FROM Anteproyectos a
        JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
        WHERE a.evaluador_id IS NULL
    </sql:query>

    <sql:query var="evaluadores" dataSource="${parcial2}">
        SELECT evaluador_id, nombre_completo FROM Evaluador
    </sql:query>

    <form action="coordinador_dashboard.jsp" method="post">
        <label for="anteproyecto_id">Selecciona Anteproyecto:</label>
        <select name="anteproyecto_id" required>
            <c:forEach var="anteproyecto" items="${anteproyectos.rows}">
                <option value="${anteproyecto.anteproyecto_id}">${anteproyecto.titulo} - ${anteproyecto.descripcion}</option>
            </c:forEach>
        </select>

        <label for="evaluador_id">Selecciona Evaluador:</label>
        <select name="evaluador_id" required>
            <c:forEach var="evaluador" items="${evaluadores.rows}">
                <option value="${evaluador.evaluador_id}">${evaluador.nombre_completo}</option>
            </c:forEach>
        </select>

        <button type="submit" name="action" value="asignar_evaluador">Asignar Evaluador</button>
    </form>
</div>

<c:if test="${param.action == 'asignar_evaluador'}">
    <sql:query var="evaluadorInfo" dataSource="${parcial2}">
        SELECT nombre_completo FROM Evaluador WHERE evaluador_id = ?
        <sql:param value="${param.evaluador_id}" />
    </sql:query>
    <c:set var="nombreEvaluador" value="${evaluadorInfo.rows[0].nombre_completo}" />

    <sql:update dataSource="${parcial2}">
        UPDATE Anteproyectos
        SET evaluador_id = ?, nombre_evaluador = ?
        WHERE anteproyecto_id = ?
        <sql:param value="${param.evaluador_id}" />
        <sql:param value="${nombreEvaluador}" />
        <sql:param value="${param.anteproyecto_id}" />
    </sql:update>
    <p class="success">Evaluador asignado exitosamente al anteproyecto.</p>
</c:if>

<!-- Buscar Proyecto section -->
<div id="buscar-proyecto" class="section">
    <h2>Buscar Proyecto por Estudiante</h2>
    <form action="coordinador_dashboard.jsp" method="get">
        <input type="hidden" name="action" value="buscar_proyecto">
        <input type="text" name="busqueda" placeholder="Código o nombre del estudiante" required>
        <button type="submit">Buscar</button>
    </form>

    <c:if test="${param.action == 'buscar_proyecto'}">
        <sql:query var="proyectos" dataSource="${parcial2}">
            SELECT i.titulo, i.descripcion, e.codigo_estudiante, a.estado, 
                   a.nombre_director, a.nombre_evaluador
            FROM Anteproyectos a
            INNER JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
            INNER JOIN Estudiantes e ON a.estudiante_id = e.estudiante_id
            WHERE e.codigo_estudiante LIKE ? OR e.nombre_completo LIKE ?
            <sql:param value="%${param.busqueda}%" />
            <sql:param value="%${param.busqueda}%" />
        </sql:query>

        <c:if test="${proyectos.rowCount > 0}">
            <h3>Resultados de la búsqueda:</h3>
            <table>
                <tr>
                    <th>Título del Proyecto</th>
                    <th>Descripción</th>
                    <th>Código del Estudiante</th>
                    <th>Estado</th>
                    <th>Director</th>
                    <th>Evaluador</th>
                </tr>
                <c:forEach var="proyecto" items="${proyectos.rows}">
                    <tr>
                        <td>${proyecto.titulo}</td>
                        <td>${proyecto.descripcion}</td>
                        <td>${proyecto.codigo_estudiante}</td>
                        <td>${proyecto.estado}</td>
                        <td>${proyecto.nombre_director}</td>
                        <td>${proyecto.nombre_evaluador}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
        <c:if test="${proyectos.rowCount == 0}">
            <p>No se encontraron proyectos para el estudiante especificado.</p>
        </c:if>
    </c:if>
</div>

            <div id="informes" class="section">
                <h2>Informes de Estado</h2>
                <h3>Proyectos por Estado</h3>
                <sql:query var="estadoProyectos" dataSource="${parcial2}">
                    SELECT a.estado, COUNT(*) as cantidad
                    FROM Anteproyectos a
                    INNER JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
                    WHERE i.coordinador_id = ?
                    GROUP BY a.estado
                    <sql:param value="${sessionScope.user.coordinador_id}" />
                </sql:query>
                <table>
                    <tr>
                        <th>Estado</th>
                        <th>Cantidad</th>
                    </tr>
                    <c:forEach var="estado" items="${estadoProyectos.rows}">
                        <tr>
                            <td>${estado.estado}</td>
                            <td>${estado.cantidad}</td>
                        </tr>
                    </c:forEach>
                </table>

                <h3>Proyectos por Director</h3>
                <sql:query var="proyectosDirector" dataSource="${parcial2}">
                    SELECT d.nombre_completo, COUNT(a.anteproyecto_id) as cantidad
                    FROM Director d
                    LEFT JOIN Anteproyectos a ON d.director_id = a.director_id
                    INNER JOIN IdeasAnteproyecto i ON a.idea_id = i.idea_id
                    WHERE i.coordinador_id = ? OR i.coordinador_id IS NULL
                    GROUP BY d.director_id, d.nombre_completo
                    <sql:param value="${sessionScope.user.coordinador_id}" />
                </sql:query>
                <table>
                    <tr>
                        <th>Director</th>
                        <th>Cantidad de Proyectos</th>
                    </tr>
                    <c:forEach var="director" items="${proyectosDirector.rows}">
                        <tr>
                            <td>${director.nombre_completo}</td>
                            <td>${director.cantidad}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>

            <div id="calendario-formatos" class="section">
                <h2>Calendario Académico y Formatos de Grado</h2>
                <a href="https://www.uts.edu.co/sitio/calendario-academico/" target="_blank" class="btn">Calendario Académico</a>
                <a href="https://www.uts.edu.co/sitio/conozca-la-actualizacion-del-procedimiento-de-grado/" target="_blank" class="btn">Procedimiento de Grado</a>
            </div>
        </div>
    </div>

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

        const urlParams = new URLSearchParams(window.location.search);
        const tabParam = urlParams.get('tab');
        if (tabParam) {
            showTab(tabParam);
        } else {
            showTab('agregar-idea');
        }
    });
    </script>
</body>
</html>