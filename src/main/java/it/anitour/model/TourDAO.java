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
                tour.setSlug(rs.getString("slug"));
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
        // Genera automaticamente lo slug dal nome del tour
        String slug = generateSlug(tour.getName());
        
        // Possono esistere più tour con lo stesso nome, quindi per rendere lo slug unico, ci aggiungo un numero alla fine
        int counter = 1;
        String baseSlug = slug;
        while (slugExists(slug)) {
            slug = baseSlug + "-" + counter++;
        }
        
        tour.setSlug(slug);
        
        String sql = "INSERT INTO tours (name, description, price, start_date, end_date, image_path, slug) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, tour.getName());
            ps.setString(2, tour.getDescription());
            ps.setDouble(3, tour.getPrice());
            ps.setDate(4, tour.getStartDate());
            ps.setDate(5, tour.getEndDate());
            ps.setString(6, tour.getImagePath());
            ps.setString(7, tour.getSlug());
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

    public Tour findBySlug(String slug) throws SQLException {
        String sql = "SELECT * FROM tours WHERE slug = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slug);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Tour tour = new Tour();
                tour.setId(rs.getInt("id"));
                tour.setName(rs.getString("name"));
                tour.setDescription(rs.getString("description"));
                tour.setPrice(rs.getDouble("price"));
                tour.setStartDate(rs.getDate("start_date"));
                tour.setEndDate(rs.getDate("end_date"));
                tour.setImagePath(rs.getString("image_path"));
                tour.setSlug(rs.getString("slug"));

                // Carica anche le tappe del tour
                loadStopsForTour(tour);

                return tour;
            }
        }
        return null;
    }

    private void loadStopsForTour(Tour tour) throws SQLException {
        String sql = "SELECT * FROM stops WHERE tour_id = ? ORDER BY stop_order";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tour.getId());
            ResultSet rs = stmt.executeQuery();
            List<Stop> stops = new ArrayList<>();

            while (rs.next()) {
                Stop stop = new Stop();
                stop.setId(rs.getInt("id"));
                stop.setTourId(rs.getInt("tour_id"));
                stop.setName(rs.getString("name"));
                stop.setDescription(rs.getString("description"));
                stop.setStopOrder(rs.getInt("stop_order"));
                stops.add(stop);
            }

            tour.setStops(stops);
        }
    }

    private String generateSlug(String name) {
        return name.toLowerCase()
            .replaceAll("[^\\w\\s-]", "") // Rimuovi caratteri speciali
            .replaceAll("[\\s_-]+", "-")  // Sostituisci spazi e underscore con trattini
            .replaceAll("^-+|-+$", "");   // Rimuovi trattini iniziali e finali
    }

    private boolean slugExists(String slug) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tours WHERE slug = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slug);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public void insertStop(Stop stop) throws SQLException {
        String sql = "INSERT INTO stops (tour_id, name, description, stop_order) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, stop.getTourId());
            ps.setString(2, stop.getName());
            ps.setString(3, stop.getDescription());
            ps.setInt(4, stop.getStopOrder());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    stop.setId(rs.getInt(1));
                }
            }
        }
    }

    public List<Tour> searchByTheme(String theme) throws SQLException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT * FROM tours WHERE name LIKE ? OR description LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + theme + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = new Tour();
                    tour.setId(rs.getInt("id"));
                    tour.setName(rs.getString("name"));
                    tour.setDescription(rs.getString("description"));
                    tour.setPrice(rs.getDouble("price"));
                    tour.setStartDate(rs.getDate("start_date"));
                    tour.setEndDate(rs.getDate("end_date"));
                    tour.setImagePath(rs.getString("image_path"));
                    tour.setSlug(rs.getString("slug"));
                    tours.add(tour);
                }
            }
        }
        return tours;
    }

    public List<Tour> searchByDate(Date startDate, Date endDate) throws SQLException {
        List<Tour> tours = new ArrayList<>();
        String sql;
        
        if (startDate != null && endDate != null) {
            // Cerca tour che iniziano tra startDate e endDate
            sql = "SELECT * FROM tours WHERE start_date >= ? AND start_date <= ?";
        } else if (startDate != null) {
            // Cerca tour che iniziano dopo startDate
            sql = "SELECT * FROM tours WHERE start_date >= ?";
        } else if (endDate != null) {
            // Cerca tour che iniziano prima di endDate
            sql = "SELECT * FROM tours WHERE start_date <= ?";
        } else {
            // Nessuna data specificata, ritorna tutti i tour
            return findAll();
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            if (startDate != null && endDate != null) {
                ps.setDate(1, startDate);
                ps.setDate(2, endDate);
            } else if (startDate != null) {
                ps.setDate(1, startDate);
            } else if (endDate != null) {
                ps.setDate(1, endDate);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = new Tour();
                    tour.setId(rs.getInt("id"));
                    tour.setName(rs.getString("name"));
                    tour.setDescription(rs.getString("description"));
                    tour.setPrice(rs.getDouble("price"));
                    tour.setStartDate(rs.getDate("start_date"));
                    tour.setEndDate(rs.getDate("end_date"));
                    tour.setImagePath(rs.getString("image_path"));
                    tour.setSlug(rs.getString("slug"));
                    tours.add(tour);
                }
            }
        }
        return tours;
    }

    public List<Tour> searchByPrice(double minPrice, double maxPrice) throws SQLException {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT * FROM tours WHERE price >= ? AND price <= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, minPrice);
            ps.setDouble(2, maxPrice);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = new Tour();
                    tour.setId(rs.getInt("id"));
                    tour.setName(rs.getString("name"));
                    tour.setDescription(rs.getString("description"));
                    tour.setPrice(rs.getDouble("price"));
                    tour.setStartDate(rs.getDate("start_date"));
                    tour.setEndDate(rs.getDate("end_date"));
                    tour.setImagePath(rs.getString("image_path"));
                    tour.setSlug(rs.getString("slug"));
                    tours.add(tour);
                }
            }
        }
        return tours;
    }
}
