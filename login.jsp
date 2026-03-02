<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <h2>Ocean View Resort</h2>
            <h3 style="text-align: center; color: #7f8c8d; margin-bottom: 40px;">Reservation Management System</h3>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "Invalid username or password" %>
                </div>
            <% } %>
            
            <% if (request.getParameter("logout") != null) { %>
                <div class="alert alert-success">
                    You have been successfully logged out.
                </div>
            <% } %>
            
            <form action="login" method="post" onsubmit="return validateLogin()">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <button type="submit" class="btn btn-primary" style="width: 100%;">Login</button>
            </form>
            

        </div>
    </div>
    
    <script>
        function validateLogin() {
            var username = document.getElementById('username').value.trim();
            var password = document.getElementById('password').value.trim();
            
            if (username === '' || password === '') {
                alert('Please enter both username and password');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
