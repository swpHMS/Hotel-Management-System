package controller.receptionist.guestlist;

import dal.ReceptionistGuestListDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GuestList;

@WebServlet(name = "ReceptionistGuestListServlet", urlPatterns = {"/receptionist/guest-list"})
public class ReceptionistGuestListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ReceptionistGuestListDAO dao = new ReceptionistGuestListDAO();

        String keyword = request.getParameter("txtSearch");
        String status = request.getParameter("filterStatus");
        String checkInDate = request.getParameter("checkInDate");
        String checkOutDate = request.getParameter("checkOutDate");

        String pageIndexRaw = request.getParameter("index");
        String pageSizeRaw = request.getParameter("size");

        int index = 1;
        int size = 10;

        try {
            if (pageIndexRaw != null) {
                index = Integer.parseInt(pageIndexRaw);
            }
        } catch (Exception e) {
            index = 1;
        }

        try {
            if (pageSizeRaw != null) {
                size = Integer.parseInt(pageSizeRaw);
            }
        } catch (Exception e) {
            size = 10;
        }

        if (status == null || status.trim().isEmpty()) {
            status = "0";
        }

        String errorMessage = null;

        if (checkInDate != null && !checkInDate.isEmpty()
                && checkOutDate != null && !checkOutDate.isEmpty()) {
            try {
                LocalDate inDate = LocalDate.parse(checkInDate);
                LocalDate outDate = LocalDate.parse(checkOutDate);

                if (!outDate.isAfter(inDate)) {
                    errorMessage = "Check-out date must be greater than check-in date.";
                }
            } catch (Exception e) {
                errorMessage = "Invalid date format.";
            }
        }

        int totalRecords = 0;
        int endP = 1;
        List<GuestList> listGuests = new ArrayList<>();

        if (errorMessage == null) {
            totalRecords = dao.countGuestList(keyword, status, checkInDate, checkOutDate);
            endP = (int) Math.ceil((double) totalRecords / size);

            if (endP == 0) {
                endP = 1;
            }

            if (index < 1) {
                index = 1;
            }
            if (index > endP) {
                index = endP;
            }

            listGuests = dao.getGuestList(keyword, status, checkInDate, checkOutDate, index, size);
        }

        request.setAttribute("listGuests", listGuests);
        request.setAttribute("searchValue", keyword == null ? "" : keyword);
        request.setAttribute("statusValue", status);
        request.setAttribute("checkInDateValue", checkInDate == null ? "" : checkInDate);
        request.setAttribute("checkOutDateValue", checkOutDate == null ? "" : checkOutDate);

        request.setAttribute("tag", index);
        request.setAttribute("endP", endP);
        request.setAttribute("currentSize", size);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("errorMessage", errorMessage);

        request.getRequestDispatcher("/view/receptionist/guest_list.jsp").forward(request, response);
    }
}