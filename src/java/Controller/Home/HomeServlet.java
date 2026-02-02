package Controller.Home;

import dal.AmenityDAO;
import dal.HotelInformationDAO;
import dal.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

        req.setAttribute("hotel", hotelRepo.getSingleHotel());

        var roomTypes = roomTypeRepo.getActiveRoomTypesForHome(8);
        System.out.println("HOME roomTypes size = " +
                (roomTypes == null ? "null" : roomTypes.size()));
        req.setAttribute("roomTypes", roomTypes);

        req.setAttribute("amenities", amenityRepo.getActiveAmenitiesForHome(6));
        req.setAttribute("defaultCheckIn", LocalDate.now().toString());
        req.setAttribute("defaultCheckOut", LocalDate.now().plusDays(1).toString());

        // ===== DEBUG JSP PATH (BẮT BUỘC THÊM) =====
        System.out.println("CTX = " + req.getContextPath());
        System.out.println("RealPath(/) = " + getServletContext().getRealPath("/"));

        System.out.println("Exists /home.jsp ? "
                + (getServletContext().getResource("/home.jsp") != null));
        System.out.println("Exists /view/home/home.jsp ? "
                + (getServletContext().getResource("/view/home/home.jsp") != null));
        System.out.println("Exists /WEB-INF/view/home/home.jsp ? "
                + (getServletContext().getResource("/WEB-INF/view/home/home.jsp") != null));
        // =========================================

        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }
}
