hasJurisdiction(Article, Country, Court, ClaimId):-
    personRole(PersonId, ClaimId, defendant),
    memberState(MemberLaw),
    call_module([MemberLaw, ClaimId], hasJurisdiction(Article, Country, Court, ClaimId)).

hasJurisdiction(Article, Country, Court, ClaimId):-
    claimObject(ClaimId, rightsInRem), 
    memberState(MemberLaw),
    call_module([MemberLaw, ClaimId], hasJurisdiction(Article, Country,Court, ClaimId)).
