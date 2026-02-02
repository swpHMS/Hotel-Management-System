<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu - Regal Quintet</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/reset.css">
</head>
<body>
    <div class="login-container" style="background-image: url('${pageContext.request.contextPath}/assets/images/auth/background.jpg');">
        <div class="login-card">
            <div class="auth-icon" style="text-align: center; font-size: 40px; color: #c5a059; margin-bottom: 10px;">
                <i class="fa-solid fa-key"></i>
            </div>
            <h2 style="text-align: center; margin-bottom: 5px;">RESET PASSWORD</h2>
            <p style="text-align: center; color: #666; font-size: 14px; margin-bottom: 25px;">Enter your new password to restore access.</p>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/resetPassword" method="POST">
                <input type="hidden" name="token" value="${token}">

                <div class="input-group">
                    <label>NEW PASSWORD</label>
                    <input type="password" name="password" required placeholder="Enter new password">
                </div>

                <div class="input-group">
                    <label>CONFIRM PASSWORD</label>
                    <input type="password" name="confirmPassword" required placeholder="Confirm Password">
                </div>

                <button type="submit" class="btn-login">UPDATE PASSWORD</button>
            </form>
            
            <div style="text-align: center; margin-top: 20px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/login" style="color: #c5a059; text-decoration: none;">RETURN TO LOGIN PAGE</a>
            </div>
        </div>
    </div>
</body>
</html>