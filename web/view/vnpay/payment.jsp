<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>VNPay Payment</title>
</head>
<body>
  <h2>Demo Thanh toán VNPay</h2>

  <form method="get" action="${pageContext.request.contextPath}/vnpay-create">
    <label>Số tiền (VND): </label>
    <input type="number" name="amount" value="100000" min="1000" required />
    <button type="submit">Thanh toán</button>
  </form>

</body>
</html>