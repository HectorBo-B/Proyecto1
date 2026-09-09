<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    String currentPage = request.getServletPath();
%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <i class="fa-solid fa-building-columns"></i>
        </div>
        <div>
            <div class="sidebar-title">Finanzas</div>
            <div class="sidebar-subtitle">Sistema de Conciliación Bancaria</div>
        </div>
    </div>
    
    <hr class="sidebar-divider">
    
    <nav class="sidebar-nav">
        <a href="DashboardServlet" class="sidebar-link <%= currentPage.contains("dashboard") ? "active" : "" %>">
            <i class="fa-solid fa-chart-line"></i> Dashboard
        </a>
        <a href="ProveedorServlet?accion=listar" class="sidebar-link <%= currentPage.contains("proveedores") ? "active" : "" %>">
            <i class="fa-solid fa-users"></i> Proveedores
        </a>
        <a href="ObjetoGastoServlet?accion=listar" class="sidebar-link <%= currentPage.contains("objetos") ? "active" : "" %>">
            <i class="fa-solid fa-tags"></i> Objetos de Gasto
        </a>
        <a href="ChequeServlet?accion=listar" class="sidebar-link <%= currentPage.contains("cheques") ? "active" : "" %>">
            <i class="fa-solid fa-money-check-dollar"></i>	</i> Cheques
        </a>
        <a href="DepositoServlet?accion=listar" class="sidebar-link <%= currentPage.contains("depositos") ? "active" : "" %>">
            <i class="fa-solid fa-money-bill-transfer"></i> Depósitos
        </a>
        <a href="ConciliacionServlet?accion=listar" class="sidebar-link <%= currentPage.contains("conciliacion") ? "active" : "" %>">
            <i class="fa-solid fa-dollar-sign"></i> Conciliación
        </a>
        <a href="ReporteServlet" class="sidebar-link <%= currentPage.contains("reportes") ? "active" : "" %>">
            <i class="fa-regular fa-file-lines"></i> Consultas / Reportes
        </a>
    </nav>
    
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="sidebar-user-name"><%= user.getNombre() %> <%= user.getApellido() %></div>
            <div class="sidebar-user-date"><%= new java.text.SimpleDateFormat("EEEE, d MMMM yyyy").format(new java.util.Date()) %></div>
        </div>
        <a href="LoginServlet?accion=logout" class="sidebar-link">
            <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
        </a>
    </div>
</aside>