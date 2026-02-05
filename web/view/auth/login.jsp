<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Login - Regal Quintet Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-left">
                <div class="logo-section">
                    <div class="diamond-icons">
                        <span>◆</span><span class="black">◆</span><span>◆</span>
                    </div>
                    <h1>REGAL QUINTET</h1>
                    <p class="subtitle">HOTEL & RESORTS</p>
                </div>
                <div class="quote-box">
                    <p>"Excellence is not an act, but a habit of the Regal house."</p>
                </div>
            </div>

            <div class="login-right">
                <h2>WELCOME BACK</h2>
                <p class="hint">Please sign in to your account.</p>

                <%-- PHẦN HIỂN THỊ THÔNG BÁO --%>
                <c:if test="${not empty sessionScope.successMsg}">
                    <p style="color: #52c41a; text-align: center; font-size: 13px; margin-bottom: 12px; background: #f6ffed; padding: 10px; border-radius: 6px; border: 1px solid #b7eb8f; animation: fadeIn 0.5s;">
                        <i class="fa-solid fa-circle-check"></i> ${sessionScope.successMsg}
                    </p>
                    <c:remove var="successMsg" scope="session"/>
                </c:if>

                <c:if test="${param.verify == 'success'}">
                    <p style="color: #52c41a; text-align: center; font-size: 13px; margin-bottom: 12px; background: #f6ffed; padding: 10px; border-radius: 6px; border: 1px solid #b7eb8f;">
                        <i class="fa-solid fa-circle-check"></i> Xác thực thành công! Bây giờ bạn có thể đăng nhập.
                    </p>
                </c:if>

                <c:if test="${not empty error or param.error == 'google_auth_failed' or param.error == 'denied'}">
                    <p style="color: #ff4d4d; text-align: center; font-size: 13px; margin-bottom: 12px; background: #fff1f0; padding: 10px; border-radius: 6px; border: 1px solid #ffa39e;">
                        <i class="fa-solid fa-circle-exclamation"></i> 
                        <c:choose>
                            <c:when test="${param.error == 'google_auth_failed'}">Lỗi xác thực Google. Vui lòng thử lại.</c:when>
                            <c:when test="${param.error == 'denied'}">Bạn không có quyền truy cập vào vùng này!</c:when>
                            <c:otherwise>${error}</c:otherwise>
                        </c:choose>
                    </p>
                </c:if>

                <%-- FORM ĐĂNG NHẬP --%>
                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="input-group">
                        <label>IDENTITY</label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-user"></i>
                            <%-- Chỉ tự điền Email --%>
                            <input type="email" name="email" placeholder="email@example.com" value="${not empty email ? email : ''}" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <label>PASSWORD</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-lock"></i>
                            <%-- KHÔNG tự điền mật khẩu vì lý do bảo mật --%>
                            <input type="password" name="password" id="password" placeholder="••••••••" required>
                            <i class="fa-regular fa-eye eye-icon" style="cursor: pointer;"></i>
                        </div>
                    </div>

                    <div class="form-options">
                        <label class="remember-me">
                            <input type="checkbox" name="remember" ${not empty remember ? 'checked' : ''}> Remember me
                        </label>
                        <%-- Dùng đường dẫn tương đối từ gốc --%>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-pwd">FORGOT PASSWORD?</a>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn-login">SIGN IN</button>
                        <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:9999/SWP391_HMS_GR2/login&response_type=code&client_id=354340472598-5ohpj00n0e7fb6jmgcednupsnj4chgpt.apps.googleusercontent.com" 
                           class="btn-google" 
                           style="text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 10px;">
                            <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google" width="18">
                            GOOGLE
                        </a>
                    </div>

                    <p class="footer-text">Don't have an account? <a href="${pageContext.request.contextPath}/register">SIGN UP</a></p>
                </form>
            </div>
        </div>
        
        <div class="page-footer">
            <a href="#">PRIVACY POLICY</a>
            <a href="#">SYSTEM STATUS</a>
            <a href="#">REGAL QUINTET V1.0</a>
        </div>
    </div>

    <script>
        document.querySelector('.eye-icon').addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('fa-eye-slash');
            this.classList.toggle('fa-eye');
        });
    </script>
</body>
</html>