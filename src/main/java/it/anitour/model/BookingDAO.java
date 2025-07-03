package it.anitour.model;

import it.anitour.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class BookingDAO {
    
    // Metodo per salvare un booking dal carrello
    public void saveBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO bookings (user_id, session_id, tour_id, quantity, price, tour_name, tour_image_path, status, order_identifier) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setObject(1, booking.getUserId());
            ps.setString(2, booking.getSessionId());
            ps.setInt(3, booking.getTourId());
            ps.setInt(4, booking.getQuantity());
            ps.setDouble(5, booking.getPrice());
            ps.setString(6, booking.getTourName());
            ps.setString(7, booking.getTourImagePath());
            ps.setString(8, booking.getStatus());
            ps.setString(9, booking.getOrderIdentifier()); 
            
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    booking.setId(rs.getInt(1));
                }
            }
        }
    }
    
    // Metodo per aggiornare un booking esistente
    public void updateBooking(Booking booking) throws SQLException {
        String sql = "UPDATE bookings SET quantity = ?, status = ?, " +
                    "shipping_name = ?, shipping_address = ?, shipping_city = ?, " +
                    "shipping_country = ?, shipping_postal_code = ?, shipping_email = ?, " +
                    "shipping_phone = ?, payment_method = ?, payment_status = ? " +
                    "WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, booking.getQuantity());
            ps.setString(2, booking.getStatus());
            ps.setString(3, booking.getShippingName());
            ps.setString(4, booking.getShippingAddress());
            ps.setString(5, booking.getShippingCity());
            ps.setString(6, booking.getShippingCountry());
            ps.setString(7, booking.getShippingPostalCode());
            ps.setString(8, booking.getShippingEmail());
            ps.setString(9, booking.getShippingPhone());
            ps.setString(10, booking.getPaymentMethod());
            ps.setString(11, booking.getPaymentStatus());
            ps.setInt(12, booking.getId());
            
            ps.executeUpdate();
        }
    }
    
    // Crea un ordine dal carrello assegnando un unico ID d'ordine a tutti gli articoli
    public void createOrderFromCart(Integer userId, String sessionId, 
                          String shippingName, String shippingAddress, 
                          String shippingCity, String shippingCountry, 
                          String shippingPostalCode, String shippingEmail, 
                          String shippingPhone, String cardHolder) throws SQLException {

        // Verifica che ci sia almeno un identificatore
        if (userId == null && (sessionId == null || sessionId.isEmpty())) {
            throw new SQLException("È necessario specificare userId o sessionId");
        }
        
        Connection conn = null;
        PreparedStatement psSelect = null;
        PreparedStatement psUpdate = null;
        ResultSet rs = null;
        List<Integer> bookingIds = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Inizia una transazione
            
            // 1. Ottieni tutti gli articoli nel carrello
            String selectSql = "SELECT * FROM bookings WHERE ";
            if (userId != null) {
                selectSql += "user_id = ? ";
            } else {
                selectSql += "session_id = ? ";
            }
            selectSql += "AND status = 'cart'";
            
            // Specifichiamo che il ResultSet deve essere scrollabile
            psSelect = conn.prepareStatement(selectSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (userId != null) {
                psSelect.setInt(1, userId);
            } else {
                psSelect.setString(1, sessionId);
            }
            
            // Esegui la query per ottenere gli articoli nel carrello
            rs = psSelect.executeQuery();
            
            // Verifica se ci sono articoli nel carrello
            boolean hasItems = false;
            while (rs.next()) {
                hasItems = true;
                bookingIds.add(rs.getInt("id"));
            }
            
            if (!hasItems) {
                conn.rollback();
                return; // Nessun articolo nel carrello
            }
            
            // 2. Genera un ID ordine comune (timestamp + hash casuale)
            String orderIdentifier = "ORD-" + System.currentTimeMillis() + "-" + (userId != null ? userId : sessionId);
            
            // 3. Aggiorna tutti gli articoli con le informazioni di spedizione e il nuovo status
            String updateSql = "UPDATE bookings SET status = 'completed', " +
                              "shipping_name = ?, shipping_address = ?, shipping_city = ?, " +
                              "shipping_country = ?, shipping_postal_code = ?, shipping_email = ?, " +
                              "shipping_phone = ?, payment_method = 'credit_card', " +
                              "payment_status = 'completed', order_identifier = ? " +
                              "WHERE id = ?";
                              
            psUpdate = conn.prepareStatement(updateSql);
            
            // Utilizziamo la lista di ID invece di rs.beforeFirst()
            for (Integer bookingId : bookingIds) {
                psUpdate.setString(1, shippingName);
                psUpdate.setString(2, shippingAddress);
                psUpdate.setString(3, shippingCity);
                psUpdate.setString(4, shippingCountry);
                psUpdate.setString(5, shippingPostalCode);
                psUpdate.setString(6, shippingEmail);
                psUpdate.setString(7, shippingPhone);
                psUpdate.setString(8, orderIdentifier);
                psUpdate.setInt(9, bookingId);
                
                psUpdate.executeUpdate();
            }
            
            // Conferma la transazione
            conn.commit();
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Annulla la transazione in caso di errore
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (psSelect != null) psSelect.close();
                if (psUpdate != null) psUpdate.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Metodo per ottenere tutti gli ordini di un utente
    public List<Booking> getUserOrders(int userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE user_id = ? AND status != 'cart' ORDER BY booking_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        }
        
        return bookings;
    }
    
    // Ottiene tutti gli ordini dell'utente raggruppati per order_identifier
    public List<Map<String, Object>> getUserOrdersGrouped(int userId) throws SQLException {
        List<Map<String, Object>> orderGroups = new ArrayList<>();
        
        // Prima otteniamo gli identificatori unici degli ordini dell'utente
        String sqlIdentifiers = "SELECT DISTINCT order_identifier FROM bookings WHERE user_id = ? AND status != 'cart' AND order_identifier IS NOT NULL ORDER BY booking_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlIdentifiers)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                String orderIdentifier = rs.getString("order_identifier");
                
                // Per ogni identificatore, otteniamo tutti gli elementi dell'ordine
                List<Booking> orderItems = getOrderItemsByIdentifier(userId, orderIdentifier);
                
                // Crea una mappa con le informazioni dell'ordine
                Map<String, Object> orderGroup = new HashMap<>();
                orderGroup.put("identifier", orderIdentifier);
                orderGroup.put("items", orderItems);
                
                // Utilizza il primo elemento per ottenere informazioni generali dell'ordine
                if (!orderItems.isEmpty()) {
                    Booking firstItem = orderItems.get(0);
                    orderGroup.put("date", firstItem.getBookingDate());
                    orderGroup.put("status", firstItem.getStatus());
                    orderGroup.put("shippingInfo", Map.of(
                        "name", firstItem.getShippingName(),
                        "address", firstItem.getShippingAddress(),
                        "city", firstItem.getShippingCity(),
                        "country", firstItem.getShippingCountry(),
                        "postalCode", firstItem.getShippingPostalCode(),
                        "email", firstItem.getShippingEmail(),
                        "phone", firstItem.getShippingPhone()
                    ));
                    
                    // Calcola il totale complessivo dell'ordine
                    double totalAmount = orderItems.stream()
                        .mapToDouble(item -> item.getPrice() * item.getQuantity())
                        .sum();
                    orderGroup.put("totalAmount", totalAmount);
                }
                
                orderGroups.add(orderGroup);
            }
        }
        
        return orderGroups;
    }

    // Ottiene tutti gli elementi di un ordine specifico
    private List<Booking> getOrderItemsByIdentifier(int userId, String orderIdentifier) throws SQLException {
        List<Booking> items = new ArrayList<>();
        
        String sql = "SELECT * FROM bookings WHERE user_id = ? AND order_identifier = ? ORDER BY id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, orderIdentifier);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToBooking(rs));
                }
            }
        }
        
        return items;
    }
    
    // Ottiene tutti gli elementi di un ordine specifico tramite orderIdentifier o ID
    public List<Booking> getOrderItemsByIdentifier(String orderIdentifier) throws SQLException {
        List<Booking> items = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE order_identifier = ? ORDER BY id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setString(1, orderIdentifier);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToBooking(rs));
                }
            }
        }
        
        return items;
    }
    
    // Metodo per ottenere un carrello per utente o sessione
    public List<Booking> getCart(Integer userId, String sessionId) throws SQLException {
        List<Booking> cart = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE ";
        
        if (userId != null) {
            sql += "user_id = ? AND status = 'cart'";
        } else {
            sql += "session_id = ? AND status = 'cart'";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, sessionId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cart.add(mapResultSetToBooking(rs));
                }
            }
        }
        
        return cart;
    }
    
    // Metodo per ottenere gli ordini raggruppati per data (per visualizzazione)
    public Map<Timestamp, List<Booking>> getOrdersByDate(int userId) throws SQLException {
        Map<Timestamp, List<Booking>> ordersByDate = new HashMap<>();
        
        String sql = "SELECT * FROM bookings WHERE user_id = ? AND status = 'completed' ORDER BY booking_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    Timestamp orderDate = booking.getBookingDate();
                    
                    if (!ordersByDate.containsKey(orderDate)) {
                        ordersByDate.put(orderDate, new ArrayList<>());
                    }
                    
                    ordersByDate.get(orderDate).add(booking);
                }
            }
        }
        
        return ordersByDate;
    }
    
    // Metodo per eliminare una prenotazione dal carrello
    public void removeFromCart(Integer userId, String sessionId, int tourId) throws SQLException {
        String sql = "DELETE FROM bookings WHERE ";
        
        if (userId != null) {
            sql += "user_id = ? AND tour_id = ? AND status = 'cart'";
        } else {
            sql += "session_id = ? AND tour_id = ? AND status = 'cart'";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, sessionId);
            }
            ps.setInt(2, tourId);
            
            ps.executeUpdate();
        }
    }
    
    // Metodo per svuotare il carrello
    public void clearCart(Integer userId, String sessionId) throws SQLException {
        String sql = "DELETE FROM bookings WHERE ";
        
        if (userId != null) {
            sql += "user_id = ? AND status = 'cart'";
        } else {
            sql += "session_id = ? AND status = 'cart'";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, sessionId);
            }
            
            ps.executeUpdate();
        }
    }
    
    // Metodo per trasferire il carrello da sessione a utente dopo login
    public void transferCart(String sessionId, int userId) throws SQLException {
        String sql = "UPDATE bookings SET user_id = ?, session_id = NULL WHERE session_id = ? AND status = 'cart'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, sessionId);
            
            ps.executeUpdate();
        }
    }
    
    // Metodo per ottenere il conteggio degli articoli nel carrello
    public int getCartItemsCount(Integer userId, String sessionId) throws SQLException {
        String sql = "SELECT SUM(quantity) as total FROM bookings WHERE ";
        
        if (userId != null) {
            sql += "user_id = ? AND status = 'cart'";
        } else {
            sql += "session_id = ? AND status = 'cart'";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, sessionId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Integer total = rs.getObject("total", Integer.class);
                    return total != null ? total : 0;
                }
            }
        }
        
        return 0;
    }
    
    // Verifica se un tour è già presente nel carrello dell'utente
    public Booking getCartItemByTourId(Integer userId, String sessionId, int tourId) throws SQLException {
        String sql = "SELECT * FROM bookings WHERE ";
        
        if (userId != null) {
            sql += "user_id = ? AND tour_id = ? AND status = 'cart'";
        } else {
            sql += "session_id = ? AND tour_id = ? AND status = 'cart'";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, sessionId);
            }
            ps.setInt(2, tourId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        }
        
        return null;
    }
    
    // Aggiorna la quantità di un elemento nel carrello
    public void updateBookingQuantity(int bookingId, int newQuantity) throws SQLException {
        String sql = "UPDATE bookings SET quantity = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, newQuantity);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        }
    }
    
    // Metodo per mappare un ResultSet a un oggetto Booking
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
        booking.setSessionId(rs.getString("session_id"));
        booking.setTourId(rs.getInt("tour_id"));
        booking.setQuantity(rs.getInt("quantity"));
        booking.setPrice(rs.getDouble("price"));
        booking.setTourName(rs.getString("tour_name"));
        booking.setTourImagePath(rs.getString("tour_image_path"));
        booking.setBookingDate(rs.getTimestamp("booking_date"));
        booking.setStatus(rs.getString("status"));
        booking.setShippingName(rs.getString("shipping_name"));
        booking.setShippingAddress(rs.getString("shipping_address"));
        booking.setShippingCity(rs.getString("shipping_city"));
        booking.setShippingCountry(rs.getString("shipping_country"));
        booking.setShippingPostalCode(rs.getString("shipping_postal_code"));
        booking.setShippingEmail(rs.getString("shipping_email"));
        booking.setShippingPhone(rs.getString("shipping_phone"));
        booking.setPaymentMethod(rs.getString("payment_method"));
        booking.setPaymentStatus(rs.getString("payment_status"));
        booking.setOrderIdentifier(rs.getString("order_identifier"));
        return booking;
    }
    
    // Ottiene tutti gli ordini (esclusi i carrelli) filtrati per data e/o cliente
    public List<Booking> getFilteredOrders(Date startDate, Date endDate, Integer clientId) throws SQLException {
        List<Booking> filteredOrders = new ArrayList<>();
        
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT * FROM bookings WHERE status != 'cart' ");
        
        if (startDate != null) {
            sqlBuilder.append("AND booking_date >= ? ");
        }
        
        if (endDate != null) {
            sqlBuilder.append("AND booking_date <= ? ");
        }
        
        if (clientId != null) {
            sqlBuilder.append("AND user_id = ? ");
        }
        
        sqlBuilder.append("ORDER BY booking_date DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {
            
            int paramIndex = 1;
            
            if (startDate != null) {
                ps.setTimestamp(paramIndex++, new Timestamp(startDate.getTime()));
            }
            
            if (endDate != null) {
                // Imposta la data di fine alla fine della giornata
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(endDate);
                calendar.set(Calendar.HOUR_OF_DAY, 23);
                calendar.set(Calendar.MINUTE, 59);
                calendar.set(Calendar.SECOND, 59);
                calendar.set(Calendar.MILLISECOND, 999);
                
                ps.setTimestamp(paramIndex++, new Timestamp(calendar.getTimeInMillis()));
            }
            
            if (clientId != null) {
                ps.setInt(paramIndex, clientId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    filteredOrders.add(mapResultSetToBooking(rs));
                }
            }
        }
        
        return filteredOrders;
    }
    
    // Ottiene gli ordini filtrati raggruppati per order_identifier
    public Map<String, List<Booking>> getFilteredOrdersGrouped(Date startDate, Date endDate, Integer clientId) throws SQLException {
        Map<String, List<Booking>> result = new LinkedHashMap<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM bookings WHERE status != 'cart' AND order_identifier IS NOT NULL");
        List<Object> params = new ArrayList<>();
        
        if (startDate != null) {
            sql.append(" AND DATE(booking_date) >= ?");
            params.add(startDate);
        }
        
        if (endDate != null) {
            sql.append(" AND DATE(booking_date) <= ?");
            params.add(endDate);
        }
        
        if (clientId != null) {
            sql.append(" AND user_id = ?");
            params.add(clientId);
        }
        
        sql.append(" ORDER BY booking_date DESC, order_identifier");
        
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Date) {
                    ps.setDate(i+1, (Date)param);
                } else if (param instanceof Integer) {
                    ps.setInt(i+1, (Integer)param);
                } else {
                    ps.setString(i+1, param.toString());
                }
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    String orderKey = booking.getOrderIdentifier();
                    
                    // Filtra valori null o vuoti per evitare problemi
                    if (orderKey != null && !orderKey.trim().isEmpty()) {
                        result.computeIfAbsent(orderKey, k -> new ArrayList<>()).add(booking);
                    }
                }
            }
        }
        
        return result;
    }
    
    // Ottiene la lista di tutti gli utenti con ordini
    public List<User> getUsersWithOrders() throws SQLException {
        List<User> usersWithOrders = new ArrayList<>();
        String sql = "SELECT DISTINCT u.* FROM users u " +
                     "JOIN bookings b ON u.id = b.user_id " +
                     "WHERE b.status != 'cart' " +
                     "ORDER BY u.username";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            UserDAO userDAO = new UserDAO();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setType(rs.getString("type"));
                usersWithOrders.add(user);
            }
        }
        
        return usersWithOrders;
    }
    
    // Ottiene le statistiche degli ordini per dashboard admin
    public Map<String, Object> getOrdersStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sqlTotalOrders = "SELECT COUNT(*) as total FROM bookings WHERE status != 'cart'";
        String sqlTotalRevenue = "SELECT SUM(price * quantity) as revenue FROM bookings WHERE status != 'cart'";
        String sqlRecentOrders = "SELECT COUNT(*) as recent FROM bookings WHERE status != 'cart' AND booking_date >= ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Ordini totali
            try (PreparedStatement ps = conn.prepareStatement(sqlTotalOrders);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalOrders", rs.getInt("total"));
                }
            }
            
            // Ricavo totale
            try (PreparedStatement ps = conn.prepareStatement(sqlTotalRevenue);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalRevenue", rs.getDouble("revenue"));
                }
            }
            
            // Recent orders (last 30 days)
            try (PreparedStatement ps = conn.prepareStatement(sqlRecentOrders)) {
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DAY_OF_MONTH, -30);
                ps.setTimestamp(1, new Timestamp(cal.getTimeInMillis()));
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("recentOrders", rs.getInt("recent"));
                    }
                }
            }
        }
        
        return stats;
    }

    // Ottiene un ordine specifico tramite ID
    public Booking getOrderById(int id) throws SQLException {
        String sql = "SELECT * FROM bookings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        }
        return null;
    }
    
    // Completa tutti gli elementi di un ordine
    public void completeOrderByIdentifier(String orderIdentifier) throws SQLException {
        String sql = "UPDATE bookings SET status = 'completed' WHERE order_identifier = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setString(1, orderIdentifier);
            ps.executeUpdate();
        }
    }

    // Annulla tutti gli elementi di un ordine
    public void cancelOrderByIdentifier(String orderIdentifier) throws SQLException {
        String sql = "UPDATE bookings SET status = 'cancelled' WHERE order_identifier = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            ps.setString(1, orderIdentifier);
            ps.executeUpdate();
        }
    }
    
    // Metodo di utilità per riparare order_identifier mancanti
    public void repairMissingOrderIdentifiers() throws SQLException {
        String sql = "UPDATE bookings SET order_identifier = CONCAT('ORDER-', id, '-', UNIX_TIMESTAMP()) " +
                    "WHERE (order_identifier IS NULL OR order_identifier = '') AND status != 'cart'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
        
            int updatedRows = ps.executeUpdate();
            System.out.println("Riparati " + updatedRows + " ordini con order_identifier mancante");
        }
    }
}