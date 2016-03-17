# Usage:
#  glpsol --check -m profrodun2016.mod -d profrodun2016.dat --wlp proftafla.lp
#  gurobi_cl TimeLimit=3600 ResultFile=proftafla.sol proftafla.lp

set CidExam; # Set of courses
set Group{1..61} within CidExam; # Defined programs (namsbrautir/leidir)

param n := 11; # Number of exam days
set ExamSlots := 1..(2*n); # Exam-slots (profstokkar)

param cidExamslot2016{CidExam}; # Solution of the University of Iceland, for comparison

param cidCount{CidExam} default 0; # Amount of students in each course
param cidCommon{CidExam, CidExam} default 0; # Amount of students that take co-taught courses

var Slot{CidExam, ExamSlots} binary; # Variable

# This constraint is used to coerce the solution to be the same as the one of the University
subject to LookAtSolution{e in ExamSlots, c in CidExam:
                          cidExamslot2016[c] == e}:  Slot[c,e] = 1;

# Does the exam table for 2016 fulfil the demands for programs:
check {i in 1..61, c1 in Group[i], c2 in Group[i]: cidCommon[c1,c2] > 0}
                             cidExamslot2016[c1] <> cidExamslot2016[c2];
# Does the exam table for 2016 fulfil the demands for joined students:
check {c1 in CidExam, c2 in CidExam: cidCommon[c1,c2] > 0}
                             cidExamslot2016[c1] <> cidExamslot2016[c2];

solve;

# Check how many students are in each exam-slot...
for {e in ExamSlots} {
  printf : "Amount of students in exam-slot %d are %d\n", e, sum{c in CidExam}
                                                Slot[c,e] * cidCount[c];
}

