<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Manager | Create Room Entry</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700;9..144,800&family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root{
            --sidebar-width: 260px;
            --content-gap: 26px;
            --bg:#f5f0e8;
            --bg2:#ede7da;
            --paper:#faf7f2;
            --border:#e0d8cc;
            --ink:#2c2416;
            --ink-mid:#5a4e3c;
            --ink-soft:#9c8e7a;
            --gold:#b5832a;
            --gold-lt:#f0ddb8;
            --danger:#b84c3a;
            --danger-bg:#f8dfda;
            --success:#3d6b49;
            --success-bg:#dcebdc;
        }

        *{box-sizing:border-box;}

        html, body{
            margin:0;
            padding:0;
            background:var(--bg);
            font-family:'DM Sans', sans-serif;
            color:var(--ink);
        }

        .cre-content{
            margin-left: calc(var(--sidebar-width) + var(--content-gap));
            width: calc(100% - (var(--sidebar-width) + var(--content-gap)));
            min-height:100vh;
            padding:30px 24px 24px 0;
            background:var(--bg);
        }

        .cre-topbar{
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            gap:18px;
            margin-bottom:20px;
        }

        .cre-kicker{
            display:flex;
            align-items:center;
            gap:10px;
            margin-bottom:6px;
            font-size:12px;
            font-weight:800;
            letter-spacing:.16em;
            text-transform:uppercase;
            color:var(--gold);
        }

        .cre-kicker::before{
            content:"";
            width:18px;
            height:2px;
            border-radius:999px;
            background:var(--gold);
        }

        .cre-title{
            font-family:'Fraunces', serif;
            font-weight:800;
            letter-spacing:-1px;
            margin:0;
            font-size:38px;
        }

        .cre-subtitle{
            margin-top:10px;
            color:var(--ink-soft);
            font-size:14px;
        }

        .cre-back-btn{
            border:1.5px solid var(--border);
            background:var(--paper);
            color:var(--ink-mid);
            border-radius:14px;
            padding:12px 18px;
            font-weight:800;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            gap:8px;
        }

        .cre-back-btn:hover{
            background:var(--gold-lt);
            color:var(--gold);
        }

        .cre-card{
            background:var(--paper);
            border:1px solid var(--border);
            border-radius:22px;
            box-shadow:0 2px 16px rgba(44,36,22,.06);
            padding:24px;
        }

        .cre-mode-switch{
            display:flex;
            gap:12px;
            margin-bottom:22px;
            flex-wrap:wrap;
        }

        .cre-mode-btn{
            padding:11px 18px;
            border-radius:14px;
            border:1.5px solid var(--border);
            background:#fff;
            color:var(--ink-mid);
            font-weight:800;
            cursor:pointer;
        }

        .cre-mode-btn.active{
            background:var(--ink);
            color:#fff;
            border-color:var(--ink);
        }

        .cre-alert{
            border-radius:14px;
            padding:12px 14px;
            font-size:14px;
            font-weight:600;
            margin-bottom:18px;
        }

        .cre-alert.error{
            background:var(--danger-bg);
            color:var(--danger);
            border:1px solid #efc5bd;
        }

        .cre-alert.success{
            background:var(--success-bg);
            color:var(--success);
            border:1px solid #c7dfc9;
        }

        .cre-grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:18px 20px;
        }

        .cre-field{
            display:flex;
            flex-direction:column;
        }

        .cre-field.full{
            grid-column:1 / -1;
        }

        .cre-label{
            display:block;
            font-size:11px;
            font-weight:800;
            letter-spacing:.16em;
            text-transform:uppercase;
            color:var(--ink-soft);
            margin-bottom:8px;
        }

        .cre-input,
        .cre-select{
            width:100%;
            height:48px;
            padding:0 14px;
            border:1.5px solid var(--border);
            border-radius:14px;
            background:var(--bg);
            font-family:'DM Sans', sans-serif;
            font-size:14px;
            color:var(--ink);
            outline:none;
        }

        .cre-input:focus,
        .cre-select:focus{
            border-color:var(--gold);
            box-shadow:0 0 0 3px rgba(181,131,42,.12);
            background:var(--paper);
        }

        .cre-help{
            margin-top:7px;
            font-size:12px;
            color:var(--ink-soft);
        }

        .cre-actions{
            display:flex;
            justify-content:flex-end;
            gap:12px;
            margin-top:24px;
            padding-top:20px;
            border-top:1px solid var(--border);
        }

        .cre-btn{
            min-width:140px;
            height:46px;
            padding:0 18px;
            border-radius:14px;
            border:1.5px solid var(--border);
            background:var(--paper);
            color:var(--ink-mid);
            font-weight:800;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            gap:8px;
            text-decoration:none;
            cursor:pointer;
        }

        .cre-btn.primary{
            background:var(--ink);
            border-color:var(--ink);
            color:#fff;
        }

        .cre-btn.primary:hover{
            background:#241e14;
        }

        .cre-result-box{
            margin-top:16px;
            padding:16px;
            border-radius:14px;
            background:#f8f4ee;
            border:1px dashed #d7cbbb;
        }

        .cre-result-title{
            font-size:13px;
            font-weight:800;
            letter-spacing:.08em;
            text-transform:uppercase;
            color:var(--ink-mid);
            margin-bottom:10px;
        }

        .cre-chip-wrap{
            display:flex;
            flex-wrap:wrap;
            gap:8px;
        }

        .cre-chip{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            padding:6px 10px;
            border-radius:999px;
            font-size:12px;
            font-weight:700;
            background:#efe7d8;
            color:var(--ink-mid);
        }

        .cre-section{
            display:none;
        }

        .cre-section.active{
            display:block;
        }

        @media (max-width: 1100px){
            .cre-content{
                margin-left:0;
                width:100%;
                padding:20px 16px;
            }
        }

        @media (max-width: 768px){
            .cre-title{
                font-size:32px;
            }

            .cre-grid{
                grid-template-columns:1fr;
            }

            .cre-actions{
                flex-direction:column;
            }

            .cre-btn{
                width:100%;
            }

            .cre-topbar{
                flex-direction:column;
                align-items:stretch;
            }
        }
    </style>
