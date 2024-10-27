<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ include file="WEB-INF/lib/conexion.jspf" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Coordinador</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
    <div class="login-container">
        <h2>Login Coordinador</h2>
        <img src="img/avatar.png" alt="Avatar Coordinador" class="avatar">
        <form action="logincoordinador.jsp" method="post">
            <input type="text" name="username" placeholder="Nombre de usuario" required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <button type="submit">Iniciar Sesión</button>
        </form>
        <button class="button-back" onclick="location.href='index.jsp'">Volver</button>
        
        <c:if test="${param.username != null && param.password != null}">
            <sql:query dataSource="${parcial2}" var="result">
                SELECT * FROM coordinadores 
                WHERE nombre_usuario = ? AND contrasena = ?
                <sql:param value="${param.username}" />
                <sql:param value="${param.password}" />
            </sql:query>
            
            <c:choose>
                <c:when test="${result.rowCount > 0}">
                    <c:set var="user" value="${result.rows[0]}" scope="session" />
                    <c:redirect url="coordinador_dashboard.jsp"/>
                </c:when>
                <c:otherwise>
                    <p class="error">Usuario o contraseña incorrectos.</p>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
</body>
</html>