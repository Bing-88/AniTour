package it.anitour.model;

import it.anitour.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TourDAO {

    public TourDAO() {}

    public List<Tour> findAll() throws SQLException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT * FROM tours";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setDescription(rs.getString("description"));
                tour.setPrice(rs.getDouble("price"));
                tour.setStartDate(rs.getDate("start_date"));
                tour.setEndDate(rs.getDate("end_date"));
                tour.setImagePath(rs.getString("image_path"));
                tours.add(tour);
            }
        }
        return tours;
    }

    public Tour findById(int id) throws SQLException {
        String sql = "SELECT * FROM tours WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Tour tour = new Tour();
                    tour.setId(rs.getInt("id"));
                    tour.setName(rs.getString("name"));
                    tour.setDescription(rs.getString("description"));
                    tour.setPrice(rs.getDouble("price"));
                    tour.setStartDate(rs.getDate("start_date"));
                    tour.setEndDate(rs.getDate("end_date"));
                    tour.setImagePath(rs.getString("image_path"));
                    return tour;
                }
            }
        }
        return null;
    }

    public void insert(Tour tour) throws SQLException {
        String sql = "INSERT INTO tours (name, description, price, start_date, end_date, image_path) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, tour.getName());
            ps.setString(2, tour.getDescription());
            ps.setDouble(3, tour.getPrice());
            ps.setDate(4, tour.getStartDate());
            ps.setDate(5, tour.getEndDate());
            ps.setString(6, tour.getImagePath());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    tour.setId(rs.getInt(1));
                }
            }
        }
    }

    public void update(Tour tour) throws SQLException {
        String sql = "UPDATE tours SET name=?, description=?, price=?, start_date=?, end_date=?, image_path=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tour.getName());
            ps.setString(2, tour.getDescription());
            ps.setDouble(3, tour.getPrice());
            ps.setDate(4, tour.getStartDate());
            ps.setDate(5, tour.getEndDate());
            ps.setString(6, tour.getImagePath());
            ps.setInt(7, tour.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM tours WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public List<Stop> findStopsByTourId(int tourId) throws SQLException {
        List<Stop> stops = new ArrayList<>();
        String sql = "SELECT * FROM stops WHERE tour_id = ? ORDER BY stop_order";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Stop stop = new Stop();
                    stop.setId(rs.getInt("id"));
                    stop.setTourId(rs.getInt("tour_id"));
                    stop.setName(rs.getString("name"));
                    stop.setDescription(rs.getString("description"));
                    stop.setStopOrder(rs.getInt("stop_order"));
                    stops.add(stop);
                }
            }
        }
        return stops;
    }
}
