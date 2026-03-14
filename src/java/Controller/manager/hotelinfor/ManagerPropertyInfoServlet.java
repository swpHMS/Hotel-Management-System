package controller.manager.hotelinfor;

import dal.HotelInformationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.HotelInformation;

@WebServlet(name = "ManagerPropertyInfoServlet", urlPatterns = {"/manager/property-info"})
public class ManagerPropertyInfoServlet extends HttpServlet {

    private final HotelInformationDAO hotelDAO = new HotelInformationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HotelInformation hotel = hotelDAO.getHotelInformation();

        if (hotel == null) {
            request.setAttribute("mode", "create");
            request.getRequestDispatcher("/view/manager/property-info-form.jsp").forward(request, response);
            return;
        }

        request.setAttribute("hotel", hotel);
        request.getRequestDispatcher("/view/manager/property-info.jsp").forward(request, response);
    }
}