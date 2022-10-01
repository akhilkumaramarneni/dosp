%%%-------------------------------------------------------------------
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(collector).

%% API
-export([start_each/3, server/1, generate_coins/1, get_random_string/2, start_mining/1, mine_coins/1, generate_limited_coins/2]).

%% fun takes i=no of zeros and start creating actors to mine bit coins
start_mining([Args]) ->
  {InitWallTimer, _} = statistics(wall_clock),
  {InitCpuTimer, _} = statistics(runtime),
  io:format("init wall and cpu Timer times ~p ~p ~n",[InitWallTimer, InitCpuTimer]),
  NoOfZeros = list_to_integer(atom_to_list(Args)),
  TotalProcessors = erlang:system_info(logical_processors_available),
  ListenerPort = 10,
  case gen_tcp:listen(ListenerPort,[{active, false},{packet,2}]) of
    {ok, ListenSock} ->
      {ok, Port} = inet:port(ListenSock),
      start_each(TotalProcessors,NoOfZeros,ListenSock), % for multiple actors(8) on single server
%%      spawn(?MODULE,server,[ListenSock]), % listening on single port
%%      server(ListenSock), % receiving s(1) from workers
      Port;
    {error,Reason} ->
      {error,Reason}
  end.


start_each(0,_,_) ->
  ok;
start_each(Num,NoOfZeros,ListenSock) ->
%%  spawn(?MODULE,server,[ListenSock]), % to receive from workers
%%  spawn(?MODULE,generate_coins,[NoOfZeros]), % to mine on server, infinite coins
  spawn(?MODULE,generate_limited_coins,[2000000,NoOfZeros]),  % to mining coins to test CPU, Real and SizeUNits
  start_each(Num-1,NoOfZeros,ListenSock).


server(LS) ->
  case gen_tcp:accept(LS) of
    {ok,S} ->
      loop(S),
      server(LS);
    Other ->
      io:format("~p closed",[Other]),
      ok
  end.

loop(S) ->
  inet:setopts(S,[{active,once}]),
  receive
    {tcp,S,Data} ->
%%      gen_tcp:send(S,Answer),
      io:format("~n"),
      io:format(Data),
      loop(S);
    {tcp_closed,S} ->
      io:format("~p ~p end",[S,self()]),
      ok
  end.

generate_limited_coins(0,_)->
  {EndWallTimer, _} = statistics(wall_clock),
  {EndCPUTimer, _} = statistics(runtime),
  io:format("end wall and cpu Timer times ~p ~p ~n",[EndWallTimer, EndCPUTimer]),
  ok;
generate_limited_coins(Times,NoOfZeros) ->
  mine_coins(NoOfZeros),
  generate_limited_coins(Times-1,NoOfZeros).

mine_coins(NoOfZeros)->
%%  io:format("~p",[NoOfZeros]),
  RandString = get_random_string(8,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$#*^1234567890"),
  UniqueUserStr = "aamarneni;" ++ RandString,
  HashVal = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, UniqueUserStr))]),
  Checker = string:equal(string:left("",NoOfZeros,$0),string:sub_string(HashVal,1,NoOfZeros)),
  if
    Checker ->
      io:format("~p ~p ~n",[UniqueUserStr, HashVal]);
    true -> no_thing
  end.

generate_coins(NoOfZeros) ->
  mine_coins(NoOfZeros),
  generate_coins(NoOfZeros).


get_random_string(Length, AllowedChars) ->
  lists:foldl(fun(_, Acc) ->
    [lists:nth(rand:uniform(length(AllowedChars)),
      AllowedChars)]
    ++ Acc
              end, [], lists:seq(1, Length)).
