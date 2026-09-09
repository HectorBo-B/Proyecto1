<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario, model.Cheque, model.Deposito, model.Conciliacion, java.util.List, java.math.BigDecimal" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String reporteTipo = (String) request.getAttribute("reporteTipo");
    List<Cheque> cheques = (List<Cheque>) request.getAttribute("cheques");
    List<Deposito> depositos = (List<Deposito>) request.getAttribute("depositos");
    List<Conciliacion> conciliaciones = (List<Conciliacion>) request.getAttribute("conciliaciones");
    BigDecimal totalCheques = (BigDecimal) request.getAttribute("totalCheques");
    BigDecimal totalDepositos = (BigDecimal) request.getAttribute("totalDepositos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - Sistema de Conciliación Bancaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="includes/sidebar.jsp" />
        
        <main class="main-content">
            <div class="page-header">
                <div>
                    <h1>Consultas y Reportes</h1>
                    <p>Seleccione un reporte para consultar y exportar</p>
                </div>
            </div>
            
            <!-- Tarjetas de reportes -->
            <div class="reportes-grid">
                <a href="ReporteServlet?tipo=cheques" class="reporte-card <%= "cheques".equals(reporteTipo) ? "active" : "" %>">
                    <div class="reporte-icon" style="background:#EFF4FF;color:#1B3F7A;">✅</div>
                    <span>Cheques emitidos por período</span>
                </a>
                <a href="ReporteServlet?tipo=chequesPendientes" class="reporte-card <%= "chequesPendientes".equals(reporteTipo) ? "active" : "" %>">
                    <div class="reporte-icon" style="background:#FFFBEB;color:#D97706;">📅</div>
                    <span>Cheques pendientes</span>
                </a>
                <a href="ReporteServlet?tipo=chequesAnulados" class="reporte-card <%= "chequesAnulados".equals(reporteTipo) ? "active" : "" %>">
                    <div class="reporte-icon" style="background:#FFF1F2;color:#DC2626;">🚫</div>
                    <span>Cheques anulados</span>
                </a>
                <a href="ReporteServlet?tipo=depositos" class="reporte-card <%= "depositos".equals(reporteTipo) ? "active" : "" %>">
                    <div class="reporte-icon" style="background:#F0FDF4;color:#059669;">💰</div>
                    <span>Depósitos por período</span>
                </a>
                <a href="ReporteServlet?tipo=conciliaciones" class="reporte-card <%= "conciliaciones".equals(reporteTipo) ? "active" : "" %>">
                    <div class="reporte-icon" style="background:#F5F3FF;color:#7C3AED;">📊</div>
                    <span>Conciliaciones realizadas</span>
                </a>
            </div>
            
            <!-- Resultados del reporte -->
            <% if (reporteTipo != null) { %>
                <div class="card" style="margin-top:20px;">
                    <div class="card-header-custom">
                        <h3>
                            <% if ("cheques".equals(reporteTipo)) { %>Cheques emitidos por período<% } %>
                            <% if ("chequesPendientes".equals(reporteTipo)) { %>Cheques pendientes<% } %>
                            <% if ("chequesAnulados".equals(reporteTipo)) { %>Cheques anulados<% } %>
                            <% if ("depositos".equals(reporteTipo)) { %>Depósitos por período<% } %>
                            <% if ("conciliaciones".equals(reporteTipo)) { %>Conciliaciones realizadas<% } %>
                        </h3>
                        <div>
                            <button class="btn btn-secondary" onclick="window.print()">🖨️ Imprimir</button>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <% if ("cheques".equals(reporteTipo) || "chequesPendientes".equals(reporteTipo) || "chequesAnulados".equals(reporteTipo)) { %>
                                        <th>N.º Cheque</th>
                                        <th>Fecha</th>
                                        <th>Beneficiario</th>
                                        <th>Monto</th>
                                        <th>Estado</th>
                                    <% } else if ("depositos".equals(reporteTipo)) { %>
                                        <th>Comprobante</th>
                                        <th>Tipo</th>
                                        <th>Fecha</th>
                                        <th>Monto</th>
                                        <th>Detalle</th>
                                    <% } else if ("conciliaciones".equals(reporteTipo)) { %>
                                        <th>Período</th>
                                        <th>Saldo libros</th>
                                        <th>Saldo banco</th>
                                        <th>Diferencia</th>
                                        <th>Estado</th>
                                    <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% if ("cheques".equals(reporteTipo) || "chequesPendientes".equals(reporteTipo) || "chequesAnulados".equals(reporteTipo)) { %>
                                    <% if (cheques != null && !cheques.isEmpty()) { %>
                                        <% for (Cheque c : cheques) { %>
                                            <tr>
                                                <td><%= c.getNumeroCheque() %></td>
                                                <td><%= c.getFechaCheque() %></td>
                                                <td><%= c.getIdProveedor() %></td>
                                                <td>B/. <%= String.format("%,.2f", c.getMonto().doubleValue()) %></td>
                                                <td>
                                                    <span class="badge <%= 
                                                        c.getEstado() == 1 ? "badge-emitido" :
                                                        c.getEstado() == 2 ? "badge-pendiente" :
                                                        c.getEstado() == 3 ? "badge-cobrado" :
                                                        c.getEstado() == 4 ? "badge-anulado" :
                                                        "badge-circulacion" %>">
                                                        <%= 
                                                            c.getEstado() == 1 ? "EMITIDO" :
                                                            c.getEstado() == 2 ? "PENDIENTE" :
                                                            c.getEstado() == 3 ? "COBRADO" :
                                                            c.getEstado() == 4 ? "ANULADO" :
                                                            "CIRCULACIÓN" %>
                                                    </span>
                                                </td>
                                            </tr>
                                        <% } %>
                                        <tr class="table-total">
                                            <td colspan="3"><strong>TOTAL</strong></td>
                                            <td><strong>B/. <%= String.format("%,.2f", totalCheques != null ? totalCheques.doubleValue() : 0) %></strong></td>
                                            <td></td>
                                        </tr>
                                    <% } else { %>
                                        <tr><td colspan="5" class="text-center">No hay cheques para mostrar</td></tr>
                                    <% } %>
                                    
                                <% } else if ("depositos".equals(reporteTipo)) { %>
                                    <% if (depositos != null && !depositos.isEmpty()) { %>
                                        <% for (Deposito d : depositos) { %>
                                            <tr>
                                                <td><%= d.getNumeroComprobante() %></td>
                                                <td>
                                                    <span class="badge <%= d.getTipoDeposito() == 1 ? "badge-transferencia" : "badge-directo" %>">
                                                        <%= d.getTipoDeposito() == 1 ? "TRANSFERENCIA" : "DEP. DIRECTO" %>
                                                    </span>
                                                </td>
                                                <td><%= d.getFecha() %></td>
                                                <td>B/. <%= String.format("%,.2f", d.getMonto().doubleValue()) %></td>
                                                <td><%= d.getDetalle() != null ? d.getDetalle() : "-" %></td>
                                            </tr>
                                        <% } %>
                                        <tr class="table-total">
                                            <td colspan="3"><strong>TOTAL</strong></td>
                                            <td><strong>B/. <%= String.format("%,.2f", totalDepositos != null ? totalDepositos.doubleValue() : 0) %></strong></td>
                                            <td></td>
                                        </tr>
                                    <% } else { %>
                                        <tr><td colspan="5" class="text-center">No hay depósitos para mostrar</td></tr>
                                    <% } %>
                                    
                                <% } else if ("conciliaciones".equals(reporteTipo)) { %>
                                    <% if (conciliaciones != null && !conciliaciones.isEmpty()) { %>
                                        <% for (Conciliacion c : conciliaciones) { %>
                                            <tr>
                                                <td><%= c.getPeriodo() %></td>
                                                <td>B/. <%= String.format("%,.2f", c.getSaldoLibros().doubleValue()) %></td>
                                                <td>B/. <%= String.format("%,.2f", c.getSaldoBanco().doubleValue()) %></td>
                                                <td style="color: <%= c.getDiferencia().doubleValue() == 0 ? "#059669" : "#DC2626" %>">
                                                    B/. <%= String.format("%,.2f", c.getDiferencia().doubleValue()) %>
                                                </td>
                                                <td>
                                                    <span class="badge <%= 
                                                        c.getEstado() == 1 ? "badge-pendiente" :
                                                        c.getEstado() == 2 ? "badge-emitido" :
                                                        c.getEstado() == 3 ? "badge-cobrado" :
                                                        "badge-circulacion" %>">
                                                        <%= 
                                                            c.getEstado() == 1 ? "EN PROCESO" :
                                                            c.getEstado() == 2 ? "AJUSTADA" :
                                                            c.getEstado() == 3 ? "VERIFICADA" :
                                                            "CERRADA" %>
                                                    </span>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr><td colspan="5" class="text-center">No hay conciliaciones para mostrar</td></tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } else { %>
                <div class="card" style="margin-top:20px;text-align:center;padding:40px;">
                    <p style="color:#5A6A7E;font-size:16px;">Seleccione un reporte de las tarjetas superiores para visualizar los datos.</p>
                </div>
            <% } %>
        </main>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>