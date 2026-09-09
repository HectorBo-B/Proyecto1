package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import dao.ChequeDAO;
import dao.ProveedorDAO;
import dao.ObjetoGastoDAO;
import model.Cheque;
import model.Proveedor;
import model.ObjetoGasto;
import model.Usuario;

@WebServlet("/ChequeServlet")
public class ChequeServlet extends HttpServlet
{
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        
        if (user == null)
        {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        ChequeDAO dao = new ChequeDAO();
        
        if (accion == null)
        {
            accion = "listar";
        }
        
        switch (accion)
        {
            case "listar":
                List<Cheque> lista = dao.listarTodos();
                request.setAttribute("cheques", lista);
                cargarDatosParaFormulario(request);
                request.getRequestDispatcher("cheques.jsp").forward(request, response);
                break;
                
            case "listarPorEstado":
                int estado = Integer.parseInt(request.getParameter("estado"));
                List<Cheque> filtrados = dao.listarPorEstado(estado);
                request.setAttribute("cheques", filtrados);
                cargarDatosParaFormulario(request);
                request.getRequestDispatcher("cheques.jsp").forward(request, response);
                break;
                
            case "obtener":
                int id = Integer.parseInt(request.getParameter("id"));
                Cheque c = dao.obtenerPorId(id);
                request.setAttribute("cheque", c);
                cargarDatosParaFormulario(request);
                request.getRequestDispatcher("cheques.jsp").forward(request, response);
                break;
                
            case "nuevo":
                cargarDatosParaFormulario(request);
                request.setAttribute("modo", "crear");
                request.getRequestDispatcher("cheques.jsp").forward(request, response);
                break;
                
            case "editar":
                int idEditar = Integer.parseInt(request.getParameter("id"));
                Cheque editar = dao.obtenerPorId(idEditar);
                request.setAttribute("cheque", editar);
                request.setAttribute("modo", "editar");
                cargarDatosParaFormulario(request);
                request.getRequestDispatcher("cheques.jsp").forward(request, response);
                break;
                
            case "anular":
                int idAnular = Integer.parseInt(request.getParameter("id"));
                String motivo = request.getParameter("motivo");
                if (motivo != null && !motivo.isEmpty())
                {
                    dao.anularCheque(idAnular, motivo, user.getIdUsuario());
                }
                response.sendRedirect("ChequeServlet?accion=listar");
                break;
                
            case "sacarCirculacion":
                int idSacar = Integer.parseInt(request.getParameter("id"));
                String observacion = request.getParameter("observacion");
                if (observacion != null && !observacion.isEmpty())
                {
                    dao.sacarDeCirculacion(idSacar, observacion);
                }
                response.sendRedirect("ChequeServlet?accion=listar");
                break;
                
            case "obtenerNumero":
                String siguienteNumero = dao.obtenerSiguienteNumeroCheque();
                response.setContentType("application/json");
                response.getWriter().write("{\"numero\":\"" + siguienteNumero + "\"}");
                break;
                
            default:
                response.sendRedirect("ChequeServlet?accion=listar");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        
        if (user == null)
        {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        ChequeDAO dao = new ChequeDAO();
        
        if (accion == null)
        {
            response.sendRedirect("ChequeServlet?accion=listar");
            return;
        }
        
        switch (accion)
        {
            case "crear":
                String numero = request.getParameter("numero_cheque");
                Date fecha = Date.valueOf(request.getParameter("fecha_cheque"));
                int idProveedor = Integer.parseInt(request.getParameter("id_proveedor"));
                String montoStr = request.getParameter("monto").replace(",", "");
                BigDecimal monto = new BigDecimal(montoStr);
                String montoLetras = request.getParameter("monto_letras");
                String detalle = request.getParameter("detalle");
                int idObjeto = Integer.parseInt(request.getParameter("id_objeto_gasto"));
                int estado = Integer.parseInt(request.getParameter("estado"));
                
                Cheque nuevo = new Cheque();
                nuevo.setNumeroCheque(numero);
                nuevo.setFechaCheque(fecha);
                nuevo.setIdProveedor(idProveedor);
                nuevo.setMonto(monto);
                nuevo.setMontoLetras(montoLetras);
                nuevo.setDetalle(detalle);
                nuevo.setIdObjetoGasto(idObjeto);
                nuevo.setEstado(1);
                nuevo.setIdUsuarioCreacion(user.getIdUsuario());
                
                dao.crear(nuevo);
                response.sendRedirect("ChequeServlet?accion=listar");
                break;
                
            case "actualizar":
                int id = Integer.parseInt(request.getParameter("id"));
                String numeroUpd = request.getParameter("numero_cheque");
                Date fechaUpd = Date.valueOf(request.getParameter("fecha_cheque"));
                int idProveedorUpd = Integer.parseInt(request.getParameter("id_proveedor"));
                String montoUpdStr = request.getParameter("monto").replace(",", "");
                BigDecimal montoUpd = new BigDecimal(montoUpdStr);                
                String montoLetrasUpd = request.getParameter("monto_letras");
                String detalleUpd = request.getParameter("detalle");
                int idObjetoUpd = Integer.parseInt(request.getParameter("id_objeto_gasto"));
                int estadoUpd = Integer.parseInt(request.getParameter("estado"));
                
                Cheque actualizar = dao.obtenerPorId(id);
                if (actualizar != null)
                {
                    actualizar.setNumeroCheque(numeroUpd);
                    actualizar.setFechaCheque(fechaUpd);
                    actualizar.setIdProveedor(idProveedorUpd);
                    actualizar.setMonto(montoUpd);
                    actualizar.setMontoLetras(montoLetrasUpd);
                    actualizar.setDetalle(detalleUpd);
                    actualizar.setIdObjetoGasto(idObjetoUpd);
                    actualizar.setEstado(estadoUpd);
                    dao.actualizar(actualizar);
                }
                response.sendRedirect("ChequeServlet?accion=listar");
                break;
                
            default:
                response.sendRedirect("ChequeServlet?accion=listar");
        }
    }
    
    private void cargarDatosParaFormulario(HttpServletRequest request)
    {
        ProveedorDAO proveedorDAO = new ProveedorDAO();
        ObjetoGastoDAO objetoDAO = new ObjetoGastoDAO();
        
        List<Proveedor> proveedores = proveedorDAO.listarActivos();
        List<ObjetoGasto> objetos = objetoDAO.listarActivos();
        
        request.setAttribute("proveedores", proveedores);
        request.setAttribute("objetos", objetos);
    }
    
    
}