<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Ocean View</h2>
            <nav>
                <ul>
                    <li><a href="dashboard.jsp">Dashboard</a></li>
                    <li><a href="add_reservation.jsp">Add Reservation</a></li>
                    <li><a href="view_reservations.jsp">View Reservations</a></li>
                    <li><a href="billing.jsp">Billing</a></li>
                    <li><a href="room_pricing.jsp">Room Pricing</a></li>
                    <li><a href="help.jsp">Help</a></li>
                </ul>
            </nav>
            <form action="logout" method="post">
                <button type="submit" class="logout-btn">Sign Out</button>
            </form>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="content-wrapper">
                <h1>Welcome to Ocean View Resort Management System</h1>
                <p style="color: #7f8c8d; margin-top: 10px;">Manage your reservations efficiently</p>
                
                <div class="dashboard-cards">
                    <div class="card" onclick="location.href='add_reservation.jsp'">
                        <h3>Add New Reservation</h3>
                        <p>Register new guests and create reservations</p>
                    </div>
                    
                    <div class="card" onclick="location.href='view_reservations.jsp'">
                        <h3>Reservation Details</h3>
                        <p>View, edit, and manage all reservations</p>
                    </div>
                    
                    <div class="card" onclick="location.href='billing.jsp'">
                        <h3>Calculate Bill</h3>
                        <p>Generate and print guest bills</p>
                    </div>
                    
                    <div class="card" onclick="location.href='room_pricing.jsp'">
                        <h3>Room Pricing</h3>
                        <p>Manage room rates and pricing</p>
                    </div>
                    
                    <div class="card" onclick="location.href='help.jsp'">
                        <h3>Help Section</h3>
                        <p>Learn how to use the system</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
