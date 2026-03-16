<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Room Operations</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/staff/app.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/admin/sidebar-styles.css"/>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/staff/dashboard-styles.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/staff/room.css">
    </head>

    <body>

        <c:set var="currentPage" value="roomops" scope="request"/>

        <jsp:include page="/view/staff/sidebar_staff/sidebar_staff.jsp"/>

        <div class="hms-main">
            <div class="page">

                <div class="page-title">
                    Room Operations
                </div>

                <div class="toolbar">

                    <div class="tabs">
                        <a class="tab ${empty selectedStatus || selectedStatus == 'all' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/staff/room-operations?status=all&pageSize=${pageSize}&keyword=${keyword}">
                            All
                        </a>

                        <a class="tab ${selectedStatus == '1' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/staff/room-operations?status=1&pageSize=${pageSize}&keyword=${keyword}">
                            Available
                        </a>

                        <a class="tab ${selectedStatus == '2' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/staff/room-operations?status=2&pageSize=${pageSize}&keyword=${keyword}">
                            Occupied
                        </a>

                        <a class="tab ${selectedStatus == '4' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/staff/room-operations?status=4&pageSize=${pageSize}&keyword=${keyword}">
                            Needs Cleaning
                        </a>

                        <a class="tab ${selectedStatus == '3' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/staff/room-operations?status=3&pageSize=${pageSize}&keyword=${keyword}">
                            Under Maintenance
                        </a>
                    </div>

                    <form class="search-form"
                          method="get"
                          action="${pageContext.request.contextPath}/staff/room-operations">

                        <input type="hidden" name="status" value="${selectedStatus}">
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="pageSize" value="${pageSize}">

                        <input type="text"
                               name="keyword"
                               value="${keyword}"
                               placeholder="Search room number...">

                        <button class="btn btn-update" type="submit">
                            Search
                        </button>
                    </form>

                </div>

                <div class="cards">
                    <div class="stat-card card-danger">
                        <div class="stat-label">Needs Attention</div>
                        <div class="stat-number">${dirtyCount}</div>
                        <div class="stat-text">Dirty Rooms Total</div>
                    </div>

                    <div class="stat-card card-blue">
                        <div class="stat-label">In Progress</div>
                        <div class="stat-number">${inProgressCount}</div>
                        <div class="stat-text">Active Housekeeping</div>
                    </div>

                    <div class="stat-card card-navy">
                        <div class="stat-label">Ready For Guest</div>
                        <div class="stat-number">${availableCount}</div>
                        <div class="stat-text">Available Inventory</div>
                    </div>
                </div>

                <div class="table-wrap">

                    <table>
                        <thead>
                            <tr>
                                <th>Room</th>
                                <th>Room Type</th>
                                <th>Status</th>
                                <th style="text-align:right;">Actions</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="r" items="${rooms}">
                                <tr>
                                    <td>
                                        <div class="room-no">${r.roomNo}</div>

                                        <c:if test="${cleaningRooms.contains(r.roomId)}">
                                            <div class="cleaning-text">• CLEANING...</div>
                                        </c:if>
                                    </td>

                                    <td>${r.roomTypeName}</td>

                                    <td>
                                        <span class="badge status-${r.status}">
                                            ${r.statusText}
                                        </span>
                                    </td>

                                    <td>
                                        <div class="action-group">

                                            <c:if test="${r.status == 4 && !cleaningRooms.contains(r.roomId)}">
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/staff/room-operations/start"
                                                      style="margin:0;">
                                                    <input type="hidden" name="roomId" value="${r.roomId}">
                                                    <input type="hidden" name="status" value="${selectedStatus}">
                                                    <input type="hidden" name="keyword" value="${keyword}">
                                                    <input type="hidden" name="page" value="${page}">
                                                    <input type="hidden" name="pageSize" value="${pageSize}">
                                                    <button type="submit" class="btn btn-start">▶ Start</button>
                                                </form>
                                            </c:if>

                                            <button type="button"
                                                    class="btn btn-update"
                                                    onclick="openUpdateModal('${r.roomId}', '${r.roomNo}', '${r.statusText}')">
                                                Update
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty rooms}">
                                <tr>
                                    <td colspan="5" style="text-align:center;">
                                        No rooms found.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>

                    <div class="table-pagination">

                        <form method="get"
                              action="${pageContext.request.contextPath}/staff/room-operations"
                              class="page-size-form">

                            <input type="hidden" name="keyword" value="${keyword}">
                            <input type="hidden" name="status" value="${selectedStatus}">
                            <input type="hidden" name="page" value="1">

                            <span>Show</span>

                            <select name="pageSize" onchange="this.form.submit()">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            </select>

                            <span>rooms per page</span>
                        </form>

                        <div class="page-nav">
                            <span class="page-info">Page ${page} of ${totalPages}</span>

                            <c:if test="${page > 1}">
                                <a class="page-btn"
                                   href="${pageContext.request.contextPath}/staff/room-operations?page=${page - 1}&pageSize=${pageSize}&keyword=${keyword}&status=${selectedStatus}">
                                    Prev
                                </a>
                            </c:if>

                            <c:if test="${page < totalPages}">
                                <a class="page-btn"
                                   href="${pageContext.request.contextPath}/staff/room-operations?page=${page + 1}&pageSize=${pageSize}&keyword=${keyword}&status=${selectedStatus}">
                                    Next
                                </a>
                            </c:if>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="overlay" id="updateModal">
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-title">Update Room Status</div>
                    <button class="close-btn" type="button" id="closeModalBtn">&times;</button>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/staff/room-operations/update">
                    <div class="modal-body">
                        <input type="hidden" name="roomId" id="modalRoomId">
                        <input type="hidden" name="newStatus" id="modalNewStatus" value="1">

                        <div class="current-box">
                            <div class="room-chip" id="modalRoomNo">202</div>
                            <div>
                                <div class="current-label">Current Status</div>
                                <div class="current-value" id="modalCurrentStatus">AVAILABLE</div>
                            </div>
                        </div>

                        <div class="section-label">Choose New Status</div>

                        <div class="choice-grid">
                            <div class="choice active available" data-status="1">
                                <div class="choice-icon">✓</div>
                                <div class="choice-title">Available</div>
                                <div class="choice-sub">Ready for guest</div>
                            </div>

                            <div class="choice maintenance" data-status="3">
                                <div class="choice-icon">🔧</div>
                                <div class="choice-title">Maintenance</div>
                                <div class="choice-sub">Blocked for repair</div>
                            </div>
                        </div>

                        <div class="modal-actions">
                            <button type="button" class="btn btn-light" id="cancelModalBtn">Cancel</button>
                            <button type="submit" class="btn btn-confirm">Confirm Update</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openUpdateModal(roomId, roomNo, currentStatusText) {
                const updateModal = document.getElementById("updateModal");
                const modalRoomId = document.getElementById("modalRoomId");
                const modalRoomNo = document.getElementById("modalRoomNo");
                const modalCurrentStatus = document.getElementById("modalCurrentStatus");
                const modalNewStatus = document.getElementById("modalNewStatus");
                const choices = document.querySelectorAll(".choice");

                if (!updateModal || !modalRoomId || !modalRoomNo || !modalCurrentStatus || !modalNewStatus) {
                    alert("Modal not found");
                    return;
                }

                modalRoomId.value = roomId;
                modalRoomNo.textContent = roomNo;
                modalCurrentStatus.textContent = currentStatusText;
                modalNewStatus.value = "1";

                choices.forEach(function (c) {
                    c.classList.remove("active");
                });

                if (choices.length > 0) {
                    choices[0].classList.add("active");
                }

                updateModal.classList.add("show");
            }

            function closeUpdateModal() {
                const updateModal = document.getElementById("updateModal");
                if (updateModal) {
                    updateModal.classList.remove("show");
                }
            }

            document.addEventListener("DOMContentLoaded", function () {
                const closeModalBtn = document.getElementById("closeModalBtn");
                const cancelModalBtn = document.getElementById("cancelModalBtn");
                const updateModal = document.getElementById("updateModal");
                const modalNewStatus = document.getElementById("modalNewStatus");
                const choices = document.querySelectorAll(".choice");

                if (closeModalBtn) {
                    closeModalBtn.addEventListener("click", closeUpdateModal);
                }

                if (cancelModalBtn) {
                    cancelModalBtn.addEventListener("click", closeUpdateModal);
                }

                if (updateModal) {
                    updateModal.addEventListener("click", function (e) {
                        if (e.target === updateModal) {
                            closeUpdateModal();
                        }
                    });
                }

                choices.forEach(function (choice) {
                    choice.addEventListener("click", function () {
                        choices.forEach(function (c) {
                            c.classList.remove("active");
                        });

                        this.classList.add("active");
                        if (modalNewStatus) {
                            modalNewStatus.value = this.dataset.status;
                        }
                    });
                });
            });
        </script>

    </body>
</html>