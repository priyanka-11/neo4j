MATCH (n)
OPTIONAL MATCH (n)-[r]-()
DELETE n,r;


CREATE 
(E: Committee {name:"Executive Committee"}),
(M: Committee {name:"Membership Committee"}),
(TheLiterarySociety: Organization {Name:"The Literary Society"}),
(TheGolfClub: Organization {Name:"The Golf Club"}),
(R: Person {ID:100, name:"Raymond Parsloe Devine"}),
(A: Person {ID:200, name:"Adeline Smethurst"}),
(W: Person {ID:300, name:"Walter Hagen"}),
(C: Person {ID:400, name:"Cuthbert Banks"});




MATCH (A:Person), (R:Person), (C:Person), (W:Person)
WHERE R.ID=100 AND A.ID=200 AND W.ID=300 AND C.ID=400
CREATE
F1 = (A)-[:IS_FRIEND_OF]->(R),
F2 = (C)-[:IS_FRIEND_OF]->(W),
F3 = (W)-[:IS_FRIEND_OF]->(C)
RETURN F1,F2,F3;

MATCH (TheGolfClub: Organization), (E: Committee),(M: Committee)
WHERE TheGolfClub.Name= "The Golf Club" AND E.name="Executive Committee"
	AND M.name="Membership Committee"
CREATE
C1 = (TheGolfClub)-[:HAS_COMMITTEE]->(E),
C2 =(TheGolfClub)-[:HAS_COMMITTEE]->(M)
RETURN C1,C2;

MATCH (A:Person), (R:Person), (C:Person), (W:Person), (TheGolfClub: Organization), (TheLiterarySociety: Organization)
WHERE R.ID=100 AND A.ID=200 AND W.ID=300 AND C.ID=400
	AND TheGolfClub.Name= "The Golf Club" AND 
	TheLiterarySociety.Name="The Literary Society"
CREATE
M1 = (R)-[:IS_MEMEBR {since:20100701}]->(TheLiterarySociety),
M2 = (A)-[:IS_MEMEBR {since:20070405}]->(TheGolfClub),
M3 = (A)-[:IS_MEMEBR {since:20050515}]->(TheLiterarySociety),
M4 = (W)-[:IS_MEMEBR {since:20090401}]->(TheGolfClub),
M5 = (C)-[:IS_MEMEBR {since:20140909}]->(TheGolfClub)
RETURN M1,M2,M3,M4,M5;

MATCH (A:Person), (R:Person), (C:Person), (W:Person),(E: Committee),(M: Committee)
WHERE R.ID=100 AND A.ID=200 AND W.ID=300 AND C.ID=400 AND E.name="Executive Committee"
	AND M.name="Membership Committee"
CREATE
R1 = (A)-[:PRESIDENT]->(E),
R2 = (W)-[:VICE_PRESIDENT]->(M),
R3 = (W)-[:MEMBER]->(E),
R4 = (C)-[:VICE_PRESIDENT]->(E)
RETURN R1,R2,R3,R4;

// Query 1
MATCH (p:Person)-[r1:IS_MEMEBR]-> (TheLiterarySociety: Organization {Name:"The Literary Society"})
RETURN r1.since,p.name;

// Query 2
MATCH (p:Person)-[r1:IS_MEMEBR]-> (TheGolfClub: Organization {Name:"The Golf Club"})
RETURN r1.since,p.name
order by r1.since asc;

// Query 3
MATCH (p:Person)—[:IS_FRIEND_OF]->(q:Person)
return p.name,q.name;

// Query 4
MATCH 
(TheGolfClub: Organization {Name:"The Golf Club"})-[:HAS_COMMITTEE]->(C:Committee)<-[r]-(s:Person)
return s.name AS Name ,C.name AS Committee_Name,type(r) AS Role;

// Query 5
MATCH (TheGolfClub: Organization {Name:"The Golf Club"})-[:HAS_COMMITTEE]-> (E: Committee {name:"Executive Committee"})<-[r]-(s:Person) return s.name AS Name,type(r) AS Role;

// Query 6
MATCH (p:Person)-[r1:IS_MEMEBR]-> (TheGolfClub: Organization {Name:"The Golf Club"})
RETURN r1.since AS Date_Joined,p.name AS Member_Name
ORDER BY r1.since asc
LIMIT 1;

// Query 7
MATCH (P:Person)-[r1:IS_MEMEBR]->(O:Organization)
WITH P, count(r1) AS no
WHERE no > 1
return  P.name;
