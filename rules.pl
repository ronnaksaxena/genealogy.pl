/* -*- mode:Prolog -*- */
%
% rules.pl
% for CS 220 Genealogy project
%
% NAME:
% DATE:

% cousin(?Person1, ?Person2, ?CommonAncestor, ?Len1, ?Len2).


% relation(?Person1, ?Person2, ?How)
relation(P1, P2, Answer) :-
    cousin(P1, P2, _, Len1, Len2),
    mainrel(Len1, Len2, P1, Mr),
    prefix(Mr, Len1, Len2, Pref),
    suffix(Mr, Len1, Len2, Suff),
    append([Pref,[Mr],Suff],Answer).

% The above is the suggestion from the project handout.  You don't have
% to use it.
