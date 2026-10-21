package com.codegym.dao;
import com.codegym.model.User;import java.sql.SQLException;import java.util.List;
public interface IUserDAO {void insertUser(User user)throws SQLException;User selectUser(int id);List<User> selectAllUsers();List<User> searchByCountry(String country);List<User> sortByName();boolean deleteUser(int id)throws SQLException;boolean updateUser(User user)throws SQLException;void insertUpdateWithoutTransaction()throws SQLException;}
