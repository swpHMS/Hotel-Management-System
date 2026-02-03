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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ===== 1) HOTEL =====
        HotelInformation hotel = hotelRepo.getSingleHotel();

        if (hotel == null) {
            System.out.println("[HOME] hotel = null (DAO không lấy được record hoặc connect sai DB)");
        } else {
            System.out.println("[HOME] hotelId=" + hotel.getHotelId());
            System.out.println("[HOME] name=" + hotel.getName());
            System.out.println("[HOME] address=" + hotel.getAddress());
            System.out.println("[HOME] phone=" + hotel.getPhone());
            System.out.println("[HOME] email=" + hotel.getEmail());
            System.out.println("[HOME] content=" + hotel.getContent());
            System.out.println("[HOME] checkIn=" + hotel.getCheckIn());
            System.out.println("[HOME] checkOut=" + hotel.getCheckOut());
        }

        req.setAttribute("hotel", hotel);

        // ===== 2) ROOM TYPES =====
        var roomTypes = roomTypeRepo.getActiveRoomTypesForHome(8);
        System.out.println("[HOME] roomTypes size = " + (roomTypes == null ? "null" : roomTypes.size()));
        req.setAttribute("roomTypes", roomTypes);

        // ===== 3) AMENITIES =====
        var amenities = amenityRepo.getActiveAmenitiesForHome(6);
        System.out.println("[HOME] amenities size = " + (amenities == null ? "null" : amenities.size()));
        req.setAttribute("amenities", amenities);

        // ===== 4) DEFAULT DATE =====
        req.setAttribute("defaultCheckIn", LocalDate.now().toString());
        req.setAttribute("defaultCheckOut", LocalDate.now().plusDays(1).toString());

        // ===== 5) FORWARD =====
        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }
}
