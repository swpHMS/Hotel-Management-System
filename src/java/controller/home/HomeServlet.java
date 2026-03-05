package controller.home;

import dal.AmenityDAO;
import dal.HotelInformationDAO;
import dal.RoomTypeDAO;
import dal.RoomTypeImageDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.HotelInformation;

import java.io.IOException;
import java.time.LocalDate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private final HotelInformationDAO hotelRepo = new HotelInformationDAO();
    private final RoomTypeDAO roomTypeRepo = new RoomTypeDAO();
    private final AmenityDAO amenityRepo = new AmenityDAO();
    private final RoomTypeImageDAO roomTypeImageRepo = new RoomTypeImageDAO();
    private static final int DEFAULT_LIMIT = 8;

    private int parseIntOrDefault(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private int clamp(int n, int min, int max) {
        return Math.max(min, Math.min(max, n));
    }

    private LocalDate parseDateOrDefault(String s, LocalDate def) {
        try {
            return (s == null || s.isBlank()) ? def : LocalDate.parse(s);
        } catch (Exception e) {
            return def;
        }
    }

    private String normalize(String s) {
        return (s == null) ? "" : s.trim();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HotelInformation hotel = hotelRepo.getSingleHotel();
        req.setAttribute("hotel", hotel);

        var amenities = amenityRepo.getActiveAmenitiesForHome(6);
        req.setAttribute("amenities", amenities);

        LocalDate defaultIn = LocalDate.now();
        LocalDate defaultOut = LocalDate.now().plusDays(1);

        // ===== params =====
        String qStr = req.getParameter("q");
        String checkInStr = req.getParameter("checkIn");
        String checkOutStr = req.getParameter("checkOut");
        String roomQtyStr = req.getParameter("roomQty");
        String adultsStr = req.getParameter("adults");
        String childrenStr = req.getParameter("children");

        String q = normalize(qStr);

        LocalDate checkIn = parseDateOrDefault(checkInStr, defaultIn);
        LocalDate checkOut = parseDateOrDefault(checkOutStr, defaultOut);

        if (!checkOut.isAfter(checkIn)) {
            checkOut = checkIn.plusDays(1);
        }

        // guests + rooms
        int roomQty = clamp(parseIntOrDefault(roomQtyStr, 1), 1, 20);
        int adults = clamp(parseIntOrDefault(adultsStr, 2), 1, 30);
        int children = clamp(parseIntOrDefault(childrenStr, 0), 0, 15);

        // for JSP defaults
        req.setAttribute("defaultCheckIn", checkIn.toString());
        req.setAttribute("defaultCheckOut", checkOut.toString());

        req.setAttribute("roomQty", roomQty);
        req.setAttribute("adults", adults);
        req.setAttribute("children", children);
        req.setAttribute("q", q);

        // ✅ Tổng số room type active để JSP quyết định có hiện nút VIEW ALL không
        int totalRoomTypes = 0;
        try {
            totalRoomTypes = roomTypeRepo.countActiveRoomTypes();
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.setAttribute("totalRoomTypes", totalRoomTypes);

        // ✅ Search khi user bấm FIND ROOMS hoặc có bất kỳ param filter nào
        boolean isSearching =
                (qStr != null && !qStr.isBlank())
                || (checkInStr != null && !checkInStr.isBlank())
                || (checkOutStr != null && !checkOutStr.isBlank())
                || (roomQtyStr != null && !roomQtyStr.isBlank())
                || (adultsStr != null && !adultsStr.isBlank())
                || (childrenStr != null && !childrenStr.isBlank());

        List<model.RoomType> roomTypes;
        if (isSearching) {
            // ✅ NEW: lọc availability theo date range + capacity theo roomQty + keyword
            roomTypes = roomTypeRepo.searchForBooking(checkIn, checkOut, q, adults, children, roomQty, DEFAULT_LIMIT);
        } else {
            roomTypes = roomTypeRepo.getActiveRoomTypesForHome(DEFAULT_LIMIT);
        }

        // ✅ Map lưu nhiều ảnh cho từng room type
        Map<Integer, List<String>> imagesMap = new HashMap<>();

        if (roomTypes != null) {
            for (var rt : roomTypes) {

                rt.setAmenityNames(
                        amenityRepo.getAmenityNamesByRoomType(rt.getRoomTypeId())
                );

                try {
                    imagesMap.put(
                            rt.getRoomTypeId(),
                            roomTypeImageRepo.getImageUrlsByRoomTypeId(rt.getRoomTypeId())
                    );
                } catch (Exception ex) {
                    ex.printStackTrace();
                    imagesMap.put(rt.getRoomTypeId(), new ArrayList<>());
                }
            }
        }

        req.setAttribute("roomTypes", roomTypes);
        req.setAttribute("imagesMap", imagesMap);

        req.getRequestDispatcher("/view/home/home.jsp").forward(req, resp);
    }
}