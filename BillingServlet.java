package com.oceanview.servlet;

import com.google.gson.Gson;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomRateDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    private RoomRateDAO roomRateDAO;
    private Gson gson;

    @Override
    public void init() {
        reservationDAO = new ReservationDAO();
        roomRateDAO = new RoomRateDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("calculate".equals(action)) {
            String reservationNumber = request.getParameter("reservationNumber");
            Reservation reservation = reservationDAO.getReservationByNumber(reservationNumber);
            
            if (reservation != null) {
                long nights = calculateNights(reservation.getCheckIn().getTime(), 
                                             reservation.getCheckOut().getTime());
                double ratePerNight = roomRateDAO.getRate(reservation.getRoomCategory(), 
                                                          reservation.getRoomType());
                double totalAmount = nights * ratePerNight * reservation.getRoomsCount();
                
                Map<String, Object> billData = new HashMap<>();
                billData.put("reservation", reservation);
                billData.put("nights", nights);
                billData.put("ratePerNight", ratePerNight);
                billData.put("totalAmount", totalAmount);
                
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(billData));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    private long calculateNights(long checkInTime, long checkOutTime) {
        long diff = checkOutTime - checkInTime;
        return TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
    }
}
