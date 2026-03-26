<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="vp2">

    <!-- Nếu profile null -->
    <c:if test="${empty profile}">
        <div class="vp2-card">
            <div class="vp2-cardHead">Profile</div>
            <div class="vp2-fields vp2-fields--one">
                <div class="vp2-field">
                    <div class="vp2-label">Message</div>
                    <div class="vp2-value">Profile not found.</div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Nếu profile tồn tại -->
    <c:if test="${not empty profile}">

        <!-- Overview -->
        <div class="vp2-overview">
            <div class="vp2-left">
                <div class="vp2-avatar">
                    <c:out value="${initials}" default="U"/>
                </div>

                <div class="vp2-meta">
                    <div class="vp2-name">
                        <c:out value="${profile.fullName}" default="User"/>
                    </div>
                </div>
            </div>

            <div class="vp2-right">
                <div class="vp2-kpi">
                    <div class="vp2-kpiLabel">Role</div>
                    <div class="vp2-kpiValue">
                        <c:out value="${profile.roleName}" default="CUSTOMER"/>
                    </div>
                </div>

                <div class="vp2-kpi">
                    <div class="vp2-kpiLabel">Account Status</div>
                    <div class="vp2-kpiValue">
                        <c:choose>
                            <c:when test="${profile.userStatus == 1}">
                                <span class="vp2-pill">Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="vp2-pill vp2-pill--off">Inactive</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <a class="vp2-editBtn"
               href="${pageContext.request.contextPath}/customer/profile/edit">
                ✎ Edit Profile
            </a>

        </div>

        <!-- STACK: 2 cards vertical -->
        <div class="vp2-stack">

            <!-- Card 1: Personal Information -->
            <div class="vp2-card">
                <div class="vp2-cardHead">Personal Information</div>

                <div class="vp2-fields">

                    <div class="vp2-field">
                        <div class="vp2-label">Full Name</div>
                        <div class="vp2-value">
                            <c:out value="${profile.fullName}" default="—"/>
                        </div>
                    </div>

                    <div class="vp2-field">
                        <div class="vp2-label">Email Address</div>
                        <div class="vp2-value">
                            <c:out value="${profile.email}" default="—"/>
                        </div>
                    </div>

                    <div class="vp2-field">
                        <div class="vp2-label">Phone Number</div>
                        <div class="vp2-value">
                            <c:out value="${profile.phone}" default="—"/>
                        </div>
                    </div>

                    <div class="vp2-field">
                        <div class="vp2-label">Gender</div>
                        <div class="vp2-value">
                            <c:choose>
                                <c:when test="${profile.gender == 1}">Male</c:when>
                                <c:when test="${profile.gender == 2}">Female</c:when>
                                <c:when test="${profile.gender == 3}">Other</c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Format DOB -->
                    <div class="vp2-field">
                        <div class="vp2-label">Date of Birth</div>
                        <div class="vp2-value">
                            <c:choose>
                                <c:when test="${not empty profile.dateOfBirth}">
                                    <fmt:formatDate value="${profile.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Card 2: Address -->
            <div class="vp2-card">
                <div class="vp2-cardHead">Address</div>

                <div class="vp2-fields vp2-fields--one">
                    <div class="vp2-field">
                        <div class="vp2-label">Residence Address</div>
                        <div class="vp2-value">
                            <c:out value="${profile.residenceAddress}" default="—"/>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </c:if>
</div>
