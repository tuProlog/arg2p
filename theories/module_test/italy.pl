hasJurisdiction(italy_art1, Court, ClaimId) :-
    personRole(PersonId, ClaimId, defendant),
    personDomicile(PersonId, italy, Court).

hasJurisdiction(italy_art2, Court, ClaimId):-
    personRole(PersonId, ClaimId, defendant),
    personAgent(AgentId, PersonId),
    personDomicile(AgentId, italy, Court).