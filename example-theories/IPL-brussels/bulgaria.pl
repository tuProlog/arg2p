hasJurisdiction(art4_1, bulgaria, Court, ClaimId):-
    personRole(PersonId, ClaimId, defendant),
    personDomicile(PersonId, bulgaria, Court).

hasJurisdiction(art4_1, bulgaria, Court, ClaimId):-
    personRole(PersonId, ClaimId, defendant),
    personPlaceOfBusiness(PersonId, bulgaria, Court).

hasJurisdiction(art12, bulgaria, Court, ClaimId):-
    claimObject(ClaimId, rightsInRem),
    immovableProperty(ClaimId, bulgaria, Court).
