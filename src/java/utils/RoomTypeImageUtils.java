
package utils;

import dal.RoomTypeImageDAO;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.RoomType;
import model.RoomTypeImage;

public class RoomTypeImageUtils {
    public static Map<Integer, List<RoomTypeImage>> buildImagesMap(List<RoomType> roomTypes) {
        Map<Integer, List<RoomTypeImage>> map = new HashMap<>();
        RoomTypeImageDAO dao = new RoomTypeImageDAO();

        if (roomTypes == null) return map;

        for (RoomType rt : roomTypes) {
            try {
                map.put(rt.getRoomTypeId(), dao.getImagesByRoomTypeId(rt.getRoomTypeId()));
            } catch (Exception e) {
                e.printStackTrace();
                map.put(rt.getRoomTypeId(), List.of());
            }
        }
        return map;
    }

}
