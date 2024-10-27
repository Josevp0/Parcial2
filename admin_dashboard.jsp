<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ include file="WEB-INF/lib/conexion.jspf" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administrador</title>
    <link rel="stylesheet" href="css/admin_dashboard1.css">
</head>
<body>
    <div class="dashboard-container">
        <div class="sidebar">
            <div class="welcome-message">
                <h2>Bienvenido</h2>
                <img src="img/avatar.png" alt="Avatar Administrador" class="avatar">
                <p>${sessionScope.user.nombre_completo}</p>
            </div>
            <nav>
                <ul>
                    <li><a href="#agregar-usuario" class="tab-link" data-tab="agregar-usuario">Agregar Usuario</a></li>
                    <li><a href="#lista-usuarios" class="tab-link" data-tab="lista-usuarios">Lista de Usuarios</a></li>
                    <li><a href="#editar-usuario" class="tab-link" data-tab="editar-usuario">Editar Usuario</a></li>
                </ul>
            </nav>
            <form action="index.jsp" method="post" class="logout-form">
                <button type="submit" name="action" value="logout">Cerrar Sesión</button>
            </form>
        </div>
        <div class="main-content">
            <h1>Panel de Administrador</h1>
            
            <div id="agregar-usuario" class="section">
                <h2>Registrar Nuevo Usuario</h2>
                <form action="admin_dashboard.jsp" method="post">
                    <input type="text" name="nombre_usuario" placeholder="Nombre de usuario" required>
                    <input type="password" name="contrasena" placeholder="Contraseña" required>
                    <input type="email" name="correo" placeholder="Correo electrónico" required>
                    <input type="text" name="nombre_completo" placeholder="Nombre completo" required>
                    <select name="tipo_usuario" required>
                        <option value="">Seleccione el tipo de usuario</option>
                        <option value="coordinador">Coordinador</option>
                        <option value="evaluador">Evaluador</option>
                        <option value="director">Director</option>
                        <option value="estudiante">Estudiante</option>
                    </select>
                    <input type="text" name="departamento" placeholder="Departamento (para Coordinador, Evaluador, Director)">
                    <input type="text" name="codigo_estudiante" placeholder="Código de estudiante (para Estudiante)">
                    <button type="submit" name="action" value="registrar">Registrar Usuario</button>
                </form>
            </div>

            <c:if test="${param.action == 'registrar'}">
                <sql:update dataSource="${parcial2}">
                    INSERT INTO ${param.tipo_usuario == 'estudiante' ? 'Estudiantes' : param.tipo_usuario == 'coordinador' ? 'Coordinadores' : param.tipo_usuario == 'evaluador' ? 'Evaluador' : 'Director'}
                    (nombre_usuario, contrasena, correo, nombre_completo${param.tipo_usuario != 'estudiante' ? ', departamento' : ', codigo_estudiante'})
                    VALUES (?, ?, ?, ?, ?)
                    <sql:param value="${param.nombre_usuario}" />
                    <sql:param value="${param.contrasena}" />
                    <sql:param value="${param.correo}" />
                    <sql:param value="${param.nombre_completo}" />
                    <sql:param value="${param.tipo_usuario == 'estudiante' ? param.codigo_estudiante : param.departamento}" />
                </sql:update>
                <p class="success">Usuario registrado exitosamente.</p>
            </c:if>

            <div id="lista-usuarios" class="section">
                <h2>Lista de Usuarios</h2>
                <form action="admin_dashboard.jsp" method="get" id="userListForm">
                    <input type="hidden" name="tab" value="lista-usuarios">
                    <select name="tipo_usuario" onchange="this.form.submit()">
                        <option value="">Seleccione el tipo de usuario</option>
                        <option value="coordinador" ${param.tipo_usuario == 'coordinador' ? 'selected' : ''}>Coordinadores</option>
                        <option value="evaluador" ${param.tipo_usuario == 'evaluador' ? 'selected' : ''}>Evaluadores</option>
                        <option value="director" ${param.tipo_usuario == 'director' ? 'selected' : ''}>Directores</option>
                        <option value="estudiante" ${param.tipo_usuario == 'estudiante' ? 'selected' : ''}>Estudiantes</option>
                    </select>
                </form>

                <c:if test="${not empty param.tipo_usuario}">
                    <sql:query var="usuarios" dataSource="${parcial2}">
                        SELECT * FROM ${param.tipo_usuario == 'estudiante' ? 'Estudiantes' : param.tipo_usuario == 'coordinador' ? 'Coordinadores' : param.tipo_usuario == 'evaluador' ? 'Evaluador' : 'Director'}
                    </sql:query>
                    <table>
                        <tr>
                            <th>ID</th>
                            <th>Nombre de Usuario</th>
                            <th>Contraseña</th>
                            <th>Correo</th>
                            <th>Nombre Completo</th>
                            <th>${param.tipo_usuario == 'estudiante' ? 'Código' : 'Departamento'}</th>
                            <th>Acciones</th>
                        </tr>
                        <c:forEach var="usuario" items="${usuarios.rows}">
                            <tr>
                                <td>${usuario[param.tipo_usuario == 'estudiante' ? 'estudiante_id' : param.tipo_usuario == 'coordinador' ? 'coordinador_id' : param.tipo_usuario == 'evaluador' ? 'evaluador_id' : 'director_id']}</td>
                                <td>${usuario.nombre_usuario}</td>
                                <td>${usuario.contrasena}</td>
                                <td>${usuario.correo}</td>
                                <td>${usuario.nombre_completo}</td>
                                <td>${param.tipo_usuario == 'estudiante' ? usuario.codigo_estudiante : usuario.departamento}</td>
                                <td>
                                    <a href="admin_dashboard.jsp?action=editar&id=${usuario[param.tipo_usuario == 'estudiante' ? 'estudiante_id' : param.tipo_usuario == 'coordinador' ? 'coordinador_id' : param.tipo_usuario == 'evaluador' ? 'evaluador_id' : 'director_id']}&tipo=${param.tipo_usuario}&tab=editar-usuario">Editar</a>
                                    <a href="admin_dashboard.jsp?action=eliminar&id=${usuario[param.tipo_usuario == 'estudiante' ? 'estudiante_id' : param.tipo_usuario == 'coordinador' ? 'coordinador_id' : param.tipo_usuario == 'evaluador' ? 'evaluador_id' : 'director_id']}&tipo=${param.tipo_usuario}&tab=lista-usuarios" onclick="return confirm('¿Está seguro de que desea eliminar este usuario?')">Eliminar</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>
            </div>

            <div id="editar-usuario" class="section">
                <h2>Editar Usuario</h2>
                <c:if test="${param.action == 'editar' and not empty param.id and not empty param.tipo}">
                    <sql:query var="usuario" dataSource="${parcial2}">
                        SELECT * FROM ${param.tipo == 'estudiante' ? 'Estudiantes' : param.tipo == 'coordinador' ? 'Coordinadores' : param.tipo == 'evaluador' ? 'Evaluador' : 'Director'}
                        WHERE ${param.tipo == 'estudiante' ? 'estudiante_id' : param.tipo == 'coordinador' ? 'coordinador_id' : param.tipo == 'evaluador' ? 'evaluador_id' : 'director_id'} = ?
                        <sql:param value="${param.id}" />
                    </sql:query>
                    <c:if test="${not empty usuario.rows}">
                        <c:set var="user" value="${usuario.rows[0]}" />
                        <form action="admin_dashboard.jsp" method="post">
                            <input type="hidden" name="id" value="${param.id}">
                            <input type="hidden" name="tipo" value="${param.tipo}">
                            <input type="text" name="nombre_usuario" value="${user.nombre_usuario}" placeholder="Nombre de usuario" required>
                            <input type="password" name="contrasena" value="${user.contrasena}" placeholder="Contraseña" required>
                            <input type="email" name="correo" value="${user.correo}" placeholder="Correo electrónico" required>
                            <input type="text" name="nombre_completo" value="${user.nombre_completo}" placeholder="Nombre completo" required>
                            <c:choose>
                                <c:when test="${param.tipo == 'estudiante'}">
                                    <input type="text" name="codigo_estudiante" value="${user.codigo_estudiante}" placeholder="Código de estudiante" required>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" name="departamento" value="${user.departamento}" placeholder="Departamento" required>
                                </c:otherwise>
                            </c:choose>
                            <button type="submit" name="action" value="actualizar">Actualizar Usuario</button>
                        </form>
                    </c:if>
                </c:if>
            </div>

            <c:if test="${param.action == 'actualizar'}">
                <sql:update dataSource="${parcial2}">
                    UPDATE ${param.tipo == 'estudiante' ? 'Estudiantes' : param.tipo == 'coordinador' ? 'Coordinadores' : param.tipo == 'evaluador' ? 'Evaluador' : 'Director'}
                    SET nombre_usuario = ?, contrasena = ?, correo = ?, nombre_completo = ?, 
                    ${param.tipo == 'estudiante' ? 'codigo_estudiante' : 'departamento'} = ?
                    WHERE ${param.tipo == 'estudiante' ? 'estudiante_id' : param.tipo == 'coordinador' ? 'coordinador_id' : param.tipo == 'evaluador' ? 'evaluador_id' : 'director_id'} = ?
                    <sql:param value="${param.nombre_usuario}" />
                    <sql:param value="${param.contrasena}" />
                    <sql:param value="${param.correo}" />
                    <sql:param value="${param.nombre_completo}" />
                    <sql:param value="${param.tipo == 'estudiante' ? param.codigo_estudiante : param.departamento}" />
                    <sql:param value="${param.id}" />
                </sql:update>
                <p class="success">Usuario actualizado exitosamente.</p>
                <script>
                    setTimeout(function() {
                        window.location.href = 'admin_dashboard.jsp?tab=lista-usuarios&tipo_usuario=${param.tipo}';
                    }, 2000);
                </script>
            </c:if>

            <c:if test="${param.action == 'eliminar'}">
                <sql:update dataSource="${parcial2}">
                    DELETE FROM ${param.tipo == 'estudiante' ? 'Estudiantes' : param.tipo == 'coordinador' ? 'Coordinadores' : param.tipo == 'evaluador' ? 'Evaluador' : 'Director'}
                    WHERE ${param.tipo == 'estudiante' ? 'estudiante_id' : param.tipo == 'coordinador' ? 'coordinador_id' : param.tipo == 'evaluador' ? 'evaluador_id' : 'director_id'} = ?
                    <sql:param value="${param.id}" />
                </sql:update>
                <p class="success">Usuario eliminado exitosamente.</p>
            </c:if>
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

            // Remove 'active' class from all links and add to the clicked one
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
            showTab('agregar-usuario');
        }

        const userListForm = document.getElementById('userListForm');
        if (userListForm) {
            userListForm.addEventListener('submit', function() {
                showTab('lista-usuarios');
            });
        }
    });
    </script>
</body>
</html>