</head>
<body>

    <%@include file="sidebar.jsp" %>

    <main class="cre-content">
        <div class="cre-topbar">
            <div>
                <div class="cre-kicker">Room Operations</div>
                <h1 class="cre-title">Create Room Entry</h1>
                <div class="cre-subtitle">
                    Create one room or generate multiple rooms at the same time.
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/manager/room-registry" class="cre-back-btn">
                <i class="bi bi-arrow-left"></i>
                Back to Registry
            </a>
        </div>

        <div class="cre-card">

            <c:set var="modeValue" value="${empty activeMode ? 'single' : activeMode}" />

            <div class="cre-mode-switch">
                <button type="button" id="singleBtn" class="cre-mode-btn">Single Room</button>
                <button type="button" id="bulkBtn" class="cre-mode-btn">Bulk Create</button>
            </div>

            <c:if test="${not empty errorList}">
                <div class="cre-alert error">
                    <ul class="mb-0">
                        <c:forEach var="err" items="${errorList}">
                            <li>${err}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="cre-alert success">${successMessage}</div>
            </c:if>

            <!-- SINGLE -->
            <div id="singleSection" class="cre-section">
                <form action="${pageContext.request.contextPath}/manager/room-registry/create" method="post">
                    <input type="hidden" name="mode" value="single">

                    <div class="cre-grid">
                        <div class="cre-field">
                            <label class="cre-label">Room Number</label>
                            <input type="text" name="roomNo" class="cre-input"
                                   placeholder="Ex: 101 or 1203"
                                   value="${param.roomNo}">
                            <div class="cre-help">Room number must be unique.</div>
                        </div>

                        <div class="cre-field">
                            <label class="cre-label">Room Type</label>
                            <select name="roomTypeId" class="cre-select">
                                <option value="">Select room type</option>
                                <c:forEach var="rt" items="${roomTypeList}">
                                    <option value="${rt.roomTypeId}" ${param.roomTypeId == rt.roomTypeId.toString() ? 'selected' : ''}>
                                        ${rt.roomTypeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="cre-field">
                            <label class="cre-label">Floor</label>
                            <input type="number" name="floor" class="cre-input"
                                   min="1" placeholder="Ex: 1"
                                   value="${param.floor}">
                        </div>

                        <div class="cre-field">
                            <label class="cre-label">Initial Status</label>
                            <select name="status" class="cre-select">
                                <option value="1" ${param.status == '1' ? 'selected' : ''}>Available</option>
                                <option value="2" ${param.status == '2' ? 'selected' : ''}>Occupied</option>
                                <option value="3" ${param.status == '3' ? 'selected' : ''}>Maintenance</option>
                                <option value="4" ${param.status == '4' ? 'selected' : ''}>Dirty</option>
                            </select>
                        </div>
                    </div>

                    <div class="cre-actions">
                        <a href="${pageContext.request.contextPath}/manager/room-registry" class="cre-btn">Cancel</a>
                        <button type="submit" class="cre-btn primary">
                            <i class="bi bi-plus-lg"></i>
                            Create Room
                        </button>
                    </div>
                </form>
            </div>

            <!-- BULK -->
            <div id="bulkSection" class="cre-section">
                <form action="${pageContext.request.contextPath}/manager/room-registry/create" method="post">
                    <input type="hidden" name="mode" value="bulk">

                    <div class="cre-grid">
                        <div class="cre-field">
                            <label class="cre-label">Room Type</label>
                            <select name="bulkRoomTypeId" class="cre-select">
                                <option value="">Select room type</option>
                                <c:forEach var="rt" items="${roomTypeList}">
                                    <option value="${rt.roomTypeId}" ${param.bulkRoomTypeId == rt.roomTypeId.toString() ? 'selected' : ''}>
                                        ${rt.roomTypeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="cre-field">
                            <label class="cre-label">Floor</label>
                            <input type="number" name="bulkFloor" class="cre-input"
                                   min="1" placeholder="Ex: 3"
                                   value="${param.bulkFloor}">
                        </div>

                        <div class="cre-field">
                            <label class="cre-label">Initial Status</label>
                            <select name="bulkStatus" class="cre-select">
                                <option value="1" ${param.bulkStatus == '1' ? 'selected' : ''}>Available</option>
                                <option value="2" ${param.bulkStatus == '2' ? 'selected' : ''}>Occupied</option>
                                <option value="3" ${param.bulkStatus == '3' ? 'selected' : ''}>Maintenance</option>
                                <option value="4" ${param.bulkStatus == '4' ? 'selected' : ''}>Dirty</option>
                            </select>
                        </div>

                        <div class="cre-field">
                            <label class="cre-label">Start Room No</label>
                            <input type="number" name="startRoomNo" class="cre-input"
                                   min="1" placeholder="Ex: 301"
                                   value="${param.startRoomNo}">
                        </div>

                        <div class="cre-field">
                            <label class="cre-label">End Room No</label>
                            <input type="number" name="endRoomNo" class="cre-input"
                                   min="1" placeholder="Ex: 320"
                                   value="${param.endRoomNo}">
                        </div>

                        <div class="cre-field full">
                            <div class="cre-help">
                                Example: start = 301, end = 305 → system creates 301, 302, 303, 304, 305.
                            </div>
                        </div>
                    </div>

                    <div class="cre-actions">
                        <a href="${pageContext.request.contextPath}/manager/room-registry" class="cre-btn">Cancel</a>
                        <button type="submit" class="cre-btn primary">
                            <i class="bi bi-layers"></i>
                            Create Rooms
                        </button>
                    </div>
                </form>

                <c:if test="${not empty createdRooms}">
                    <div class="cre-result-box">
                        <div class="cre-result-title">Created Rooms</div>
                        <div class="cre-chip-wrap">
                            <c:forEach var="r" items="${createdRooms}">
                                <span class="cre-chip">${r}</span>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty skippedRooms}">
                    <div class="cre-result-box">
                        <div class="cre-result-title">Skipped Rooms</div>
                        <div class="cre-chip-wrap">
                            <c:forEach var="r" items="${skippedRooms}">
                                <span class="cre-chip">${r}</span>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>

        </div>
    </main>

    <script>
        const modeValue = "${modeValue}";
        const singleBtn = document.getElementById("singleBtn");
        const bulkBtn = document.getElementById("bulkBtn");
        const singleSection = document.getElementById("singleSection");
        const bulkSection = document.getElementById("bulkSection");

        function showMode(mode) {
            if (mode === "bulk") {
                bulkBtn.classList.add("active");
                singleBtn.classList.remove("active");
                bulkSection.classList.add("active");
                singleSection.classList.remove("active");
            } else {
                singleBtn.classList.add("active");
                bulkBtn.classList.remove("active");
                singleSection.classList.add("active");
                bulkSection.classList.remove("active");
            }
        }

        singleBtn.addEventListener("click", function () {
            showMode("single");
        });

        bulkBtn.addEventListener("click", function () {
            showMode("bulk");
        });

        showMode(modeValue);
    </script>

</body>
</html>