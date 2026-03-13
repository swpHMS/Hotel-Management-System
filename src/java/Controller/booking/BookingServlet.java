package controller.booking;

import dal.AmenityDAO;
import dal.HotelInformationDAO;
import dal.RoomTypeDAO;
import dal.RoomTypeImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import model.HotelInformation;

import model.RoomType;
import model.RoomTypeImage;

@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private LocalDate parseDateOrNull(String s) {
        try {
            return (s == null || s.isBlank()) ? null : LocalDate.parse(s);
        } catch (Exception e) {
            return null;
        }
    }

    private int clamp(int n, int min, int max) {
        return Math.max(min, Math.min(max, n));
    }

    private String normalize(String s) {
        return (s == null) ? "" : s.trim();
    }

    private Integer parseIntegerOrNull(String s) {
        try {
            return (s == null || s.isBlank()) ? null : Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private void moveSelectedRoomTypeToTop(List<RoomType> roomTypes, Integer selectedRoomTypeId) {
        if (roomTypes == null || roomTypes.isEmpty() || selectedRoomTypeId == null) {
            return;
        }

        RoomType selected = null;
        for (RoomType rt : roomTypes) {
            if (rt != null && rt.getRoomTypeId() == selectedRoomTypeId) {
                selected = rt;
                break;
            }
        }

        if (selected != null) {
            roomTypes.remove(selected);
            roomTypes.add(0, selected);
        }
    }

    private void process(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
HotelInformationDAO hotelDao = new HotelInformationDAO();
HotelInformation hotel = hotelDao.getSingleHotel();
request.setAttribute("hotel", hotel);
        String q = normalize(request.getParameter("q"));
        Integer selectedRoomTypeId = parseIntegerOrNull(request.getParameter("roomTypeId"));

        // THÊM SORT
        String sort = normalize(request.getParameter("sort"));
        if (!sort.equals("priceAsc") && !sort.equals("priceDesc")) {
            sort = "";
        }

        LocalDate today = LocalDate.now();
        LocalDate checkIn = parseDateOrNull(request.getParameter("checkIn"));
        LocalDate checkOut = parseDateOrNull(request.getParameter("checkOut"));

        int adults = clamp(parseIntOrDefault(request.getParameter("adults"), 2), 1, 30);
        int children = clamp(parseIntOrDefault(request.getParameter("children"), 0), 0, 15);
        int roomQty = clamp(parseIntOrDefault(request.getParameter("roomQty"), 1), 1, 20);

        if (checkIn == null) {
            checkIn = today;
        }
        if (checkOut == null) {
            checkOut = checkIn.plusDays(1);
        }

        if (!checkOut.isAfter(checkIn)) {
            checkOut = checkIn.plusDays(1);
        }

        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
        RoomTypeImageDAO imageDAO = new RoomTypeImageDAO();
        AmenityDAO amenityDAO = new AmenityDAO();

        // SỬA DÒNG NÀY: truyền sort xuống DAO
        List<RoomType> roomTypes = roomTypeDAO.searchForBooking(
                checkIn, checkOut, q, adults, children, roomQty, sort
        );

        System.out.println("[BOOKING] checkIn=" + checkIn
                + ", checkOut=" + checkOut
                + ", adults=" + adults
                + ", children=" + children
                + ", roomQty=" + roomQty
                + ", q=" + q
                + ", sort=" + sort
                + ", roomTypeId=" + selectedRoomTypeId
                + ", results=" + (roomTypes == null ? 0 : roomTypes.size()));

        if (roomTypes != null) {
            for (RoomType rt : roomTypes) {
                try {
                    List<RoomTypeImage> images = imageDAO.getImagesByRoomTypeId(rt.getRoomTypeId());
                    rt.setImages(images);
                } catch (Exception e) {
                    e.printStackTrace();
                    rt.setImages(null);
                }

                List<String> names = amenityDAO.getAmenityNamesByRoomType(rt.getRoomTypeId());
                rt.setAmenityNames(names);
            }
        }

        // Đưa room user vừa chọn từ Home lên đầu danh sách
       if (sort.isBlank()) {
    moveSelectedRoomTypeToTop(roomTypes, selectedRoomTypeId);
}
        request.setAttribute("checkIn", checkIn.toString());
        request.setAttribute("checkOut", checkOut.toString());
        request.setAttribute("adults", adults);
        request.setAttribute("children", children);
        request.setAttribute("roomQty", roomQty);
        request.setAttribute("q", q);
        request.setAttribute("sort", sort); // THÊM
        request.setAttribute("selectedRoomTypeId", selectedRoomTypeId);
        request.setAttribute("roomTypes", roomTypes);

        request.getRequestDispatcher("/view/booking/booking.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }
}