# Usage:
#  glpsol --check -m proftafla2016.mod -d profrodun2016.dat
#  glpsol -m profrodun2016.mod -d profrodun2016.dat --wlp proftafla.lp
#  gurobi_cl TimeLimit=3600 ResultFile=proftafla.sol proftafla.lp

set cidExam; # Set of courses
set group{1..61} within cidExam; # Defined programs (namsbrautir/leidir)
#set noExamDays;

param n := 16; # Number of days in the exam period
set examSlots := 1..(2*n); # Exam-slots (profstokkar)
set offSlots; #Set of slots that belong to off Days

param cidExamslot2016{cidExam}; # Solution of the University of Iceland, for comparison
param ourBasicSolution{cidExam}; # Calculated solution with 3 basic constraint
param solutionWithoutSeats{cidExam}; # Calculated solution without seat constraint

param cidCount{cidExam} default 0; # Amount of students in each course
param cidCommon{cidExam, cidExam} default 0; # Amount of students that take co-taught courses
param conjoinedCourses{cidExam, cidExam} default 0; # Vector containing courses that are taught jointly

param studentsTolerance := 2;


var slot{cidExam, examSlots} binary; # Variable

# This constraint is used to coerce the solution to be the same as the one of the University
#subject to lookAtSolution{e in examSlots, c in cidExam:
                          #cidExamslot2016[c] == e}:  slot[c,e] = 1;

# This constraint its used to coerce the solution to be one of our own solutions
# subject to coerceSolution{e in examSlots, c in cidExam:
#  solutionWithoutSeats[c] == e}: slot[c,e] = 1;

#minimize totalSlots: sum{c in cidExam, e in examSlots} slot[c,e]*(e^8);

# Courses with the most students have exams in the beginning of exam period
minimize totalSlots: sum{c in cidExam, e in examSlots} slot[c,e]*(cidCount[c]*(e^2))^4;

# Ensure that no students have exams in two different courses at the same time
 subject to examClashes{c1 in cidExam, c2 in cidExam, e in examSlots: cidCommon[c1, c2] > 0}: slot[c1,e]+slot[c2,e] <= 1;

# Ensure that each course has exactly one exam in the table
 subject to hasExam{c in cidExam}:sum{e in examSlots}slot[c,e] = 1;

# Ensure that all students assigned to slot have a seat to take an exam
 subject to maxInSlot{e in examSlots}:sum{c in cidExam}slot[c,e]*cidCount[c] <= 450;

# Conjoined courses have exams in same slot
 subject to jointlyTaught{c1 in cidExam, c2 in cidExam, e in examSlots: conjoinedCourses[c1,c2] <>0}:slot[c1,e]=slot[c2,e];

#Ensure that there are no exams on weekends and holidays
subject to noExams{c in cidExam, e in examSlots: e in offSlots}: slot[c,e] = 0;

#Ensure that a student is not in exam slots side by side
subject to examSpace{e in examSlots, c1 in cidExam, c2 in cidExam: cidCommon[c1, c2] >= studentsTolerance && e+1 in examSlots}: slot[c1,e]+slot[c2, e+1] <= 1;

# Does the exam table for 2016 fulfil the demands for programs:
check {i in 1..61, c1 in group[i], c2 in group[i]: cidCommon[c1,c2] > 0}
                             cidExamslot2016[c1] <> cidExamslot2016[c2];
# Does the exam table for 2016 fulfil the demands for joined students:
check {c1 in cidExam, c2 in cidExam: cidCommon[c1,c2] > 0}
                             cidExamslot2016[c1] <> cidExamslot2016[c2];

solve;

# Check how many students are in each exam-slot...
for {e in examSlots} {
  printf : "Amount of students in exam-slot %d are %d\n", e, sum{c in cidExam}
                                                slot[c,e] * cidCount[c];
}

