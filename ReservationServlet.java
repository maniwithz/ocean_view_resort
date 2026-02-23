package com.oceanview.servlet;

import com.google.gson.Gson;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    private Gson gson;

    @Override
    public void init() {
        reservationDAO = new ReservationDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("getAll".equals(action)) {
            List<Reservation> reservations = reservationDAO.getAllReservations();
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(reservations));
        } else if ("getByNumber".equals(action)) {
            String reservationNumber = request.getParameter("reservationNumber");
            Reservation reservation = reservationDAO.getReservationByNumber(reservationNumber);
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(reservation));
        } else if ("getByNIC".equals(action)) {
            String nic = request.getParameter("nic");
            Reservation reservation = reservationDAO.getReservationByNIC(nic);
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(reservation));
        } else if ("generateNumber".equals(action)) {
            String number = reservationDAO.generateReservationNumber();
            response.setContentType("text/plain");
            response.getWriter().write(number);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            Reservation reservation = new Reservation();
            reservation.setReservationNumber(reservationDAO.generateReservationNumber());
            reservation.setGuestName(request.getParameter("guestName"));
            reservation.setAddress(request.getParameter("address"));
            reservation.setNic(request.getParameter("nic"));
            reservation.setContactNumber(request.getParameter("contactNumber"));
            reservation.setRoomCategory(request.getParameter("roomCategory"));
            reservation.setRoomType(request.getParameter("roomType"));
            reservation.setCheckIn(Date.valueOf(request.getParameter("checkIn")));
            reservation.setCheckOut(Date.valueOf(request.getParameter("checkOut")));
            reservation.setAdults(Integer.parseInt(request.getParameter("adults")));
            reservation.setChildren(Integer.parseInt(request.getParameter("children")));
            reservation.setRoomsCount(Integer.parseInt(request.getParameter("roomsCount")));
            reservation.setTotalAmount(Double.parseDouble(request.getParameter("totalAmount")));
            
            boolean success = reservationDAO.createReservation(reservation);
            if (success) {
                response.sendRedirect("view_reservations.jsp?success=true&reservationNumber=" + reservation.getReservationNumber());
            } else {
                response.sendRedirect("add_reservation.jsp?error=true");
            }
        } else if ("update".equals(action)) {
            Reservation reservation = new Reservation();
            reservation.setReservationNumber(request.getParameter("reservationNumber"));
            reservation.setGuestName(request.getParameter("guestName"));
            reservation.setAddress(request.getParameter("address"));
            reservation.setNic(request.getParameter("nic"));
            reservation.setContactNumber(request.getParameter("contactNumber"));
            reservation.setRoomCategory(request.getParameter("roomCategory"));
            reservation.setRoomType(request.getParameter("roomType"));
            reservation.setCheckIn(Date.valueOf(request.getParameter("checkIn")));
            reservation.setCheckOut(Date.valueOf(request.getParameter("checkOut")));
            reservation.setAdults(Integer.parseInt(request.getParameter("adults")));
            reservation.setChildren(Integer.parseInt(request.getParameter("children")));
            reservation.setRoomsCount(Integer.parseInt(request.getParameter("roomsCount")));
            reservation.setTotalAmount(Double.parseDouble(request.getParameter("totalAmount")));
            
            boolean success = reservationDAO.updateReservation(reservation);
            response.sendRedirect("view_reservations.jsp?updated=" + success);
        } else if ("delete".equals(action)) {
            String reservationNumber = request.getParameter("reservationNumber");
            boolean success = reservationDAO.deleteReservation(reservationNumber);
            response.sendRedirect("view_reservations.jsp?deleted=" + success);
        }
    }
}
