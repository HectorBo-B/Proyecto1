<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario, model.Proveedor, java.util.List" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Proveedor> proveedores = (List<Proveedor>) request.getAttribute("proveedores");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proveedores - Sistema de Conciliación Bancaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="includes/sidebar.jsp" />
        
        <main class="main-content">
            <div class="page-header">
                <div>
                    <h1>Proveedores</h1>
                    <p>Administración del catálogo de proveedores</p>
                </div>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalProveedor">
                    + Nuevo proveedor
                </button>
            </div>
            
            <div class="card">
                <div class="card-toolbar">
                    <!-- 🔍 BÚSQUEDA AUTOMÁTICA CON AJAX (SIN RECARGAR) -->
                    <div class="search-form">
                        <input type="text" id="inputBuscar" class="form-control" 
                               placeholder="Buscar por nombre o RUC..." 
                               onkeyup="buscarAutomatico()" onkeydown = "SPchar(id, event)">
                    </div>
                    <a href="#" class="btn btn-secondary" onclick="cargarTodos(); return false;">Limpiar</a>
                </div>
                
                <div id="tablaProveedores">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>RUC</th>
                                    <th>Nombre</th>
                                    <th>Teléfono</th>
                                    <th>Correo</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (proveedores != null && !proveedores.isEmpty()) { %>
                                    <% for (Proveedor p : proveedores) { %>
                                        <tr>
                                            <td><%= p.getIdProveedor() %></td>
                                            <td><%= p.getRuc() %></td>
                                            <td><%= p.getNombre() %></td>
                                            <td><%= p.getTelefono() != null ? p.getTelefono() : "-" %></td>
                                            <td><%= p.getCorreo() != null ? p.getCorreo() : "-" %></td>
                                            <td>
                                                <span class="badge <%= p.getEstado() == 1 ? "badge-activo" : "badge-inactivo" %>">
                                                    <%= p.getEstado() == 1 ? "ACTIVO" : "INACTIVO" %>
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn-icon" onclick="editarProveedor(<%= p.getIdProveedor() %>)">✏️</button>
                                                <a href="ProveedorServlet?accion=eliminar&id=<%= p.getIdProveedor() %>" 
                                                   class="btn-icon" onclick="return confirm('¿Eliminar este proveedor?')">🗑️</a>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="7" class="text-center">No hay proveedores registrados</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Modal Nuevo/Editar Proveedor -->
    <div class="modal fade" id="modalProveedor" tabindex="-1">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <form action="ProveedorServlet" method="post" autocomplete="off">
	                <input type="hidden" name="accion" id="formAccion" value="crear">
	                <input type="hidden" name="id" id="formId">
	                <div class="modal-header">
	                    <h5 class="modal-title" id="modalTitle">Nuevo proveedor</h5>
	                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	                </div>
	                <div class="modal-body">
	                    <!-- Nombre -->
	                    <div class="form-group">
	                        <label>Nombre <span class="required">*</span></label>
	                        <input type="text" name="nombre" id="formNombre" class="form-control" 
	                               placeholder="Ej. Servicios Integrales, S.A." onkeydown = "SPchar(id, event)" required>
	                    </div>
	                    
	                    <!-- RUC -->
	                    <div class="form-group">
	                        <label>RUC <span class="required">*</span></label>
	                        <input type="text" name="ruc" id="formRuc" class="form-control" 
	                               placeholder="Ej. 123456-1-123456" onkeydown = "SPchar(id, event)" required>
	                    </div>
	                    
	                    <!-- Teléfono y Correo -->
	                    <div class="row">
	                        <div class="col-md-6">
	                            <div class="form-group">
	                                <label>Teléfono</label>
	                                <input type="text" name="telefono" id="formTelefono" class="form-control" 
	                                       placeholder="Ej. 507-6123-4567">
	                            </div>
	                        </div>
	                        <div class="col-md-6">
	                            <div class="form-group">
	                                <label>Correo</label>
	                                <input type="email" name="correo" id="formCorreo" class="form-control" 
	                                       placeholder="Ej. correo@empresa.com">
	                            </div>
	                        </div>
	                    </div>
	                </div>
	                <div class="modal-footer">
	                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
	                    <button type="submit" class="btn btn-primary">Guardar proveedor</button>
	                </div>
	            </form>
	        </div>
	    </div>
	</div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 🔍 BÚSQUEDA AUTOMÁTICA CON AJAX (SIN RECARGAR)
        function buscarAutomatico() {
            var input = document.getElementById('inputBuscar');
            var texto = input.value.trim();
            
            if (texto.length >= 1) {
                fetch('ProveedorServlet?accion=buscar&texto=' + encodeURIComponent(texto))
                    .then(response => response.text())
                    .then(html => {
                        var parser = new DOMParser();
                        var doc = parser.parseFromString(html, 'text/html');
                        var tabla = doc.querySelector('#tablaProveedores');
                        if (tabla) {
                            document.getElementById('tablaProveedores').innerHTML = tabla.innerHTML;
                        }
                    })
                    .catch(error => console.error('Error:', error));
            } else {
                cargarTodos();
            }
        }
        
        function cargarTodos() {
            fetch('ProveedorServlet?accion=listar')
                .then(response => response.text())
                .then(html => {
                    var parser = new DOMParser();
                    var doc = parser.parseFromString(html, 'text/html');
                    var tabla = doc.querySelector('#tablaProveedores');
                    if (tabla) {
                        document.getElementById('tablaProveedores').innerHTML = tabla.innerHTML;
                    }
                    document.getElementById('inputBuscar').value = '';
                })
                .catch(error => console.error('Error:', error));
        }
        
        function editarProveedor(id) {
            fetch('ProveedorServlet?accion=obtener&id=' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('formAccion').value = 'actualizar';
                    document.getElementById('formId').value = data.idProveedor;
                    document.getElementById('formNombre').value = data.nombre;
                    document.getElementById('formRuc').value = data.ruc;
                    document.getElementById('formTelefono').value = data.telefono || '';
                    document.getElementById('formCorreo').value = data.correo || '';
                    document.getElementById('formEstado').value = data.estado;
                    document.getElementById('modalTitle').textContent = 'Editar proveedor';
                    new bootstrap.Modal(document.getElementById('modalProveedor')).show();
                });
        }
        
        document.getElementById('modalProveedor').addEventListener('hidden.bs.modal', function() {
            document.getElementById('formAccion').value = 'crear';
            document.getElementById('formId').value = '';
            document.getElementById('formNombre').value = '';
            document.getElementById('formRuc').value = '';
            document.getElementById('formTelefono').value = '';
            document.getElementById('formCorreo').value = '';
            document.getElementById('formEstado').value = '1';
            document.getElementById('modalTitle').textContent = 'Nuevo proveedor';
        });
        
        function SPchar(id){
        	
        	
        	const inputField = document.getElementById(id);
        	
        	inputField.addEventListener('input', function(event){
        		let ognTxt = event.target.value;
        		
        		let clnTxt = ognTxt.replace(/[^a-zA-Z0-9\s]/g, '');
        		
        		event.target.value = clnTxt;
        	})
        }
    </script>
</body>
</html>