:- object(solver).

	:- info([
		version is 1:1:0,
		author is 'Paul Brown',
		date is 2021-06-28,
		comment is 'Solver advises on how many of each part to make'
	]).

	:- if((
		current_logtalk_flag(prolog_dialect, swi) ;
		current_logtalk_flag(prolog_dialect, yap) ;
		current_logtalk_flag(prolog_dialect, eclipse)
	)).
		:- use_module(clpfd, [
			(#=)/2,
			(#=<)/2,
			(#>=)/2,
			labeling/2
		]).
	:- elif(current_logtalk_flag(prolog_dialect, sicstus)).
		:- use_module(clpfd, [
			(#=)/2,
			(#=<)/2,
			(#>=)/2
		]).
		:- meta_predicate(clpfd:labeling(*, *)).
		labeling([max(Var)], [A, B, P]) :-
			clpfd:labeling([maximize(Var)], [A, B, P]).
	:- elif(current_logtalk_flag(prolog_dialect, gnu)).
		labeling(_Opts, [A, B, P]) :-
			fd_labeling([P, A, B], [value_method(max)]).
	:- endif.

	:- public(solve/6).
	:- mode(solve(+integer, +integer, +integer, -integer, -integer, -integer), zero_or_one).
	:- info(solve/6, [
		comment is 'Find an optimal solution for the given args',
		argnames is [
			'LatheHours',
			'PolisherHours',
			'PressHours',
			'UnitA',
			'UnitB',
			'Profit'
			]
	]).
	/*
	Mathematical Definition
	maximize z =  16a  +25b            (profit)
	subject to:     a   +2b ≤ La * 10  (lathe hours)
				   2a    +b ≤ Po * 10  (polisher hours)
				   4a    +b ≤ Pr * 10  (press hours)
					a       ≥   0      (non-negative)
						  b ≥   0      (non-negative)
	*/
	solve(LatheHours, PolisherHours, PressHours, UnitA, UnitB, Profit) :-
		Profit #= 16*UnitA + 25*UnitB,
					 UnitA +  2*UnitB #=< LatheHours * 10,
				   2*UnitA +    UnitB #=< PolisherHours * 10,
				   4*UnitA +    UnitB #=< PressHours * 10,
					 UnitA		      #>= 0,
							    UnitB #>= 0,
		labeling([max(Profit)], [UnitA, UnitB, Profit]).


:- end_object.
