rvehi: [] => vehi.
remer: [] => emer.
rProh: vehi => o(-enter).
rPerm: emer => p(enter).
v: o(-enter), enter => violation.
f: violation => fine.
vPrime: [] => -violation.
fPrime: [] => -fine.
s: violation => o(stop).

e: [] => enter.

%sup(_, [d, _]).
%sup(_, [p, _]).
sup(rPerm, rProh).

sup(v, vPrime).
sup(f, fPrime).


%inAsItShouldBe([[emer],[enter],[neg,fine],[neg,violation],[perm,[enter]],[vehi]]).
%outAsItShouldBe([[fine],[obl,[neg,enter]],[obl,[stop]],[violation]]).


%buildLabelSets.