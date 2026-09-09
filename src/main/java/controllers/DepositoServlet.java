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

import dao.DepositoDAO;
import model.Deposito;
import model.Usuario;

@WebServlet("/DepositoServlet")
public class DepositoServlet extends HttpServlet
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
        DepositoDAO dao = new DepositoDAO();
        
        if (accion == null)
        {
            accion = "listar";
        }
        
        switch (accion)
        {
        
	        case "buscar":
	            String texto = request.getParameter("texto");
	            List<Deposito> resultados = dao.buscar(texto);
	            request.setAttribute("depositos", resultados);
	            request.getRequestDispatcher("depositos.jsp").forward(request, response);
	            break;
            
            case "listar":
                List<Deposito> lista = dao.listarTodos();
                request.setAttribute("depositos", lista);
                request.getRequestDispatcher("depositos.jsp").forward(request, response);
                break;
                
            case "listarActivos":
                List<Deposito> activos = dao.listarActivos();
                request.setAttribute("depositos", activos);
                request.getRequestDispatcher("depositos.jsp").forward(request, response);
                break;
                
            case "listarPorTipo":
                int tipo = Integer.parseInt(request.getParameter("tipo"));
                List<Deposito> filtrados = dao.listarPorTipo(tipo);
                request.setAttribute("depositos", filtrados);
                request.getRequestDispatcher("depositos.jsp").forward(request, response);
                break;
                
            case "obtener":
                int id = Integer.parseInt(request.getParameter("id"));
                Deposito d = dao.obtenerPorId(id);
                request.setAttribute("deposito", d);
                request.getRequestDispatcher("depositos.jsp").forward(request, response);
                break;
                
            case "nuevo":
                request.setAttribute("modo", "crear");
                request.getRequestDispatcher("depositos.jsp").forward(request, response);
                break;
                
            case "editar":
                int idEditar = Integer.parseInt(request.getParameter("id"));
                Deposito editar = dao.obtenerPorId(idEditar);
                request.setAttribute("deposito", editar);
                request.setAttribute("modo", "editar");
                request.getRequestDispatcher("depositos.jsp").forward(request, response);
                break;
                
            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(idEliminar);
                response.sendRedirect("DepositoServlet?accion=listar");
                break;
                
            default:
                response.sendRedirect("DepositoServlet?accion=listar");
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
        DepositoDAO dao = new DepositoDAO();
        
        if (accion == null)
        {
            response.sendRedirect("DepositoServlet?accion=listar");
            return;
        }
        
        switch (accion)
        {
        case "crear":
            String numeroComprobante = request.getParameter("numero_comprobante");
            int tipoDeposito = Integer.parseInt(request.getParameter("tipo_deposito"));
            Date fecha = Date.valueOf(request.getParameter("fecha"));
            String montoStr = request.getParameter("monto").replace(",", "");
            BigDecimal monto = new BigDecimal(montoStr);
            String detalle = request.getParameter("detalle");
            
            Deposito nuevo = new Deposito();
            nuevo.setNumeroComprobante(numeroComprobante);
            nuevo.setTipoDeposito(tipoDeposito);
            nuevo.setFecha(fecha);
            nuevo.setMonto(monto);
            nuevo.setDetalle(detalle);
            nuevo.setEstado(1);
            nuevo.setIdUsuario(user.getIdUsuario());
            
            dao.crear(nuevo);
            response.sendRedirect("DepositoServlet?accion=listar");
            break;
                
        case "actualizar":
            int id = Integer.parseInt(request.getParameter("id"));
            String numeroComprobanteUpd = request.getParameter("numero_comprobante");
            int tipoDepositoUpd = Integer.parseInt(request.getParameter("tipo_deposito"));
            Date fechaUpd = Date.valueOf(request.getParameter("fecha"));
            
            String montoUpdStr = request.getParameter("monto").replace(",", "");
            BigDecimal montoUpd = new BigDecimal(montoUpdStr);
            
            String detalleUpd = request.getParameter("detalle");
            
            Deposito actualizar = dao.obtenerPorId(id);
            if (actualizar != null)
            {
                actualizar.setNumeroComprobante(numeroComprobanteUpd);
                actualizar.setTipoDeposito(tipoDepositoUpd);
                actualizar.setFecha(fechaUpd);
                actualizar.setMonto(montoUpd);
                actualizar.setDetalle(detalleUpd);
                dao.actualizar(actualizar);
            }
            response.sendRedirect("DepositoServlet?accion=listar");
            break;
                
            default:
                response.sendRedirect("DepositoServlet?accion=listar");
        }
    }
}