package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import dao.ProveedorDAO;
import model.Proveedor;
import model.Usuario;

@WebServlet("/ProveedorServlet")
public class ProveedorServlet extends HttpServlet
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
        ProveedorDAO dao = new ProveedorDAO();
        
        if (accion == null)
        {
            accion = "listar";
        }
        
        switch (accion)
        {
            case "listar":
                List<Proveedor> lista = dao.listarTodos();
                request.setAttribute("proveedores", lista);
                request.getRequestDispatcher("proveedores.jsp").forward(request, response);
                break;
                
            case "buscar":
                String texto = request.getParameter("texto");
                List<Proveedor> resultados = dao.buscar(texto);
                request.setAttribute("proveedores", resultados);
                request.getRequestDispatcher("proveedores.jsp").forward(request, response);
                break;
                
            case "eliminar":
                int id = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(id);
                response.sendRedirect("ProveedorServlet?accion=listar");
                break;
                
            case "obtener":
                int idObtener = Integer.parseInt(request.getParameter("id"));
                Proveedor p = dao.obtenerPorId(idObtener);
                request.setAttribute("proveedor", p);
                request.getRequestDispatcher("proveedores.jsp").forward(request, response);
                break;
                
            default:
                response.sendRedirect("ProveedorServlet?accion=listar");
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
        ProveedorDAO dao = new ProveedorDAO();
        
        if (accion == null)
        {
            response.sendRedirect("ProveedorServlet?accion=listar");
            return;
        }
        
        switch (accion)
        {
            case "crear":
                String nombre = request.getParameter("nombre");
                String telefono = request.getParameter("telefono");
                String correo = request.getParameter("correo");
                String ruc = request.getParameter("ruc");
                
                Proveedor nuevo = new Proveedor();
                nuevo.setNombre(nombre);
                nuevo.setTelefono(telefono);
                nuevo.setCorreo(correo);
                nuevo.setRuc(ruc);
                nuevo.setEstado(1);
                
                dao.crear(nuevo);
                response.sendRedirect("ProveedorServlet?accion=listar");
                break;
                
            case "actualizar":
                int id = Integer.parseInt(request.getParameter("id"));
                String nombreUpd = request.getParameter("nombre");
                String telefonoUpd = request.getParameter("telefono");
                String correoUpd = request.getParameter("correo");
                String rucUpd = request.getParameter("ruc");
                int estadoUpd = Integer.parseInt(request.getParameter("estado"));
                
                Proveedor actualizar = dao.obtenerPorId(id);
                if (actualizar != null)
                {
                    actualizar.setNombre(nombreUpd);
                    actualizar.setTelefono(telefonoUpd);
                    actualizar.setCorreo(correoUpd);
                    actualizar.setRuc(rucUpd);
                    actualizar.setEstado(estadoUpd);
                    dao.actualizar(actualizar);
                }
                response.sendRedirect("ProveedorServlet?accion=listar");
                break;
                
            default:
                response.sendRedirect("ProveedorServlet?accion=listar");
        }
    }
}