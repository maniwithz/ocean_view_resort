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
    <title>Billing - Ocean View Resort</title>
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
                <h1>Calculate and Print Bill</h1>
                
                <!-- Search Reservation -->
                <div style="margin: 20px 0; padding: 20px; background: #f8f9fa; border-radius: 5px;">
                    <h3>Search Reservation</h3>
                    <div style="display: flex; gap: 10px; margin-top: 10px;">
                        <input type="text" id="searchReservationNumber" placeholder="Enter Reservation Number" 
                               style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
                        <button onclick="loadBill()" class="btn btn-primary">Load Bill</button>
                    </div>
                </div>
                
                <!-- Bill Display -->
                <div id="billSection" style="display: none;">
                    <div id="billContent" style="padding: 30px; background: white; border: 2px solid #2c3e50; border-radius: 10px;">
                        <div style="text-align: center; margin-bottom: 30px;">
                            <h1 style="color: #2c3e50; margin-bottom: 5px;">Ocean View Resort</h1>
                            <p style="color: #7f8c8d;">Galle, Sri Lanka</p>
                            <p style="color: #7f8c8d;">Tel: +94 91 222 3333 | Email: info@oceanview.lk</p>
                            <hr style="margin: 20px 0; border: 1px solid #ddd;">
                            <h2 style="color: #2c3e50;">GUEST BILL</h2>
                        </div>
                        
                        <div style="margin-bottom: 30px;">
                            <table style="width: 100%; border: none;">
                                <tr>
                                    <td style="border: none;"><strong>Reservation Number:</strong></td>
                                    <td style="border: none;" id="billReservationNumber"></td>
                                    <td style="border: none;"><strong>Date:</strong></td>
                                    <td style="border: none;" id="billDate"></td>
                                </tr>
                                <tr>
                                    <td style="border: none;"><strong>Guest Name:</strong></td>
                                    <td style="border: none;" id="billGuestName"></td>
                                    <td style="border: none;"><strong>NIC:</strong></td>
                                    <td style="border: none;" id="billNIC"></td>
                                </tr>
                                <tr>
                                    <td style="border: none;"><strong>Contact:</strong></td>
                                    <td style="border: none;" id="billContact"></td>
                                    <td style="border: none;"><strong>Address:</strong></td>
                                    <td style="border: none;" id="billAddress"></td>
                                </tr>
                            </table>
                        </div>
                        
                        <h3 style="color: #2c3e50; margin-bottom: 15px;">Reservation Details</h3>
                        <table style="width: 100%; margin-bottom: 30px;">
                            <thead>
                                <tr style="background: #2c3e50; color: white;">
                                    <th>Description</th>
                                    <th>Details</th>
                                    <th>Amount (Rs.)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Room Category</td>
                                    <td id="billRoomCategory"></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Room Type</td>
                                    <td id="billRoomType"></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Check-in Date</td>
                                    <td id="billCheckIn"></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Check-out Date</td>
                                    <td id="billCheckOut"></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Number of Nights</td>
                                    <td id="billNights"></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Number of Rooms</td>
                                    <td id="billRoomsCount"></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Guests</td>
                                    <td><span id="billAdults"></span> Adults, <span id="billChildren"></span> Children</td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td><strong>Rate per Night</strong></td>
                                    <td></td>
                                    <td><strong id="billRatePerNight"></strong></td>
                                </tr>
                                <tr style="background: #f8f9fa;">
                                    <td colspan="2"><strong>TOTAL AMOUNT</strong></td>
                                    <td><strong style="font-size: 20px; color: #27ae60;" id="billTotalAmount"></strong></td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <div style="margin-top: 50px; text-align: center; color: #7f8c8d;">
                            <p>Thank you for choosing Ocean View Resort!</p>
                            <p style="margin-top: 10px;">We hope you enjoyed your stay with us.</p>
                        </div>
                    </div>
                    
                    <div style="margin-top: 20px; text-align: center;">
                        <button onclick="window.print()" class="btn btn-success">Print Bill</button>
                        <button onclick="resetBill()" class="btn btn-warning" style="margin-left: 10px;">New Bill</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function loadBill() {
            const reservationNumber = document.getElementById('searchReservationNumber').value.trim();
            
            if (!reservationNumber) {
                alert('Please enter a reservation number');
                return;
            }
            
            fetch('billing?action=calculate&reservationNumber=' + reservationNumber)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Reservation not found');
                    }
                    return response.json();
                })
                .then(data => {
                    displayBill(data);
                })
                .catch(error => {
                    alert('Reservation not found. Please check the reservation number.');
                });
        }
        
        function displayBill(data) {
            const reservation = data.reservation;
            
            document.getElementById('billReservationNumber').textContent = reservation.reservationNumber;
            document.getElementById('billDate').textContent = new Date().toLocaleDateString();
            document.getElementById('billGuestName').textContent = reservation.guestName;
            document.getElementById('billNIC').textContent = reservation.nic;
            document.getElementById('billContact').textContent = reservation.contactNumber;
            document.getElementById('billAddress').textContent = reservation.address || 'N/A';
            document.getElementById('billRoomCategory').textContent = reservation.roomCategory;
            document.getElementById('billRoomType').textContent = reservation.roomType;
            document.getElementById('billCheckIn').textContent = reservation.checkIn;
            document.getElementById('billCheckOut').textContent = reservation.checkOut;
            document.getElementById('billNights').textContent = data.nights;
            document.getElementById('billRoomsCount').textContent = reservation.roomsCount;
            document.getElementById('billAdults').textContent = reservation.adults;
            document.getElementById('billChildren').textContent = reservation.children;
            document.getElementById('billRatePerNight').textContent = 'Rs. ' + data.ratePerNight.toFixed(2);
            document.getElementById('billTotalAmount').textContent = 'Rs. ' + data.totalAmount.toFixed(2);
            
            document.getElementById('billSection').style.display = 'block';
        }
        
        function resetBill() {
            document.getElementById('searchReservationNumber').value = '';
            document.getElementById('billSection').style.display = 'none';
        }
    </script>
</body>
</html>
