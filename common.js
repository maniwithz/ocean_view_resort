// Common utility functions for Ocean View Resort Management System

// Format currency
function formatCurrency(amount) {
    return 'Rs. ' + parseFloat(amount).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
}

// Format date
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-GB');
}

// Validate NIC number
function validateNIC(nic) {
    // Sri Lankan NIC format: 9 digits + V or 12 digits
    const oldFormat = /^[0-9]{9}[vVxX]$/;
    const newFormat = /^[0-9]{12}$/;
    return oldFormat.test(nic) || newFormat.test(nic);
}

// Validate phone number
function validatePhone(phone) {
    // Sri Lankan phone format: 10 digits starting with 0
    const phoneRegex = /^0[0-9]{9}$/;
    return phoneRegex.test(phone);
}

// Calculate nights between two dates
function calculateNights(checkIn, checkOut) {
    const start = new Date(checkIn);
    const end = new Date(checkOut);
    const diffTime = Math.abs(end - start);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
}

// Show loading spinner
function showLoading(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.innerHTML = '<div style="text-align: center; padding: 20px;"><div class="spinner"></div><p>Loading...</p></div>';
    }
}

// Show error message
function showError(message) {
    alert('Error: ' + message);
}

// Show success message
function showSuccess(message) {
    alert('Success: ' + message);
}

// Confirm action
function confirmAction(message) {
    return confirm(message);
}

// Print page
function printPage() {
    window.print();
}

// Go back
function goBack() {
    window.history.back();
}
