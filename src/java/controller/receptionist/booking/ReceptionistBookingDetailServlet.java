package controller.receptionist.booking;

import dal.ReceptionistBookingDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.BookingSummary;
import model.AssignedRoomView;
import model.PaymentView;

@WebServlet(name = "ReceptionistBookingDetailServlet", urlPatterns = {"/receptionist/booking/detail"})
public class ReceptionistBookingDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("active", "booking_list");

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            ReceptionistBookingDetailDAO dao = new ReceptionistBookingDetailDAO();

            BookingSummary booking = dao.getBookingById(id);
            if (booking == null) {
                req.getSession().setAttribute("errorMsg", "Không tìm thấy thông tin Booking!");
                resp.sendRedirect(req.getContextPath() + "/receptionist/bookings");
                return;
            }

            List<AssignedRoomView> assignedRooms = dao.getAssignedRooms(id);
            List<PaymentView> payments = dao.getPaymentsByBooking(id);

            req.setAttribute("booking", booking);
            req.setAttribute("assignedRooms", assignedRooms);
            req.setAttribute("payments", payments);

            req.getRequestDispatcher("/view/receptionist/booking_detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMsg", "Có lỗi khi tải chi tiết booking!");
            resp.sendRedirect(req.getContextPath() + "/receptionist/bookings");
        }
    }
}