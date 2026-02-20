<%-- 
    Document   : template_list
    Created on : Feb 18, 2026, 11:03:37 PM
    Author     : DieuBHHE191686
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <title>HMS Admin | Email Templates</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/app.css"/>

  <style>
    .wrap{ padding:28px; }
    .tabs{
      display:flex; gap:12px; background:#fff; border:1px solid #e2e8f0;
      padding:6px; border-radius:14px; width:fit-content;
      margin:14px 0 18px; box-shadow:0 2px 10px rgba(15,23,42,.05);
    }
    .tab{ padding:10px 18px; border-radius:12px; text-decoration:none; font-weight:800; color:#0f172a; }
    .tab:hover{ background:#f8fafc; }
    .tab.is-active{ background:#0b1b33; color:#fff; }

    .card{
      background:#fff; border:1px solid #e2e8f0; border-radius:16px;
      box-shadow:0 8px 24px rgba(15,23,42,.06);
      padding:18px;
      min-height:400px;
    }
  </style>
</head>
<body>

  <jsp:include page="/view/admin_layout/sidebar.jsp"/>

  <div class="wrap">
    <h1 style="margin:0;font-size:30px;font-weight:900;">System Configuration</h1>
    <div style="margin-top:6px;color:#64748b;">Configure legal frameworks and communication workflows.</div>

    <div class="tabs">
      <a class="tab" href="${pageContext.request.contextPath}/admin/policies">Terms &amp; Policies</a>
      <a class="tab is-active" href="${pageContext.request.contextPath}/admin/templates">Email Templates</a>
    </div>

    <div class="card">
      <h2 style="margin:0 0 8px;font-size:22px;font-weight:900;">Email Templates</h2>
      <div style="color:#64748b;">(Coming soon) - bạn sẽ làm phần templates ở bước tiếp theo.</div>
    </div>
  </div>

</body>
</html>

