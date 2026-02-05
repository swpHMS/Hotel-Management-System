<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Regal Quintet - Register</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/auth/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <div class="banner-side">
        <div class="logo-area">
            <div class="diamond-separator">
                <span class="diamond gold"></span>
                <span class="diamond black"></span>
                <span class="diamond gold"></span>
            </div>
            <h1>REGAL QUINTET</h1>
            <p>HERITAGE OF EXCELLENCE</p>
        </div>
        <div class="quote">
            "Experience the pinnacle of hospitality, where every detail is curated for your absolute comfort."
        </div>
    </div>

    <div class="form-side">
        <div class="container">
            <h2>Create Account</h2>
            <p class="sub-text">Join our exclusive circle of distinguished guests.</p>
            
            <hr style="border: 0.5px solid #eee; margin: 20px 0;">

            <%-- 1. Hiển thị thông báo LỖI (Màu đỏ) --%>
            <c:if test="${not empty error}">
                <div style="color: #ff4d4d; background: #fff1f0; border: 1px solid #ffa39e; padding: 12px; border-radius: 4px; margin-bottom: 15px; text-align: center; font-size: 13px; animation: fadeIn 0.5s;">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <%-- 2. Thông báo GỬI LẠI MÃ (Màu xanh dương - Xử lý đăng ký lại) --%>
            <c:if test="${not empty message}">
                <div style="color: #096dd9; background: #e6f7ff; border: 1px solid #91d5ff; padding: 12px; border-radius: 4px; margin-bottom: 15px; text-align: center; font-size: 13px; line-height: 1.6; animation: fadeIn 0.5s;">
                    <i class="fa-solid fa-paper-plane"></i> <strong>Lưu ý:</strong> ${message}
                    <br>
                    <small style="color: #666;">Vui lòng kiểm tra kỹ hòm thư cá nhân và mục thư rác.</small>
                </div>
            </c:if>

            <%-- 3. Thông báo THÀNH CÔNG --%>
            <c:if test="${not empty successMessage}">
                <div style="color: #52c41a; background: #f6ffed; border: 1px solid #b7eb8f; padding: 12px; border-radius: 4px; margin-bottom: 15px; text-align: center; font-size: 13px;">
                    <i class="fa-solid fa-circle-check"></i> ${successMessage} 
                    <br>
                    <a href="${pageContext.request.contextPath}/login" style="color: #52c41a; font-weight: bold; text-decoration: underline;">Sign In Now</a>
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label>Identity</label>
                    <input type="text" name="fullName" placeholder="Full Name" value="${fullName}" required>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" placeholder="email@example.com" value="${email}" required>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="tel" name="phone" placeholder="Phone Number" value="${phone}">
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" placeholder="password" required>
                    </div>
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input type="password" name="confirmPassword" placeholder="Confirm" required>
                    </div>
                </div>

                <div class="checkbox-group" style="margin: 15px 0; font-size: 13px; color: #666;">
                    <input type="checkbox" name="terms" required style="margin-right: 8px;">
                    I consent to the privileged terms of stay
                </div>

                <button type="submit" class="btn-signup" style="cursor: pointer;">Sign Up</button>
            </form>

            <div class="social-login" style="margin: 25px 0; text-align: center; position: relative;">
                <span style="background: #fff; padding: 0 10px; color: #999; font-size: 12px; position: relative; z-index: 1;">OR CONNECT VIA</span>
                <div style="position: absolute; top: 50%; left: 0; right: 0; border-top: 1px solid #eee; z-index: 0;"></div>
            </div>
            
            <%-- CẬP NHẬT: Thêm đầy đủ tham số Google OAuth2 --%>
            <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:9999/SWP391_HMS_GR2/login&response_type=code&client_id=354340472598-5ohpj00n0e7fb6jmgcednupsnj4chgpt.apps.googleusercontent.com" 
               class="btn-google" 
               style="text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 10px; border: 1px solid #ddd; padding: 10px; border-radius: 4px; color: #333; transition: background 0.3s;">
                <img src="https://img.icons8.com/color/16/000000/google-logo.png" alt="google"/>
                GOOGLE ACCOUNT
            </a>

            <div class="footer-links" style="margin-top: 25px; text-align: center; font-size: 13px; color: #888;">
                <%-- SỬA: Dùng Servlet URL thay vì .jsp để tránh lỗi 404 --%>
                ALREADY HAVE AN ACCOUNT? <a href="${pageContext.request.contextPath}/login" style="color: #b89664; text-decoration: none; font-weight: bold;">SIGN IN</a>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/auth/register.js"></script>
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</body>
</html>