<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - Regal Quintet</title>
    <%-- Sử dụng chung CSS với trang Login để đồng bộ giao diện --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .forgot-header { text-align: center; margin-bottom: 30px; }
        .forgot-header i { font-size: 50px; color: #c5a059; margin-bottom: 15px; }
        .message-success { color: #52c41a; background: #f6ffed; padding: 10px; border: 1px solid #b7eb8f; margin-bottom: 15px; text-align: center; }
        .message-error { color: #ff4d4d; background: #fff1f0; padding: 10px; border: 1px solid #ffa39e; margin-bottom: 15px; text-align: center; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-right" style="width: 100%; border-radius: 12px;">
                <div class="forgot-header">
                    <i class="fa-solid fa-key"></i>
                    <h2>FORGOT PASSWORD?</h2>
                    <p class="hint">Enter your email address to receive a password reset link.</p>
                </div>

                <%-- Hiển thị thông báo thành công hoặc lỗi --%>
                <c:if test="${not empty message}">
                    <div class="message-success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="message-error">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                    <div class="input-group">
                        <label>EMAIL ACCOUNT</label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-envelope"></i>
                            <input type="email" name="email" placeholder="example@gmail.com" required>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn-login">SUBMIT RECOVERY LINK</button>
                    </div>

                    <p class="footer-text" style="margin-top: 20px;">
                        Remember your password? <a href="login.jsp">RETURN TO LOGIN PAGE</a>
                    </p>
                </form>
            </div>
        </div>
    </div>
</body>
</html>