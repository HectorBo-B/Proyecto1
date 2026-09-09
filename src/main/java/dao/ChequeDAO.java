package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import config.Conexion;
import model.Cheque;

public class ChequeDAO
{
    public List<Cheque> listarTodos()
    {
        List<Cheque> lista = new ArrayList<>();
        String sql = "SELECT * FROM cheques ORDER BY fecha_cheque DESC";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next())
            {
                Cheque c = new Cheque();
                c.setIdCheque(rs.getInt("id_cheque"));
                c.setNumeroCheque(rs.getString("numero_cheque"));
                c.setFechaCheque(rs.getDate("fecha_cheque"));
                c.setIdProveedor(rs.getInt("id_proveedor"));
                c.setMonto(rs.getBigDecimal("monto"));
                c.setMontoLetras(rs.getString("monto_letras"));
                c.setDetalle(rs.getString("detalle"));
                c.setIdObjetoGasto(rs.getInt("id_objeto_gasto"));
                c.setEstado(rs.getInt("estado"));
                c.setFechaAnulacion(rs.getDate("fecha_anulacion"));
                c.setMotivoAnulacion(rs.getString("motivo_anulacion"));
                c.setFechaSalidaCirculacion(rs.getDate("fecha_salida_circulacion"));
                c.setObservacionSalida(rs.getString("observacion_salida"));
                c.setIdUsuarioCreacion(rs.getInt("id_usuario_creacion"));
                c.setIdUsuarioAnulacion(rs.getInt("id_usuario_anulacion"));
                lista.add(c);
            }
            