end;
/*
Here is the solution of the University:
Number	Course	Amount	Date
EFN205G	Efnafr��i II (EFN214G)	22	M�n. 25 apr. 2016 kl. 09:00 - 12:00
EFN214G	L�fr�n efnafr��i L (EFN205G)	54	M�n. 25 apr. 2016 kl. 09:00 - 12:00
HBV401G	�r�un hugb�na�ar	122	M�n. 25 apr. 2016 kl. 09:00 - 12:00
LEF406G	L�fefnafr��i 2	43	M�n. 25 apr. 2016 kl. 09:00 - 12:00
STA202G	Mengi og fir�r�m	21	M�n. 25 apr. 2016 kl. 09:00 - 12:00
VEL601G	Varmaflutningsfr��i	53	M�n. 25 apr. 2016 kl. 09:00 - 12:00
BYG603G	Framkv�mdafr��i 1	18	M�n. 25 apr. 2016 kl. 13:30 - 16:30
FER603M	N�sk�pun � fer�a�j�nustu	62	M�n. 25 apr. 2016 kl. 13:30 - 16:30
JAR418G	J�klafr��i	22	M�n. 25 apr. 2016 kl. 13:30 - 16:30
RAF403G	Rafeindat�kni 1	14	M�n. 25 apr. 2016 kl. 13:30 - 16:30
IDN209F	Slembin ferli og �kvar�anafr��i	15	�ri. 26 apr. 2016 kl. 09:00 - 12:00
JAR253F	Jar�efnafr��i hinnar f�stu jar�ar	10	�ri. 26 apr. 2016 kl. 09:00 - 12:00
LEF617M	Efnafr��i ens�ma	6	�ri. 26 apr. 2016 kl. 09:00 - 12:00
LIF412M	Sameindaerf�afr��i	15	�ri. 26 apr. 2016 kl. 09:00 - 12:00
TOL203F	Reiknirit, r�kfr��i og reiknanleiki	10	�ri. 26 apr. 2016 kl. 09:00 - 12:00
UMV213F	Vatnsaflsvirkjanir	10	�ri. 26 apr. 2016 kl. 09:00 - 12:00
LAN203G	T�lfr��i (ST�209G)	106	�ri. 26 apr. 2016 kl. 13:30 - 16:30
STA209G	T�lfr��i og gagnavinnsla (LAN203G)	130	�ri. 26 apr. 2016 kl. 13:30 - 16:30
STA405G	T�luleg greining	169	�ri. 26 apr. 2016 kl. 13:30 - 16:30
TOL203G	T�lvunarfr��i 2	279	Mi�. 27 apr. 2016 kl. 09:00 - 12:00
UAU214M	Verndunarl�ffr��i	22	Mi�. 27 apr. 2016 kl. 09:00 - 12:00
BYG201G	Greining bur�arvirkja 1	19	Mi�. 27 apr. 2016 kl. 13:30 - 16:30
EDL403G	Frumeinda- og lj�sfr��i	13	Mi�. 27 apr. 2016 kl. 13:30 - 16:30
LAN604M	Borgalandfr��i	25	Mi�. 27 apr. 2016 kl. 13:30 - 16:30
LIF401G	�roskunarfr��i	44	Mi�. 27 apr. 2016 kl. 13:30 - 16:30
VEL202G	Bur�ar�olsfr��i	88	Mi�. 27 apr. 2016 kl. 13:30 - 16:30
EFN410G	E�lisefnafr��i B	23	Fim. 28 apr. 2016 kl. 09:00 - 12:00
JAR211G	Steindafr��i	20	Fim. 28 apr. 2016 kl. 09:00 - 12:00
JAR417G	Eldfjallafr��i	57	Fim. 28 apr. 2016 kl. 09:00 - 12:00
RAF401G	Greining og uppbygging r�sa	15	Fim. 28 apr. 2016 kl. 09:00 - 12:00
RAF616M	�r��laus fjarskipti	8	Fim. 28 apr. 2016 kl. 09:00 - 12:00
STA403M	Algebra III	14	Fim. 28 apr. 2016 kl. 09:00 - 12:00
TOL401G	St�rikerfi	117	Fim. 28 apr. 2016 kl. 09:00 - 12:00
IDN403G	Varma- og varmaflutningsfr��i	28	Fim. 28 apr. 2016 kl. 13:30 - 16:30
LIF201G	�rverufr��i	90	Fim. 28 apr. 2016 kl. 13:30 - 16:30
REI202M	�l�nuleg bestun	36	Fim. 28 apr. 2016 kl. 13:30 - 16:30
REI201G	St�r�fr��i og reiknifr��i	97	F�s. 29 apr. 2016 kl. 09:00 - 12:00
STA207G	St�r�fr��igreining IIA	20	F�s. 29 apr. 2016 kl. 09:00 - 12:00
STA401G	St�r�fr��igreining IV	100	F�s. 29 apr. 2016 kl. 09:00 - 12:00
FER210F	Kenningar � fer�am�lafr��i (FER409G)	4	F�s. 29 apr. 2016 kl. 13:30 - 16:30
FER409G	Kenningar � fer�am�lafr��i (FER210F)	61	F�s. 29 apr. 2016 kl. 13:30 - 16:30
HBV601G	Hugb�na�arverkefni 2	91	F�s. 29 apr. 2016 kl. 13:30 - 16:30
LIF227F	Skord�r (L�F633G)	1	F�s. 29 apr. 2016 kl. 13:30 - 16:30
LIF633G	Skord�r (L�F227F)	17	F�s. 29 apr. 2016 kl. 13:30 - 16:30
STA205G	St�r�fr��igreining II	262	F�s. 29 apr. 2016 kl. 13:30 - 16:30
BYG401G	Reiknileg aflfr��i 1	17	M�n. 02 mai. 2016 kl. 09:00 - 12:00
EDL402G	Varmafr��i 1	38	M�n. 02 mai. 2016 kl. 09:00 - 12:00
EFN406G	L�fr�n efnafr��i 2	76	M�n. 02 mai. 2016 kl. 09:00 - 12:00
IDN603G	I�na�art�lfr��i	43	M�n. 02 mai. 2016 kl. 09:00 - 12:00
JED201G	Almenn jar�e�lisfr��i	37	M�n. 02 mai. 2016 kl. 09:00 - 12:00
LIF635G	Atferlisfr��i	10	M�n. 02 mai. 2016 kl. 09:00 - 12:00
MAS201F	L�kindareikningur og t�lfr��i (HAG206G,ST�203G)	15	M�n. 02 mai. 2016 kl. 13:30 - 16:30
STA203G	L�kindareikningur og t�lfr��i (HAG206G,MAS201F)	307	M�n. 02 mai. 2016 kl. 13:30 - 16:30
TOV602M	Verkfr��i �greyptra kerfa	7	M�n. 02 mai. 2016 kl. 13:30 - 16:30
BYG601G	H�sager�	22	�ri. 03 mai. 2016 kl. 09:00 - 12:00
EDL204G	E�lisfr��i allt umkring	4	�ri. 03 mai. 2016 kl. 09:00 - 12:00
EFN404G	�l�fr�n efnafr��i 2	10	�ri. 03 mai. 2016 kl. 09:00 - 12:00
JAR617G	J�klajar�fr��i	41	�ri. 03 mai. 2016 kl. 09:00 - 12:00
LAN205G	Listin a� fer�ast	101	�ri. 03 mai. 2016 kl. 09:00 - 12:00
LIF243F	D�ral�fe�lisfr��i fyrir framhaldsnema (L�F410G)	2	�ri. 03 mai. 2016 kl. 09:00 - 12:00
LIF410G	D�ral�fe�lisfr��i (L�F243F)	26	�ri. 03 mai. 2016 kl. 09:00 - 12:00
RAF601G	Rafmagnsv�lar 1	7	�ri. 03 mai. 2016 kl. 09:00 - 12:00
UAU206M	Umhverfishagfr��i	22	�ri. 03 mai. 2016 kl. 09:00 - 12:00
VEL218F	Bein n�ting jar�hita	23	�ri. 03 mai. 2016 kl. 09:00 - 12:00
EDL612M	St�r�fr��ileg e�lisfr��i	3	�ri. 03 mai. 2016 kl. 13:30 - 16:30
IDN401G	A�ger�agreining	113	�ri. 03 mai. 2016 kl. 13:30 - 16:30
LIF214G	D�rafr��i - hryggleysingjar	49	�ri. 03 mai. 2016 kl. 13:30 - 16:30
HBV201G	Vi�m�tsforritun	216	Mi�. 04 mai. 2016 kl. 09:00 - 12:00
JAR202G	Ytri �fl jar�ar	25	Mi�. 04 mai. 2016 kl. 09:00 - 12:00
LEF616M	Bygging og eiginleikar pr�teina	10	Mi�. 04 mai. 2016 kl. 09:00 - 12:00
LIF615M	Gr��urr�ki �slands og jar�vegur	19	Mi�. 04 mai. 2016 kl. 09:00 - 12:00
RAF201G	Greining r�sa	38	Mi�. 04 mai. 2016 kl. 09:00 - 12:00
UMV203G	Jar�fr��i fyrir verkfr��inga	23	Mi�. 04 mai. 2016 kl. 09:00 - 12:00
VEL402G	V�lhlutafr��i	26	Mi�. 04 mai. 2016 kl. 09:00 - 12:00
EDL401G	Rafsegulfr��i 1 (RAF402G)	24	Mi�. 04 mai. 2016 kl. 13:30 - 16:30
EFN202G	Almenn efnafr��i 2	151	Mi�. 04 mai. 2016 kl. 13:30 - 16:30
LAN209F	Fer�amennska og umhverfi (LAN410G)	4	Mi�. 04 mai. 2016 kl. 13:30 - 16:30
LAN219G	Inngangur a� ve�ur-og ve�urfarsfr��i	14	Mi�. 04 mai. 2016 kl. 13:30 - 16:30
LAN410G	Fer�amennska og umhverfi (LAN209F)	62	Mi�. 04 mai. 2016 kl. 13:30 - 16:30
RAF402G	Rafsegulfr��i (E�L401G)	12	Mi�. 04 mai. 2016 kl. 13:30 - 16:30
TOL202M	���endur	42	Mi�. 04 mai. 2016 kl. 13:30 - 16:30
FER208G	Fyrirt�ki og stofnanir fer�a�j�nustunnar	99	F�s. 06 mai. 2016 kl. 09:00 - 12:00
JAR212G	Almenn jar�efnafr��i	24	F�s. 06 mai. 2016 kl. 09:00 - 12:00
JAR415G	Au�lindir og umhverfisjar�fr��i	20	F�s. 06 mai. 2016 kl. 09:00 - 12:00
LIF403G	�r�unarfr��i	64	F�s. 06 mai. 2016 kl. 09:00 - 12:00
TOL403G	Greining reiknirita	141	F�s. 06 mai. 2016 kl. 09:00 - 12:00
UMV203M	Vatns- og fr�veitur	11	F�s. 06 mai. 2016 kl. 09:00 - 12:00
BYG202M	Steinsteypuvirki 1	9	F�s. 06 mai. 2016 kl. 13:30 - 16:30
BYG203M	Vegager�	4	F�s. 06 mai. 2016 kl. 13:30 - 16:30
EDL201G	E�lisfr��i 2 V (E�L206G)	142	F�s. 06 mai. 2016 kl. 13:30 - 16:30
EDL206G	E�lisfr��i 2 R (E�L201G)	26	F�s. 06 mai. 2016 kl. 13:30 - 16:30
EDL402M	Inngangur a� stjarne�lisfr��i	5	F�s. 06 mai. 2016 kl. 13:30 - 16:30
EFN207G	Notkun st�r�fr��i og e�lisfr��i � efnafr��i	10	F�s. 06 mai. 2016 kl. 13:30 - 16:30
HBV203F	G��astj�rnun � hugb�na�arger�	11	F�s. 06 mai. 2016 kl. 13:30 - 16:30
STA418M	Grundv�llur l�kindafr��innar	13	F�s. 06 mai. 2016 kl. 13:30 - 16:30
EFN208G	Efnagreining	88	M�n. 09 mai. 2016 kl. 09:00 - 12:00
IDN402G	Hermun	35	M�n. 09 mai. 2016 kl. 09:00 - 12:00
JAR619G	Hafi� � t�mum hnattr�nna breytinga	12	M�n. 09 mai. 2016 kl. 09:00 - 12:00
LIF215G	L�fm�lingar I	50	M�n. 09 mai. 2016 kl. 09:00 - 12:00
TOV201G	Greining og h�nnun stafr�nna r�sa	219	M�n. 09 mai. 2016 kl. 09:00 - 12:00
VEL401G	Sveiflufr��i	25	M�n. 09 mai. 2016 kl. 09:00 - 12:00
BYG201M	St�lvirki 1	7	M�n. 09 mai. 2016 kl. 13:30 - 16:30
EDL205G	E�lisfr��i r�ms og t�ma	22	M�n. 09 mai. 2016 kl. 13:30 - 16:30
EFN408G	Efnagreiningart�kni	51	M�n. 09 mai. 2016 kl. 13:30 - 16:30
FER211F	Skipulag og stefnum�tun � fer�amennsku (FER609G)	4	M�n. 09 mai. 2016 kl. 13:30 - 16:30
FER609G	Skipulag og stefnum�tun � fer�amennsku (FER211F)	14	M�n. 09 mai. 2016 kl. 13:30 - 16:30
HBV402G	�r�un hugb�na�ar A	51	M�n. 09 mai. 2016 kl. 13:30 - 16:30
JAR611G	Umhverfisjar�efnafr��i	18	M�n. 09 mai. 2016 kl. 13:30 - 16:30
LAN401G	Sj�narhorn landfr��innar	8	M�n. 09 mai. 2016 kl. 13:30 - 16:30
LIF614M	Frumul�ffr��i II	21	M�n. 09 mai. 2016 kl. 13:30 - 16:30
RAF404G	L�kindaa�fer�ir	14	M�n. 09 mai. 2016 kl. 13:30 - 16:30
STA411G	Grannfr��i	20	M�n. 09 mai. 2016 kl. 13:30 - 16:30
UMV201G	Vatnafr��i	16	M�n. 09 mai. 2016 kl. 13:30 - 16:30
EFN612M	Litr�fsgreiningar sameinda og hvarfgangur efnahvarfa	9	�ri. 10 mai. 2016 kl. 09:00 - 12:00
TOL203M	T�lvugraf�k	94	�ri. 10 mai. 2016 kl. 09:00 - 12:00
VEL201G	T�lvuteikning og framsetning	89	�ri. 10 mai. 2016 kl. 09:00 - 12:00
VEL215F	T�lvuv�dd varma- og straumfr��i	13	�ri. 10 mai. 2016 kl. 09:00 - 12:00
EDL203G	E�lisfr��i 2a	16	�ri. 10 mai. 2016 kl. 13:30 - 16:30
VEL405G	Orkuferli	7	�ri. 10 mai. 2016 kl. 13:30 - 16:30
*/
