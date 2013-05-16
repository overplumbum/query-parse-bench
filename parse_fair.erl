%%
%% sudo apt-get install erlang
%% erlc parse_fair.erl && time erl -s parse_fair -s init stop -noshell
%%
%% разбор query string реализовал самостоятельно чисто из интереса.
%%
-module(parse_fair).
-export([start/0]).

-define(FIELDS_TO_EXTRACT, [<<"h">>, <<"p">>]).

start() ->
    Line = <<"127.0.0.1 - - [15/May/2013:21:35:24 +0000] \"GET /hc/cdn-bench.gif?p=http&h=host.example.org&dt=235 HTTP/1.1\" 200 43 \"http://example.org/blah/?q=Kiev&sort=price.asc&utm_source=yandex&utm_medium=cpc&utm_campaign=s_gen_city_cis_ua_kiev_1565_alldevices_georus&from=earch.no&_openstat=zzz\" \"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1106.241 YaBrowser/1.5.1106.241 Safari/537.4\" \"0.002\" \"ostrovok.ru\" \"1368653724.588\" \"lucky:92\" us:1.1.1.1:80 us_t:0.001">>,
    %% fprof:trace([start, {file, "fprof.trace"}]),
    parse_n_times(Line, 3000000).
    %% fprof:trace([stop]).

parse_n_times(_, 0) ->
    ok;
parse_n_times(Line, N) ->
    parse(Line),
    parse_n_times(Line, N - 1).

parse(Line) ->
    UrlPos = skip_spaces(Line, 6, 0),
    QSPos = find_query_string(Line, UrlPos),
    Pairs = parse_qs(Line, QSPos),
    _Protocol = proplists:get_value(<<"p">>, Pairs),
    _Provider = proplists:get_value(<<"h">>, Pairs).
    %% io:format("~p ~p~n~p~n~p~n~p~n", [UrlPos, QSPos, Pairs, Protocol, Provider]).

skip_spaces(_, 0, Offset) ->
    Offset;
skip_spaces(Bin, N, O) ->
    case Bin of
        <<_:O/binary, " ", _/binary>> -> skip_spaces(Bin, N - 1, O + 1);
        _ -> skip_spaces(Bin, N, O + 1)
    end.

find_query_string(Bin, O) ->
    case Bin of
        <<_:O/binary, "?", _/binary>> -> O + 1;
        _ -> find_query_string(Bin, O + 1)
    end.

%% library function
parse_qs(Bin, O) ->
    parse_qs_key(Bin, O, O, []).

parse_qs_key(Bin, O, TokenStart, Stack) ->
    case Bin of
        <<_:O/binary, "=", _/binary>> ->
            Key = materialize_token(Bin, TokenStart, O),
            parse_qs_value(Bin, O + 1, O + 1, [Key | Stack]);
        <<_:O/binary, "&", _/binary>>  ->
            %% ?a=b&c&d ...
            Key = materialize_token(Bin, TokenStart, O),
            parse_qs_key(Bin, O + 1, O + 1, [{Key, Key} | Stack]);
        <<_:O/binary, " ", _/binary>> ->
            %% terminate loop
            Key = materialize_token(Bin, TokenStart, O),
            [{Key, Key} | Stack];
        _ ->
            parse_qs_key(Bin, O + 1, TokenStart, Stack)
    end.

parse_qs_value(Bin, O, TokenStart, Stack) ->
    case Bin of
        <<_:O/binary, "&", _/binary>> ->
            Value = materialize_token(Bin, TokenStart, O),
            [Key | Pairs] = Stack,
            parse_qs_key(Bin, O + 1, O + 1, [{Key, Value} | Pairs]);
        <<_:O/binary, " ", _/binary>> ->
            %% terminate loop
            Value = materialize_token(Bin, TokenStart, O),
            [Key | Pairs] = Stack,
            [{Key, Value} | Pairs];
        _ ->
            parse_qs_value(Bin, O + 1, TokenStart, Stack)
    end.

materialize_token(Bin, Start, End) ->
    TokenSize = End - Start,
    <<_:Start/binary, Value:TokenSize/binary, _/binary>> = Bin,
    Value.
