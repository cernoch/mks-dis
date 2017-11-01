#!/bin/bash

# This script imports DiagonalBenchmark.csv file into
# the SQLite3 database DiagonalBenchmark.sqlite.

rm -f Diagonal.sqlite
SQLite/sqlite3 Diagonal.sqlite <<-EOF
CREATE TABLE Poly (
seed INTEGER PRIMARY KEY,
p INTEGER,
dMax INTEGER,
availables INTEGER,
plain TEXT,
jump INTEGER,
gain INTEGER,
contour INTEGER,
plateau INTEGER,
qEst INTEGER,
qHat INTEGER,
sHat INTEGER,
pHit INTEGER,
fromzero INTEGER,
fzSAG INTEGER,
fzPur TEXT,
randomly INTEGER,
rdSAG INTEGER,
rdPur TEXT,
cleverly INTEGER,
clSAG INTEGER,
clPur TEXT,
greedyIG INTEGER,
grSAG INTEGER,
grPur TEXT,
bForceIG INTEGER,
bfSAG INTEGER,
bfPur TEXT);

CREATE VIEW Renamed AS SELECT plain,
randomly AS baseline,
cleverly AS sag,
greedyIG AS greedy,
bForceIG as exact
FROM Poly;

CREATE TABLE Sat (
p INTEGER,
d INTEGER,
CPU REAL,
keys INTEGER,
theory INTEGER);

CREATE TABLE MinGvl (
LockChart TEXT,
Algorithm TEXT,
Enterings INTEGER,
First REAL,
Optim REAL,
Finish REAL);

CREATE VIEW MinGvlCharts AS SELECT DISTINCT LockChart FROM MinGvl;

CREATE VIEW MinGvlResults AS
SELECT Main.LockChart
,SAT2.Enterings AS SAT2Enterings, SAT2.First AS SAT2First, SAT2.Optim AS SAT2Optim, SAT2.Finish AS SAT2Finish
,SAT4.Enterings AS SAT4Enterings, SAT4.First AS SAT4First, SAT4.Optim AS SAT4Optim, SAT4.Finish AS SAT4Finish 
,Lawer.Enterings AS LawerEnterings, Lawer.First AS LawerFirst, Lawer.Optim AS LawerOptim, Lawer.Finish AS LawerFinish
,AllD.Enterings AS AllDEnterings, AllD.First AS AllDFirst, AllD.Optim AS AllDOptim, AllD.Finish AS AllDFinish
,Impl10.Enterings AS Impl10Enterings, Impl10.First AS Impl10First, Impl10.Optim AS Impl10Optim, Impl10.Finish AS Impl10Finish
,Impl15.Enterings AS Impl15Enterings, Impl15.First AS Impl15First, Impl15.Optim AS Impl15Optim, Impl15.Finish AS Impl15Finish
,Impl30.Enterings AS Impl30Enterings, Impl30.First AS Impl30First, Impl30.Optim AS Impl30Optim, Impl30.Finish AS Impl30Finish
,Impl50.Enterings AS Impl50Enterings, Impl50.First AS Impl50First, Impl50.Optim AS Impl50Optim, Impl50.Finish AS Impl50Finish
FROM MinGvlCharts AS Main
LEFT JOIN MinGvl AS SAT2 ON Main.LockChart = SAT2.LockChart AND SAT2.Algorithm = "SAT2"
LEFT JOIN MinGvl AS SAT4 ON Main.LockChart = SAT4.LockChart AND SAT4.Algorithm = "SAT4"
LEFT JOIN MinGvl AS Lawer ON Main.LockChart = Lawer.LockChart AND Lawer.Algorithm = "Lawer"
LEFT JOIN MinGvl AS AllD ON Main.LockChart = AllD.LockChart AND AllD.Algorithm = "AllD"
LEFT JOIN MinGvl AS Impl10 ON Main.LockChart = Impl10.LockChart AND Impl10.Algorithm = "Impl10"
LEFT JOIN MinGvl AS Impl15 ON Main.LockChart = Impl15.LockChart AND Impl15.Algorithm = "Impl15"
LEFT JOIN MinGvl AS Impl30 ON Main.LockChart = Impl30.LockChart AND Impl30.Algorithm = "Impl30"
LEFT JOIN MinGvl AS Impl50 ON Main.LockChart = Impl50.LockChart AND Impl50.Algorithm = "Impl50";
EOF

{
echo "BEGIN TRANSACTION;";

HEADER=`cat PolyDiag.csv | head -1 | sed 's/; */,/g'`
cat PolyDiag.csv | { read; cat; } | sed 's/; */,/g'\
 | sed 's/\([a-z]\+\)/"\1"/g' | sed 's/?/NULL/g'\
 | sed "s/\(.*\)/INSERT INTO Poly ($HEADER) VALUES (\\1);/"

echo "END TRANSACTION;";



echo "BEGIN TRANSACTION;";

HEADER=`cat SatDiag.csv | head -1 | sed 's/; */,/g'`
cat SatDiag.csv | { read; cat; } | sed 's/; */,/g'\
 | sed 's/\([a-z]\+\)/"\1"/g' | sed 's/?/NULL/g'\
 | sed "s/\(.*\)/INSERT INTO Sat ($HEADER) VALUES (\\1);/"

echo "END TRANSACTION;";




echo "BEGIN TRANSACTION;";

HEADER=`cat MinGvlPredefined.csv | head -1 | sed 's/ //g' | sed 's/;/,/g'`
{
  cat MinGvlPredefined.csv | { read; cat; }
  cat MinGvlSynthetic.csv  | { read; cat; }
} | sed 's/ //g' | sed 's/; */,/g'\
  | sed 's/\([A-Za-z0-9]*[A-Za-z]\+[A-Za-z0-9]*\)/"\1"/g'\
  | sed "s/\(.*\)/INSERT INTO MinGvl ($HEADER) VALUES (\\1);/"

echo "END TRANSACTION;";

} | SQLite/sqlite3 Diagonal.sqlite

