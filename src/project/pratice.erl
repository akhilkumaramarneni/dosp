%%%-------------------------------------------------------------------
%%% @author amarneni
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Sep 2022 7:54 PM
%%%-------------------------------------------------------------------
-module(pratice).
-author("amarneni").

%% API
-export([len/1,startServer/0,start/0,run/0]).

% recursion
len([])-> 0;
len([_| T]) -> 1+len(T).

run()->
  4.
%%  B=4,
%%  if
%%    A == B ->
%%      io:format("master ~p",[A == B]);
%%    true ->
%%      io:format("master ~p1")
%%  end.


%%  Str = "0000abcd0000",
%%  Str1 = string:sub_string(Str,1,K),
%%  Check = string:left("",K,$0) ,
%%  io:format("~p ~p ~p",[Str, Str1, Check]).
%%
%%  Str = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, "aamarneni;4NIsu1n7"))]),
%%  if
%%    string:find() -> io:format("value ~p ~n",[Str]);
%%
%%  end,
%%
%%  run().

startServer()->
  spawn(pratice, start, []).

start()->
  receive
    {From, {_}} ->
      From ! {"sent msg-007"},
      io: format("inside call");
    _ -> io:format("string one")
  end.





