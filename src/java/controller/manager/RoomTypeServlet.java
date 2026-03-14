package controller.manager;

import dal.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.RoomTypeForm;
import model.RoomTypeManagementView;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "RoomTypeServlet", urlPatterns = {"/manager/room-types"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class RoomTypeServlet extends HttpServlet {

    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = trim(req.getParameter("action"));
        if ("deleteImage".equals(action)) {
            handleDeleteImage(req, resp);
            return;
        }
        loadViewData(req);
        renderPage(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String action = trim(req.getParameter("action"));
        if ("deleteImage".equals(action)) {
            handleDeleteImage(req, resp);
            return;
        }

        RoomTypeForm form = parseForm(req);
        List<String> errors = form.validate("create".equals(action));

        String thumbnailImageUrl = null;
        boolean hasNewThumbnail = false;
        List<String> galleryImageUrls = new ArrayList<>();
        try {
            Part thumbnailPart = req.getPart("thumbnailImage");
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                thumbnailImageUrl = saveImage(thumbnailPart, req);
                hasNewThumbnail = true;
            }
        } catch (Exception ex) {
            errors.add("Thumbnail upload failed: " + ex.getMessage());
        }
        try {
            galleryImageUrls = saveImages(req.getParts(), "galleryImages", req);
        } catch (Exception ex) {
            errors.add("Gallery upload failed: " + ex.getMessage());
        }

        if (!errors.isEmpty()) {
            Integer editingId = toInt(req.getParameter("roomTypeId"), null);
            req.setAttribute("errors", errors);
            req.setAttribute("mode", "create".equals(action) ? "create" : "edit");
            req.setAttribute("editingId", editingId);
            if (editingId != null && editingId > 0) {
                req.setAttribute("editingRoomType", roomTypeDAO.getRoomTypeForManagerById(editingId));
            }
            req.setAttribute("formValue", form);
            loadViewData(req);
            renderPage(req, resp);
            return;
        }

        boolean ok;
        if ("update".equals(action)) {
            Integer roomTypeId = toInt(req.getParameter("roomTypeId"), null);
            if (roomTypeId == null || roomTypeId <= 0) {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?error=Invalid+room+type+id");
                return;
            }
            ok = roomTypeDAO.updateRoomType(roomTypeId, form, thumbnailImageUrl, hasNewThumbnail, galleryImageUrls);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?success=updated");
            } else {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?error=Update+failed");
            }
        } else {
            ok = roomTypeDAO.createRoomType(form, thumbnailImageUrl, galleryImageUrls);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?success=created");
            } else {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?error=Create+failed");
            }
        }
    }

    private void handleDeleteImage(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer roomTypeId = toInt(req.getParameter("roomTypeId"), null);
        Integer imageId = toInt(req.getParameter("imageId"), null);
        if (roomTypeId == null || imageId == null || roomTypeId <= 0 || imageId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/manager/room-types?error=Invalid+image+request");
            return;
        }

        boolean ok = roomTypeDAO.deleteGalleryImage(roomTypeId, imageId);
        String status = ok ? "imageDeleted" : "imageDeleteFailed";
        resp.sendRedirect(req.getContextPath() + "/manager/room-types?editId=" + roomTypeId + "&success=" + status);
    }

    private void loadViewData(HttpServletRequest req) {
        String q = trim(req.getParameter("q"));
        List<RoomTypeManagementView> roomTypes = roomTypeDAO.getRoomTypesForManager(q);
        req.setAttribute("roomTypes", roomTypes);
        req.setAttribute("amenities", roomTypeDAO.getAllActiveAmenities());
        req.setAttribute("q", q == null ? "" : q);

        Integer editingId = toInt(req.getParameter("editId"), null);
        if (editingId != null && editingId > 0) {
            req.setAttribute("mode", "edit");
            req.setAttribute("editingId", editingId);
            req.setAttribute("editingRoomType", roomTypeDAO.getRoomTypeForManagerById(editingId));
        } else if ("create".equals(req.getParameter("mode"))) {
            req.setAttribute("mode", "create");
        }
    }

    private RoomTypeForm parseForm(HttpServletRequest req) {
        RoomTypeForm form = new RoomTypeForm();
        form.setName(trim(req.getParameter("name")));
        form.setBedType(trim(req.getParameter("bedType")));
        form.setViewType(trim(req.getParameter("viewType")));
        form.setRoomSize(toInt(req.getParameter("roomSize"), null));
        form.setDescription(trim(req.getParameter("description")));
        form.setMaxAdult(toInt(req.getParameter("maxAdult"), null));
        form.setMaxChildren(toInt(req.getParameter("maxChildren"), 0));
        form.setStatus("1".equals(req.getParameter("status")) ? 1 : 0);

        String priceRaw = trim(req.getParameter("price"));
        if (priceRaw != null && !priceRaw.isEmpty()) {
            try {
                form.setPrice(new BigDecimal(priceRaw));
            } catch (NumberFormatException ex) {
                form.setPrice(BigDecimal.valueOf(-1));
            }
        }

        String fromRaw = trim(req.getParameter("validFrom"));
        if (fromRaw != null && !fromRaw.isEmpty()) {
            try {
                form.setValidFrom(LocalDate.parse(fromRaw));
            } catch (Exception ignore) {
                form.setValidFrom(null);
            }
        }

        String toRaw = trim(req.getParameter("validTo"));
        if (toRaw != null && !toRaw.isEmpty()) {
            try {
                form.setValidTo(LocalDate.parse(toRaw));
            } catch (Exception ignore) {
                form.setValidTo(null);
            }
        }

        form.setAmenityIds(parseAmenityIds(req));
        return form;
    }

    private List<Integer> parseAmenityIds(HttpServletRequest req) {
        List<Integer> ids = new ArrayList<>();
        String[] values = req.getParameterValues("amenityIds");
        if (values != null) {
            for (String value : values) {
                Integer id = toInt(value, null);
                if (id != null && id > 0) {
                    ids.add(id);
                }
            }
        }
        return ids;
    }

    private List<String> saveImages(java.util.Collection<Part> parts, String fieldName, HttpServletRequest req) throws IOException {
        List<String> urls = new ArrayList<>();
        if (parts == null) {
            return urls;
        }

        for (Part part : parts) {
            if (part == null || !fieldName.equals(part.getName()) || part.getSize() <= 0) {
                continue;
            }
            urls.add(saveImage(part, req));
        }
        return urls;
    }

    private void renderPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "roomTypes");
        req.setAttribute("pageTitle", "Room Types");
        req.setAttribute("contentPage", "/view/manager/room-types.jsp");
        req.getRequestDispatcher("/view/manager/layout.jsp").forward(req, resp);
    }

    private String saveImage(Part part, HttpServletRequest req) throws IOException {
        String submittedName = part.getSubmittedFileName();
        if (submittedName == null || submittedName.isBlank()) {
            throw new IOException("Invalid file name");
        }

        String lowerName = submittedName.toLowerCase();
        if (!(lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg") || lowerName.endsWith(".png") || lowerName.endsWith(".webp"))) {
            throw new IOException("Only JPG, JPEG, PNG, WEBP are allowed");
        }

        String extension = lowerName.substring(lowerName.lastIndexOf('.'));
        String fileName = "rt_" + UUID.randomUUID().toString().replace("-", "") + extension;

        String relativeFolder = "assets/images/room_types";
        String absoluteFolder = req.getServletContext().getRealPath("/" + relativeFolder);
        if (absoluteFolder == null) {
            absoluteFolder = System.getProperty("user.dir") + File.separator + "web" + File.separator + relativeFolder.replace("/", File.separator);
        }

        File folder = new File(absoluteFolder);
        if (!folder.exists() && !folder.mkdirs()) {
            throw new IOException("Cannot create image directory");
        }

        Path output = Path.of(folder.getAbsolutePath(), fileName);
        Files.copy(part.getInputStream(), output, StandardCopyOption.REPLACE_EXISTING);

        return relativeFolder + "/" + fileName;
    }

    private Integer toInt(String input, Integer defaultValue) {
        try {
            if (input == null || input.trim().isEmpty()) {
                return defaultValue;
            }
            return Integer.parseInt(input.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String trim(String input) {
        return input == null ? null : input.trim();
    }
}
