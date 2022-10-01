%%%-------------------------------------------------------------------
%%% @author vipul
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Sep 2022 23:13
%%%-------------------------------------------------------------------
-module(nc).
-author("vipul").

%% API
-export([start_client/2, client/2]).

start_client(PortNo,Message) ->
  io:write("accept returned"),
  spawn(nc, client, [PortNo, Message]).


client(PortNo,Message) ->
  io:write("accept returned"),
  {ok,Sock} = gen_tcp:connect("192.168.0.129",PortNo,[{active,false},
    {packet,2}]),
  gen_tcp:send(Sock,Message),
  io:write("accept returned").


