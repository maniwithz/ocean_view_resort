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
    <title>Help - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .help-section {
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #667eea;
        }
        .help-section h3 {
            color: #2c3e50;
            margin-bottom: 15px;
        }
        .help-section ol, .help-section ul {
            margin-left: 20px;
            line-height: 1.8;
        }
        .help-section li {
            margin-bottom: 10px;
        }
    </style>
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
                <h1>Help & User Guide</h1>
                <p style="color: #7f8c8d; margin-bottom: 30px;">Step-by-step instructions for using the Ocean View Resort Management System</p>
                
                <div class="help-section">
                    <h3>1. Logging In</h3>
                    <ol>
                        <li>Open the system in your web browser</li>
                        <li>Enter your username and password</li>
                        <li>Click the "Login" button</li>
                        <li>Default credentials: <strong>admin / admin123</strong></li>
                    </ol>
                </div>
                
                <div class="help-section">
                    <h3>2. Adding a New Reservation</h3>
                    <ol>
                        <li>Click on "Add Reservation" from the dashboard or sidebar</li>
                        <li>The system will automatically generate a unique reservation number (e.g., R00001)</li>
                        <li>Fill in the guest information:
                            <ul>
                                <li>Guest Name (required)</li>
                                <li>Address (optional)</li>
                                <li>NIC Number (required)</li>
                                <li>Contact Number (required)</li>
                            </ul>
                        </li>
                        <li>Select room details:
                            <ul>
                                <li>Room Category: Standard, Deluxe, Elite, or Suites</li>
                                <li>Room Type: Single (SGL), Double (DBL), or Triple (TPL)</li>
                            </ul>
                        </li>
                        <li>Enter check-in and check-out dates</li>
                        <li>Specify number of adults, children, and rooms</li>
                        <li>The total amount will be calculated automatically</li>
                        <li>Click "Save Reservation" to complete</li>
                    </ol>
                </div>
                
                <div class="help-section">
                    <h3>3. Viewing and Managing Reservations</h3>
                    <ol>
                        <li>Click on "View Reservations" from the dashboard or sidebar</li>
                        <li>All reservations will be displayed in a table</li>
                        <li><strong>To Search:</strong>
                            <ul>
                                <li>Enter a Reservation Number or NIC Number in the search box</li>
                                <li>Click "Search" to find specific reservations</li>
                                <li>Click "Show All" to display all reservations again</li>
                            </ul>
                        </li>
                        <li><strong>To Edit:</strong>
                            <ul>
                                <li>Click the "Edit" button next to the reservation</li>
                                <li>Update the required information in the popup form</li>
                                <li>Click "Update" to save changes</li>
                            </ul>
                        </li>
                        <li><strong>To Delete:</strong>
                            <ul>
                                <li>Click the "Delete" button next to the reservation</li>
                                <li>Confirm the deletion when prompted</li>
                            </ul>
                        </li>
                    </ol>
                </div>
                
                <div class="help-section">
                    <h3>4. Calculating and Printing Bills</h3>
                    <ol>
                        <li>Click on "Billing" from the dashboard or sidebar</li>
                        <li>Enter the Reservation Number in the search box</li>
                        <li>Click "Load Bill" to retrieve the reservation details</li>
                        <li>The system will automatically calculate:
                            <ul>
                                <li>Number of nights (check-out date - check-in date)</li>
                                <li>Rate per night based on room category and type</li>
                                <li>Total amount (nights × rate × number of rooms)</li>
                            </ul>
                        </li>
                        <li>Review the bill details</li>
                        <li>Click "Print Bill" to print the invoice</li>
                        <li>Click "New Bill" to search for another reservation</li>
                    </ol>
                </div>
                
                <div class="help-section">
                    <h3>5. Managing Room Pricing</h3>
                    <ol>
                        <li>Click on "Room Pricing" from the dashboard or sidebar</li>
                        <li>View the current rates for all room categories and types</li>
                        <li>To update rates:
                            <ul>
                                <li>Click on the price field you want to change</li>
                                <li>Enter the new price</li>
                                <li>Repeat for all rates you want to update</li>
                            </ul>
                        </li>
                        <li>Click "Save All Changes" to update the rates</li>
                        <li>Click "Refresh" to reload the current rates</li>
                    </ol>
                </div>
                
                <div class="help-section">
                    <h3>6. Logging Out</h3>
                    <ol>
                        <li>Click the "Sign Out" button in the sidebar</li>
                        <li>You will be redirected to the login page</li>
                        <li>Always log out when you finish using the system</li>
                    </ol>
                </div>
                
                <div class="help-section">
                    <h3>Tips and Best Practices</h3>
                    <ul>
                        <li>Always verify guest information before saving a reservation</li>
                        <li>Double-check dates to avoid booking conflicts</li>
                        <li>Use the search function to quickly find specific reservations</li>
                        <li>Update room rates regularly to reflect current pricing</li>
                        <li>Print bills immediately after guest checkout</li>
                        <li>Keep NIC numbers accurate for guest identification</li>
                        <li>Log out when leaving your workstation for security</li>
                    </ul>
                </div>
                
                <div class="help-section">
                    <h3>Troubleshooting</h3>
                    <ul>
                        <li><strong>Cannot login:</strong> Verify your username and password are correct</li>
                        <li><strong>Reservation not saving:</strong> Ensure all required fields are filled</li>
                        <li><strong>Bill not loading:</strong> Check that the reservation number is correct</li>
                        <li><strong>Dates not working:</strong> Ensure check-out date is after check-in date</li>
                        <li><strong>Price not calculating:</strong> Make sure room category and type are selected</li>
                    </ul>
                </div>
                
                <div style="margin-top: 30px; padding: 20px; background: #d1ecf1; border-radius: 5px; text-align: center;">
                    <h3 style="color: #0c5460;">Need More Help?</h3>
                    <p style="color: #0c5460;">Contact the system administrator or IT support team for additional assistance.</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
