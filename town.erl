-module(town).
-behaviour(gen_server).
%% API
-export([start/0, combine/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {port}).
-define(SERVER, ?MODULE).


combine(String0) ->
	start(),
	String = list_to_binary("combine|" ++ String0 ++ "\n"),
	gen_server:call(?SERVER, {combine, String}, infinity),
	stop().


start() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


stop() ->
	gen_server:cast(?SERVER, stop).


init([]) ->
	process_flag(trap_exit, true),
	Port = erlang:open_port({spawn, "python -u /users/johnson/Desktop/erl/town.py"},[stream, {line, 1024}]),
	{ok, #state{port = Port}}.


handle_call({combine,String}, _From, #state{port = Port} = State) ->
	erlang:port_command(Port, String),
	receive
		{Port, {data, {_Flag, Data}}} ->
		io:format("receiving:~p~n", [Data]),
		{reply, Data, State}
	end.


handle_cast(stop, State) ->
	{stop, normal, State};

handle_cast(_Msg, State) ->
	{noreply, State}.


handle_info(_Info, State) ->
	{noreply, State}.


terminate(_Reason, _State) ->
	ok.


code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
