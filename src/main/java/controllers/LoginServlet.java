package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Usuario;
import dao.UsuarioDAO;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet
{
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");
        
        UsuarioDAO dao = new UsuarioDAO();
        Usuario user = dao.validarLogin(usuario, password);
        
        if (user != null)
        {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", user);
            response.sendRedirect("DashboardServlet");
        }
        else
        {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.sendRedirect("login.jsp");
    }
}