            rs.close();
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return lista;
    }
    
    public List<Cheque> listarPorEstado(int estado)
    {
        List<Cheque> lista = new ArrayList<>();
        String sql = "SELECT * FROM cheques WHERE estado = ? ORDER BY fecha_cheque DESC";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, estado);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next())
            {
                Cheque c = new Cheque();
                c.setIdCheque(rs.getInt("id_cheque"));
                c.setNumeroCheque(rs.getString("numero_cheque"));
                c.setFechaCheque(rs.getDate("fecha_cheque"));
                c.setIdProveedor(rs.getInt("id_proveedor"));
                c.setMonto(rs.getBigDecimal("monto"));
                c.setMontoLetras(rs.getString("monto_letras"));
                c.setDetalle(rs.getString("detalle"));
                c.setIdObjetoGasto(rs.getInt("id_objeto_gasto"));
                c.setEstado(rs.getInt("estado"));
                c.setFechaAnulacion(rs.getDate("fecha_anulacion"));
                c.setMotivoAnulacion(rs.getString("motivo_anulacion"));
                c.setFechaSalidaCirculacion(rs.getDate("fecha_salida_circulacion"));
                c.setObservacionSalida(rs.getString("observacion_salida"));
                c.setIdUsuarioCreacion(rs.getInt("id_usuario_creacion"));
                c.setIdUsuarioAnulacion(rs.getInt("id_usuario_anulacion"));
                lista.add(c);
            }
            
            rs.close();
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return lista;
    }
    
    public Cheque obtenerPorId(int idCheque)
    {
        Cheque c = null;
        String sql = "SELECT * FROM cheques WHERE id_cheque = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idCheque);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next())
            {
                c = new Cheque();
                c.setIdCheque(rs.getInt("id_cheque"));
                c.setNumeroCheque(rs.getString("numero_cheque"));
                c.setFechaCheque(rs.getDate("fecha_cheque"));
                c.setIdProveedor(rs.getInt("id_proveedor"));
                c.setMonto(rs.getBigDecimal("monto"));
                c.setMontoLetras(rs.getString("monto_letras"));
                c.setDetalle(rs.getString("detalle"));
                c.setIdObjetoGasto(rs.getInt("id_objeto_gasto"));
                c.setEstado(rs.getInt("estado"));
                c.setFechaAnulacion(rs.getDate("fecha_anulacion"));
                c.setMotivoAnulacion(rs.getString("motivo_anulacion"));
                c.setFechaSalidaCirculacion(rs.getDate("fecha_salida_circulacion"));
                c.setObservacionSalida(rs.getString("observacion_salida"));
                c.setIdUsuarioCreacion(rs.getInt("id_usuario_creacion"));
                c.setIdUsuarioAnulacion(rs.getInt("id_usuario_anulacion"));
            }
            
            rs.close();
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return c;
    }
    
    public Cheque obtenerPorNumero(String numeroCheque)
    {
        Cheque c = null;
        String sql = "SELECT * FROM cheques WHERE numero_cheque = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, numeroCheque);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next())
            {
                c = new Cheque();
                c.setIdCheque(rs.getInt("id_cheque"));
                c.setNumeroCheque(rs.getString("numero_cheque"));
                c.setFechaCheque(rs.getDate("fecha_cheque"));
                c.setIdProveedor(rs.getInt("id_proveedor"));
                c.setMonto(rs.getBigDecimal("monto"));
                c.setMontoLetras(rs.getString("monto_letras"));
                c.setDetalle(rs.getString("detalle"));
                c.setIdObjetoGasto(rs.getInt("id_objeto_gasto"));
                c.setEstado(rs.getInt("estado"));
                c.setFechaAnulacion(rs.getDate("fecha_anulacion"));
                c.setMotivoAnulacion(rs.getString("motivo_anulacion"));
                c.setFechaSalidaCirculacion(rs.getDate("fecha_salida_circulacion"));
                c.setObservacionSalida(rs.getString("observacion_salida"));
                c.setIdUsuarioCreacion(rs.getInt("id_usuario_creacion"));
                c.setIdUsuarioAnulacion(rs.getInt("id_usuario_anulacion"));
            }
            
            rs.close();
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return c;
    }
    
    public boolean crear(Cheque cheque)
    {
        boolean creado = false;
        String sql = "INSERT INTO cheques (numero_cheque, fecha_cheque, id_proveedor, monto, "
                   + "monto_letras, detalle, id_objeto_gasto, estado, id_usuario_creacion) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, cheque.getNumeroCheque());
            ps.setDate(2, cheque.getFechaCheque());
            ps.setInt(3, cheque.getIdProveedor());
            ps.setBigDecimal(4, cheque.getMonto());
            ps.setString(5, cheque.getMontoLetras());
            ps.setString(6, cheque.getDetalle());
            ps.setInt(7, cheque.getIdObjetoGasto());
            ps.setInt(8, cheque.getEstado());
            ps.setInt(9, cheque.getIdUsuarioCreacion());
            
            int filas = ps.executeUpdate();
            if (filas > 0)
            {
                creado = true;
            }
            
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return creado;
    }
    
    public boolean actualizar(Cheque cheque)
    {
        boolean actualizado = false;
        String sql = "UPDATE cheques SET numero_cheque = ?, fecha_cheque = ?, id_proveedor = ?, "
                   + "monto = ?, monto_letras = ?, detalle = ?, id_objeto_gasto = ?, estado = ? "
                   + "WHERE id_cheque = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, cheque.getNumeroCheque());
            ps.setDate(2, cheque.getFechaCheque());
            ps.setInt(3, cheque.getIdProveedor());
            ps.setBigDecimal(4, cheque.getMonto());
            ps.setString(5, cheque.getMontoLetras());
            ps.setString(6, cheque.getDetalle());
            ps.setInt(7, cheque.getIdObjetoGasto());
            ps.setInt(8, cheque.getEstado());
            ps.setInt(9, cheque.getIdCheque());
            
            int filas = ps.executeUpdate();
            if (filas > 0)
            {
                actualizado = true;
            }
            
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return actualizado;
    }
    
    public boolean cambiarEstado(int idCheque, int nuevoEstado)
    {
        boolean actualizado = false;
        String sql = "UPDATE cheques SET estado = ? WHERE id_cheque = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idCheque);
            
            int filas = ps.executeUpdate();
            if (filas > 0)
            {
                actualizado = true;
            }
            
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return actualizado;
    }
    
    public boolean anularCheque(int idCheque, String motivo, int idUsuarioAnulacion)
    {
        boolean actualizado = false;
        String sql = "UPDATE cheques SET estado = 4, fecha_anulacion = NOW(), "
                   + "motivo_anulacion = ?, id_usuario_anulacion = ? WHERE id_cheque = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, motivo);
            ps.setInt(2, idUsuarioAnulacion);
            ps.setInt(3, idCheque);
            
            int filas = ps.executeUpdate();
            if (filas > 0)
            {
                actualizado = true;
            }
            
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return actualizado;
    }
    
    public boolean sacarDeCirculacion(int idCheque, String observacion)
    {
        boolean actualizado = false;
        String sql = "UPDATE cheques SET estado = 5, fecha_salida_circulacion = NOW(), "
                   + "observacion_salida = ? WHERE id_cheque = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, observacion);
            ps.setInt(2, idCheque);
            
            int filas = ps.executeUpdate();
            if (filas > 0)
            {
                actualizado = true;
            }
            
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return actualizado;
    }
    
    public String obtenerSiguienteNumeroCheque()
    {
        String siguiente = "1";
        String sql = "SELECT MAX(CAST(numero_cheque AS UNSIGNED)) AS max_numero FROM cheques";

        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next())
            {
                int maxNumero = rs.getInt("max_numero");
                siguiente = String.valueOf(maxNumero + 1);
            }

            rs.close();
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }

        return siguiente;
    }
}