package com.oceanview.dao;

import com.oceanview.model.RoomRate;
import com.oceanview.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomRateDAO {

    public List<RoomRate> getAllRoomRates() {
        List<RoomRate> rates = new ArrayList<>();
        String sql = "SELECT * FROM room_rates ORDER BY category, type";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                RoomRate rate = new RoomRate();
                rate.setId(rs.getInt("id"));
                rate.setCategory(rs.getString("category"));
                rate.setType(rs.getString("type"));
                rate.setPrice(rs.getBigDecimal("price"));
                rates.add(rate);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rates;
    }

    public RoomRate getRoomRateById(int id) {
        RoomRate rate = null;
        String sql = "SELECT * FROM room_rates WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    rate = new RoomRate();
                    rate.setId(rs.getInt("id"));
                    rate.setCategory(rs.getString("category"));
                    rate.setType(rs.getString("type"));
                    rate.setPrice(rs.getBigDecimal("price"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rate;
    }

    public boolean updateRoomRate(int id, BigDecimal newPrice) {
        String sql = "UPDATE room_rates SET price = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, newPrice);
            stmt.setInt(2, id);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double getRate(String category, String type) {
        String sql = "SELECT price FROM room_rates WHERE category = ? AND type = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category);
            stmt.setString(2, type);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("price");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public boolean updateRoomRateByCategoryType(String category, String type, double price) {
        String sql = "UPDATE room_rates SET price = ? WHERE category = ? AND type = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, price);
            stmt.setString(2, category);
            stmt.setString(3, type);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
