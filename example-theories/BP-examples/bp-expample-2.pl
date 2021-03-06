% Medical malpractice (Example 3)

% r1: ⇒ ¬guidelines
% r2: ⇒ guidelines
% r3: ¬guidelines ⇒ negligent
% r4: guidelines ⇒ ¬negligent
% r5: negligent ⇒ liable
% r6: ¬negligent ⇒ ¬liable

% Example 5
% BP(¬negligent)

% Example 8
% BP(¬negligent)
% BP(¬guidelines)

%========================================================================================

r1 : [] => -guidelines('Mary').
r2 : [] => guidelines('Mary').
r3 : -guidelines(X) => negligent(X).
r4 : guidelines(X) => -negligent(X).
r5 : negligent(X) => liable(X).
r6 : -negligent(X) => -liable(X).

bp(-negligent(X)).
%bp(-guidelines(X)).

partialHBP.
demonstration.
