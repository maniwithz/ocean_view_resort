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
    <title>View Reservations - Ocean View Resort</title>
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
                <h1>Reservation Details</h1>
                
                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success">
                        Reservation created successfully! Reservation Number: <%= request.getParameter("reservationNumber") %>
                    </div>
                <% } %>
                
                <% if (request.getParameter("updated") != null) { %>
                    <div class="alert alert-success">Reservation updated successfully!</div>
                <% } %>
                
                <% if (request.getParameter("deleted") != null) { %>
                    <div class="alert alert-success">Reservation deleted successfully!</div>
                <% } %>
                
                <!-- Search Section -->
                <div style="margin: 20px 0; padding: 20px; background: #f8f9fa; border-radius: 5px;">
                    <h3>Search Reservations</h3>
                    <div style="display: flex; gap: 10px; margin-top: 10px;">
                        <input type="text" id="searchReservationNumber" placeholder="Reservation Number" 
                               style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
                        <input type="text" id="searchNIC" placeholder="NIC Number" 
                               style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
                        <button onclick="searchReservations()" class="btn btn-primary">Search</button>
                        <button onclick="loadAllReservations()" class="btn btn-info">Show All</button>
                    </div>
                </div>
                
                <!-- Reservations Table -->
                <div id="reservationsTable">
                    <p style="text-align: center; color: #7f8c8d;">Loading reservations...</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Modal -->
    <div id="editModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
         background: rgba(0,0,0,0.5); z-index: 1000;">
        <div style="background: white; margin: 50px auto; padding: 30px; width: 80%; max-width: 600px; 
             border-radius: 10px; max-height: 80vh; overflow-y: auto;">
            <h2>Edit Reservation</h2>
            <form id="editForm" onsubmit="updateReservation(event)">
                <input type="hidden" id="editReservationNumber" name="reservationNumber">
                
                <div class="form-group">
                    <label>Guest Name *</label>
                    <input type="text" id="editGuestName" name="guestName" required>
                </div>
                
                <div class="form-group">
                    <label>Address</label>
                    <textarea id="editAddress" name="address" rows="2"></textarea>
                </div>
                
                <div class="form-group">
                    <label>NIC *</label>
                    <input type="text" id="editNic" name="nic" required>
                </div>
                
                <div class="form-group">
                    <label>Contact Number *</label>
                    <input type="text" id="editContactNumber" name="contactNumber" required>
                </div>
                
                <div class="form-group">
                    <label>Room Category *</label>
                    <select id="editRoomCategory" name="roomCategory" required onchange="calculateEditTotal()">
                        <option value="Standard">Standard</option>
                        <option value="Deluxe">Deluxe</option>
                        <option value="Elite">Elite</option>
                        <option value="Suites">Suites</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Room Type *</label>
                    <select id="editRoomType" name="roomType" required onchange="calculateEditTotal()">
                        <option value="SGL">Single (SGL)</option>
                        <option value="DBL">Double (DBL)</option>
                        <option value="TPL">Triple (TPL)</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Check-in Date *</label>
                    <input type="date" id="editCheckIn" name="checkIn" required onchange="calculateEditTotal()">
                </div>
                
                <div class="form-group">
                    <label>Check-out Date *</label>
                    <input type="date" id="editCheckOut" name="checkOut" required onchange="calculateEditTotal()">
                </div>
                
                <div class="form-group">
                    <label>Adults *</label>
                    <input type="number" id="editAdults" name="adults" min="1" required>
                </div>
                
                <div class="form-group">
                    <label>Children</label>
                    <input type="number" id="editChildren" name="children" min="0">
                </div>
                
                <div class="form-group">
                    <label>Rooms Count *</label>
                    <input type="number" id="editRoomsCount" name="roomsCount" min="1" required onchange="calculateEditTotal()">
                </div>
                
                <div class="form-group">
                    <label>Total Amount (Rs.)</label>
                    <input type="number" id="editTotalAmount" name="totalAmount" step="0.01" required>
                </div>
                
                <div style="margin-top: 20px;">
                    <button type="submit" class="btn btn-success">Update</button>
                    <button type="button" onclick="closeEditModal()" class="btn btn-danger" 
                            style="margin-left: 10px;">Cancel</button>
                </div>
            </form>
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
            loadAllReservations();
        };
        
        function calculateEditTotal() {
            const category = document.getElementById('editRoomCategory').value;
            const type = document.getElementById('editRoomType').value;
            const checkIn = new Date(document.getElementById('editCheckIn').value);
            const checkOut = new Date(document.getElementById('editCheckOut').value);
            const roomsCount = parseInt(document.getElementById('editRoomsCount').value) || 1;
            
            if (category && type && checkIn && checkOut && checkOut > checkIn) {
                const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
                const ratePerNight = roomRates[category][type];
                const total = nights * ratePerNight * roomsCount;
                document.getElementById('editTotalAmount').value = total.toFixed(2);
            }
        }
        
        function loadAllReservations() {
            fetch('reservation?action=getAll')
                .then(response => response.json())
                .then(data => displayReservations(data))
                .catch(error => {
                    document.getElementById('reservationsTable').innerHTML = 
                        '<p style="color: red;">Error loading reservations</p>';
                });
        }
        
        function searchReservations() {
            const reservationNumber = document.getElementById('searchReservationNumber').value.trim();
            const nic = document.getElementById('searchNIC').value.trim();
            
            if (reservationNumber) {
                fetch('reservation?action=getByNumber&reservationNumber=' + reservationNumber)
                    .then(response => response.json())
                    .then(data => displayReservations(data ? [data] : []))
                    .catch(error => console.error('Error:', error));
            } else if (nic) {
                fetch('reservation?action=getByNIC&nic=' + nic)
                    .then(response => response.json())
                    .then(data => displayReservations(data ? [data] : []))
                    .catch(error => console.error('Error:', error));
            } else {
                alert('Please enter a reservation number or NIC to search');
            }
        }
        
        function displayReservations(reservations) {
            let html = '<table><thead><tr>' +
                '<th>Reservation #</th><th>Guest Name</th><th>NIC</th><th>Contact</th>' +
                '<th>Room</th><th>Check-in</th><th>Check-out</th><th>Total (Rs.)</th><th>Actions</th>' +
                '</tr></thead><tbody>';
            
            if (reservations.length === 0) {
                html += '<tr><td colspan="9" style="text-align: center;">No reservations found</td></tr>';
            } else {
                reservations.forEach(r => {
                    html += '<tr>' +
                        '<td>' + r.reservationNumber + '</td>' +
                        '<td>' + r.guestName + '</td>' +
                        '<td>' + r.nic + '</td>' +
                        '<td>' + r.contactNumber + '</td>' +
                        '<td>' + r.roomCategory + ' - ' + r.roomType + '</td>' +
                        '<td>' + r.checkIn + '</td>' +
                        '<td>' + r.checkOut + '</td>' +
                        '<td>' + r.totalAmount.toFixed(2) + '</td>' +
                        '<td>' +
                        '<button onclick="editReservation(\'' + r.reservationNumber + '\')" class="btn btn-warning" style="margin-right: 5px;">Edit</button>' +
                        '<button onclick="deleteReservation(\'' + r.reservationNumber + '\')" class="btn btn-danger">Delete</button>' +
                        '</td>' +
                        '</tr>';
                });
            }
            
            html += '</tbody></table>';
            document.getElementById('reservationsTable').innerHTML = html;
        }
        
        function editReservation(reservationNumber) {
            fetch('reservation?action=getByNumber&reservationNumber=' + reservationNumber)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('editReservationNumber').value = data.reservationNumber;
                    document.getElementById('editGuestName').value = data.guestName;
                    document.getElementById('editAddress').value = data.address || '';
                    document.getElementById('editNic').value = data.nic;
                    document.getElementById('editContactNumber').value = data.contactNumber;
                    document.getElementById('editRoomCategory').value = data.roomCategory;
                    document.getElementById('editRoomType').value = data.roomType;
                    document.getElementById('editCheckIn').value = data.checkIn;
                    document.getElementById('editCheckOut').value = data.checkOut;
                    document.getElementById('editAdults').value = data.adults;
                    document.getElementById('editChildren').value = data.children;
                    document.getElementById('editRoomsCount').value = data.roomsCount;
                    document.getElementById('editTotalAmount').value = data.totalAmount;
                    
                    document.getElementById('editModal').style.display = 'block';
                });
        }
        
        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }
        
        function updateReservation(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            formData.append('action', 'update');
            
            fetch('reservation', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
            .then(() => {
                closeEditModal();
                location.reload();
            });
        }
        
        function deleteReservation(reservationNumber) {
            if (confirm('Are you sure you want to delete this reservation?')) {
                fetch('reservation', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=delete&reservationNumber=' + reservationNumber
                })
                .then(() => location.reload());
            }
        }
    </script>
</body>
</html>
