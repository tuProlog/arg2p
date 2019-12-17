f0: [] => patient('John').
f1: [] => doctor('Mary').
f2: [] => expert('Mark').
f3: [] => expert('Edward').
f4: [] => say('Mark',harmed('Mary', 'John')).
f5: [] => say('Edward',followedGuidelines('Mary')).

r1: harmed ('Mary','John'), doctor('Mary') => liable('Mary').
r2: followedGuidelines('Mary'), doctor('Mary') => -liable('Mary').
r3: say('Mark', harmed('Mary','John')), expert('Mark') => harmed('Mary', 'John').
r4: say('Edward',followedGuidelines('Mary')), expert('Edward') => followedGuidelines('Mary').


%==============================================

testDoctor :- convertRule, go([In, Out, Und]),
  write( ['==============================================> IN '),write('\n'),
  write(In),write('\n'),
  write( ['==============================================> OUT '),write('\n'),
  write(Out),write('\n'),
  write( ['==============================================> UND '),write('\n'),
  write(Und),write('\n'),
