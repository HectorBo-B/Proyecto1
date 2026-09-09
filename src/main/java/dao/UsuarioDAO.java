package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;

import config.Conexion;
import model.Usuario;

public class UsuarioDAO
{
    public Usuario validarLogin(String usuario, String password)
    {
        Usuario user = null;
        String sql = "SELECT * FROM usuarios WHERE usuario = ? AND password = ? AND estado = 1";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next())
            {
                user = new Usuario();
                user.setIdUsuario(rs.getInt("id_usuario"));
                user.setNombre(rs.getString("nombre"));
                user.setApellido(rs.getString("apellido"));
                user.setUsuario(rs.getString("usuario"));
                user.setPassword(rs.getString("password"));
                user.setCorreo(rs.getString("correo"));
                user.setRol(rs.getString("rol"));
                user.setEstado(rs.getInt("estado"));
                user.setFechaCreacion(rs.getDate("fecha_creacion"));
                user.setIntentosFallidos(rs.getInt("intentos_fallidos"));
                user.setBloqueadoHasta(rs.getDate("bloqueado_hasta"));
            }
            
            rs.close();
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return user;
    }
    
    public Usuario obtenerPorId(int idUsuario)
    {
        Usuario user = null;
        String sql = "SELECT * FROM usuarios WHERE id_usuario = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next())
            {
                user = new Usuario();
                user.setIdUsuario(rs.getInt("id_usuario"));
                user.setNombre(rs.getString("nombre"));
                user.setApellido(rs.getString("apellido"));
                user.setUsuario(rs.getString("usuario"));
                user.setPassword(rs.getString("password"));
                user.setCorreo(rs.getString("correo"));
                user.setRol(rs.getString("rol"));
                user.setEstado(rs.getInt("estado"));
                user.setFechaCreacion(rs.getDate("fecha_creacion"));
                user.setIntentosFallidos(rs.getInt("intentos_fallidos"));
                user.setBloqueadoHasta(rs.getDate("bloqueado_hasta"));
            }
            
            rs.close();
            ps.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        
        return user;
    }
    
    public boolean actualizarIntentosFallidos(int idUsuario, int intentos)
    {
        boolean actualizado = false;
        String sql = "UPDATE usuarios SET intentos_fallidos = ? WHERE id_usuario = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, intentos);
            ps.setInt(2, idUsuario);
            
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
    
    public boolean bloquearUsuario(int idUsuario, Date fechaBloqueo)
    {
        boolean actualizado = false;
        String sql = "UPDATE usuarios SET bloqueado_hasta = ? WHERE id_usuario = ?";
        
        try
        {
            Connection conn = Conexion.getInstance().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDate(1, fechaBloqueo);
            ps.setInt(2, idUsuario);
            
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
    
}

