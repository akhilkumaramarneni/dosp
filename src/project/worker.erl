%%%-------------------------------------------------------------------
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(worker).

%% API
-export([start_worker/1, worker/3, generate/2,get_random_string/2]).

start_worker(ServerAdd) ->
  IpAdd = erlang:atom_to_list(lists:nth(1,ServerAdd)),
  io:format("~p",[IpAdd]),
  PortNo = 10,
  NoOfZeros = 5, % can take dynamic for workers
  worker(IpAdd,PortNo,NoOfZeros).


worker(IpAdd,PortNo, NoOfZeros) ->
  io:write("accept returned"),
  {ok,Sock} = gen_tcp:connect(IpAdd,PortNo,[{active,false},
    {packet,2}]),
  io:format("~p",[IpAdd]),
  generate(Sock,NoOfZeros),
  io:write("accept returned").

generate(Sock, NoOfZeros) ->

  RandString = get_random_string(8,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$#*^1234567890"),
  UniqueUserStr = "aamarneni;" ++ RandString,
  HashVal = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, UniqueUserStr))]),
  Checker = string:equal(string:left("",NoOfZeros,$0),string:sub_string(HashVal,1,NoOfZeros)),

  if
    Checker -> gen_tcp:send(Sock, UniqueUserStr++" "++HashVal);
    true -> no_thing
  end,
  generate(Sock,NoOfZeros).


get_random_string(Length, AllowedChars) ->
  lists:foldl(fun(_, Acc) ->
    [lists:nth(rand:uniform(length(AllowedChars)),
      AllowedChars)]
    ++ Acc
              end, [], lists:seq(1, Length)).





