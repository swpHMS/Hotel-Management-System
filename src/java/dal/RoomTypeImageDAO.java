package dal;

import context.DBContext;
import model.RoomTypeImage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeImageDAO {

    private static final String SQL_LIST_BY_ROOMTYPE
            = "SELECT image_id, room_type_id, image_url, is_thumbnail, sort_order, created_at "
            + "FROM dbo.room_type_images "
            + "WHERE room_type_id = ? "
            + "ORDER BY is_thumbnail DESC, sort_order ASC, image_id ASC";

    private static final String SQL_THUMBNAIL
            = "SELECT TOP 1 image_url "
            + "FROM dbo.room_type_images "
            + "WHERE room_type_id = ? "
            + "ORDER BY is_thumbnail DESC, sort_order ASC, image_id ASC";

    public List<RoomTypeImage> getImagesByRoomTypeId(int roomTypeId) throws Exception {
        List<RoomTypeImage> list = new ArrayList<>();

        try (Connection con = new DBContext().getConnection()) {

            // ✅ Debug: kiểm tra web đang connect DB nào (xong việc có thể xoá)
            try (ResultSet rdb = con.createStatement().executeQuery("SELECT DB_NAME() AS dbname")) {
                if (rdb.next()) {
                    System.out.println("✅ RoomTypeImageDAO Connected DB = " + rdb.getString("dbname"));
                }
            }

            try (PreparedStatement ps = con.prepareStatement(SQL_LIST_BY_ROOMTYPE)) {
                ps.setInt(1, roomTypeId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        RoomTypeImage img = new RoomTypeImage();
                        img.setImageId(rs.getInt("image_id"));
                        img.setRoomTypeId(rs.getInt("room_type_id"));
                        img.setImageUrl(rs.getString("image_url"));
                        img.setThumbnail(rs.getBoolean("is_thumbnail"));
                        img.setSortOrder(rs.getInt("sort_order"));
                        img.setCreatedAt(rs.getTimestamp("created_at"));
                        list.add(img);
                    }
                }
            }
        }

        // ✅ Debug: xem count ảnh trả về theo roomTypeId (xong việc có thể xoá)
        System.out.println("✅ RoomTypeImageDAO roomTypeId=" + roomTypeId + " -> images=" + list.size());

        return list;
    }

    public String getThumbnailUrl(int roomTypeId) throws Exception {
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_THUMBNAIL)) {

            ps.setInt(1, roomTypeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("image_url");
                }
            }
        }
        return null;
    }

    public List<String> getImageUrlsByRoomTypeId(int roomTypeId) throws Exception {
        List<String> urls = new ArrayList<>();
        for (RoomTypeImage img : getImagesByRoomTypeId(roomTypeId)) {
            urls.add(img.getImageUrl());
        }
        return urls;
    }
}
