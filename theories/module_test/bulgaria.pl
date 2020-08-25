hasJurisdiction(bulgaria_art3, Court, ClaimId):-
    personRole(PersonId, ClaimId, defendant),
    personAgent(AgentId, PersonId),
    personDomicile(AgentId, bulgaria, Court).