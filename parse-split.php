<?php
for ($i = 3000000; $i > 0; $i--) {
    $line = "127.0.0.1 - - [15/May/2013:21:35:24 +0000] \"GET /hc/cdn-bench.gif?p=http&h=host.example.org&dt=235 HTTP/1.1\" 200 43 \"http://example.org/blah/?q=Kiev&sort=price.asc&utm_source=yandex&utm_medium=cpc&utm_campaign=s_gen_city_cis_ua_kiev_1565_alldevices_georus&from=earch.no&_openstat=zzz\" \"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1106.241 YaBrowser/1.5.1106.241 Safari/537.4\" \"0.002\" \"ostrovok.ru\" \"1368653724.588\" \"lucky:92\" us:1.1.1.1:80 us_t:0.001";
    $v = explode(" ", $line, 8);
    $v = $v[6];
    $v = explode("?", $v, 2);
    $v = $v[1];
    $v = explode("&", $v);

    $args = 3;

    foreach ($v as $kv) {
        $kv = explode('=', $kv, 2);
        switch ($kv[0]) {
            case "dt":
                $dt = (int)($kv[1]);
                $args--;
                break;
            case "h":
                $provider = $kv[1];
                $args--;
                break;
            case "p":
                $protocol = $kv[1];
                $args--;
                break;
        }
    }
    if ($args != 0) {
        continue;
    }
    if ($dt > 500) {
        echo $protocol . ' ' . $provider . ' ' . $dt . "\n";
    }
}