
package context;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import model.GoogleUserDTO;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

public class GoogleUtils {
    public static String getToken(String code) throws IOException {
        String response = Request.Post("https://oauth2.googleapis.com/token")
                .bodyForm(Form.form()
                    .add("client_id", "")
                    .add("client_secret", "") 
                    .add("redirect_uri", "http://localhost:9999/SWP391_HMS_GR2/login")
                    .add("code", code)
                    .add("grant_type", "authorization_code").build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").toString().replaceAll("\"", "");
    }

    public static GoogleUserDTO getUserInfo(String accessToken) throws IOException {
        String link = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, GoogleUserDTO.class);
    }
}
