package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import dao.ObjetoGastoDAO;
import model.ObjetoGasto;
import model.Usuario;

@WebServlet("/ObjetoGastoServlet")
public class ObjetoGastoServlet extends HttpServlet
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
        ObjetoGastoDAO dao = new ObjetoGastoDAO();
        
        if (accion == null)
        {
            accion = "listar";
        }
        
        switch (accion)
        {
	        case "buscar":
	            String texto = request.getParameter("texto");
	            List<ObjetoGasto> resultados = dao.buscar(texto);
	            request.setAttribute("objetos", resultados);
	            request.getRequestDispatcher("objetos.jsp").forward(request, response);
	            break;
	            
            case "listar":
                List<ObjetoGasto> lista = dao.listarTodos();
                request.setAttribute("objetos", lista);
                request.getRequestDispatcher("objetos.jsp").forward(request, response);
                break;
                
            case "listarActivos":
                List<ObjetoGasto> activos = dao.listarActivos();
                request.setAttribute("objetos", activos);
                request.getRequestDispatcher("objetos.jsp").forward(request, response);
                break;
                
            case "eliminar":
                int id = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(id);
                response.sendRedirect("ObjetoGastoServlet?accion=listar");
                break;
                
            case "obtener":
                int idObtener = Integer.parseInt(request.getParameter("id"));
                ObjetoGasto o = dao.obtenerPorId(idObtener);
                request.setAttribute("objeto", o);
                request.getRequestDispatcher("objetos.jsp").forward(request, response);
                break;
                
            default:
                response.sendRedirect("ObjetoGastoServlet?accion=listar");
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
        ObjetoGastoDAO dao = new ObjetoGastoDAO();
        
        if (accion == null)
        {
            response.sendRedirect("ObjetoGastoServlet?accion=listar");
            return;
        }
        
        switch (accion)
        {
        case "crear":
            System.out.println("=== SERVLET: CREANDO OBJETO DE GASTO ===");
            System.out.println("Código recibido: " + request.getParameter("codigo"));
            System.out.println("Descripción recibida: " + request.getParameter("descripcion"));
            
            String codigo = request.getParameter("codigo");
            String descripcion = request.getParameter("descripcion");
            
            ObjetoGasto nuevo = new ObjetoGasto();
            nuevo.setCodigo(codigo);
            nuevo.setDescripcion(descripcion);
            nuevo.setEstado(1);
            
            boolean creado = dao.crear(nuevo);
            System.out.println("Resultado de crear(): " + creado);
            
            response.sendRedirect("ObjetoGastoServlet?accion=listar");
            break;
                
            case "actualizar":
                int id = Integer.parseInt(request.getParameter("id"));
                String codigoUpd = request.getParameter("codigo");
                String descripcionUpd = request.getParameter("descripcion");
                int estadoUpd = Integer.parseInt(request.getParameter("estado"));
                
                ObjetoGasto actualizar = dao.obtenerPorId(id);
                if (actualizar != null)
                {
                    actualizar.setCodigo(codigoUpd);
                    actualizar.setDescripcion(descripcionUpd);
                    actualizar.setEstado(estadoUpd);
                    dao.actualizar(actualizar);
                }
                response.sendRedirect("ObjetoGastoServlet?accion=listar");
                break;
                
            default:
                response.sendRedirect("ObjetoGastoServlet?accion=listar");
        }
    }
}