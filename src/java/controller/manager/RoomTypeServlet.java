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
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
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
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.MemoryCacheImageOutputStream;

@WebServlet(name = "RoomTypeServlet", urlPatterns = {"/manager/room-types"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class RoomTypeServlet extends HttpServlet {

    private static final List<String> ALLOWED_IMAGE_EXTENSIONS = List.of(".jpg", ".jpeg", ".png");
    private static final String ALLOWED_IMAGE_LABEL = "JPG, JPEG, PNG";
    private static final int MAX_IMAGE_BYTES = 300 * 1024;
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        loadViewData(req);
        renderPage(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String action = trim(req.getParameter("action"));

        RoomTypeForm form = parseForm(req);
        List<String> errors = form.validate("create".equals(action));
        Integer roomTypeId = toInt(req.getParameter("roomTypeId"), null);
        List<Integer> deletedGalleryImageIds = parseIntegerList(req.getParameterValues("deletedGalleryImageIds"));

        String thumbnailImageUrl = null;
        String uploadedThumbnailImageUrl = null;
        boolean hasNewThumbnail = false;
        List<String> galleryImageUrls = new ArrayList<>();
        List<String> uploadedGalleryImageUrls = new ArrayList<>();
        String preservedThumbnailUrl = trim(req.getParameter("existingThumbnailUrl"));
        List<String> preservedGalleryUrls = parseStringList(req.getParameterValues("existingGalleryUrls"));
        try {
            Part thumbnailPart = req.getPart("thumbnailImage");
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                thumbnailImageUrl = saveImage(thumbnailPart, req);
                uploadedThumbnailImageUrl = thumbnailImageUrl;
                hasNewThumbnail = true;
            }
        } catch (Exception ex) {
            errors.add("Thumbnail upload failed: " + ex.getMessage());
        }
        try {
            galleryImageUrls = saveImages(req.getParts(), "galleryImages", req);
            uploadedGalleryImageUrls = new ArrayList<>(galleryImageUrls);
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
            deleteUploadedImages(uploadedThumbnailImageUrl, uploadedGalleryImageUrls, req);
            req.setAttribute("errors", errors);
            req.setAttribute("mode", "create".equals(action) ? "create" : "edit");
            req.setAttribute("editingId", roomTypeId);
            if (roomTypeId != null && roomTypeId > 0) {
                req.setAttribute("editingRoomType", roomTypeDAO.getRoomTypeForManagerById(roomTypeId));
            }
            req.setAttribute("formValue", form);
            req.setAttribute("preservedThumbnailUrl", preservedThumbnailUrl);
            req.setAttribute("preservedGalleryUrls", preservedGalleryUrls);
            req.setAttribute("deletedGalleryImageIds", deletedGalleryImageIds);
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
            ok = roomTypeDAO.updateRoomType(roomTypeId, form, thumbnailImageUrl, hasNewThumbnail, galleryImageUrls, deletedGalleryImageIds);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?success=updated");
            } else {
                deleteUploadedImages(uploadedThumbnailImageUrl, uploadedGalleryImageUrls, req);
                req.setAttribute("errors", List.of(buildPersistenceError("Update failed", roomTypeDAO.getLastErrorMessage())));
                req.setAttribute("mode", "edit");
                req.setAttribute("editingId", roomTypeId);
                req.setAttribute("editingRoomType", roomTypeDAO.getRoomTypeForManagerById(roomTypeId));
                req.setAttribute("formValue", form);
                req.setAttribute("preservedThumbnailUrl", preservedThumbnailUrl);
                req.setAttribute("preservedGalleryUrls", preservedGalleryUrls);
                req.setAttribute("deletedGalleryImageIds", deletedGalleryImageIds);
                loadViewData(req);
                renderPage(req, resp);
            }
        } else {
            ok = roomTypeDAO.createRoomType(form, thumbnailImageUrl, galleryImageUrls);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/manager/room-types?success=created");
            } else {
                deleteUploadedImages(uploadedThumbnailImageUrl, uploadedGalleryImageUrls, req);
                req.setAttribute("errors", List.of(buildPersistenceError("Create failed", roomTypeDAO.getLastErrorMessage())));
                req.setAttribute("mode", "create");
                req.setAttribute("formValue", form);
                req.setAttribute("preservedThumbnailUrl", preservedThumbnailUrl);
                req.setAttribute("preservedGalleryUrls", preservedGalleryUrls);
                loadViewData(req);
                renderPage(req, resp);
            }
        }
    }

    private void loadViewData(HttpServletRequest req) {
        String q = trim(req.getParameter("q"));
        int pageSize = normalizePageSize(toInt(req.getParameter("pageSize"), 3));
        int currentPage = Math.max(1, toInt(req.getParameter("page"), 1));

        List<RoomTypeManagementView> allRoomTypes = roomTypeDAO.getRoomTypesForManager((String) null);
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

    private List<Integer> parseIntegerList(String[] values) {
        List<Integer> ids = new ArrayList<>();
        if (values == null) {
            return ids;
        }
        for (String value : values) {
            Integer id = toInt(value, null);
            if (id != null && id > 0) {
                ids.add(id);
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

        String relativeFolder = "assets/images/room_types";
        byte[] content = part.getInputStream().readAllBytes();
        ProcessedImage processedImage = normalizeImageForStorage(content, extension);
        String fileName = "rt_" + UUID.randomUUID().toString().replace("-", "") + processedImage.extension;
        Set<Path> imageFolders = resolveImageFolders(req, relativeFolder);
        if (imageFolders.isEmpty()) {
            throw new IOException("Cannot resolve image directory");
        }

        for (Path folder : imageFolders) {
            Files.createDirectories(folder);
            Files.write(folder.resolve(fileName), processedImage.bytes);
        }

        return relativeFolder + "/" + fileName;
    }

    private ProcessedImage normalizeImageForStorage(byte[] originalBytes, String originalExtension) throws IOException {
        if (originalBytes == null || originalBytes.length == 0) {
            throw new IOException("Empty image file");
        }
        if (originalBytes.length <= MAX_IMAGE_BYTES) {
            return new ProcessedImage(originalBytes, originalExtension);
        }

        BufferedImage source = ImageIO.read(new ByteArrayInputStream(originalBytes));
        if (source == null) {
            throw new IOException("Unsupported or corrupted image");
        }

        String format = ".png".equals(originalExtension) ? "png" : "jpg";
        String extension = "png".equals(format) ? ".png" : ".jpg";
        BufferedImage current = "png".equals(format) ? source : toRgbImage(source);
        float quality = 0.9f;

        for (int attempt = 0; attempt < 10; attempt++) {
            byte[] encoded = writeImage(current, format, quality);
            if (encoded.length <= MAX_IMAGE_BYTES) {
                return new ProcessedImage(encoded, extension);
            }

            int nextWidth = Math.max(240, (int) Math.round(current.getWidth() * 0.85));
            int nextHeight = Math.max(180, (int) Math.round(current.getHeight() * 0.85));
            if (nextWidth == current.getWidth() && nextHeight == current.getHeight()) {
                break;
            }
            current = resizeImage(current, nextWidth, nextHeight, "png".equals(format));
            if (!"png".equals(format)) {
                quality = Math.max(0.55f, quality - 0.08f);
            }
        }

        BufferedImage jpgSource = toRgbImage(source);
        float jpgQuality = 0.82f;
        BufferedImage jpgCurrent = jpgSource;
        for (int attempt = 0; attempt < 10; attempt++) {
            byte[] encoded = writeImage(jpgCurrent, "jpg", jpgQuality);
            if (encoded.length <= MAX_IMAGE_BYTES) {
                return new ProcessedImage(encoded, ".jpg");
            }

            int nextWidth = Math.max(240, (int) Math.round(jpgCurrent.getWidth() * 0.82));
            int nextHeight = Math.max(180, (int) Math.round(jpgCurrent.getHeight() * 0.82));
            if (nextWidth == jpgCurrent.getWidth() && nextHeight == jpgCurrent.getHeight()) {
                break;
            }
            jpgCurrent = resizeImage(jpgCurrent, nextWidth, nextHeight, false);
            jpgQuality = Math.max(0.5f, jpgQuality - 0.07f);
        }

        byte[] fallbackBytes = writeImage(jpgCurrent, "jpg", 0.5f);
        return new ProcessedImage(fallbackBytes, ".jpg");
    }

    private BufferedImage resizeImage(BufferedImage source, int width, int height, boolean keepAlpha) {
        int imageType = keepAlpha ? BufferedImage.TYPE_INT_ARGB : BufferedImage.TYPE_INT_RGB;
        BufferedImage resized = new BufferedImage(width, height, imageType);
        Graphics2D graphics = resized.createGraphics();
        if (!keepAlpha) {
            graphics.setColor(Color.WHITE);
            graphics.fillRect(0, 0, width, height);
        }
        graphics.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        graphics.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        graphics.drawImage(source, 0, 0, width, height, null);
        graphics.dispose();
        return resized;
    }

    private BufferedImage toRgbImage(BufferedImage source) {
        if (source.getType() == BufferedImage.TYPE_INT_RGB) {
            return source;
        }
        BufferedImage rgbImage = new BufferedImage(source.getWidth(), source.getHeight(), BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = rgbImage.createGraphics();
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, source.getWidth(), source.getHeight());
        graphics.drawImage(source, 0, 0, null);
        graphics.dispose();
        return rgbImage;
    }

    private byte[] writeImage(BufferedImage image, String format, float quality) throws IOException {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        if ("jpg".equals(format)) {
            ImageWriter writer = ImageIO.getImageWritersByFormatName("jpg").next();
            try (MemoryCacheImageOutputStream imageOutput = new MemoryCacheImageOutputStream(output)) {
                writer.setOutput(imageOutput);
                ImageWriteParam writeParam = writer.getDefaultWriteParam();
                if (writeParam.canWriteCompressed()) {
                    writeParam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
                    writeParam.setCompressionQuality(quality);
                }
                writer.write(null, new IIOImage(image, null, null), writeParam);
            } finally {
                writer.dispose();
            }
            return output.toByteArray();
        }

        ImageIO.write(image, format, output);
        return output.toByteArray();
    }

    private static final class ProcessedImage {
        private final byte[] bytes;
        private final String extension;

        private ProcessedImage(byte[] bytes, String extension) {
            this.bytes = bytes;
            this.extension = extension;
        }
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

    private void deleteUploadedImages(String uploadedThumbnailImageUrl, List<String> uploadedGalleryImageUrls, HttpServletRequest req) {
        deleteImageByUrl(uploadedThumbnailImageUrl, req);
        if (uploadedGalleryImageUrls == null) {
            return;
        }
        for (String imageUrl : uploadedGalleryImageUrls) {
            deleteImageByUrl(imageUrl, req);
        }
    }

    private void deleteImageByUrl(String imageUrl, HttpServletRequest req) {
        String trimmedUrl = trim(imageUrl);
        if (trimmedUrl == null || trimmedUrl.isBlank()) {
            return;
        }

        int slashIndex = trimmedUrl.lastIndexOf('/');
        if (slashIndex <= 0 || slashIndex >= trimmedUrl.length() - 1) {
            return;
        }

        String relativeFolder = trimmedUrl.substring(0, slashIndex);
        String fileName = trimmedUrl.substring(slashIndex + 1);
        for (Path folder : resolveImageFolders(req, relativeFolder)) {
            try {
                Files.deleteIfExists(folder.resolve(fileName));
            } catch (IOException ignored) {
            }
        }
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
