package controller.manager.hotelinfor;

import dal.HotelInformationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Time;
import model.HotelInformation;

@WebServlet(name = "ManagerPropertyInfoSaveServlet", urlPatterns = {"/manager/property-info/save"})
public class ManagerPropertyInfoSaveServlet extends HttpServlet {

    private final HotelInformationDAO hotelDAO = new HotelInformationDAO();

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String hotelIdRaw = trim(request.getParameter("hotelId"));
        String name = trim(request.getParameter("name"));
        String address = trim(request.getParameter("address"));
        String phone = trim(request.getParameter("phone"));
        String email = trim(request.getParameter("email"));
        String checkInTimeRaw = trim(request.getParameter("checkInTime"));
        String checkOutTimeRaw = trim(request.getParameter("checkOutTime"));
        String content = trim(request.getParameter("content"));

        String error = null;

        if (name.isEmpty()) {
            error = "Property name không được để trống.";
        } else if (address.isEmpty()) {
            error = "Address không được để trống.";
        } else if (phone.isEmpty()) {
            error = "Phone không được để trống.";
        } else if (email.isEmpty()) {
            error = "Email không được để trống.";
        } else if (!isValidEmail(email)) {
            error = "Email không đúng định dạng.";
        } else if (checkInTimeRaw.isEmpty()) {
            error = "Check-in time không được để trống.";
        } else if (checkOutTimeRaw.isEmpty()) {
            error = "Check-out time không được để trống.";
        } else if (content.isEmpty()) {
            error = "Content không được để trống.";
        }

        HotelInformation hotel = new HotelInformation();
        hotel.setName(name);
        hotel.setAddress(address);
        hotel.setPhone(phone);
        hotel.setEmail(email);
        hotel.setContent(content);

try {
    hotel.setCheckIn(java.time.LocalTime.parse(checkInTimeRaw));
    hotel.setCheckOut(java.time.LocalTime.parse(checkOutTimeRaw));
} catch (Exception e) {
    error = "Định dạng thời gian không hợp lệ.";
}

        if (!hotelIdRaw.isEmpty()) {
            try {
                hotel.setHotelId(Integer.parseInt(hotelIdRaw));
            } catch (NumberFormatException e) {
                error = "Hotel ID không hợp lệ.";
            }
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("hotel", hotel);
            request.setAttribute("mode", hotelIdRaw.isEmpty() ? "create" : "update");
            request.getRequestDispatcher("/view/manager/property-info-form.jsp").forward(request, response);
            return;
        }

        boolean success;
        if (hotelDAO.existsHotelInformation()) {
            if (hotel.getHotelId() == 0) {
                HotelInformation existing = hotelDAO.getHotelInformation();
                if (existing != null) {
                    hotel.setHotelId(existing.getHotelId());
                }
            }
            success = hotelDAO.updateHotelInformation(hotel);
        } else {
            success = hotelDAO.insertHotelInformation(hotel);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/manager/property-info?success=1");
        } else {
            request.setAttribute("error", "Lưu hotel information thất bại.");
            request.setAttribute("hotel", hotel);
            request.setAttribute("mode", hotelIdRaw.isEmpty() ? "create" : "update");
            request.getRequestDispatcher("/view/manager/property-info-form.jsp").forward(request, response);
        }
    }
}