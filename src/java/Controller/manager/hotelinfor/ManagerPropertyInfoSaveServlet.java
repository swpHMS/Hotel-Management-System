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
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
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

        java.util.Map<String, String> errors = new java.util.HashMap<>();

        if (name.isEmpty()) {
            errors.put("name", "Property name không được để trống.");
        } else if (name.length() < 2 || name.length() > 100) {
            errors.put("name", "Property name phải từ 2 đến 100 ký tự.");
        }

        if (content.isEmpty()) {
            errors.put("content", "Brand introduction không được để trống.");
        } else if (content.length() < 10 || content.length() > 500) {
            errors.put("content", "Brand introduction phải từ 10 đến 500 ký tự.");
        }

        if (address.isEmpty()) {
            errors.put("address", "Official address không được để trống.");
        } else if (address.length() < 10 || address.length() > 255) {
            errors.put("address", "Official address phải từ 10 đến 255 ký tự.");
        }

        if (phone.isEmpty()) {
            errors.put("phone", "Primary hotline không được để trống.");
        } else if (!phone.matches("^\\+?[0-9\\s-]{10,20}$")) {
            errors.put("phone", "Primary hotline không đúng định dạng.");
        }

        if (email.isEmpty()) {
            errors.put("email", "Official email không được để trống.");
        } else if (!isValidEmail(email)) {
            errors.put("email", "Official email không đúng định dạng.");
        }

        if (checkInTimeRaw.isEmpty()) {
            errors.put("checkInTime", "Check-in time không được để trống.");
        }

        if (checkOutTimeRaw.isEmpty()) {
            errors.put("checkOutTime", "Check-out time không được để trống.");
        }

        HotelInformation hotel = new HotelInformation();
        hotel.setName(name);
        hotel.setAddress(address);
        hotel.setPhone(phone);
        hotel.setEmail(email);
        hotel.setContent(content);

        if (!checkInTimeRaw.isEmpty()) {
            try {
                hotel.setCheckIn(java.time.LocalTime.parse(checkInTimeRaw));
            } catch (Exception e) {
                errors.put("checkInTime", "Định dạng check-in time không hợp lệ.");
            }
        }

        if (!checkOutTimeRaw.isEmpty()) {
            try {
                hotel.setCheckOut(java.time.LocalTime.parse(checkOutTimeRaw));
            } catch (Exception e) {
                errors.put("checkOutTime", "Định dạng check-out time không hợp lệ.");
            }
        }

        if (!hotelIdRaw.isEmpty()) {
            try {
                hotel.setHotelId(Integer.parseInt(hotelIdRaw));
            } catch (NumberFormatException e) {
                errors.put("hotelId", "Hotel ID không hợp lệ.");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
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
