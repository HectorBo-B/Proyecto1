package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import dao.ChequeDAO;
import dao.ConciliacionDAO;
import dao.ConciliacionDetalleChequeDAO;
import dao.ConciliacionDetalleDepositoDAO;
import dao.DepositoDAO;
import model.Cheque;
import model.Conciliacion;
import model.ConciliacionDetalleCheque;
import model.ConciliacionDetalleDeposito;
import model.Deposito;
import model.Usuario;

@WebServlet("/ConciliacionServlet")
public class ConciliacionServlet extends HttpServlet
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
        ConciliacionDAO dao = new ConciliacionDAO();
        
        if (accion == null)
        {
            accion = "listar";
        }
        
        switch (accion)
        {
            case "listar":
                List<Conciliacion> lista = dao.listarTodos();
                request.setAttribute("conciliaciones", lista);
                request.getRequestDispatcher("conciliacion.jsp").forward(request, response);
                break;
                
            case "nueva":
                request.setAttribute("modo", "crear");
                request.getRequestDispatcher("conciliacion.jsp").forward(request, response);
                break;
                
            case "calcular":
                String periodo = request.getParameter("periodo");
                BigDecimal saldoBanco = new BigDecimal(request.getParameter("saldo_banco"));
                
                // Obtener cheques pendientes del periodo
                ChequeDAO chequeDAO = new ChequeDAO();
                List<Cheque> chequesPendientes = chequeDAO.listarPorEstado(2);
                BigDecimal totalPendientes = BigDecimal.ZERO;
                for (Cheque c : chequesPendientes)
                {
                    totalPendientes = totalPendientes.add(c.getMonto());
                }
                
                // Obtener depositos activos del periodo
                DepositoDAO depositoDAO = new DepositoDAO();
                List<Deposito> depositosActivos = depositoDAO.listarActivos();
                BigDecimal totalDepositos = BigDecimal.ZERO;
                for (Deposito d : depositosActivos)
                {
                    totalDepositos = totalDepositos.add(d.getMonto());
                }
                
                // Calcular saldo libros (ejemplo: 0 o se puede obtener de otra tabla)
                BigDecimal saldoLibros = BigDecimal.ZERO;
                
                // Calcular saldo conciliado
                BigDecimal saldoConciliado = saldoLibros.add(totalDepositos).subtract(totalPendientes);
                
                // Calcular diferencia
                BigDecimal diferencia = saldoBanco.subtract(saldoConciliado);
                
                // Determinar estado
                int estado = (diferencia.compareTo(BigDecimal.ZERO) == 0) ? 3 : 1;
                
                request.setAttribute("periodo", periodo);
                request.setAttribute("saldoLibros", saldoLibros);
                request.setAttribute("totalDepositos", totalDepositos);
                request.setAttribute("totalPendientes", totalPendientes);
                request.setAttribute("saldoConciliado", saldoConciliado);
                request.setAttribute("saldoBanco", saldoBanco);
                request.setAttribute("diferencia", diferencia);
                request.setAttribute("estado", estado);
                request.setAttribute("modo", "resultado");
                
                request.getRequestDispatcher("conciliacion.jsp").forward(request, response);
                break;
                
            case "obtener":
                int id = Integer.parseInt(request.getParameter("id"));
                Conciliacion c = dao.obtenerPorId(id);
                request.setAttribute("conciliacion", c);
                request.getRequestDispatcher("conciliacion.jsp").forward(request, response);
                break;
                
            default:
                response.sendRedirect("ConciliacionServlet?accion=listar");
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
        ConciliacionDAO dao = new ConciliacionDAO();
        
        if (accion == null)
        {
            response.sendRedirect("ConciliacionServlet?accion=listar");
            return;
        }
        
        switch (accion)
        {
            case "guardar":
                String periodo = request.getParameter("periodo");
                BigDecimal saldoLibros = new BigDecimal(request.getParameter("saldo_libros"));
                BigDecimal depositosTransito = new BigDecimal(request.getParameter("depositos_transito"));
                BigDecimal chequesPendientes = new BigDecimal(request.getParameter("cheques_pendientes"));
                BigDecimal saldoBanco = new BigDecimal(request.getParameter("saldo_banco"));
                BigDecimal diferencia = new BigDecimal(request.getParameter("diferencia"));
                int estado = Integer.parseInt(request.getParameter("estado"));
                String observaciones = request.getParameter("observaciones");
                
                Conciliacion nueva = new Conciliacion();
                nueva.setPeriodo(periodo);
                nueva.setSaldoLibros(saldoLibros);
                nueva.setDepositosTransito(depositosTransito);
                nueva.setChequesPendientes(chequesPendientes);
                nueva.setSaldoBanco(saldoBanco);
                nueva.setDiferencia(diferencia);
                nueva.setEstado(estado);
                nueva.setIdUsuario(user.getIdUsuario());
                nueva.setObservaciones(observaciones);
                
                dao.crear(nueva);
                response.sendRedirect("ConciliacionServlet?accion=listar");
                break;
                
            default:
                response.sendRedirect("ConciliacionServlet?accion=listar");
        }
    }
}