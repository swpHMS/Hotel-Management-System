/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector("form");
    const password = document.getElementsByName("password")[0];
    const confirmPassword = document.getElementsByName("confirmPassword")[0];

    form.addEventListener("submit", function(event) {
        if (password.value !== confirmPassword.value) {
            alert("Mật khẩu xác nhận không khớp!");
            event.preventDefault(); // Ngăn không cho submit form
        }
    });
});


// Thêm vào cuối file register.jsp
document.querySelector('form').addEventListener('submit', function(e) {
    const phoneInput = document.getElementsByName('phone')[0].value;
    const phoneRegex = /^(0[3|5|7|8|9])[0-9]{8}$/; // Regex cho SĐT Việt Nam

    if (!phoneRegex.test(phoneInput)) {
        alert("Số điện thoại không hợp lệ! Vui lòng nhập 10 chữ số (vd: 0987654321).");
        e.preventDefault(); // Ngăn gửi form
        return false;
    }
});