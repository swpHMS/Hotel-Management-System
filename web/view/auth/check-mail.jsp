<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Xác nhận Email - Regal Quintet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .check-email-card { text-align: center; padding: 40px; }
        .envelope-icon { font-size: 80px; color: #c5a059; margin-bottom: 20px; }
        .btn-back { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #c5a059; color: #white; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card" style="display: block;">
            <div class="check-email-card">
                <i class="fa-solid fa-envelope-open-text envelope-icon"></i>
                <h2>CONFIRM YOUR EMAIL</h2>
                <p>We have sent the activation link to your email.</p>
                <p>Please check your inbox (including spam) to complete your registration.</p>
                <a href="${pageContext.request.contextPath}/view/auth/login.jsp" class="btn-back">RETURN TO LOG IN</a>
            </div>
        </div>
    </div>
</body>
</html>