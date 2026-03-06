<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1"/>

        <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Manager Panel" %></title>

        <!-- ✅ Bootstrap CSS (bạn đang dùng row/col/d-flex nên bắt buộc) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- ✅ Sidebar CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar-styles.css"/>

        <!-- ✅ Dashboard CSS (CHÍNH là file bạn gửi) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard-styles.css"/>
    </head>
    <body>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard-styles.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar-styles.css"/>

        <!-- Sidebar manager -->
        <jsp:include page="/view/manager/sidebar.jsp"/>

        <!-- ✅ MAIN: class hms-main để áp margin-left 260px -->
        <main class="hms-main">
            <jsp:include page="<%= (String) request.getAttribute(\"contentPage\") %>"/>
        </main>

        <!-- Bootstrap JS (optional) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>