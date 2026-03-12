<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Regal Quintet - Register</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/auth/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS for red required star */
        .required-star {
            color: #ff4d4d;
            margin-left: 3px;
        }

        /* CSS for password toggle icon */
        .password-container {
            position: relative;
            display: flex;
            align-items: center;
        }
        .password-container input {
            width: 100%;
            padding-right: 40px; /* Space for icon */
        }
        .toggle-password {
            position: absolute;
            right: 15px;
            cursor: pointer;
            color: #999;
            z-index: 10;
        }
        .toggle-password:hover {
            color: #b89664;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="banner-side">
        <div class="logo-area">
            <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; color: inherit">
                <div class="diamond-icons" style="display: flex; align-items: center; margin-bottom: 5px;">
                    <a href="${pageContext.request.contextPath}/home" 
                       style="text-decoration: none; display: flex; gap: 1px; border: none; outline: none; align-items: center;">

                        <span style="color: #FFD700; font-size: 14px; line-height: 1; text-shadow: 0 0 8px rgba(255, 215, 0, 0.4);">◆</span>

                        <span style="color: #FF0000; font-size: 18px; line-height: 1; text-shadow: 0 0 0px #FF0000, 0 0 10px rgba(255, 0, 0, 0.4);">◆</span>

                        <span style="color: #FFD700; font-size: 14px; line-height: 1; text-shadow: 0 0 8px rgba(255, 215, 0, 0.4);">◆</span>

                    </a>
                </div>
            </a>
            <h1><a href="${pageContext.request.contextPath}/home" style="text-decoration: none; color: inherit">REGAL QUINTET</a></h1>
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

            <%-- ERROR Notification --%>
            <c:if test="${not empty error}">
                <div style="color: #ff4d4d; background: #fff1f0; border: 1px solid #ffa39e; padding: 12px; border-radius: 4px; margin-bottom: 15px; text-align: center; font-size: 13px; animation: fadeIn 0.5s;">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <%-- MESSAGE/RE-SEND Notification --%>
            <c:if test="${not empty message}">
                <div style="color: #096dd9; background: #e6f7ff; border: 1px solid #91d5ff; padding: 12px; border-radius: 4px; margin-bottom: 15px; text-align: center; font-size: 13px; line-height: 1.6; animation: fadeIn 0.5s;">
                    <i class="fa-solid fa-paper-plane"></i> <strong>Notice:</strong> ${message}
                    <br>
                    <small style="color: #666;">Please carefully check your inbox and spam folder in your personal email.</small>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label>Identity <span class="required-star">*</span></label>
                    <input type="text" name="fullName" placeholder="Full Name" value="${fullName}" required>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Email <span class="required-star">*</span></label>
                        <input type="email" name="email" placeholder="email@example.com" value="${email}" required>
                    </div>
                    <div class="form-group">
                        <label>Phone <span class="required-star">*</span></label>
                        <input type="tel" name="phone" placeholder="0xxxxxxxxx" value="${phone}" required 
                               pattern="^0\d{9}$" title="Phone number must start with 0 and be exactly 10 digits">
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Password <span class="required-star">*</span></label>
                        <div class="password-container">
                            <input type="password" name="password" id="password" placeholder="Password" required>
                            <i class="fa-solid fa-eye toggle-password" onclick="togglePasswordVisibility('password', this)"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Confirm Password <span class="required-star">*</span></label>
                        <div class="password-container">
                            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm" required>
                            <i class="fa-solid fa-eye toggle-password" onclick="togglePasswordVisibility('confirmPassword', this)"></i>
                        </div>
                    </div>
                </div>

                <div class="checkbox-group" style="margin: 15px 0; font-size: 13px; color: #666;">
                    <input type="checkbox" name="terms" required style="margin-right: 8px;">
                    I consent to the privileged terms of stay <span class="required-star">*</span>
                </div>

                <button type="submit" class="btn-signup" style="cursor: pointer;">Sign Up</button>
            </form>

            <div class="social-login" style="margin: 25px 0; text-align: center; position: relative;">
                <span style="background: #fff; padding: 0 10px; color: #999; font-size: 12px; position: relative; z-index: 1;">OR CONNECT VIA</span>
                <div style="position: absolute; top: 50%; left: 0; right: 0; border-top: 1px solid #eee; z-index: 0;"></div>
            </div>
            
            <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:9999/SWP391_HMS_GR2/login&response_type=code&client_id=354340472598-5ohpj00n0e7fb6jmgcednupsnj4chgpt.apps.googleusercontent.com" 
               class="btn-google" 
               style="text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 10px; border: 1px solid #ddd; padding: 10px; border-radius: 4px; color: #333;">
                <img src="https://img.icons8.com/color/16/000000/google-logo.png" alt="google"/>
                GOOGLE ACCOUNT
            </a>

            <div class="footer-links" style="margin-top: 25px; text-align: center; font-size: 13px; color: #888;">
                ALREADY HAVE AN ACCOUNT? <a href="${pageContext.request.contextPath}/login" style="color: #b89664; text-decoration: none; font-weight: bold;">SIGN IN</a>
            </div>
        </div>
    </div>

    <script>
        // Password visibility toggle handler
        function togglePasswordVisibility(inputId, icon) {
            const input = document.getElementById(inputId);
            if (input.type === "password") {
                input.type = "text";
                // Show eye-slash when text is visible (click to hide)
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            } else {
                input.type = "password";
                // Show eye when text is hidden (click to show)
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            }
        }

        // Optional: Force only numbers in phone field
        document.querySelector('input[name="phone"]').addEventListener('input', function (e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>
</body>
</html>