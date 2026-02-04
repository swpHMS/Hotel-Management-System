package Controller.Home;

import dal.AmenityDAO;
import dal.HotelInformationDAO;
import dal.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.HotelInformation;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private final HotelInformationDAO hotelRepo = new HotelInformationDAO();
    private final RoomTypeDAO roomTypeRepo = new RoomTypeDAO();
    private final AmenityDAO amenityRepo = new AmenityDAO();

    private static final int MAX_ROOMS = 5;
    private static final int DEFAULT_LIMIT = 8;

    private int parseIntOrDefault(String s, int def){
        try { return Integer.parseInt(s); } catch(Exception e){ return def; }
    }

    private LocalDate parseDateOrDefault(String s, LocalDate def){
        try { return LocalDate.parse(s); } catch(Exception e){ return def; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HotelInformation hotel = hotelRepo.getSingleHotel();
        req.setAttribute("hotel", hotel);

        var amenities = amenityRepo.getActiveAmenitiesForHome(6);
        req.setAttribute("amenities", amenities);

        LocalDate defaultIn  = LocalDate.now();
        LocalDate defaultOut = LocalDate.now().plusDays(1);

        String checkInStr  = req.getParameter("checkIn");
        String checkOutStr = req.getParameter("checkOut");

        int rawRoomQty = parseIntOrDefault(req.getParameter("roomQty"), 1);
        int roomQty = rawRoomQty;

        if (roomQty < 1) roomQty = 1;
        if (roomQty > MAX_ROOMS) {
            roomQty = MAX_ROOMS;
            req.setAttribute("roomQtyError", "Maximum " + MAX_ROOMS + " rooms per search.");
        }

        LocalDate checkIn  = parseDateOrDefault(checkInStr, defaultIn);
        LocalDate checkOut = parseDateOrDefault(checkOutStr, defaultOut);

        if (!checkOut.isAfter(checkIn)) {
            checkOut = checkIn.plusDays(1);
        }

        req.setAttribute("defaultCheckIn", checkIn.toString());
        req.setAttribute("defaultCheckOut", checkOut.toString());
        req.setAttribute("roomQty", roomQty);
        req.setAttribute("maxRooms", MAX_ROOMS);

        var roomTypes = roomTypeRepo.getActiveRoomTypesForHome(DEFAULT_LIMIT);

        if (roomTypes != null) {
            for (var rt : roomTypes) {
                rt.setAmenityNames(
                        amenityRepo.getAmenityNamesByRoomType(rt.getRoomTypeId())
                );
            }
        }

        req.setAttribute("roomTypes", roomTypes);

        // (Optional) Nếu bạn vẫn muốn dùng search kết quả ở chỗ khác:
        // boolean isSearching = (checkInStr != null || checkOutStr != null || req.getParameter("roomQty") != null);
        // if (isSearching) {
        //     var searchResults = roomTypeRepo.searchByRoomQty(checkIn, checkOut, roomQty, DEFAULT_LIMIT);
        //     req.setAttribute("searchResults", searchResults);
        // }

        req.getRequestDispatcher("/view/home/home.jsp").forward(req, resp);
    }
}
