%%%-------------------------------------------------------------------
%%% @author amarneni
%%% @copyright (C) 2022, <UFL>
%%% @doc
%%%
%%% @end
%%% Created : 30. Aug 2022 12:54 PM
%%%-------------------------------------------------------------------
-module(server).
-author("amarneni").

-export([start/0,e/0, loop/1, loopa/1]).

%%to(n) ->

loop(10) -> ok;
loop(N) ->
  Pid = spawn(?MODULE, e, []),
  register(list_to_atom(integer_to_list(N)),Pid),
  loop(N+1).

loopa(10) -> ok;
loopa(N) ->
  io: format("~p ~n",[whereis(list_to_atom(integer_to_list(N)))]),
  loopa(N+1).

start()->
  Pid = spawn(?MODULE, e, []),

  register(list_to_atom(integer_to_list(1)),Pid),
%%  C = rpc:call(node, erlang, whereis, [Pid]),
  C= whereis(list_to_atom(integer_to_list(1))),
  io:format("~p", [C]),
  C.


e() ->
%%  io:format("inside server now"),
  receive
    {Client, {Str, upper} } ->
%%      io:format("~n inside server recieve"),
      Client ! {self(), string:uppercase(Str)}
  end,
  e().

