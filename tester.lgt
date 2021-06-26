:- if((
	current_logtalk_flag(prolog_dialect, swi)
)).
% For SWI we need to load the library module
:- initialization(use_module(library(clpfd))).

:- elif((
	current_logtalk_flag(prolog_dialect, eclipse)
)).
% For ECLiPSe we need to import CLPFD
:- initialization(import(clpfd)).

:- elif((
	\+ current_logtalk_flag(prolog_dialect, gnu)
)).
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
	set_logtalk_flag(report, warnings),
	logtalk_load(lgtunit(loader)),
	logtalk_load([
		solver
	], [
		source_data(on),
		debug(on)
	]),
	logtalk_load(tests, [hook(lgtunit)]),
	tests::run
)).
