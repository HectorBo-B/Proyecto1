<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario, model.ObjetoGasto, java.util.List" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<ObjetoGasto> objetos = (List<ObjetoGasto>) request.getAttribute("objetos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Objetos de Gasto - Sistema de Conciliación Bancaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="includes/sidebar.jsp" />
        
        <main class="main-content">
            <div class="page-header">
                <div>
                    <h1>Objetos de Gasto</h1>
                    <p>Clasificación presupuestaria del gasto institucional</p>
                </div>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalObjeto">
                    + Nuevo objeto de gasto
                </button>
            </div>
            
            <div class="card">
                <div class="card-toolbar">
                    <!-- 🔍 BÚSQUEDA AUTOMÁTICA CON AJAX -->
                    <div class="search-form">
                        <input type="text" id="inputBuscar" class="form-control" 
                               placeholder="Buscar por código o descripción..." 
                               onkeyup="buscarAutomatico()">
                    </div>
                    <a href="#" class="btn btn-secondary" onclick="cargarTodos(); return false;">Limpiar</a>
                </div>
                
                <div id="tablaObjetos">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Código</th>
                                    <th>Descripción</th>
                                    <th>Estado</th>
                                    <th>Fecha creación</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (objetos != null && !objetos.isEmpty()) { %>
                                    <% for (ObjetoGasto o : objetos) { %>
                                        <tr>
                                            <td><%= o.getCodigo() %></td>
                                            <td><%= o.getDescripcion() %></td>
                                            <td>
                                                <span class="badge <%= o.getEstado() == 1 || o.getEstado() == 2 || o.getEstado() == 3 || o.getEstado() == 6 ? "badge-activo" : "badge-inactivo" %>">
                                                    <%= o.getEstado() == 1 ? "ACTIVO" : 
                                                       o.getEstado() == 2 ? "ACTIVO" : 
                                                       o.getEstado() == 3 ? "ACTIVO" : 
                                                       o.getEstado() == 6 ? "ACTIVO" : "INACTIVO" %>
                                                </span>
                                            </td>
                                            <td><%= o.getFechaCreacion() %></td>
                                            <td>
                                                <button class="btn-icon" onclick="editarObjeto(<%= o.getIdObjetoGasto() %>)">✏️</button>
                                                <a href="ObjetoGastoServlet?accion=eliminar&id=<%= o.getIdObjetoGasto() %>" 
                                                   class="btn-icon" onclick="return confirm('¿Eliminar este objeto de gasto?')">🗑️</a>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="5" class="text-center">No hay objetos de gasto registrados</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Modal Nuevo/Editar Objeto de Gasto -->
    <div class="modal fade" id="modalObjeto" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="ObjetoGastoServlet" method="post" autocomplete="off">
                    <input type="hidden" name="accion" id="formAccion" value="crear">
                    <input type="hidden" name="id" id="formId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Nuevo objeto de gasto</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label>Código</label>
                            <input type="text" name="codigo" id="formCodigo" class="form-control" placeholder="Ej. 1.2.03" required>
                        </div>
                        <div class="form-group">
                            <label>Descripción</label>
                            <input type="text" name="descripcion" id="formDescripcion" class="form-control" placeholder="Descripción del objeto de gasto" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 🔍 BÚSQUEDA AUTOMÁTICA CON AJAX
        function buscarAutomatico() {
            var input = document.getElementById('inputBuscar');
            var texto = input.value.trim();
            
            if (texto.length >= 1) {
                fetch('ObjetoGastoServlet?accion=buscar&texto=' + encodeURIComponent(texto))
                    .then(response => response.text())
                    .then(html => {
                        var parser = new DOMParser();
                        var doc = parser.parseFromString(html, 'text/html');
                        var tabla = doc.querySelector('#tablaObjetos');
                        if (tabla) {
                            document.getElementById('tablaObjetos').innerHTML = tabla.innerHTML;
                        }
                    })
                    .catch(error => console.error('Error:', error));
            } else {
                cargarTodos();
            }
        }
        
        function cargarTodos() {
            fetch('ObjetoGastoServlet?accion=listar')
                .then(response => response.text())
                .then(html => {
                    var parser = new DOMParser();
                    var doc = parser.parseFromString(html, 'text/html');
                    var tabla = doc.querySelector('#tablaObjetos');
                    if (tabla) {
                        document.getElementById('tablaObjetos').innerHTML = tabla.innerHTML;
                    }
                    document.getElementById('inputBuscar').value = '';
                })
                .catch(error => console.error('Error:', error));
        }
        
        function editarObjeto(id) {
            fetch('ObjetoGastoServlet?accion=obtener&id=' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('formAccion').value = 'actualizar';
                    document.getElementById('formId').value = data.idObjetoGasto;
                    document.getElementById('formCodigo').value = data.codigo;
                    document.getElementById('formDescripcion').value = data.descripcion;
                    document.getElementById('formEstado').value = data.estado;
                    document.getElementById('modalTitle').textContent = 'Editar objeto de gasto';
                    new bootstrap.Modal(document.getElementById('modalObjeto')).show();
                });
        }
        
        document.getElementById('modalObjeto').addEventListener('hidden.bs.modal', function() {
            document.getElementById('formAccion').value = 'crear';
            document.getElementById('formId').value = '';
            document.getElementById('formCodigo').value = '';
            document.getElementById('formDescripcion').value = '';
            document.getElementById('formEstado').value = '1';
            document.getElementById('modalTitle').textContent = 'Nuevo objeto de gasto';
        });
    </script>
</body>
</html>