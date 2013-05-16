import java.lang.Integer;
import java.net.*;
import java.util.*;
import java.io.UnsupportedEncodingException;

public class parse_split {
    public static void main(String _args[]) throws URISyntaxException, UnsupportedEncodingException {
        for (int i = 3000000; i > 0; i--) {
            String line = "127.0.0.1 - - [15/May/2013:21:35:24 +0000] \"GET /hc/cdn-bench.gif?p=http&h=host.example.org&dt=235 HTTP/1.1\" 200 43 \"http://example.org/blah/?q=Kiev&sort=price.asc&utm_source=yandex&utm_medium=cpc&utm_campaign=s_gen_city_cis_ua_kiev_1565_alldevices_georus&from=earch.no&_openstat=zzz\" \"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1106.241 YaBrowser/1.5.1106.241 Safari/537.4\" \"0.002\" \"ostrovok.ru\" \"1368653724.588\" \"lucky:92\" us:1.1.1.1:80 us_t:0.001";
            String[] kvs = line.split(" ", 8)[6].split("\\?", 2)[1].split("&");

            String provider = null;
            String protocol = null;
            int dt  = -1;
            int args = 3;

            for (String kv: kvs) {
                String[] _kv = kv.split("=", 2);
                switch (_kv[0]) {
                    case "dt":
                        dt = Integer.parseInt(_kv[1]);
                        args--;
                        break;
                    case "h":
                        provider = _kv[1];
                        args--;
                        break;
                    case "p":
                        protocol = _kv[1];
                        args--;
                        break;
                }
            }
            if (args != 0) {
                continue;
            }

            if (dt > 500) {
                System.out.printf("%s %s %d\n", protocol, provider, dt);
            }
        }

    }
}
