package controller.home;

import dal.HotelInformationDAO;
import dal.PolicyRuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.HotelInformation;
import model.PolicyRule;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PolicyServlet", urlPatterns = {"/policy"})
public class PolicyServlet extends HttpServlet {

    private final PolicyRuleDAO policyDao = new PolicyRuleDAO();
    private final HotelInformationDAO hotelRepo = new HotelInformationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ✅ để menu active
            request.setAttribute("active", "policy");

            // ✅ load hotel info cho header/footer (đây là cái bạn thiếu)
            HotelInformation hotel = hotelRepo.getSingleHotel();
            request.setAttribute("hotel", hotel);

            // ✅ load policies
            List<PolicyRule> policies = policyDao.getAllPolicyRules();

            // ✅ xử lý xuống dòng ngay ở server
            if (policies != null) {
                for (PolicyRule p : policies) {
                    if (p != null && p.getContent() != null) {
                        p.setContent(
                            p.getContent()
                             .replace("\r\n", "<br/>")
                             .replace("\n", "<br/>")
                        );
                    }
                }
            }

            request.setAttribute("policies", policies);

            request.getRequestDispatcher("/view/home/policy.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load policies", e);
        }
    }
}
