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
    <title>Add Reservation - Ocean View Resort</title>
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
                <a href="dashboard.jsp" class="back-btn">← Back</a>
                <h1>Add New Reservation</h1>
                
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-error">Failed to create reservation. Please try again.</div>
                <% } %>
                
                <form action="reservation?action=create" method="post" onsubmit="return validateReservation()">
                    <h3>Guest Information</h3>
                    <div class="form-group">
                        <label for="reservationNumber">Reservation Number</label>
                        <input type="text" id="reservationNumber" name="reservationNumber" readonly 
                               style="background: #f5f5f5;">
                    </div>
                    
                    <div class="form-group">
                        <label for="guestName">Guest Name *</label>
                        <input type="text" id="guestName" name="guestName" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea id="address" name="address" rows="3"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="nic">NIC Number *</label>
                        <input type="text" id="nic" name="nic" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="contactNumber">Contact Number *</label>
                        <input type="text" id="contactNumber" name="contactNumber" required>
                    </div>
                    
                    <h3 style="margin-top: 30px;">Room Details</h3>
                    <div class="form-group">
                        <label for="roomCategory">Room Category *</label>
                        <select id="roomCategory" name="roomCategory" required onchange="updateRate()">
                            <option value="">Select Category</option>
                            <option value="Standard">Standard</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Elite">Elite</option>
                            <option value="Suites">Suites</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="roomType">Room Type *</label>
                        <select id="roomType" name="roomType" required onchange="updateRate()">
                            <option value="">Select Type</option>
                            <option value="SGL">Single (SGL)</option>
                            <option value="DBL">Double (DBL)</option>
                            <option value="TPL">Triple (TPL)</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="checkIn">Check-in Date *</label>
                        <input type="date" id="checkIn" name="checkIn" required onchange="calculateTotal()">
                    </div>
                    
                    <div class="form-group">
                        <label for="checkOut">Check-out Date *</label>
                        <input type="date" id="checkOut" name="checkOut" required onchange="calculateTotal()">
                    </div>
                    
                    <div class="form-group">
                        <label for="adults">Number of Adults *</label>
                        <input type="number" id="adults" name="adults" value="1" min="1" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="children">Number of Children</label>
                        <input type="number" id="children" name="children" value="0" min="0">
                    </div>
                    
                    <div class="form-group">
                        <label for="roomsCount">Number of Rooms *</label>
                        <input type="number" id="roomsCount" name="roomsCount" value="1" min="1" required onchange="calculateTotal()">
                    </div>
                    
                    <div class="form-group">
                        <label for="totalAmount">Total Amount (Rs.)</label>
                        <input type="number" id="totalAmount" name="totalAmount" step="0.01" readonly 
                               style="background: #f5f5f5; font-weight: bold; font-size: 18px;">
                    </div>
                    
                    <div style="margin-top: 20px;">
                        <button type="submit" class="btn btn-success">Save Reservation</button>
                        <button type="reset" class="btn btn-warning" style="margin-left: 10px;">Reset</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        const roomRates = {
            'Standard': {'SGL': 15000, 'DBL': 20000, 'TPL': 25000},
            'Deluxe': {'SGL': 25000, 'DBL': 35000, 'TPL': 45000},
            'Elite': {'SGL': 40000, 'DBL': 50000, 'TPL': 60000},
            'Suites': {'SGL': 75000, 'DBL': 90000, 'TPL': 100000}
        };
        
        window.onload = function() {
            fetch('reservation?action=generateNumber')
                .then(response => response.text())
                .then(data => {
                    document.getElementById('reservationNumber').value = data;
                });
            
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('checkIn').min = today;
            document.getElementById('checkOut').min = today;
        };
        
        function updateRate() {
            calculateTotal();
        }
        
        function calculateTotal() {
            const category = document.getElementById('roomCategory').value;
            const type = document.getElementById('roomType').value;
            const checkIn = new Date(document.getElementById('checkIn').value);
            const checkOut = new Date(document.getElementById('checkOut').value);
            const roomsCount = parseInt(document.getElementById('roomsCount').value) || 1;
            
            if (category && type && checkIn && checkOut && checkOut > checkIn) {
                const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
                const ratePerNight = roomRates[category][type];
                const total = nights * ratePerNight * roomsCount;
                document.getElementById('totalAmount').value = total.toFixed(2);
            }
        }
        
        function validateReservation() {
            const checkIn = new Date(document.getElementById('checkIn').value);
            const checkOut = new Date(document.getElementById('checkOut').value);
            
            if (checkOut <= checkIn) {
                alert('Check-out date must be after check-in date');
                return false;
            }
            
            const nic = document.getElementById('nic').value;
            if (nic.length < 9) {
                alert('Please enter a valid NIC number');
                return false;
            }
            
            const contact = document.getElementById('contactNumber').value;
            if (contact.length < 10) {
                alert('Please enter a valid contact number');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>
