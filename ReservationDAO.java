package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public String generateReservationNumber() {
        String sql = "SELECT reservation_number FROM reservations ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                String lastNumber = rs.getString("reservation_number");
                int num = Integer.parseInt(lastNumber.substring(1)) + 1;
                return String.format("R%05d", num);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "R00001";
    }

    public boolean createReservation(Reservation reservation) {
        String sql = "INSERT INTO reservations (reservation_number, guest_name, address, nic, contact_number, " +
                     "room_category, room_type, check_in, check_out, adults, children, rooms_count, total_amount) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reservation.getReservationNumber());
            stmt.setString(2, reservation.getGuestName());
            stmt.setString(3, reservation.getAddress());
            stmt.setString(4, reservation.getNic());
            stmt.setString(5, reservation.getContactNumber());
            stmt.setString(6, reservation.getRoomCategory());
            stmt.setString(7, reservation.getRoomType());
            stmt.setDate(8, reservation.getCheckIn());
            stmt.setDate(9, reservation.getCheckOut());
            stmt.setInt(10, reservation.getAdults());
            stmt.setInt(11, reservation.getChildren());
            stmt.setInt(12, reservation.getRoomsCount());
            stmt.setDouble(13, reservation.getTotalAmount());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                reservations.add(extractReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public Reservation getReservationByNumber(String reservationNumber) {
        String sql = "SELECT * FROM reservations WHERE reservation_number = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reservationNumber);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractReservation(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Reservation getReservationByNIC(String nic) {
        String sql = "SELECT * FROM reservations WHERE nic = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nic);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractReservation(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateReservation(Reservation reservation) {
        String sql = "UPDATE reservations SET guest_name=?, address=?, nic=?, contact_number=?, " +
                     "room_category=?, room_type=?, check_in=?, check_out=?, adults=?, children=?, " +
                     "rooms_count=?, total_amount=? WHERE reservation_number=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reservation.getGuestName());
            stmt.setString(2, reservation.getAddress());
            stmt.setString(3, reservation.getNic());
            stmt.setString(4, reservation.getContactNumber());
            stmt.setString(5, reservation.getRoomCategory());
            stmt.setString(6, reservation.getRoomType());
            stmt.setDate(7, reservation.getCheckIn());
            stmt.setDate(8, reservation.getCheckOut());
            stmt.setInt(9, reservation.getAdults());
            stmt.setInt(10, reservation.getChildren());
            stmt.setInt(11, reservation.getRoomsCount());
            stmt.setDouble(12, reservation.getTotalAmount());
            stmt.setString(13, reservation.getReservationNumber());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteReservation(String reservationNumber) {
        String sql = "DELETE FROM reservations WHERE reservation_number = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reservationNumber);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Reservation extractReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setId(rs.getInt("id"));
        reservation.setReservationNumber(rs.getString("reservation_number"));
        reservation.setGuestName(rs.getString("guest_name"));
        reservation.setAddress(rs.getString("address"));
        reservation.setNic(rs.getString("nic"));
        reservation.setContactNumber(rs.getString("contact_number"));
        reservation.setRoomCategory(rs.getString("room_category"));
        reservation.setRoomType(rs.getString("room_type"));
        reservation.setCheckIn(rs.getDate("check_in"));
        reservation.setCheckOut(rs.getDate("check_out"));
        reservation.setAdults(rs.getInt("adults"));
        reservation.setChildren(rs.getInt("children"));
        reservation.setRoomsCount(rs.getInt("rooms_count"));
        reservation.setTotalAmount(rs.getDouble("total_amount"));
        return reservation;
    }
}
