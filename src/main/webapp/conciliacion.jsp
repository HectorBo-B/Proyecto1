<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario, model.Conciliacion, java.util.List, java.math.BigDecimal" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Conciliacion> conciliaciones = (List<Conciliacion>) request.getAttribute("conciliaciones");
    String modo = (String) request.getAttribute("modo");
    String periodo = (String) request.getAttribute("periodo");
    BigDecimal saldoLibros = (BigDecimal) request.getAttribute("saldoLibros");
    BigDecimal totalDepositos = (BigDecimal) request.getAttribute("totalDepositos");
    BigDecimal totalPendientes = (BigDecimal) request.getAttribute("totalPendientes");
    BigDecimal saldoConciliado = (BigDecimal) request.getAttribute("saldoConciliado");
    BigDecimal saldoBanco = (BigDecimal) request.getAttribute("saldoBanco");
    BigDecimal diferencia = (BigDecimal) request.getAttribute("diferencia");
    Integer estado = (Integer) request.getAttribute("estado");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conciliación - Sistema de Conciliación Bancaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="includes/sidebar.jsp" />
        
        <main class="main-content">
            <div class="page-header">
                <div>
                    <h1>Conciliación Bancaria Mensual</h1>
                    <p>Verificación de saldos contables y bancarios</p>
                </div>
                <a href="ConciliacionServlet?accion=nueva" class="btn btn-primary">+ Nueva conciliación</a>
            </div>
            
            <!-- Lista de conciliaciones -->
            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Período</th>
                                <th>Saldo libros</th>
                                <th>Depósitos tránsito</th>
                                <th>Cheques pendientes</th>
                                <th>Saldo banco</th>
                                <th>Diferencia</th>
                                <th>Estado</th>
                                <th>Fecha</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (conciliaciones != null && !conciliaciones.isEmpty()) { %>
                                <% for (Conciliacion c : conciliaciones) { %>
                                    <tr>
                                        <td><%= c.getPeriodo() %></td>
                                        <td>B/. <%= String.format("%,.2f", c.getSaldoLibros().doubleValue()) %></td>
                                        <td>B/. <%= String.format("%,.2f", c.getDepositosTransito().doubleValue()) %></td>
                                        <td>B/. <%= String.format("%,.2f", c.getChequesPendientes().doubleValue()) %></td>
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
                                        <td><%= c.getFechaConciliacion() %></td>
                                    </tr>
                                <% } %>
                            <% } else { %>
                                <tr>
                                    <td colspan="8" class="text-center">No hay conciliaciones registradas</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Mostrar resultados del cálculo si existen -->
            <% if ("resultado".equals(modo)) { %>
                <div class="card" style="margin-top:20px;">
                    <h3>Resultado de la conciliación - <%= periodo %></h3>
                    
                    <div class="conciliacion-resultado">
                        <div class="result-item">
                            <span class="result-label">Saldo según libros</span>
                            <span class="result-value">B/. <%= String.format("%,.2f", saldoLibros.doubleValue()) %></span>
                        </div>
                        <div class="result-item">
                            <span class="result-label">+ Depósitos en tránsito</span>
                            <span class="result-value" style="color:#059669;">+ B/. <%= String.format("%,.2f", totalDepositos.doubleValue()) %></span>
                        </div>
                        <div class="result-item">
                            <span class="result-label">− Cheques pendientes</span>
                            <span class="result-value" style="color:#DC2626;">− B/. <%= String.format("%,.2f", totalPendientes.doubleValue()) %></span>
                        </div>
                        <div class="result-item" style="border-top:2px solid #D1DBE8;padding-top:10px;">
                            <span class="result-label" style="font-weight:700;">= Saldo conciliado</span>
                            <span class="result-value" style="font-weight:700;">B/. <%= String.format("%,.2f", saldoConciliado.doubleValue()) %></span>
                        </div>
                        <div class="result-item">
                            <span class="result-label">Saldo según banco</span>
                            <span class="result-value">B/. <%= String.format("%,.2f", saldoBanco.doubleValue()) %></span>
                        </div>
                        <div class="result-item">
                            <span class="result-label">Diferencia</span>
                            <span class="result-value" style="color: <%= diferencia.doubleValue() == 0 ? "#059669" : "#DC2626" %>; font-weight:700;">
                                B/. <%= String.format("%,.2f", diferencia.doubleValue()) %>
                            </span>
                        </div>
                    </div>
                    
                    <% if (diferencia.doubleValue() == 0) { %>
                        <div class="alert alert-success">
                            ✅ Conciliación exitosa - El saldo bancario coincide con el saldo conciliado.
                        </div>
                        <form action="ConciliacionServlet" method="post" autocomplete="off" style="margin-top:15px;">
                            <input type="hidden" name="accion" value="guardar">
                            <input type="hidden" name="periodo" value="<%= periodo %>">
                            <input type="hidden" name="saldo_libros" value="<%= saldoLibros %>">
                            <input type="hidden" name="depositos_transito" value="<%= totalDepositos %>">
                            <input type="hidden" name="cheques_pendientes" value="<%= totalPendientes %>">
                            <input type="hidden" name="saldo_banco" value="<%= saldoBanco %>">
                            <input type="hidden" name="diferencia" value="<%= diferencia %>">
                            <input type="hidden" name="estado" value="3">
                            <div class="form-group">
                                <label>Observaciones</label>
                                <textarea name="observaciones" class="form-control" rows="2"></textarea>
                            </div>
                            <button type="submit" class="btn btn-success">Guardar conciliación</button>
                        </form>
                    <% } else { %>
                        <div class="alert alert-danger">
                            ❌ Conciliación no válida - Existe una diferencia de B/. <%= String.format("%,.2f", Math.abs(diferencia.doubleValue())) %> que debe ser investigada.
                        </div>
                    <% } %>
                </div>
            <% } %>
            
            <!-- Formulario nueva conciliación -->
            <% if ("crear".equals(modo)) { %>
                <div class="card" style="margin-top:20px;">
                    <h3>Nueva conciliación</h3>
                    <form action="ConciliacionServlet" method="get">
                        <input type="hidden" name="accion" value="calcular">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Período</label>
                                    <input type="month" name="periodo" class="form-control" required>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Saldo según banco (B/.)</label>
                                    <input type="number" step="0.01" name="saldo_banco" class="form-control" placeholder="0.00" required>
                                </div>
                            </div>
                            <div class="col-md-4" style="display:flex;align-items:flex-end;">
                                <button type="submit" class="btn btn-primary">Calcular conciliación</button>
                            </div>
                        </div>
                    </form>
                </div>
            <% } %>
        </main>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>