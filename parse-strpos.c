#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    char *line;
    int i, j, k;
    char *query_start;
    char *query_end;
    char *p;
    char *arg_k_start;
    char *arg_v_start;
    int args_to_find;

    #define BUF_PROTOCOL_LEN 6
    #define BUF_PROVIDER_LEN 100
    char protocol[BUF_PROTOCOL_LEN];
    char provider[BUF_PROVIDER_LEN];
    int dt;

	for (i = 3000000; i > 0; --i) {
		line = "127.0.0.1 - - [15/May/2013:21:35:24 +0000] \"GET /hc/cdn-bench.gif?p=http&h=host.example.org&dt=235 HTTP/1.1\" 200 43 \"http://example.org/blah/?q=Kiev&sort=price.asc&utm_source=yandex&utm_medium=cpc&utm_campaign=s_gen_city_cis_ua_kiev_1565_alldevices_georus&from=earch.no&_openstat=zzz\" \"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1106.241 YaBrowser/1.5.1106.241 Safari/537.4\" \"0.002\" \"ostrovok.ru\" \"1368653724.588\" \"lucky:92\" us:1.1.1.1:80 us_t:0.001";
		query_start = line;

		for (j=0; j<6; j++) {
		    query_start = strchr(query_start, ' ') + 1;
            if (!query_start) {
                goto finish_line;
            }
		}
		query_start = strchr(query_start, '?') + 1;
        if (!query_start) {
            goto finish_line;
        }

		p = query_start;

		args_to_find = 3;

		while (*p != ' ' && *p != 0) {
            arg_k_start = p;
            while (*p != '=' && *p != 0) {
                p++;
            }
            if (!*p) {
                goto finish_line;
            }
            p++;
            if (!*p) {
                goto finish_line;
            }
            arg_v_start = p;
            while (*p != '&' && *p != ' ' && *p != 0) {
                p++;
            }
            if (!*p) {
                goto finish_line;
            }
            if (strncmp(arg_k_start, "p", 1) == 0 && *(arg_k_start+1) == '=') {
                if ((p-arg_v_start) > (BUF_PROTOCOL_LEN - 1)) {
                    goto finish_line;
                }
                strncpy(protocol, arg_v_start, p-arg_v_start);
                args_to_find--;
            } else if (strncmp(arg_k_start, "h", 1) == 0 && *(arg_k_start+1) == '=') {
                if ((p-arg_v_start) > (BUF_PROVIDER_LEN - 1)) {
                    goto finish_line;
                }
                strncpy(provider, arg_v_start, p-arg_v_start);
                args_to_find--;
            } else if (strncmp(arg_k_start, "dt", 2) == 0 && *(arg_k_start+2) == '=') {
                dt = atoi(arg_v_start);
                args_to_find--;
            }
            if (!args_to_find) {
                break;
            }
            p++;
		}

		if (args_to_find) {
		    goto finish_line;
		}
        if (!p) {
            goto finish_line;
        }

        if (dt > 500) {
            printf("%s %s %d\n", protocol, provider, dt);
        }

        finish_line:
            0;
	}
	return 0;
}
