<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bienvenidos Usuarios</title>
    <link rel="stylesheet" href="css/index.css"> 
</head>
<body>

    <div class="welcome-container">
        <div class="login-options">
            <h1>BIENVENIDOS USUARIOS</h1>
            <img src="img/avatar.png" alt="Avatar" class="avatar"> 

            <button class="button" onclick="location.href='loginadmin.jsp'">Ingresa como Administrador</button>
            <button class="button" onclick="location.href='logincoordinador.jsp'">Ingresa como Coordinador</button>
            <button class="button" onclick="location.href='loginevaluador.jsp'">Ingresa como Evaluador</button>
            <button class="button" onclick="location.href='logindirector.jsp'">Ingresa como Director</button>
            <button class="button" onclick="location.href='loginestudiante.jsp'">Ingresa como Estudiante</button>
        </div>

        <div class="image-section"> 
            <img src="img/fondo.jpeg" alt="Estudiante" class="student-image"> <
        </div>
    </div>

</body>
</html>