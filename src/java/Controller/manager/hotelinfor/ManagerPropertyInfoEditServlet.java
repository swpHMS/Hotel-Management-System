package controller.manager.hotelinfor;

import dal.HotelInformationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.HotelInformation;

@WebServlet(name = "ManagerPropertyInfoEditServlet", urlPatterns = {"/manager/property-info/edit"})
public class ManagerPropertyInfoEditServlet extends HttpServlet {

    private final HotelInformationDAO hotelDAO = new HotelInformationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HotelInformation hotel = hotelDAO.getHotelInformation();

        if (hotel == null) {
            request.setAttribute("mode", "create");
        } else {
            request.setAttribute("mode", "update");
            request.setAttribute("hotel", hotel);
        }

        request.getRequestDispatcher("/view/manager/property-info-form.jsp").forward(request, response);
    }
}