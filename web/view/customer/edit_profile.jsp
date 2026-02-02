<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <title>Edit Profile</title>

  <!-- Flatpickr (English by default) -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

  <style>
    :root{
      --bg:#f5f7fb;
      --card:#ffffff;
      --text:#111827;
      --muted:#6b7280;
      --muted2:#9ca3af;
      --line:#e9eef5;
      --shadow: 0 2px 14px rgba(16,24,40,.06);
      --radius:16px;
      --primary:#2563eb;
      --danger:#dc2626;
      --errbg:#fff1f2;
    }
    *{box-sizing:border-box}
    body{
      margin:0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
      background:var(--bg);
      color:var(--text);
    }
    .wrap{
      max-width: 980px;
      margin: 0 auto;
      padding: 20px 18px 24px;
    }
    .top{
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap: 12px;
      margin-bottom: 14px;
    }
    h1{
      margin:0;
      font-size: 26px;
      font-weight: 700;
      letter-spacing: -.2px;
    }
    .backBtn{
      display:inline-flex;
      align-items:center;
      gap: 8px;
      padding: 10px 14px;
      border-radius: 10px;
      background:#f1f5f9;
      color:#1f2937;
      text-decoration:none;
      font-size:14px;
      font-weight:600;
    }
    .backBtn:hover{background:#e5e7eb;}

    .grid{
      display:grid;
      grid-template-columns: 320px 1fr;
      gap: 18px;
      align-items:start;
    }
    .card{
      background:var(--card);
      border:1px solid var(--line);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
    }

    /* left mini profile */
    .left{
      padding: 16px;
      text-align:center;
    }
    .avatarWrap{position:relative;display:inline-block;margin: 4px 0 10px;}
    .avatar{
      width:92px;height:92px;border-radius:50%;
      background:#eef2ff;
      display:flex;align-items:center;justify-content:center;
      font-size:32px;font-weight:600;color:#1f2937;
    }
    .dot{
      position:absolute;right:8px;bottom:8px;
      width:12px;height:12px;border-radius:50%;
      background:#22c55e;border:3px solid #fff;
    }
    .name{margin: 6px 0 2px;font-size:16px;font-weight:700;}
    .email{margin:0;font-size:13px;color:var(--muted);word-break:break-word;}
    .roleBadge{
      display:inline-block;margin-top: 10px;padding: 6px 14px;border-radius:999px;
      background:#eef2ff;color:var(--primary);
      font-size:12px;font-weight:700;letter-spacing:.4px;text-transform:uppercase;
    }

    /* form */
    .sectionHead{
      padding: 14px 16px;
      border-bottom:1px solid var(--line);
      font-size: 15px;
      font-weight: 700;
    }
    .sectionBody{padding: 16px;}
    .row{
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px 18px;
      margin-bottom: 12px;
    }
    .field label{
      display:block;
      font-size:11px;
      color:var(--muted2);
      letter-spacing:.8px;
      text-transform:uppercase;
      font-weight:600;
      margin-bottom:6px;
    }
    .field input, .field select, .field textarea{
      width:100%;
      padding: 10px 12px;
      border-radius: 10px;
      border:1px solid var(--line);
      outline:none;
      font-size:14px;
      background:#fff;
    }
    .field input[disabled]{
      background:#f8fafc;
      color:#64748b;
      cursor:not-allowed;
    }
    .field textarea{min-height: 92px; resize: vertical;}

    .alert{
      padding:10px 12px;
      border-radius: 10px;
      margin-bottom: 12px;
      font-size: 14px;
      border:1px solid transparent;
    }
    .alert.err{background:var(--errbg); border-color:#fecdd3; color:#b42318;}

    .actions{
      display:flex;
      gap: 10px;
      justify-content:flex-end;
      margin-top: 8px;
    }
    .btn{
      display:inline-flex;
      align-items:center;
      gap:8px;
      padding: 10px 16px;
      border-radius: 10px;
      border:1px solid var(--line);
      background:#fff;
      font-weight:600;
      font-size:14px;
      cursor:pointer;
      text-decoration:none;
      color: var(--text);
    }
    .btn.primary{
      background: var(--primary);
      border-color: var(--primary);
      color:#fff;
    }
    .btn:hover{filter:brightness(.98);}

    @media (max-width: 980px){
      .grid{grid-template-columns:1fr;}
      .row{grid-template-columns:1fr;}
    }
  </style>
</head>

<body>
<div class="wrap">

  <div class="top">
    <h1>Edit Profile</h1>
    <a class="backBtn" href="${pageContext.request.contextPath}/customer/profile">← Back</a>
  </div>

  <div class="grid">
    <!-- LEFT mini profile -->
    <div class="card left">
      <div class="avatarWrap">
        <div class="avatar">${initials}</div>
        <span class="dot"></span>
      </div>

      <div class="name"><c:out value="${profile.fullName}" default="User"/></div>
      <p class="email"><c:out value="${profile.email}" default=""/></p>
      <div class="roleBadge"><c:out value="${profile.roleName}" default="CUSTOMER"/></div>
    </div>

    <!-- RIGHT form -->
    <div class="card">
      <div class="sectionHead">Update Information</div>
      <div class="sectionBody">

        <c:if test="${not empty error}">
          <div class="alert err">${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/customer/profile/edit">
          <div class="row">
            <div class="field">
              <label>Full Name</label>
              <input type="text" name="fullName"
                     value="<c:out value='${not empty form_fullName ? form_fullName : profile.fullName}'/>"
                     required />
            </div>

            <div class="field">
              <label>Email Address</label>
              <input type="text" value="<c:out value='${profile.email}'/>" disabled />
            </div>
          </div>

          <div class="row">
            <div class="field">
              <label>Gender</label>
              <c:set var="gVal" value="${not empty form_gender ? form_gender : profile.gender}" />
              <select name="gender">
                <option value="" <c:if test="${empty gVal}">selected</c:if>>—</option>
                <option value="1" <c:if test="${gVal == 1}">selected</c:if>>Male</option>
                <option value="2" <c:if test="${gVal == 2}">selected</c:if>>Female</option>
                <option value="3" <c:if test="${gVal == 3}">selected</c:if>>Other</option>
              </select>
            </div>

            <div class="field">
              <label>Date of Birth</label>

              <!-- Always output yyyy-MM-dd -->
              <c:set var="dobValue" value="${form_dob}" />
              <c:if test="${empty dobValue && not empty profile.dateOfBirth}">
                <fmt:formatDate value="${profile.dateOfBirth}" pattern="yyyy-MM-dd" var="dobValue"/>
              </c:if>

              <!-- Use text + Flatpickr to force English calendar -->
              <input type="text" id="dob" name="dateOfBirth"
                     value="${dobValue}"
                     placeholder="YYYY-MM-DD" />
            </div>
          </div>

          <div class="row">
            <div class="field">
              <label>Phone Number</label>
              <input type="text" name="phone"
                     value="<c:out value='${not empty form_phone ? form_phone : profile.phone}'/>" />
            </div>

            <div class="field">
              <label>Identity Number</label>
              <input type="text" value="<c:out value='${profile.identityNumber}'/>" disabled />
            </div>
          </div>

          <div class="field">
            <label>Street Address</label>
            <textarea name="residenceAddress"><c:out value="${not empty form_address ? form_address : profile.residenceAddress}"/></textarea>
          </div>

          <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/customer/profile">Cancel</a>
            <button class="btn primary" type="submit">Save Changes</button>
          </div>
        </form>

      </div>
    </div>
  </div>

</div>

<script>
  // English calendar by default (no locale import needed)
  flatpickr("#dob", {
    dateFormat: "Y-m-d",   // submit format: yyyy-MM-dd
    allowInput: true
  });
</script>

</body>
</html>
