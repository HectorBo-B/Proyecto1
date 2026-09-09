<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">	
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema de Conciliación Bancaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <jsp:include page="includes/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1>Dashboard</h1>
                <p>Resumen General De Operaciones Bancarias</p>
            </div>
            
            <!-- Estadísticas -->
            <div class="stats-grid">
                <div class="stat-card stat-card-blue">
                    <span class="stat-label">Total cheques emitidos</span>
                    <span class="stat-value"><%= request.getAttribute("emitidos") %></span>
                    <span class="stat-sub">este mes</span>
                </div>
                
                <div class="stat-card stat-card-amber">
                    <span class="stat-label">Cheques pendientes</span>
                    <span class="stat-value"><%= request.getAttribute("pendientes") %></span>
                    <span class="stat-sub">por cobrar</span>
                </div>
                
                <div class="stat-card stat-card-green">
                    <span class="stat-label">Cheques cobrados</span>
                    <span class="stat-value"><%= request.getAttribute("cobrados") %></span>
                    <span class="stat-sub">este mes</span>
                </div>
                
                <div class="stat-card stat-card-red">
                    <span class="stat-label">Cheques anulados</span>
                    <span class="stat-value"><%= request.getAttribute("anulados") %></span>
                    <span class="stat-sub">este mes</span>
                </div>
                
                <div class="stat-card stat-card-violet">
                    <span class="stat-label">Sacados de circulación</span>
                    <span class="stat-value"><%= request.getAttribute("circulacion") %></span>
                    <span class="stat-sub">este mes</span>
                </div>
                
                <div class="stat-card stat-card-gold">
                    <span class="stat-label">Monto total cheques</span>
                    <span class="stat-value amount-mono">B/. <%= String.format("%,.2f", ((BigDecimal) request.getAttribute("totalCheques")).doubleValue()) %></span>
                    <span class="stat-sub">acumulado</span>
                </div>
                
                <div class="stat-card stat-card-teal">
                    <span class="stat-label">Monto total depósitos</span>
                    <span class="stat-value amount-mono">B/. <%= String.format("%,.2f", ((BigDecimal) request.getAttribute("totalDepositos")).doubleValue()) %></span>
                    <span class="stat-sub">acumulado</span>
                </div>
            </div>
            
            <!-- Bienvenida -->
            <div class="card">
                <h3>Bienvenido, <%= user.getNombre() %> <%= user.getApellido() %></h3>
                <p>Rol: <%= user.getRol() %> | Correo: <%= user.getCorreo() %></p>
                <p>Último acceso: <%= new java.util.Date() %></p>
            </div>
        </main>
    </div>
</body>
</html>