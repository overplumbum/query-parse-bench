#!/usr/bin/env perl
use strict;
use warnings;

my ($line, %qs);
for (1..3000000) {
    $line = q!127.0.0.1 - - [15/May/2013:21:35:24 +0000] "GET /hc/cdn-bench.gif?p=http&h=host.example.org&dt=235 HTTP/1.1" 200 43 "http://example.org/blah/?q=Kiev&sort=price.asc&utm_source=yandex&utm_medium=cpc&utm_campaign=s_gen_city_cis_ua_kiev_1565_alldevices_georus&from=earch.no&_openstat=zzz" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1106.241 YaBrowser/1.5.1106.241 Safari/537.4" "0.002" "ostrovok.ru" "1368653724.588" "lucky:92" us:1.1.1.1:80 us_t:0.001!;
    %qs = map {split '=' } split '&', (split '\?', (split ' ', $line)[6])[1] ;
    if ($qs{dt} > 500) {
        print "$qs{p} $qs{h} $qs{dt}\n"
    }
}
