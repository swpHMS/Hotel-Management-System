<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Manager | Update Room Entry</title>
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

        .upd-content{
            margin-left: calc(var(--sidebar-width) + var(--content-gap));
            width: calc(100% - (var(--sidebar-width) + var(--content-gap)));
            min-height:100vh;
            padding:30px 24px 24px 0;
            background:var(--bg);
        }

        .upd-topbar{
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            gap:18px;
            margin-bottom:20px;
        }

        .upd-kicker{
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

        .upd-kicker::before{
            content:"";
            width:18px;
            height:2px;
            border-radius:999px;
            background:var(--gold);
        }

        .upd-title{
            font-family:'Fraunces', serif;
            font-weight:800;
            letter-spacing:-1px;
            margin:0;
            font-size:38px;
        }

        .upd-subtitle{
            margin-top:10px;
            color:var(--ink-soft);
            font-size:14px;
        }

        .upd-back-btn{
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

        .upd-back-btn:hover{
            background:var(--gold-lt);
            color:var(--gold);
        }

        .upd-card{
            background:var(--paper);
            border:1px solid var(--border);
            border-radius:22px;
            box-shadow:0 2px 16px rgba(44,36,22,.06);
            padding:24px;
        }

        .upd-alert{
            border-radius:14px;
            padding:12px 14px;
            font-size:14px;
            font-weight:600;
            margin-bottom:18px;
        }

        .upd-alert.error{
            background:var(--danger-bg);
            color:var(--danger);
            border:1px solid #efc5bd;
        }

        .upd-grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:18px 20px;
        }

        .upd-field{
            display:flex;
            flex-direction:column;
        }

        .upd-label{
            display:block;
            font-size:11px;
            font-weight:800;
            letter-spacing:.16em;
            text-transform:uppercase;
            color:var(--ink-soft);
            margin-bottom:8px;
        }

        .upd-input,
        .upd-select{
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

        .upd-input:focus,
        .upd-select:focus{
            border-color:var(--gold);
            box-shadow:0 0 0 3px rgba(181,131,42,.12);
            background:var(--paper);
        }

        .upd-help{
            margin-top:7px;
            font-size:12px;
            color:var(--ink-soft);
        }

        .upd-actions{
            display:flex;
            justify-content:flex-end;
            gap:12px;
            margin-top:24px;
            padding-top:20px;
            border-top:1px solid var(--border);
        }

        .upd-btn{
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

        .upd-btn.primary{
            background:var(--ink);
            border-color:var(--ink);
            color:#fff;
        }

        .upd-btn.primary:hover{
            background:#241e14;
        }

        @media (max-width: 1100px){
            .upd-content{
                margin-left:0;
                width:100%;
                padding:20px 16px;
            }
        }

        @media (max-width: 768px){
            .upd-title{
                font-size:32px;
            }

            .upd-grid{
                grid-template-columns:1fr;
            }

            .upd-actions{
                flex-direction:column;
            }

            .upd-btn{
                width:100%;
            }

            .upd-topbar{
                flex-direction:column;
                align-items:stretch;
            }
        }
    </style>
</head>
<body>

    <%@include file="sidebar.jsp" %>

    <main class="upd-content">
        <div class="upd-topbar">
            <div>
                <div class="upd-kicker">Room Operations</div>
                <h1 class="upd-title">Update Room Entry</h1>
                <div class="upd-subtitle">
                    Update room information for this room entry.
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/manager/room-registry" class="upd-back-btn">
                <i class="bi bi-arrow-left"></i>
                Back to Registry
            </a>
        </div>

        <div class="upd-card">

            <c:if test="${not empty errorList}">
                <div class="upd-alert error">
                    <ul class="mb-0">
                        <c:forEach var="err" items="${errorList}">
                            <li>${err}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/manager/room-registry/update" method="post">
                <input type="hidden" name="roomId" value="${room.roomId}">

                <div class="upd-grid">
                    <div class="upd-field">
                        <label class="upd-label">Room Number</label>
                        <input type="text" name="roomNo" class="upd-input"
                               placeholder="Ex: 101 or 1203"
                               value="${room.roomNo}">
                        <div class="upd-help">Room number must be unique.</div>
                    </div>

                    <div class="upd-field">
                        <label class="upd-label">Room Type</label>
                        <select name="roomTypeId" class="upd-select">
                            <option value="">Select room type</option>
                            <c:forEach var="rt" items="${roomTypeList}">
                                <option value="${rt.roomTypeId}"
                                    ${room.roomTypeId == rt.roomTypeId ? 'selected' : ''}>
                                    ${rt.roomTypeName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="upd-field">
                        <label class="upd-label">Floor</label>
                        <input type="number" name="floor" class="upd-input"
                               min="1" placeholder="Ex: 1"
                               value="${room.floor}">
                    </div>

                    <div class="upd-field">
                        <label class="upd-label">Status</label>
                        <select name="status" class="upd-select">
                            <option value="1" ${room.status == 1 ? 'selected' : ''}>Available</option>
                            <option value="2" ${room.status == 2 ? 'selected' : ''}>Occupied</option>
                            <option value="3" ${room.status == 3 ? 'selected' : ''}>Maintenance</option>
                            <option value="4" ${room.status == 4 ? 'selected' : ''}>Dirty</option>
                        </select>
                    </div>
                </div>

                <div class="upd-actions">
                    <a href="${pageContext.request.contextPath}/manager/room-registry" class="upd-btn">Cancel</a>
                    <button type="submit" class="upd-btn primary">
                        <i class="bi bi-pencil-square"></i>
                        Save Changes
                    </button>
                </div>
            </form>
        </div>
    </main>

</body>
</html>