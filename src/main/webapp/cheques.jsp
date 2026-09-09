<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario, model.Cheque, model.Proveedor, model.ObjetoGasto, java.util.List" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Cheque> cheques = (List<Cheque>) request.getAttribute("cheques");
    List<Proveedor> proveedores = (List<Proveedor>) request.getAttribute("proveedores");
    List<ObjetoGasto> objetos = (List<ObjetoGasto>) request.getAttribute("objetos");
    String modo = (String) request.getAttribute("modo");
    Cheque cheque = (Cheque) request.getAttribute("cheque");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cheques - Sistema de Conciliación Bancaria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="includes/sidebar.jsp" />
        
        <main class="main-content">
            <div class="page-header">
                <div>
                    <h1>Gestión de Cheques</h1>
                    <p>Registro y seguimiento de cheques emitidos</p>
                </div>
                <button class="btn btn-primary" onclick="abrirModalCheque()">
                    <i class="fas fa-plus"></i> Registrar cheque
                </button>
            </div>
            
            <!-- ============================================================ -->
            <!-- FILTROS Y TABLA -->
            <!-- ============================================================ -->
            <div class="card">
                <form action="ChequeServlet" method="get" class="filter-form">
                    <input type="hidden" name="accion" value="listarPorEstado">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label>Fecha inicial</label>
                            <input type="date" name="fecha_inicio" class="form-control">
                        </div>
                        <div class="filter-group">
                            <label>Fecha final</label>
                            <input type="date" name="fecha_fin" class="form-control">
                        </div>
                        <div class="filter-group">
                            <label>Buscar</label>
                            <input type="text" name="texto" class="form-control" placeholder="Buscar por número o beneficiario...">
                        </div>
                        <div class="filter-group">
                            <label>Estado</label>
                            <select name="estado" class="form-control">
                                <option value="0">Todos</option>
                                <option value="1">Emitido</option>
                                <option value="2">Pendiente</option>
                                <option value="3">Cobrado</option>
                                <option value="4">Anulado</option>
                                <option value="5">Sacado de circulación</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-secondary">
                            <i class="fas fa-search"></i> Buscar
                        </button>
                        <a href="ChequeServlet?accion=listar" class="btn btn-secondary">
                            <i class="fas fa-sync-alt"></i> Limpiar
                        </a>
                    </div>
                </form>
            </div>

            <!-- Tabla de cheques -->
            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>N.º Cheque</th>
                                <th>Fecha</th>
                                <th>Beneficiario</th>
                                <th>Monto</th>
                                <th>Objeto de gasto</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (cheques != null && !cheques.isEmpty()) { %>
                                <% for (Cheque c : cheques) { %>
                                    <tr>
                                        <td><%= c.getNumeroCheque() %></td>
                                        <td><%= c.getFechaCheque() %></td>
                                        <td><%= c.getIdProveedor() %></td>
                                        <td>B/. <%= String.format("%,.2f", c.getMonto().doubleValue()) %></td>
                                        <td><%= c.getIdObjetoGasto() %></td>
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
                                        <td>
                                            <button class="btn-icon" onclick="editarCheque(<%= c.getIdCheque() %>)" title="Editar">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <% if (c.getEstado() == 1 || c.getEstado() == 2) { %>
                                                <button class="btn-icon" onclick="anularCheque(<%= c.getIdCheque() %>)" style="color:red;" title="Anular">
                                                    <i class="fas fa-ban"></i>
                                                </button>
                                            <% } %>
                                            <% if (c.getEstado() == 2) { %>
                                                <button class="btn-icon" onclick="sacarCirculacion(<%= c.getIdCheque() %>)" style="color:purple;" title="Sacar de circulación">
                                                    <i class="fas fa-circle"></i>
                                                </button>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } else { %>
                                <tr>
                                    <td colspan="7" class="text-center">No hay cheques registrados</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
<!-- ============================================================ -->
<!-- MODAL PARA REGISTRAR/EDITAR CHEQUE -->
<!-- ============================================================ -->
<div class="modal fade" id="modalCheque" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="ChequeServlet" method="post" id="formCheque" autocomplete="off" onsubmit="return validarFormularioCheque()">
                <input type="hidden" name="accion" id="formAccion" value="crear">
                <input type="hidden" name="id" id="formId">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Registrar cheque</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <div class="form-group">
                                    <label>N.º de cheque <span class="required">*</span></label>
                                    <span id="formNumero" class="form-control" style="background:#f8f9fa; font-weight:bold; color:#1B3F7A; display:inline-block;"></span>
                                    <input type="hidden" name="numero_cheque" id="formNumeroHidden">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Fecha del cheque <span class="required">*</span></label>
                                <span id="formFecha" class="form-control" style="background:#f8f9fa; font-weight:bold; color:#1B3F7A; display:inline-block;"></span>
                                <input type="hidden" name="fecha_cheque" id="formFechaHidden" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Proveedor / Beneficiario <span class="required">*</span></label>
                                <select name="id_proveedor" id="formProveedor" class="form-control" required>
                                    <option value="">--- Seleccionar proveedor ---</option>
                                    <% if (proveedores != null) {
                                        for (Proveedor p : proveedores) { %>
                                            <option value="<%= p.getIdProveedor() %>"><%= p.getNombre() %></option>
                                    <%   }
                                    } %>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Objeto de gasto <span class="required">*</span></label>
                                <select name="id_objeto_gasto" id="formObjeto" class="form-control" required>
                                    <option value="">--- Seleccionar objeto ---</option>
                                    <% if (objetos != null) {
                                        for (ObjetoGasto o : objetos) { %>
                                            <option value="<%= o.getIdObjetoGasto() %>"><%= o.getCodigo() %> - <%= o.getDescripcion() %></option>
                                    <%   }
                                    } %>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Monto (B/.) <span class="required">*</span></label>
                                <input type="text" name="monto" id="formMonto" class="form-control monto-input" 
                                       placeholder="0.00" 
                                       oninput="formatearMontoEnVivo(this); actualizarMontoLetrasModal()"
                                       onblur="completarCentavos(this); actualizarMontoLetrasModal()"
                                       onfocus="this.select()"
                                       maxlength="14">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Monto en letras</label>
                                <input type="text" name="monto_letras" id="formMontoLetras" class="form-control" 
                                       readonly style="background:#f8f9fa; text-transform:uppercase;">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Detalle / Concepto</label>
                                <textarea name="detalle" id="formDetalle" class="form-control" rows="2" placeholder="Descripción del pago..."></textarea>
                            </div>
                        </div>
                    </div>
                <input type="hidden" name="estado" id="formEstado" value="1">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Guardar cheque</button>
                </div>
            </form>
        </div>
    </div>
</div>
            
        </main>
    </div>
    
    <!-- Modal Anular Cheque -->
    <div class="modal fade" id="modalAnular" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="ChequeServlet" method="get">
                    <input type="hidden" name="accion" value="anular">
                    <input type="hidden" name="id" id="anularId">
                    <div class="modal-header">
                        <h5 class="modal-title" style="color:#DC2626;">
                            <i class="fas fa-exclamation-triangle"></i> Anular cheque
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>¿Está seguro de que desea anular este cheque? Esta acción no se puede deshacer.</p>
                        <div class="form-group">
                            <label>Motivo de anulación <span class="required">*</span></label>
                            <textarea name="motivo" class="form-control" rows="3" placeholder="Describa el motivo de la anulación..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times"></i> Cancelar
                        </button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-ban"></i> Confirmar anulación
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Modal Sacar de Circulación -->
    <div class="modal fade" id="modalCirculacion" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="ChequeServlet" method="get">
                    <input type="hidden" name="accion" value="sacarCirculacion">
                    <input type="hidden" name="id" id="circulacionId">
                    <div class="modal-header">
                        <h5 class="modal-title" style="color:#7C3AED;">
                            <i class="fas fa-circle"></i> Sacar de circulación
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>¿Está seguro de que desea sacar este cheque de circulación?</p>
                        <div class="form-group">
                            <label>Observación <span class="required">*</span></label>
                            <textarea name="observacion" class="form-control" rows="3" placeholder="Describa el motivo..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times"></i> Cancelar
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check"></i> Confirmar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/funciones.js"></script>
    <script>
        // ============================================================
        // FUNCIONES PARA ANULAR Y SACAR DE CIRCULACIÓN
        // ============================================================
        
        function anularCheque(id) {
            document.getElementById('anularId').value = id;
            new bootstrap.Modal(document.getElementById('modalAnular')).show();
        }
        
        function sacarCirculacion(id) {
            document.getElementById('circulacionId').value = id;
            new bootstrap.Modal(document.getElementById('modalCirculacion')).show();
        }
        
        // ============================================================
        // FUNCIONES PARA EL MODAL DE CHEQUES
        // ============================================================
        
        function obtenerFechaActualFormateada() {
            var hoy = new Date();
            var dia = String(hoy.getDate()).padStart(2, '0');
            var mes = String(hoy.getMonth() + 1).padStart(2, '0');
            var anio = hoy.getFullYear();
            return { display : dia + '/' + mes + '/' + anio, iso : anio + '-' + mes + '-' + dia };
        }
        
        function abrirModalCheque() {
            document.getElementById('formAccion').value = 'crear';
            document.getElementById('formId').value = '';
            document.getElementById('formNumero').textContent = '...';
            document.getElementById('formNumeroHidden').value = '';
            document.getElementById('formProveedor').value = '';
            document.getElementById('formObjeto').value = '';
            document.getElementById('formMonto').value = '';
            document.getElementById('formMontoLetras').value = '';
            document.getElementById('formDetalle').value = '';
            document.getElementById('formEstado').value = '1';
            document.getElementById('modalTitle').textContent = 'Registrar cheque';
            
            var fechaActual = obtenerFechaActualFormateada();
            document.getElementById('formFecha').textContent = fechaActual.display;
            document.getElementById('formFechaHidden').value = fechaActual.iso;
            
            fetch('ChequeServlet?accion=obtenerNumero')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('formNumero').textContent = data.numero;
                    document.getElementById('formNumeroHidden').value = data.numero;
                })
                .catch(error => console.error('Error:', error));
            
            new bootstrap.Modal(document.getElementById('modalCheque')).show();
        }
        
        function editarCheque(id) {
            fetch('ChequeServlet?accion=obtener&id=' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('formAccion').value = 'actualizar';
                    document.getElementById('formId').value = data.idCheque;
                    document.getElementById('formNumero').textContent = data.numeroCheque;
                    document.getElementById('formNumeroHidden').value = data.numeroCheque;
                    document.getElementById('formFecha').textContent = data.fechaCheque;
                    document.getElementById('formFechaHidden').value = data.fechaCheque;
                    document.getElementById('formProveedor').value = data.idProveedor;
                    document.getElementById('formObjeto').value = data.idObjetoGasto;
                    document.getElementById('formMonto').value = data.monto;
                    document.getElementById('formMontoLetras').value = data.montoLetras || '';
                    document.getElementById('formDetalle').value = data.detalle || '';
                    document.getElementById('formEstado').value = data.estado;
                    document.getElementById('modalTitle').textContent = 'Editar cheque';
                    new bootstrap.Modal(document.getElementById('modalCheque')).show();
                })
                .catch(error => console.error('Error:', error));
        }
        
        // ============================================================
        // VALIDAR MONTO EN TEXTO (solo números y punto)
        // ============================================================
        
        function validarMontoTexto(input) {
            var valor = input.value.replace(/[^0-9.]/g, '');
            input.value = valor;
        }
        
        // ============================================================
        // VALIDACIÓN DEL FORMULARIO DE CHEQUES
        // ============================================================
        
        function validarFormularioCheque() {
            var numero = document.getElementById('formNumeroHidden').value.trim();
            var fecha = document.getElementById('formFechaHidden').value.trim();
            var proveedor = document.getElementById('formProveedor').value;
            var objeto = document.getElementById('formObjeto').value;
            var monto = document.getElementById('formMonto').value.trim();

            if (numero === '') {
                alert('⚠️ El número de cheque aún no se ha generado, espere un momento e intente de nuevo.');
                return false;
            }

            if (fecha === '') {
                alert('⚠️ No se pudo establecer la fecha del cheque.');
                return false;
            }

            if (proveedor === '') {
                alert('⚠️ Por favor, seleccione un proveedor.');
                document.getElementById('formProveedor').focus();
                return false;
            }

            if (objeto === '') {
                alert('⚠️ Por favor, seleccione un objeto de gasto.');
                document.getElementById('formObjeto').focus();
                return false;
            }

            if (monto === '' || parseFloat(monto) <= 0) {
                alert('⚠️ Por favor, ingrese un monto mayor que cero.');
                document.getElementById('formMonto').focus();
                return false;
            }

            return true;
        }
    </script>
</body>
</html>