end;
/*
Here is the solution of the University:
Number	Course	Amount	Date
EFN205G	Efnafraei II (EFN214G)	22	Man. 25 apr. 2016 kl. 09:00 - 12:00
EFN214G	Lifraen efnafraedi L (EFN205G)	54	Man. 25 apr. 2016 kl. 09:00 - 12:00
HBV401G	Throun hugbunadar	122	Man. 25 apr. 2016 kl. 09:00 - 12:00
LEF406G	Lifefnafraedi 2	43	Man. 25 apr. 2016 kl. 09:00 - 12:00
STA202G	Mengi og firdrum	21	Man. 25 apr. 2016 kl. 09:00 - 12:00
VEL601G	Varmaflutningsfraedi	53	Man. 25 apr. 2016 kl. 09:00 - 12:00
BYG603G	Framkvaemdafraedi 1	18	Man. 25 apr. 2016 kl. 13:30 - 16:30
FER603M	Nyskopun i ferdathjonustu	62	Man. 25 apr. 2016 kl. 13:30 - 16:30
JAR418G	Joklafraedi	22	Man. 25 apr. 2016 kl. 13:30 - 16:30
RAF403G	Rafeindataekni 1	14	Man. 25 apr. 2016 kl. 13:30 - 16:30
IDN209F	Slembin ferli og akvardanafraedi	15	Tri. 26 apr. 2016 kl. 09:00 - 12:00
JAR253F	Jardefnafraedi hinnar fostu jardar	10	Tri. 26 apr. 2016 kl. 09:00 - 12:00
LEF617M	Efnafraedi ensima	6	Tri. 26 apr. 2016 kl. 09:00 - 12:00
LIF412M	Sameindaerfdafraedi	15	Tri. 26 apr. 2016 kl. 09:00 - 12:00
TOL203F	Reiknirit, rokfraedi og reiknanleiki	10	Tri. 26 apr. 2016 kl. 09:00 - 12:00
UMV213F	Vatnsaflsvirkjanir	10	Tri. 26 apr. 2016 kl. 09:00 - 12:00
LAN203G	Tolfraedi (STA209G)	106	Tri. 26 apr. 2016 kl. 13:30 - 16:30
STA209G	Tolfraedi og gagnavinnsla (LAN203G)	130	Tri. 26 apr. 2016 kl. 13:30 - 16:30
STA405G	Toluleg greining	169	Tri. 26 apr. 2016 kl. 13:30 - 16:30
TOL203G	Tolvunarfraedi 2	279	Mid. 27 apr. 2016 kl. 09:00 - 12:00
UAU214M	Verndunarliffraedi	22	Mid. 27 apr. 2016 kl. 09:00 - 12:00
BYG201G	Greining burdarvirkja 1	19	Mid. 27 apr. 2016 kl. 13:30 - 16:30
EDL403G	Frumeinda- og ljosfraedi	13	Mid. 27 apr. 2016 kl. 13:30 - 16:30
LAN604M	Borgalandfraedi	25	Mid. 27 apr. 2016 kl. 13:30 - 16:30
LIF401G	Throskunarfraedi	44	Mid. 27 apr. 2016 kl. 13:30 - 16:30
VEL202G	Burdartholsfraedi	88	Mid. 27 apr. 2016 kl. 13:30 - 16:30
EFN410G	Edlisefnafraedi B	23	Fim. 28 apr. 2016 kl. 09:00 - 12:00
JAR211G	Steindafraedi	20	Fim. 28 apr. 2016 kl. 09:00 - 12:00
JAR417G	Eldfjallafraedi	57	Fim. 28 apr. 2016 kl. 09:00 - 12:00
RAF401G	Greining og uppbygging rasa	15	Fim. 28 apr. 2016 kl. 09:00 - 12:00
RAF616M	Thradlaus fjarskipti	8	Fim. 28 apr. 2016 kl. 09:00 - 12:00
STA403M	Algebra III	14	Fim. 28 apr. 2016 kl. 09:00 - 12:00
TOL401G	Styrikerfi	117	Fim. 28 apr. 2016 kl. 09:00 - 12:00
IDN403G	Varma- og Varmaflutningsfraedi	28	Fim. 28 apr. 2016 kl. 13:30 - 16:30
LIF201G	Orverufraedi	90	Fim. 28 apr. 2016 kl. 13:30 - 16:30
REI202M	Olinuleg bestun	36	Fim. 28 apr. 2016 kl. 13:30 - 16:30
REI201G	Staerdfraedi og reiknifraedi	97	Fos. 29 apr. 2016 kl. 09:00 - 12:00
STA207G	Staerdfraedigreining IIA	20	Fos. 29 apr. 2016 kl. 09:00 - 12:00
STA401G	Staerdfraedigreining IV	100	Fos. 29 apr. 2016 kl. 09:00 - 12:00
FER210F	Kenningar i ferdamalafraedi (FER409G)	4	Fos. 29 apr. 2016 kl. 13:30 - 16:30
FER409G	Kenningar i ferdamalafraedi (FER210F)	61	Fos. 29 apr. 2016 kl. 13:30 - 16:30
HBV601G	Hugbunadarverkefni 2	91	Fos. 29 apr. 2016 kl. 13:30 - 16:30
LIF227F	Skordur (LIF633G)	1	Fos. 29 apr. 2016 kl. 13:30 - 16:30
LIF633G	Skordur (LIF227F)	17	Fos. 29 apr. 2016 kl. 13:30 - 16:30
STA205G	Stzerdfraedigreining II	262	Fos. 29 apr. 2016 kl. 13:30 - 16:30
BYG401G	Reiknileg aflfraedi 1	17	Man. 02 mai. 2016 kl. 09:00 - 12:00
EDL402G	Varmafraedi 1	38	Man. 02 mai. 2016 kl. 09:00 - 12:00
EFN406G	Lifraen efnafraedi 2	76	Man. 02 mai. 2016 kl. 09:00 - 12:00
IDN603G	Idnadartolfraedi	43	Man. 02 mai. 2016 kl. 09:00 - 12:00
JED201G	Almenn Joklafraediedlisfraedi	37	Man. 02 mai. 2016 kl. 09:00 - 12:00
LIF635G	Atferlisfraedi	10	Man. 02 mai. 2016 kl. 09:00 - 12:00
MAS201F	Likindareikningur og tolfraedi (HAG206G,STA203G)	15	Man. 02 mai. 2016 kl. 13:30 - 16:30
STA203G	Likindareikningur og tolfraedi (HAG206G,MAS201F)	307	Man. 02 mai. 2016 kl. 13:30 - 16:30
TOV602M	Verkfraedi igreyptra kerfa	7	Man. 02 mai. 2016 kl. 13:30 - 16:30
BYG601G	Husagerd	22	Tri. 03 mai. 2016 kl. 09:00 - 12:00
EDL204G	Edlisfraedi allt umkring	4	Tri. 03 mai. 2016 kl. 09:00 - 12:00
EFN404G	Olifraen efnafraedi 2	10	Tri. 03 mai. 2016 kl. 09:00 - 12:00
JAR617G	Joklajardfraedi	41	Tri. 03 mai. 2016 kl. 09:00 - 12:00
LAN205G	Listin ad ferdast	101	Tri. 03 mai. 2016 kl. 09:00 - 12:00
LIF243F	Dyralifedlisfraedi fyrir framhaldsnema (LIF410G)	2	Tri. 03 mai. 2016 kl. 09:00 - 12:00
LIF410G	Dyralifedlisfraedi (LIF243F)	26	Tri. 03 mai. 2016 kl. 09:00 - 12:00
RAF601G	Rafmagnsvelar 1	7	Tri. 03 mai. 2016 kl. 09:00 - 12:00
UAU206M	Umhverfishagfraedi	22	Tri. 03 mai. 2016 kl. 09:00 - 12:00
VEL218F	Bein nyting jardhita	23	Tri. 03 mai. 2016 kl. 09:00 - 12:00
EDL612M	Staerdfraedileg edlisfraedi	3	Tri. 03 mai. 2016 kl. 13:30 - 16:30
IDN401G	Adgerdagreining	113	Tri. 03 mai. 2016 kl. 13:30 - 16:30
LIF214G	Dyrafraedi - hryggleysingjar	49	Tri. 03 mai. 2016 kl. 13:30 - 16:30
HBV201G	Vidmotsforritun	216	Mid. 04 mai. 2016 kl. 09:00 - 12:00
JAR202G	Ytri ofl jardar	25	Mid. 04 mai. 2016 kl. 09:00 - 12:00
LEF616M	Bygging og eiginleikar proteina	10	Mid. 04 mai. 2016 kl. 09:00 - 12:00
LIF615M	Grodurriki Islands og jardvegur	19	Mid. 04 mai. 2016 kl. 09:00 - 12:00
RAF201G	Greining rasa	38	Mid. 04 mai. 2016 kl. 09:00 - 12:00
UMV203G	Jardfraedi fyrir verkfraedinga	23	Mid. 04 mai. 2016 kl. 09:00 - 12:00
VEL402G	Velhlutafraedi	26	Mid. 04 mai. 2016 kl. 09:00 - 12:00
EDL401G	Rafsegulfraedi 1 (RAF402G)	24	Mid. 04 mai. 2016 kl. 13:30 - 16:30
EFN202G	Almenn efnafraedi 2	151	Mid. 04 mai. 2016 kl. 13:30 - 16:30
LAN209F	Ferdamennska og umhverfi (LAN410G)	4	Mid. 04 mai. 2016 kl. 13:30 - 16:30
LAN219G	Inngangur ad vedur-og vedurfarsfraedi	14	Mid. 04 mai. 2016 kl. 13:30 - 16:30
LAN410G	Ferdamennska og umhverfi (LAN209F)	62	Mid. 04 mai. 2016 kl. 13:30 - 16:30
RAF402G	Rafsegulfraedi (EDL401G)	12	Mid. 04 mai. 2016 kl. 13:30 - 16:30
TOL202M	Thydendur	42	Mid. 04 mai. 2016 kl. 13:30 - 16:30
FER208G	Fyrirtdki og stofnanir ferdathjonustunnar	99	Fos. 06 mai. 2016 kl. 09:00 - 12:00
JAR212G	Almenn jardefnafraedi	24	Fos. 06 mai. 2016 kl. 09:00 - 12:00
JAR415G	Audlindir og umhverfisjardfraedi	20	Fos. 06 mai. 2016 kl. 09:00 - 12:00
LIF403G	Trounarfraedi	64	Fos. 06 mai. 2016 kl. 09:00 - 12:00
TOL403G	Greining reiknirita	141	Fos. 06 mai. 2016 kl. 09:00 - 12:00
UMV203M	Vatns- og fraveitur	11	Fos. 06 mai. 2016 kl. 09:00 - 12:00
BYG202M	Steinsteypuvirki 1	9	Fos. 06 mai. 2016 kl. 13:30 - 16:30
BYG203M	Vegagerd	4	Fos. 06 mai. 2016 kl. 13:30 - 16:30
EDL201G	Edlisfraedi 2 V (EDL206G)	142	Fos. 06 mai. 2016 kl. 13:30 - 16:30
EDL206G	Edlisfraedi 2 R (EDL201G)	26	Fos. 06 mai. 2016 kl. 13:30 - 16:30
EDL402M	Inngangur ad stjarnedlisfraedi	5	Fos. 06 mai. 2016 kl. 13:30 - 16:30
EFN207G	Notkun Staerdfraedi og edlisfraedi i efnafraedi	10	Fos. 06 mai. 2016 kl. 13:30 - 16:30
HBV203F	Gaedastjornun i hugbunadargerd	11	Fos. 06 mai. 2016 kl. 13:30 - 16:30
STA418M	Grundvollur likindafraedinnar	13	Fos. 06 mai. 2016 kl. 13:30 - 16:30
EFN208G	Efnagreining	88	Man. 09 mai. 2016 kl. 09:00 - 12:00
IDN402G	Hermun	35	Man. 09 mai. 2016 kl. 09:00 - 12:00
JAR619G	Hafid i timum hnattraenna breytinga	12	Man. 09 mai. 2016 kl. 09:00 - 12:00
LIF215G	Lifmaelingar I	50	Man. 09 mai. 2016 kl. 09:00 - 12:00
TOV201G	Greining og honnun stafraenna rasa	219	Man. 09 mai. 2016 kl. 09:00 - 12:00
VEL401G	Sveiflufraedi	25	Man. 09 mai. 2016 kl. 09:00 - 12:00
BYG201M	Stalvirki 1	7	Man. 09 mai. 2016 kl. 13:30 - 16:30
EDL205G	Edlisfraedi rums og tima	22	Man. 09 mai. 2016 kl. 13:30 - 16:30
EFN408G	Efnagreiningartaekni	51	Man. 09 mai. 2016 kl. 13:30 - 16:30
FER211F	Skipulag og stefnumotun i ferdamennsku (FER609G)	4	Man. 09 mai. 2016 kl. 13:30 - 16:30
FER609G	Skipulag og stefnumotun i ferdamennsku (FER211F)	14	Man. 09 mai. 2016 kl. 13:30 - 16:30
HBV402G	Throun hugbunadar A	51	Man. 09 mai. 2016 kl. 13:30 - 16:30
JAR611G	Umhverfisjardefnafraedi	18	Man. 09 mai. 2016 kl. 13:30 - 16:30
LAN401G	Sjonarhorn landfraedinnar	8	Man. 09 mai. 2016 kl. 13:30 - 16:30
LIF614M	Frumuliffraedi II	21	Man. 09 mai. 2016 kl. 13:30 - 16:30
RAF404G	Likindaadferdir	14	Man. 09 mai. 2016 kl. 13:30 - 16:30
STA411G	Grannfraedi	20	Man. 09 mai. 2016 kl. 13:30 - 16:30
UMV201G	Vatnafraedi	16	Man. 09 mai. 2016 kl. 13:30 - 16:30
EFN612M	Litrofsgreiningar sameinda og hvarfgangur efnahvarfa	9	Tri. 10 mai. 2016 kl. 09:00 - 12:00
TOL203M	Tolvugrafik	94	Tri. 10 mai. 2016 kl. 09:00 - 12:00
VEL201G	Tolvuteikning og framsetning	89	Tri. 10 mai. 2016 kl. 09:00 - 12:00
VEL215F	Tolvuvaedd varma- og straumfraedi	13	Tri. 10 mai. 2016 kl. 09:00 - 12:00
EDL203G	Edlisfraedi 2a	16	Tri. 10 mai. 2016 kl. 13:30 - 16:30
VEL405G	Orkuferli	7	Tri. 10 mai. 2016 kl. 13:30 - 16:30
*/
