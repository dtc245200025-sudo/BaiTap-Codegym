package com.codegym.dao;
import com.codegym.model.Product;
import java.sql.*; import java.util.*;
public class ProductDAO {
  private static final String URL=System.getenv().getOrDefault("DB_URL","jdbc:mysql://localhost:3306/product_management?useSSL=false&serverTimezone=UTC");
  private static final String USER=System.getenv().getOrDefault("DB_USER","root");
  private static final String PASSWORD=System.getenv().getOrDefault("DB_PASSWORD","");
  private Connection connection()throws SQLException{return DriverManager.getConnection(URL,USER,PASSWORD);}
  public List<Product> findAll()throws SQLException{List<Product> result=new ArrayList<>();try(Connection c=connection();PreparedStatement p=c.prepareStatement("SELECT id,name,price,quantity FROM products ORDER BY id");ResultSet r=p.executeQuery()){while(r.next())result.add(map(r));}return result;}
  public Product findById(int id)throws SQLException{try(Connection c=connection();PreparedStatement p=c.prepareStatement("SELECT id,name,price,quantity FROM products WHERE id=?")){p.setInt(1,id);try(ResultSet r=p.executeQuery()){return r.next()?map(r):null;}}}
  public void save(Product x)throws SQLException{String sql=x.getId()==0?"INSERT INTO products(name,price,quantity) VALUES(?,?,?)":"UPDATE products SET name=?,price=?,quantity=? WHERE id=?";try(Connection c=connection();PreparedStatement p=c.prepareStatement(sql)){p.setString(1,x.getName());p.setDouble(2,x.getPrice());p.setInt(3,x.getQuantity());if(x.getId()!=0)p.setInt(4,x.getId());p.executeUpdate();}}
  public void delete(int id)throws SQLException{try(Connection c=connection();PreparedStatement p=c.prepareStatement("DELETE FROM products WHERE id=?")){p.setInt(1,id);p.executeUpdate();}}
  private Product map(ResultSet r)throws SQLException{return new Product(r.getInt("id"),r.getString("name"),r.getDouble("price"),r.getInt("quantity"));}
}
