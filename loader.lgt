:- if(current_logtalk_flag(prolog_dialect, swi)).
	% For SWI-Prolog we need to load the library module
	:- use_module(library(clpfd)).
:- elif(current_logtalk_flag(prolog_dialect, sicstus)).
	% For SICStus Prolog we need to load the library module
	:- use_module(library(clpfd)).
:- elif(current_logtalk_flag(prolog_dialect, yap)).
	% For YAP we need to load the library module
	:- use_module(library(clpfd)).
:- elif(current_logtalk_flag(prolog_dialect, eclipse)).
	% For ECLiPSe we need to import CLPFD
	:- import(clpfd).
:- elif(\+ current_logtalk_flag(prolog_dialect, gnu)).
	% For GNU we don't need to load anything
	% BProlog doesn't support the variable_names option for `write_term/2`, needed for tkinter
	% CXProlog doesn't have CLPFD
	% Other backends aren't tested
	:- initialization((
		write('Backend not supported, please use SWI, ECLiPSe, GNU, or BProlog'),
		nl,
		halt
	)).
:- endif.


:- initialization((
	logtalk_load([
		json(loader),
		dictionaries(loader),
		nested_dictionaries(loader)
	]),
	logtalk_load([
		solver,
		tkinter
	],
	[ optimize(on)
	])
)).
