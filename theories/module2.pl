checkLabelling(Yes, No, Und) :-
    defendant(X),
    call_module('test-doctor', answerQuery(liable(X), Yes, No, Und)).