/* -*- mode:Prolog -*- */
%
% rules.pl
% for CS 220 Genealogy project
%
% NAME: Ronnak Saxena
% DATE: 9/9/2020

% child(?Parent, ?Child).
child(P1, P2) :-
  person(P2, _, P1, _).
child(P1, P2) :-
  person(P2, _, _, P1).

% descendant(?P1, ?P2, ?N). Assuming P1 is older than P2
descendant(P1,P1, 0).
descendant(P1,P2, N) :-
  child(P1, X),
  descendant(X, P2, Np),
  N is Np + 1.


%sibling(?Person1, ?Person2)
sibling(X,Y) :-
  child(Z,X),
  child(Z,Y),
  not(X=Y).


%leastcommon
leastcommon(P1, P1, _, _, P1) :- !.
leastcommon(P1, P2, _, _, P2) :- child(P2, P1), !.
leastcommon(P1, P2, _, _, P1) :- child(P1, P2), !.
leastcommon(P1, P2, Len1, Len2, Answer) :-
  Len1 > Len2,
  child(Parent, P1),
  Len1p is Len1 - 1,
  leastcommon(Parent, P2, Len1p, Len2, Answer).
leastcommon(P1, P2, Len1, Len2, Answer) :-
  Len1 < Len2,
  child(Parent, P2),
  Len2p is Len2 - 1,
  leastcommon(P1, Parent, Len1, Len2p, Answer).
leastcommon(P1, P2, Len1, Len1, Answer) :-
  child(Parent1, P1),
  child(Parent2, P2),
  Len1p is Len1 - 1,
  leastcommon(Parent1, Parent2, Len1p, Len1p, Answer).

% cousin(?Person1, ?Person2, ?CommonAncestor, ?Len1, ?Len2).
cousin(P1, Cousin, Common, Len1, Len2) :-
  descendant(Common, P1, Len1),
  descendant(Common, Cousin, Len2),
  leastcommon(P1,Cousin,Len1,Len2,Least),
  Common = Least.

% female(?P).
female(P) :-
  person(P,female,_,_).

% male(?P).
male(P) :-
  person(P,male,_,_).

%mainrel(?Len1, ?Len2, ?Person, ?MainRelation)
mainrel(0, 0, P1, P1, self).
mainrel(_,_,P1, P2, sister) :-
  sibling(P1, P2),
  female(P2).
mainrel(_,_,P1, P2, brother) :-
  sibling(P1,P2),
  male(P2).
mainrel(Len1,Len2,P1, P2, daughter) :-
  Len1 > Len2,
  female(P1),
  descendant(P2, P1, _).
mainrel(Len1,Len2,P1, P2, son) :-
  Len1 > Len2,
  male(P1),
  descendant(P2, P1, _).
mainrel(Len1,Len2,P1, P2, mother) :-
  Len1 < Len2,
  female(P2),
  descendant(P1, P2, _).
mainrel(Len1,Len2,P1, P2, father) :-
  Len1 < Len2,
  male(P2),
  descendant(P1, P2, _).
mainrel(Len1,Len2,P1, P2, neice) :-
  Len1 > Len2,
  female(P1),
  sibling(P2, Sib),
  descendant(Sib, P1, _).
mainrel(Len1,Len2,P1, P2, nephew) :-
  Len1 > Len2,
  male(P1),
  sibling(P2, Sib),
  descendant(Sib, P1, _).
mainrel(Len1,Len2,P1, P2, cousin) :-
  (Len1=Len2),
  child(Parent,P2),
  sibling(Parent,Sib),
  descendant(Sib,P1, _).
mainrel(Len1, Len2, P1, P2, aunt) :-
  Len2 > Len1,
  female(P1),
  sibling(P1, Sibling),
  descendant(Sibling, P2, _).
mainrel(Len1, Len2, P1, P2, uncle) :-
  Len2 > Len1,
  male(P1),
  sibling(P1, Sibling),
  descendant(Sibling, P2, _).


%prefix(?Mr, ?Len1, ?Len2, ?Pref)
prefix(self, _, _, []) :- !.
prefix(sister, _, _, []) :- !.
prefix(brother,_,_, []) :- !.
prefix(cousin,Len1,Len2,[]) :-
  1 is min(Len1,Len2), !.
prefix(cousin,Len1,Len2,[first]) :-
  2 is min(Len1,Len2), !.
prefix(cousin,Len1,Len2,[second]) :-
  3 is min(Len1,Len2), !.
prefix(cousin,Len1,Len2,[third]) :-
  4 is min(Len1,Len2), !.
prefix(Mr, Len1, Len2, []) :-
  not(Mr=cousin),
  1 is abs(Len1 - Len2), !.
prefix(Mr, Len1, Len2, [grand]) :-
  not(Mr=cousin),
  2 is abs(Len1 - Len2), !.
prefix(Mr, Len1, Len2, Answer) :-
  not(Mr=cousin),
  Len2 > Len1,
  Len2 - Len1 > 2,
  Len2p is Len2 - 1,
  prefix(Mr, Len1, Len2p, AnswerP),
  append([great], AnswerP, Answer).
prefix(Mr, Len1, Len2, Answer) :-
  not(Mr=cousin),
  Len2 > Len1,
  Len2 - Len1 < 2,
  Len2p is Len2 + 1,
  prefix(Mr, Len1, Len2p, AnswerP),
  append([great], AnswerP, Answer).
prefix(Mr, Len1, Len2, Answer) :-
  not(Mr=cousin),
  Len1 > Len2,
  Len1 - Len2 > 2,
  Len1p is Len1 - 1,
  prefix(Mr, Len1p, Len2, AnswerP),
  append([great], AnswerP, Answer).
prefix(Mr, Len1, Len2, Answer) :-
  not(Mr=cousin),
  Len1 > Len2,
  Len1 - Len2 < 2,
  Len1p is Len1 + 1,
  prefix(Mr, Len1p, Len2, AnswerP),
  append([great], AnswerP, Answer).


% suffix(?MainRelation, ?Len1, ?Len2, ?Suffix)
suffix(Mr, _, _, []) :-
  not(Mr=cousin).
suffix(Mr, Len1, Len1, []) :-
  (Mr=cousin).
suffix(Mr, Len1, Len2, [once, removed]) :-
  (Mr=cousin),
  1 is abs(Len1 - Len2).
suffix(Mr, Len1, Len2, [twice, removed]) :-
  (Mr=cousin),
  2 is abs(Len1 - Len2).
suffix(Mr, Len1, Len2, [thrice, removed]) :-
  (Mr=cousin),
  3 is abs(Len1 - Len2).


% relation(?Person1, ?Person2, ?How)
relation(P1, P2, Answer) :-
  cousin(P1, P2, _, Len1, Len2),
  mainrel(Len1, Len2, P1, P2, Mr),
  prefix(Mr, Len1, Len2, Pref),
  suffix(Mr, Len1, Len2, Suff),
  append([Pref,[Mr],Suff],Answer).

% The above is the suggestion from the project handout.  You don't have
% to use it.
