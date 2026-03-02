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
    <title>Room Pricing - Ocean View Resort</title>
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
                <h1>Room Pricing Management</h1>
                <p style="color: #7f8c8d; margin-bottom: 20px;">Manage room rates by category and type</p>
                
                <% if (request.getParameter("updated") != null) { %>
                    <div class="alert alert-success">Room rates updated successfully!</div>
                <% } %>
                
                <div id="pricingTable">
                    <p style="text-align: center; color: #7f8c8d;">Loading room rates...</p>
                </div>
                
                <div style="margin-top: 20px;">
                    <button onclick="saveAllRates()" class="btn btn-success">Save All Changes</button>
                    <button onclick="loadRates()" class="btn btn-info" style="margin-left: 10px;">Refresh</button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        window.onload = function() {
            loadRates();
        };
        
        function loadRates() {
            fetch('roomRate?action=getAll')
                .then(response => response.json())
                .then(data => displayRates(data))
                .catch(error => {
                    document.getElementById('pricingTable').innerHTML = 
                        '<p style="color: red;">Error loading room rates</p>';
                });
        }
        
        function displayRates(rates) {
            const categories = ['Standard', 'Deluxe', 'Elite', 'Suites'];
            const types = ['SGL', 'DBL', 'TPL'];
            
            let html = '<table><thead><tr>' +
                '<th>Room Category</th><th>Single (SGL)</th><th>Double (DBL)</th><th>Triple (TPL)</th>' +
                '</tr></thead><tbody>';
            
            categories.forEach(category => {
                html += '<tr><td><strong>' + category + '</strong></td>';
                
                types.forEach(type => {
                    const rate = rates.find(r => r.category === category && r.type === type);
                    const price = rate ? rate.price : 0;
                    html += '<td><input type="number" class="rate-input" ' +
                        'data-category="' + category + '" data-type="' + type + '" ' +
                        'value="' + price + '" step="0.01" ' +
                        'style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 5px;"></td>';
                });
                
                html += '</tr>';
            });
            
            html += '</tbody></table>';
            document.getElementById('pricingTable').innerHTML = html;
        }
        
        function saveAllRates() {
            const inputs = document.querySelectorAll('.rate-input');
            const updates = [];
            
            inputs.forEach(input => {
                updates.push({
                    category: input.dataset.category,
                    type: input.dataset.type,
                    price: parseFloat(input.value)
                });
            });
            
            fetch('roomRate?action=updateAll', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(updates)
            })
            .then(response => {
                if (response.ok) {
                    alert('Room rates updated successfully!');
                    loadRates();
                } else {
                    alert('Error updating room rates');
                }
            })
            .catch(error => {
                alert('Error updating room rates');
            });
        }
    </script>
</body>
</html>
