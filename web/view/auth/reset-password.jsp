<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reset Password - Regal Quintet</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/reset.css">
    <style>
        .error-msg {
            color: #ff4d4d;
            background: #fff1f0;
            border: 1px solid #ffa39e;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            font-size: 13px;
            text-align: center;
        }
        
        .password-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .password-wrapper input {
            width: 100%;
            padding-right: 40px;
        }
        
        .toggle-icon {
            position: absolute;
            right: 12px;
            cursor: pointer;
            color: #999;
            z-index: 10;
            font-size: 16px;
        }
        
        .toggle-icon:hover {
            color: #c5a059;
        }

        .required-star {
            color: #ff4d4d;
            margin-left: 3px;
        }
    </style>
</head>
<body>
    <div class="login-container" style="background-image: url('${pageContext.request.contextPath}/assets/images/auth/background.jpg');">
        <div class="login-card">
            <div class="auth-icon" style="text-align: center; font-size: 40px; color: #c5a059; margin-bottom: 10px;">
                <i class="fa-solid fa-key"></i>
            </div>
            <h2 style="text-align: center; margin-bottom: 5px;">RESET PASSWORD</h2>
            <p style="text-align: center; color: #666; font-size: 14px; margin-bottom: 25px;">Enter your new password to restore access.</p>

            <%-- Hiển thị thông báo lỗi từ Servlet --%>
            <c:if test="${not empty error}">
                <div class="error-msg">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/reset-password" method="POST">
                <%-- Giữ token để Servlet nhận diện --%>
                <input type="hidden" name="token" value="${token}">

                <div class="input-group">
                    <label>NEW PASSWORD <span class="required-star">*</span></label>
                    <div class="password-wrapper">
                        <%-- ĐÃ SỬA: pattern chuẩn HTML (dùng \d thay vì \\d) --%>
                        <input type="password" name="password" id="password" required 
                               placeholder="Min 8 chars, 1 uppercase, 1 digit"
                               pattern="^(?=.*[A-Z])(?=.*\d)\S{8,}$"
                               title="Password must be at least 8 characters long, including at least one uppercase letter, one number, and no spaces.">
                        <i class="fa-solid fa-eye toggle-icon" onclick="toggleVisibility('password', this)"></i>
                    </div>
                </div>

                <div class="input-group">
                    <label>CONFIRM PASSWORD <span class="required-star">*</span></label>
                    <div class="password-wrapper">
                        <input type="password" name="confirmPassword" id="confirmPassword" required 
                               placeholder="Re-enter new password">
                        <i class="fa-solid fa-eye toggle-icon" onclick="toggleVisibility('confirmPassword', this)"></i>
                    </div>
                </div>

                <button type="submit" class="btn-login" style="cursor: pointer;">UPDATE PASSWORD</button>
            </form>
            
            <div style="text-align: center; margin-top: 20px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/login" style="color: #c5a059; text-decoration: none; font-weight: bold;">
                    <i class="fa-solid fa-arrow-left"></i> RETURN TO LOGIN PAGE
                </a>
            </div>
        </div>
    </div>

    <script>
        function toggleVisibility(inputId, icon) {
            const inputField = document.getElementById(inputId);
            if (inputField.type === "password") {
                inputField.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                inputField.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
    </script>
</body>
</html>