package com.codegym.dao;
import com.codegym.model.User;import java.sql.*;import java.util.*;import java.math.BigDecimal;import java.time.LocalDateTime;
public class UserDAO implements IUserDAO {
 private static final String URL="jdbc:mysql://localhost:3306/demo?useSSL=false&serverTimezone=UTC";private static final String USER=System.getenv().getOrDefault("DB_USER","root");private static final String PASSWORD=System.getenv().getOrDefault("DB_PASSWORD","");
 private Connection connection()throws SQLException{return DriverManager.getConnection(URL,USER,PASSWORD);}
 public void insertUser(User u)throws SQLException{try(Connection c=connection();PreparedStatement p=c.prepareStatement("INSERT INTO users(name,email,country) VALUES(?,?,?)")){p.setString(1,u.getName());p.setString(2,u.getEmail());p.setString(3,u.getCountry());p.executeUpdate();}}
 public User selectUser(int id){try(Connection c=connection();PreparedStatement p=c.prepareStatement("SELECT * FROM users WHERE id=?")){p.setInt(1,id);try(ResultSet r=p.executeQuery()){if(r.next())return map(r);}}catch(SQLException e){throw new RuntimeException(e);}return null;}
 public List<User> selectAllUsers(){List<User> list=new ArrayList<>();try(Connection c=connection();PreparedStatement p=c.prepareStatement("SELECT * FROM users ORDER BY id");ResultSet r=p.executeQuery()){while(r.next())list.add(map(r));}catch(SQLException e){throw new RuntimeException(e);}return list;}
 public boolean deleteUser(int id)throws SQLException{try(Connection c=connection();PreparedStatement p=c.prepareStatement("DELETE FROM users WHERE id=?")){p.setInt(1,id);return p.executeUpdate()>0;}}
 public boolean updateUser(User u)throws SQLException{try(Connection c=connection();PreparedStatement p=c.prepareStatement("UPDATE users SET name=?,email=?,country=? WHERE id=?")){p.setString(1,u.getName());p.setString(2,u.getEmail());p.setString(3,u.getCountry());p.setInt(4,u.getId());return p.executeUpdate()>0;}}
 public List<User> selectAllUsersUsingSP(){List<User> list=new ArrayList<>();try(Connection c=connection();CallableStatement call=c.prepareCall("{CALL get_users()}");ResultSet r=call.executeQuery()){while(r.next())list.add(map(r));}catch(SQLException e){throw new RuntimeException(e);}return list;}
 public boolean updateUserUsingSP(User u)throws SQLException{try(Connection c=connection();CallableStatement call=c.prepareCall("{CALL update_user(?,?,?,?)}")){call.setInt(1,u.getId());call.setString(2,u.getName());call.setString(3,u.getEmail());call.setString(4,u.getCountry());return call.executeUpdate()>0;}}
 public boolean deleteUserUsingSP(int id)throws SQLException{try(Connection c=connection();CallableStatement call=c.prepareCall("{CALL delete_user(?)}")){call.setInt(1,id);return call.executeUpdate()>0;}}
 public void insertUpdateWithoutTransaction()throws SQLException{
  String create="CREATE TABLE Employee(id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,salary DECIMAL(15,2) NOT NULL,created_Date TIMESTAMP)";
  try(Connection c=connection();Statement st=c.createStatement();PreparedStatement ins=c.prepareStatement("INSERT INTO Employee(name,salary,created_Date) VALUES(?,?,?)");PreparedStatement upd=c.prepareStatement("UPDATE Employee SET salary=? WHERE name=?")){
   st.execute("DROP TABLE IF EXISTS Employee");st.execute(create);
   ins.setString(1,"Quynh");ins.setBigDecimal(2,new BigDecimal("10"));ins.setTimestamp(3,Timestamp.valueOf(LocalDateTime.now()));ins.executeUpdate();
   ins.setString(1,"Ngan");ins.setBigDecimal(2,new BigDecimal("20"));ins.setTimestamp(3,Timestamp.valueOf(LocalDateTime.now()));ins.executeUpdate();
   upd.setBigDecimal(2,new BigDecimal("999.99"));upd.setString(2,"Quynh");upd.executeUpdate();
  }
 }
 private User map(ResultSet r)throws SQLException{return new User(r.getInt("id"),r.getString("name"),r.getString("email"),r.getString("country"));}
}
