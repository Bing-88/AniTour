package it.anitour.model;

import it.anitour.utils.DBConnection;
import java.sql.*;

public class UserDAO {

	public UserDAO() {
	}

	// Metodo per verificare se l'utente esiste nel database (utile per il login)
	public User findByUsername(String username) throws SQLException {
		String sql = "SELECT * FROM users WHERE username = ?";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, username);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				User user = new User();
				user.setId(rs.getInt("id"));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setEmail(rs.getString("email"));
				user.setType(rs.getString("type"));
				return user;
			}
		}
		return null;
	}

	// Uso GeneratedKeys per ottenere l'id che viene generato automaticamente dal db (AUTO_INCREMENT)
	public void insertUser(User user) throws SQLException {
		String sql = "INSERT INTO users (username, password, email, type) VALUES (?, ?, ?, ?)";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			stmt.setString(1, user.getUsername());
			stmt.setString(2, user.getPassword());
			stmt.setString(3, user.getEmail());
			stmt.setString(4, user.getType());
			stmt.executeUpdate();
			ResultSet rs = stmt.getGeneratedKeys();
			if (rs.next()) {
				user.setId(rs.getInt(1));
			}
		}
	}
}