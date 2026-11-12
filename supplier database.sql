CREATE DATABASE Supplier;
USE Supplier;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(100) NOT NULL,
    color VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Catalog (
    sid INT NOT NULL,
    pid INT NOT NULL,
    cost DECIMAL(10, 2) NOT NULL CHECK (cost >= 0),
    PRIMARY KEY (sid, pid),
    CONSTRAINT fk_catalog_supplier
	FOREIGN KEY (sid) REFERENCES Supplier(sid)
	ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_catalog_parts
	FOREIGN KEY (pid) REFERENCES Parts(pid)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Supplier (sid, sname, city) VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

INSERT INTO Parts (pid, pname, color) VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

INSERT INTO Catalog (sid, pid, cost) VALUES
(10001, 20001, 10.00),
(10001, 20002, 10.00),
(10001, 20003, 30.00),
(10001, 20004, 10.00),
(10001, 20005, 10.00),
(10002, 20001, 10.00),
(10002, 20002, 20.00),
(10003, 20003, 30.00),
(10004, 20003, 40.00);

SELECT * FROM Catalog;

#3
select distinct P.pname from parts P join catalog C on P.pid=C.pid;

#4
SELECT S.sname
FROM Supplier S
JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname
HAVING COUNT(DISTINCT C.pid) = (SELECT COUNT(*) FROM Parts);

select s.sname from supplier s where not exists(select p.pid from parts p where p.pid not in (select c.pid from cataog ));

#5
SELECT S.sname
FROM Supplier S, Catalog C, Parts P
WHERE S.sid = C.sid
  AND C.pid = P.pid
  AND P.color = 'Red'
GROUP BY S.sid, S.sname
HAVING COUNT(DISTINCT P.pid) = (SELECT COUNT(*) FROM Parts WHERE color = 'Red');


 #7
 select distinct C1.sid from catalog C1 where C1.cost>(select avg(c2.cost) from catalog C2 where C2.pid=C1.pid);


#1
select P.pname, S.sname, C.cost from Parts P, Supplier S, Catalog C where P.pid = C.pid and S.sid = C.sid and C.cost = (select MAX(cost) from Catalog);

#2
select S.sname from Supplier S where S.sid NOT IN (select C.sid from Catalog C, Parts P where C.pid = P.pid and P.color = 'Red');

#3

#4
select S.sname  from Supplier S, Catalog C where S.sid = C.sid AND C.cost < 20 GROUP BY S.sid, S.sname HAVING COUNT(C.pid) >= 2;

#5
select C1.pid, P.pname, S.sname, C1.cost from Catalog C1, Parts P, Supplier S where C1.pid = P.pid AND C1.sid = S.sid AND C1.cost = (SELECT MIN(C2.cost) FROM Catalog C2 WHERE C2.pid =C1.pid) ORDER BY C1.pid;

