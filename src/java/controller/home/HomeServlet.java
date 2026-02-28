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

    private LocalDate parseDateOrDefault(String s, LocalDate def) {
        try {
            return LocalDate.parse(s);
        } catch (Exception e) {
            return def;
        }
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

        String checkInStr = req.getParameter("checkIn");
        String checkOutStr = req.getParameter("checkOut");

        LocalDate checkIn = parseDateOrDefault(checkInStr, defaultIn);
        LocalDate checkOut = parseDateOrDefault(checkOutStr, defaultOut);

        if (!checkOut.isAfter(checkIn)) {
            checkOut = checkIn.plusDays(1);
        }

        req.setAttribute("defaultCheckIn", checkIn.toString());
        req.setAttribute("defaultCheckOut", checkOut.toString());
        String priceSort = req.getParameter("priceSort"); // asc | desc | null
        req.setAttribute("priceSort", priceSort);

        // ✅ Tổng số room type active để JSP quyết định có hiện nút VIEW ALL không
        int totalRoomTypes = 0;
        try {
            totalRoomTypes = roomTypeRepo.countActiveRoomTypes();
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.setAttribute("totalRoomTypes", totalRoomTypes);

        var roomTypes = roomTypeRepo.getActiveRoomTypesForHome(DEFAULT_LIMIT, priceSort);

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
