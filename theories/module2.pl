checkLabelling(Yes, No, Und) :-
    defendant(X),
    call_module(['test-doctor', 'module-case'], answerQuery(liable(X), Yes, No, Und)).