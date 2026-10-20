package com.codegym.dao;
import com.codegym.model.User;import java.sql.*;import java.util.*;
public class UserDAO implements IUserDAO {
 private static final String URL="jdbc:mysql://localhost:3306/demo?useSSL=false&serverTimezone=UTC";private static final String USER="root";private static final String PASSWORD="123456";
 private Connection connection()throws SQLException{return DriverManager.getConnection(URL,USER,PASSWORD);}
 public void insertUser(User u)throws SQLException{try(Connection c=connection();PreparedStatement p=c.prepareStatement("INSERT INTO users(name,email,country) VALUES(?,?,?)")){p.setString(1,u.getName());p.setString(2,u.getEmail());p.setString(3,u.getCountry());p.executeUpdate();}}
 public User selectUser(int id){try(Connection c=connection();PreparedStatement p=c.prepareStatement("SELECT * FROM users WHERE id=?")){p.setInt(1,id);try(ResultSet r=p.executeQuery()){if(r.next())return map(r);}}catch(SQLException e){throw new RuntimeException(e);}return null;}
 public List<User> selectAllUsers(){List<User> list=new ArrayList<>();try(Connection c=connection();PreparedStatement p=c.prepareStatement("SELECT * FROM users ORDER BY id");ResultSet r=p.executeQuery()){while(r.next())list.add(map(r));}catch(SQLException e){throw new RuntimeException(e);}return list;}
 public boolean deleteUser(int id)throws SQLException{try(Connection c=connection();PreparedStatement p=c.prepareStatement("DELETE FROM users WHERE id=?")){p.setInt(1,id);return p.executeUpdate()>0;}}
 public boolean updateUser(User u)throws SQLException{try(Connection c=connection();PreparedStatement p=c.prepareStatement("UPDATE users SET name=?,email=?,country=? WHERE id=?")){p.setString(1,u.getName());p.setString(2,u.getEmail());p.setString(3,u.getCountry());p.setInt(4,u.getId());return p.executeUpdate()>0;}}
 private User map(ResultSet r)throws SQLException{return new User(r.getInt("id"),r.getString("name"),r.getString("email"),r.getString("country"));}
}
