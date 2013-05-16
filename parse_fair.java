import java.net.*;
import java.util.*;
import java.io.UnsupportedEncodingException;

public class parse_fair {
    public static void main(String args[]) throws URISyntaxException, UnsupportedEncodingException {
        for (int i = 3000000; i > 0; i--) {
            String line = "127.0.0.1 - - [15/May/2013:21:35:24 +0000] \"GET /hc/cdn-bench.gif?p=http&h=host.example.org&dt=235 HTTP/1.1\" 200 43 \"http://example.org/blah/?q=Kiev&sort=price.asc&utm_source=yandex&utm_medium=cpc&utm_campaign=s_gen_city_cis_ua_kiev_1565_alldevices_georus&from=earch.no&_openstat=zzz\" \"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1106.241 YaBrowser/1.5.1106.241 Safari/537.4\" \"0.002\" \"ostrovok.ru\" \"1368653724.588\" \"lucky:92\" us:1.1.1.1:80 us_t:0.001";
            String[] parts = line.split(" ", 8);
            String query = parts[6];
            Map<String, String> kv = splitQuery(new URI(query));
            int dt = Integer.parseInt(kv.get("dt"));
            String provider = kv.get("h");
            String protocol = kv.get("p");
            if (dt > 500) {
                System.out.printf("%s %s %s\n", protocol, provider, dt);
            }
        }

    }

    private static Map<String, String> splitQuery(URI url) throws UnsupportedEncodingException {
        Map<String, String> query_pairs = new LinkedHashMap<String, String>();
        String query = url.getQuery();
        String[] pairs = query.split("&");
        for (String pair : pairs) {
            int idx = pair.indexOf("=");
            query_pairs.put(URLDecoder.decode(pair.substring(0, idx), "UTF-8"), URLDecoder.decode(pair.substring(idx + 1), "UTF-8"));
        }
        return query_pairs;
    }
}