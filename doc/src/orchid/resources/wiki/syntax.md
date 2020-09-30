---
---

## Defeasible Rules
All statements are expressed in this form:

    RuleName: Premise1, ..., PremiseN => Conclusion.


The absence of premises, necessary for facts codification, can be expressed with the notation:

    FactName: [] => Conclusion.


As for the form that premises and conclusions can take, all the properties of prolog terms (atoms, variables, lists, compound terms) are allowed.


## Strong negation

    -Term

to indicate a strong negation, as opposed to the negation as failure implemented within the tuProlog engine. Strong negation cannot be nested.

## Weak negation

    ~(Term)

to indicate a weak negation. This notation, allowed only in premises, provides the ability to encode rules exceptions. For example, the rule:

    r : ~(Term1), Term2 => Conclusions.

can be translated in: _if Term2 then Conclusions unless Term1_.


## Permission and obligation

    p(Term)
    o(Term)

to indicate permission and obligation respectively. These concepts, belonging to the deontic expansion of classical logic, allow obtaining the flexibility necessary to deal with prohibitions and rights. For instance:

    v_rule: o(-enter), enter => violation.

The system only allows terms in the form:

    o(something)     _obligation_
    o(-something)    _prohibition_
    -o(something)    _no obligation_
    -o(-something)   _no prohibition_
    p(something)     _permission to do something_
    p(-something)    _permission to don't do something_

with _something_ as any standard Prolog language member.

## Superiority Relation

It is possible to express these preferences with the following notation:


    sup(RuleNam1, RuleName2).


This proposition symbolises the greater reliability of the rule with identifier equal to _RuleName 1_ over that with identifier _RuleName 2_.

## Burden of proof

The indication of burden of persuasion can be expressed as:

    bp(Term1,…, TermN).

