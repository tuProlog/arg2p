hasJurisdiction(art3_1, italy, Court, ClaimId) :-
    personRole(PersonId, ClaimId, defendant),
    personDomicile(PersonId, italy, Court).

hasJurisdiction(art3_1, italy, Court, ClaimId):-
    personRole(PersonId, ClaimId, defendant),
    personAgent(AgentId, PersonId),
    personDomicile(AgentId, italy, Court).

hasJurisdiction(art51, italy, Court, ClaimId):-
    claimObject(ClaimId, rightsInRem),
    immovableProperty(ClaimId, italy, Court).
