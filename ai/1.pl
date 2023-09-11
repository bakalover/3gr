era('Ancient').
era('Classical').
era('Medieval').
era('Renaissance').


tech('Agriculture').
in_era('Agriculture', 'Ancient').
leads_to('Agriculture','Pottery').
leads_to('Agriculture','Animal Husbandry').
leads_to('Agriculture','Archery').
leads_to('Agriculture', 'Mining').

tech('Animal Husbandry').
in_era('Animal Husbandry', 'Ancient').
requires('Animal Husbandry', 'Agriculture').
leads_to('Animal Husbundry', 'Trapping').
leads_to('Animal Husbandry','The Wheel').

tech('Trapping').
in_era('Trapping','Ancient').
requires('Trapping','Animal Husbandry').

tech('Archery').
in_era('Archery','Ancient').
requires('Archery','Agriculture').
leads_to('Archery','The Wheel').

tech('Pottery').
in_era('Pottery','Ancient').
requires('Pottery','Agriculture').
leads_to('Pottery','Sailing').
leads_to('Pottery','Calendar').
leads_to('Pottery','Writing').

tech('Sailing').
in_era('Sailing','Medieval').
requires('Sailing','Pottery').

tech('Calendar').
in_era('Calendar','Ancient').
requires('Calendar','Pottery').

tech('Writing').
in_era('Writing','Medieval').
requires('Writing','Pottery').


tech('Mining').
in_era('Mining','Ancient').
requires('Mining','Agriculture').
leads_to('Mining','Masonry').
leads_to('Mining','Bronze Working').

tech('Bronze Working').
in_era('Bronze Working','Ancient').
requires('Bronze Working','Mining').

tech('The Wheel').
in_era('The Wheel','Ancient').
requires('The Wheel','Animal Husbandry').
requires('The Wheel','Archery').
leads_to('The Wheel','Mathematics').
leads_to('The Wheel','Horseback Riding').
leads_to('The Wheel', 'Construction').

tech('Horseback Riding').
in_era('Horseback Riding','Medieval').
requires('Horseback Riding','The Wheel').


tech('Mathematics').
in_era('Mathematics','Classical').
requires('Mathematics','The Wheel').
leads_to('Mathematics','Currency').
leads_to('Mathematics','Engineering').

tech('Currency').
in_era('Currency','Classical').
requires('Currency','Mathematics').

tech('Masonry').
in_era('Masonry','Ancient').
requires('Masonry','Mining').
leads_to('Masonry','Construction').

tech('Construction').
in_era('Construction','Classical').
requires('Construction','Masonry').
requires('Construction', 'The Wheel').
leads_to('Construction','Engineering').

tech('Engineering').
in_era('Engineering','Classical').
requires('Engineering','Mathematics').
requires('Engineering','Construction').
leads_to('Engineering','Metal Casting').
leads_to('Engineering','Machinery').


tech('Iron Working').
in_era('Iron Working','Medieval').

tech('Metal Casting').
in_era('Metal Casting','Medieval').
requires('Metal Casting','Iron Working').
requires('Metal Casting','Engineering').
leads_to('Metal Casting','Physics').
leads_to('Metal Casting','Steel').

tech('Steel').
in_era('Steel','Medieval').
requires('Steel', 'Metal Casting').

tech('Guilds').
in_era('Guilds','Medieval').
requires('Guilds','Currency').
leads_to('Guilds','Machinery').
leads_to('Guilds','Chivalry').

tech('Chivalry').
in_era('Chivalry','Medieval').
requires('Guilds').

tech('Machinery').
in_era('Machinery','Medieval').
requires('Machinery','Guilds').
requires('Machinery','Engineering').
leads_to('Machinery','Printing Press').

tech('Physics').
in_era('Physics','Medieval').
requires('Physics','Metal Casting').
leads_to('Physics','Printing Press').
leads_to('Physics','Gunpowder').

tech('Gunpowder').
in_era('Gunpowder','Medieval').
requires('Gunpowder','Physics').

tech('Printing Press').
in_era('Printing Press','Renaissance').
requires('Printing Press','Chivarly').
requires('Printing Press','Physics').
requires('Printing Press','Machinery').
leads_to('Printing Press','Economics').
leads_to('Printing Press','Metallurgy').

tech('Economics').
in_era('Economics','Renaissance').
requires('Economics','Printing Press').

tech('Metallurgy').
in_era('Metallurgy','Renaissance').
requires('Metallurgy','Printing Press').

%rules
same_era(X,Y) :- in_era(X,P), in_era(Y,Q), P == Q.
to(From,To) :- leads_to(From,To), requires(To,From).
linked(X,Y) :- to(X,Y) ; (leads_to(Y,X), requires(X,Y)).
under_tree_count(Start, Count) :- dfs(Start, [], Count).

dfs(Node, Visited, Count) :-
    (\+ member(Node, Visited)),
    findall(Child, to(Node, Child), Children),
    dfs_list(Children, [Node|Visited], Count1), 
    Count is Count1 + 1. 

dfs_list([], _, 0).
dfs_list([H|T], Visited, Count) :-
    dfs(H, Visited, Count1),
    dfs_list(T, Visited, Count2), 
    Count is Count1 + Count2. 

%queries
%same_era('Pottery','Metallurgy').
%same_era('Pottery','Archery').
%linked('Archery','Agriculture').
%linked('Archery','Engineering').
%under_tree_count('Physics', Count).
%under_tree_count('Metal Casting', Count).