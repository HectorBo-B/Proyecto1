<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistema de Conciliación Bancaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body class="login-body">
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="login-logo">$</div>
                <p>Sistema de Conciliación Bancaria</p>
            </div>
            
            <div class="login-form">
                <h2>Inicio de sesión</h2>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
				<form action="LoginServlet" method="post" autocomplete="off">                    <div class="form-group">
                        <label for="usuario">Usuario</label>
                        <input type="text" id="usuario" name="usuario" class="form-control" placeholder="Ingrese su usuario" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Contraseña</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Ingrese su contraseña" required>
                    </div>
                    
                    <button type="submit" class="btn btn-login">Ingresar al sistema</button>
                </form>
                
                <p class="login-demo">Demo: usuario <strong>admin</strong> · contraseña <strong>admin123</strong></p>
            </div>
        </div>
    </div>
</body>
</html>