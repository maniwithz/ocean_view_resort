Ocean View Resort - Reservation Management System

Ocean View Resort is a  web application for managing hotel reservations, room pricing, billing, and guest information. The system supports reservation management, dynamic pricing, bill generation, and comprehensive CRUD operations for all entities.

Features

- User Authentication (Login, Logout, Session Management)
- Reservation Management (Add, Update, Delete, View)
- Room Pricing Management (Dynamic pricing by category and type)
- Billing System (Generate bills, Calculate totals)
- Guest Management (Customer information handling)
- Search Functionality (Search by Reservation ID or NIC)
- Input Validation (Guest name, NIC, Contact, Dates, Prices)
- MySQL Database Integration
- DAO Pattern for data access

Technologies Used

- Java EE / Jakarta EE
- Servlets & JSP
- MySQL Database
- DAO Pattern for data access
- Gson for JSON handling
- Maven for dependency management
- GitHub for version control

Setup Instructions

Clone the Repository

git clone https://github.com/maniwithz/ocean_view_resort.git

cd ocean_view_resort_icbt

Database Setup

Import the provided database file:

1. Open MySQL Workbench or phpMyAdmin
2. Import the SQL file: src/main/resources/ocean_view_db.sql
3. The database will be created automatically with all tables and data

Configure Database Connection

Run the project using your IDE or deploy to Jetty server.

Access the WebApplication

http://localhost:8080/ocean_view_resort_icbt

Default credentials: admin / admin123
