<!DOCTYPE html>
<html>
<head>
    <title>Manager</title>
    <meta charset="UTF-8">

    <!-- Sidebar CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/sidebar-styles.css">

    <!-- Dashboard CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/dashboard-styles.css">

</head>
<body>

<div class="wrapper">

    <jsp:include page="sidebar.jsp"/>

    <div class="content">
        <jsp:include page="${contentPage}"/>
    </div>

</div>

</body>
</html>