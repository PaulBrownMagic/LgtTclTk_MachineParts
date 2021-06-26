:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-06-26,
		comment is 'Unit tests for solver'
	]).

	cover(solver).

	test(known_solution, true([A, B, P] == [200, 700, 20700])) :-
		solver::solve(160, 120, 150, A, B, P).

:- end_object.
