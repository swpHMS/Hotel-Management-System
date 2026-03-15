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

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@WebServlet(name = "RoomTypeServlet", urlPatterns = {"/manager/room-types"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class RoomTypeServlet extends HttpServlet {

    private static final List<String> ALLOWED_IMAGE_EXTENSIONS = List.of(".jpg", ".jpeg", ".png");
    private static final String ALLOWED_IMAGE_LABEL = "JPG, JPEG, PNG";
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
        Integer roomTypeId = toInt(req.getParameter("roomTypeId"), null);

        String thumbnailImageUrl = null;
        boolean hasNewThumbnail = false;
        List<String> galleryImageUrls = new ArrayList<>();
        String preservedThumbnailUrl = trim(req.getParameter("existingThumbnailUrl"));
        List<String> preservedGalleryUrls = parseStringList(req.getParameterValues("existingGalleryUrls"));
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

        if (!hasNewThumbnail) {
            thumbnailImageUrl = preservedThumbnailUrl;
        }
        if (!preservedGalleryUrls.isEmpty()) {
            List<String> mergedGalleryUrls = new ArrayList<>(preservedGalleryUrls);
            mergedGalleryUrls.addAll(galleryImageUrls);
            galleryImageUrls = mergedGalleryUrls;
        }

        if ("update".equals(action) && (thumbnailImageUrl == null || thumbnailImageUrl.isBlank()) && roomTypeId != null && roomTypeId > 0) {
            RoomTypeManagementView existingRoomType = roomTypeDAO.getRoomTypeForManagerById(roomTypeId);
            if (existingRoomType != null && existingRoomType.getThumbnailImage() != null) {
                thumbnailImageUrl = existingRoomType.getThumbnailImage().getImageUrl();
            } else if (existingRoomType != null && existingRoomType.getImageUrl() != null && !existingRoomType.getImageUrl().isBlank()) {
                thumbnailImageUrl = existingRoomType.getImageUrl();
            }
        }

        if (thumbnailImageUrl == null || thumbnailImageUrl.isBlank()) {
            errors.add("Thumbnail image is required.");
        }
        if ("create".equals(action) && roomTypeDAO.existsRoomTypeName(form.getName(), null)) {
            errors.add("Room type name already exists.");
        }
        if ("update".equals(action) && roomTypeDAO.existsRoomTypeName(form.getName(), roomTypeId)) {
            errors.add("Room type name already exists.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("mode", "create".equals(action) ? "create" : "edit");
            req.setAttribute("editingId", roomTypeId);
            if (roomTypeId != null && roomTypeId > 0) {
                req.setAttribute("editingRoomType", roomTypeDAO.getRoomTypeForManagerById(roomTypeId));
            }
            req.setAttribute("formValue", form);
            req.setAttribute("preservedThumbnailUrl", thumbnailImageUrl);
            req.setAttribute("preservedGalleryUrls", galleryImageUrls);
            loadViewData(req);
            renderPage(req, resp);
            return;
        }

        boolean ok;
        if ("update".equals(action)) {
            if (roomTypeId == null || roomTypeId <= 0) {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?error=Invalid+room+type+id");
                return;
            }
            ok = roomTypeDAO.updateRoomType(roomTypeId, form, thumbnailImageUrl, hasNewThumbnail, galleryImageUrls);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?success=updated");
            } else {
                req.setAttribute("errors", List.of(buildPersistenceError("Update failed", roomTypeDAO.getLastErrorMessage())));
                req.setAttribute("mode", "edit");
                req.setAttribute("editingId", roomTypeId);
                req.setAttribute("editingRoomType", roomTypeDAO.getRoomTypeForManagerById(roomTypeId));
                req.setAttribute("formValue", form);
                req.setAttribute("preservedThumbnailUrl", thumbnailImageUrl);
                req.setAttribute("preservedGalleryUrls", galleryImageUrls);
                loadViewData(req);
                renderPage(req, resp);
            }
        } else {
            ok = roomTypeDAO.createRoomType(form, thumbnailImageUrl, galleryImageUrls);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?success=created");
            } else {
                req.setAttribute("errors", List.of(buildPersistenceError("Create failed", roomTypeDAO.getLastErrorMessage())));
                req.setAttribute("mode", "create");
                req.setAttribute("formValue", form);
                req.setAttribute("preservedThumbnailUrl", thumbnailImageUrl);
                req.setAttribute("preservedGalleryUrls", galleryImageUrls);
                loadViewData(req);
                renderPage(req, resp);
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
        int pageSize = normalizePageSize(toInt(req.getParameter("pageSize"), 3));
        int currentPage = Math.max(1, toInt(req.getParameter("page"), 1));

        List<RoomTypeManagementView> allRoomTypes = roomTypeDAO.getRoomTypesForManager(q);
        int totalItems = allRoomTypes.size();
        int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) pageSize));
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int fromIndex = Math.max(0, (currentPage - 1) * pageSize);
        int toIndex = Math.min(totalItems, fromIndex + pageSize);
        List<RoomTypeManagementView> roomTypes = allRoomTypes.subList(fromIndex, toIndex);

        req.setAttribute("roomTypes", roomTypes);
        req.setAttribute("amenities", roomTypeDAO.getAllActiveAmenities());
        req.setAttribute("q", q == null ? "" : q);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("pageTokens", buildPageTokens(currentPage, totalPages));
        req.setAttribute("pageSizeOptions", Arrays.asList(3, 6, 9));

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

    private List<String> parseStringList(String[] values) {
        List<String> list = new ArrayList<>();
        if (values == null) {
            return list;
        }
        for (String value : values) {
            String trimmed = trim(value);
            if (trimmed != null && !trimmed.isEmpty()) {
                list.add(trimmed);
            }
        }
        return list;
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

    private String buildPersistenceError(String fallback, String details) {
        if (details == null || details.isBlank()) {
            return fallback + ". Please check the input and try again.";
        }
        return fallback + ": " + details;
    }

    private int normalizePageSize(Integer pageSize) {
        if (pageSize == null) {
            return 3;
        }
        if (pageSize == 6 || pageSize == 9) {
            return pageSize;
        }
        return 3;
    }

    private List<String> buildPageTokens(int currentPage, int totalPages) {
        List<String> tokens = new ArrayList<>();
        if (totalPages <= 3) {
            for (int i = 1; i <= totalPages; i++) {
                tokens.add(String.valueOf(i));
            }
            return tokens;
        }

        if (currentPage <= 2) {
            tokens.add("1");
            tokens.add("2");
            tokens.add("...");
            tokens.add(String.valueOf(totalPages));
            return tokens;
        }

        if (currentPage >= totalPages - 1) {
            tokens.add("1");
            tokens.add("...");
            tokens.add(String.valueOf(totalPages - 1));
            tokens.add(String.valueOf(totalPages));
            return tokens;
        }

        tokens.add(String.valueOf(currentPage - 1));
        tokens.add(String.valueOf(currentPage));
        tokens.add("...");
        tokens.add(String.valueOf(totalPages));
        return tokens;
    }

    private String saveImage(Part part, HttpServletRequest req) throws IOException {
        String submittedName = part.getSubmittedFileName();
        if (submittedName == null || submittedName.isBlank()) {
            throw new IOException("Invalid file name");
        }

        String lowerName = submittedName.toLowerCase();
        String extension = null;
        for (String allowedExtension : ALLOWED_IMAGE_EXTENSIONS) {
            if (lowerName.endsWith(allowedExtension)) {
                extension = allowedExtension;
                break;
            }
        }
        if (extension == null) {
            throw new IOException("Only " + ALLOWED_IMAGE_LABEL + " files are allowed");
        }
        String fileName = "rt_" + UUID.randomUUID().toString().replace("-", "") + extension;

        String relativeFolder = "assets/images/room_types";
        byte[] content = part.getInputStream().readAllBytes();
        Set<Path> imageFolders = resolveImageFolders(req, relativeFolder);
        if (imageFolders.isEmpty()) {
            throw new IOException("Cannot resolve image directory");
        }

        for (Path folder : imageFolders) {
            Files.createDirectories(folder);
            Files.write(folder.resolve(fileName), content);
        }

        return relativeFolder + "/" + fileName;
    }

    private Set<Path> resolveImageFolders(HttpServletRequest req, String relativeFolder) {
        Set<Path> folders = new LinkedHashSet<>();
        String normalizedRelativeFolder = relativeFolder.replace("/", java.io.File.separator);

        String realPath = req.getServletContext().getRealPath("/" + relativeFolder);
        if (realPath != null && !realPath.isBlank()) {
            Path runtimeFolder = Path.of(realPath);
            folders.add(runtimeFolder);

            Path runtimePath = runtimeFolder.toAbsolutePath().normalize();
            String runtimeText = runtimePath.toString().replace("/", "\\");
            String marker = "\\build\\web\\";
            int markerIndex = runtimeText.toLowerCase().indexOf(marker);
            if (markerIndex >= 0) {
                String projectRoot = runtimeText.substring(0, markerIndex);
                folders.add(Path.of(projectRoot, "web", normalizedRelativeFolder));
            }
        }

        folders.add(Path.of(System.getProperty("user.dir"), "web", normalizedRelativeFolder));
        return folders;
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
