<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>HMS Admin | Edit Profile</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

        <style>
            .page-wrap{
                padding: 28px;
            }
            .card{
                background:#fff;
                border:1px solid rgba(15,23,42,.10);
                border-radius:16px;
                padding:28px;
                box-shadow:0 8px 24px rgba(15,23,42,.06);
                margin-bottom:18px;
            }
            .grid-2{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:16px;
            }
            .grid-3{
                display:grid;
                grid-template-columns:1fr 1fr 1fr;
                gap:16px;
            }
            @media (max-width: 900px){
                .grid-2,.grid-3{
                    grid-template-columns:1fr;
                }
            }

            .label{
                font-size:11px;
                letter-spacing:.14em;
                text-transform:uppercase;
                color:rgba(15,23,42,.45);
                font-weight:800;
                margin-bottom:6px;
            }
            .control{
                width:100%;
                border:1px solid rgba(15,23,42,.12);
                border-radius:12px;
                padding:10px 12px;
                outline:none;
                background:#fff;
            }
            .control:focus{
                box-shadow:0 0 0 3px rgba(37,99,235,.15);
                border-color:rgba(37,99,235,.45);
            }
            .readonly{
                background:#f8fafc;
                border-color:rgba(15,23,42,.08);
                color:rgba(15,23,42,.45);
                cursor:not-allowed;
            }
            .hint{
                font-size:11px;
                color:rgba(15,23,42,.45);
                font-style:italic;
                margin-top:6px;
            }

            .actions{
                display:flex;
                justify-content:flex-end;
                gap:12px;
                padding-top:16px;
                border-top:1px solid rgba(15,23,42,.08);
            }
            .btn{
                padding:10px 18px;
                border-radius:12px;
                font-weight:800;
                border:1px solid rgba(15,23,42,.18);
                background:#fff;
                cursor:pointer;
            }
            .btn-primary{
                background:#2563eb;
                color:#fff;
                border-color:#2563eb;
                box-shadow:0 10px 20px rgba(37,99,235,.18);
            }

            .field-error{
                color:#dc2626;
                font-size:12px;
                font-weight:700;
                margin-top:6px;
            }
            .is-invalid{
                border-color:#dc2626 !important;
                box-shadow:0 0 0 3px rgba(220,38,38,.12) !important;
            }
        </style>
    </head>

    <body>
        <div class="app-shell">
            <%@ include file="/view/admin_layout/sidebar.jsp" %> 
            <div class="hms-main"> 
                <div class="page-wrap">

                    <div style="margin-bottom:14px;">


                        <div style="display:flex; justify-content:space-between; align-items:center; gap:12px; margin-top:6px;">
                            <h2 style="margin:0; font-size:24px;">Edit Profile</h2>
                            <div style="display:flex; gap:10px;">
                                <a class="btn" href="${pageContext.request.contextPath}/admin/staff/detail?id=${staff.userId}">Back</a>
                            </div>
                        </div>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/admin/staff/edit-profile">
                        <input type="hidden" name="userId" value="${staff.userId}"/>

                        <!-- 1. Basic Information -->
                        <section class="card">
                            <div style="border-bottom:1px solid rgba(15,23,42,.08); padding-bottom:14px; margin-bottom:16px;">
                                <h3 style="margin:0 0 6px;">1. Basic Information</h3>
                                <p style="margin:0; color:rgba(15,23,42,.65); font-size:13px;">Essential personal details for identifying the staff member.</p>
                            </div>

                            <div class="grid-2">
                                <div>
                                    <div class="label">Full Name</div>
                                    <input name="fullName" value="${staff.fullName}"
                                           class="control ${errors.fullName != null ? 'is-invalid' : ''}" required/>
                                    <c:if test="${errors.fullName != null}">
                                        <div class="field-error">${errors.fullName}</div>
                                    </c:if>
                                </div>

                                <div>
                                    <div class="label">Gender</div>
                                    <select name="gender" class="control ${errors.gender != null ? 'is-invalid' : ''}">
                                        <option value="1" ${staff.gender == 1 ? 'selected' : ''}>Male</option>
                                        <option value="2" ${staff.gender == 2 ? 'selected' : ''}>Female</option>
                                        <option value="3" ${staff.gender == 3 ? 'selected' : ''}>Other</option>
                                    </select>
                                    <c:if test="${errors.gender != null}">
                                        <div class="field-error">${errors.gender}</div>
                                    </c:if>
                                </div>

                                <div>
                                    <div class="label">Date of Birth</div>
                                    <input type="date" name="dateOfBirth"
                                           value="<fmt:formatDate value='${staff.dateOfBirth}' pattern='yyyy-MM-dd'/>"
                                           class="control ${errors.dateOfBirth != null ? 'is-invalid' : ''}"/>
                                    <c:if test="${errors.dateOfBirth != null}">
                                        <div class="field-error">${errors.dateOfBirth}</div>
                                    </c:if>
                                </div>

                                <div>
                                    <div class="label">Residence Address</div>
                                    <input name="residenceAddress" value="${staff.residenceAddress}" class="control"/>
                                    <c:if test="${errors.residenceAddress != null}">
                                        <div class="field-error">${errors.residenceAddress}</div>
                                    </c:if>
                                </div>
                            </div>
                        </section>

                        <!-- 2. Identity & Contact -->
                        <section class="card">
                            <div style="border-bottom:1px solid rgba(15,23,42,.08); padding-bottom:14px; margin-bottom:16px;">
                                <h3 style="margin:0 0 6px;">2. Identity & Contact</h3>
                                <p style="margin:0; color:rgba(15,23,42,.65); font-size:13px;">Contact information and system verification identifiers.</p>
                            </div>

                            <div class="grid-2">
                                <div>
                                    <div class="label">Phone Number</div>
                                    <input name="phone" value="${staff.phone}"
                                           class="control ${errors.phone != null ? 'is-invalid' : ''}"/>
                                    <c:if test="${errors.phone != null}">
                                        <div class="field-error">${errors.phone}</div>
                                    </c:if>
                                </div>

                                <div>
                                    <div class="label">Email Address</div>
                                    <input type="email" name="email" value="${staff.email}"
                                           class="control ${errors.email != null ? 'is-invalid' : ''}" required/>
                                    <c:if test="${errors.email != null}">
                                        <div class="field-error">${errors.email}</div>
                                    </c:if>
                                </div>

                                <div>
                                    <div class="label">Identity Number</div>
                                    <input class="control readonly"
                                           value="${empty staff.identityNumber ? 'PENDING-ID' : staff.identityNumber}" readonly/>
                                    <div class="hint">Identity Number is read-only for verification security.</div>
                                </div>
                            </div>
                        </section>

                        <!-- 3. Account Information (readonly) -->
                        <!--        <section class="card">
                                  <div style="border-bottom:1px solid rgba(15,23,42,.08); padding-bottom:14px; margin-bottom:16px;">
                                    <h3 style="margin:0 0 6px;">3. Account Information</h3>
                                    <p style="margin:0; color:rgba(15,23,42,.65); font-size:13px;">Current system assignment and status.</p>
                                  </div>
                        
                                  <div class="grid-3" style="opacity:.85;">
                                    <div>
                                      <div class="label">User ID</div>
                                      <div class="control readonly" style="font-family:ui-monospace,Menlo,monospace;">${staff.userId}</div>
                                    </div>
                                    <div>
                                      <div class="label">Role</div>
                                      <div class="control readonly">${staff.roleName}</div>
                                    </div>
                                    <div>
                                      <div class="label">Status</div>
                                      <div class="control readonly">${staff.statusText}</div>
                                    </div>
                                  </div>
                        
                                 
                                </section>-->
                        <div class="actions">
                            <a class="btn" href="${pageContext.request.contextPath}/admin/staff/detail?id=${staff.userId}">Cancel</a>
                            <button class="btn btn-primary" type="submit">Save Changes</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </body>
</html>
