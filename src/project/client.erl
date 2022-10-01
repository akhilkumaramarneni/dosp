%%%-------------------------------------------------------------------
%%% @author amarneni
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Sep 2022 11:31 PM
%%%-------------------------------------------------------------------
-module(client).
-author("amarneni").

%% API
-export([sendToServer/2]).

sendToServer(_, 10) -> ok;
sendToServer(ServerAdd, N) ->
%%  ServerAdd=akhil,
  io:format("inside client now"),
  ServerAdd ! {self(), {"something",upper}},
  self() ! {dummy},
%%  erlang:send(),
%%  Input = 1,
%%  {ok,Ip} = inet:parse_address("127.0.0.1"),
%%  {<127,0,0,1>} ! {self(), {Input}},
  receive
    {ServerAdd, ReturnVal} ->
      io:format("~n inside client recieve"),
      sendToServer(ServerAdd, N+1),
      ReturnVal;
    {dummy} ->  io:format("~n dummy received--->"),
      sendToServer(ServerAdd, N)
  end.