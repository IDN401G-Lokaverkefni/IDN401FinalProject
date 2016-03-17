# Notkun:
#  glpsol --check -m profrodun2016.mod -d profrodun2016.dat --wlp proftafla.lp
#  gurobi_cl TimeLimit=3600 ResultFile=proftafla.sol proftafla.lp

set CidExam; # Mengi námskeiða
set Group{1..61} within CidExam; # Skilgreindar námsbrautir/leiðir

param n := 11; # fjöldi prófdaga
set ExamSlots := 1..(2*n); # Prófstokkar

param cidExamslot2016{CidExam}; # Lausn háskólans til samnburðar

param cidCount{CidExam} default 0; # fjöldi nema skráðir í námskeið
param cidCommon{CidExam, CidExam} default 0; # fjöldi nema sem taka sameiginleg námskeið

var Slot{CidExam, ExamSlots} binary; # ákvörðunarbreyta

# þessi skorða er notuð til að þvinga lausnina til að vera sú sama og lausn háskólans
subject to LookAtSolution{e in ExamSlots, c in CidExam: 
                          cidExamslot2016[c] == e}:  Slot[c,e] = 1;

# Uppfyllir próftaflan 2016 kröfur um námsleiðir:
check {i in 1..61, c1 in Group[i], c2 in Group[i]: cidCommon[c1,c2] > 0} 
                             cidExamslot2016[c1] <> cidExamslot2016[c2];
# Uppfyllir próftaflan 2016 kröfur um sameiginlega nema:
check {c1 in CidExam, c2 in CidExam: cidCommon[c1,c2] > 0} 
                             cidExamslot2016[c1] <> cidExamslot2016[c2];

solve;

# Skoðum hversu margir nemar eru í prófi í prófstokki ...
for {e in ExamSlots} {
  printf : "Fjöldi nema í prófstokki %d eru %d\n", e, sum{c in CidExam} 
                                                Slot[c,e] * cidCount[c];
}

end;
/*
Hér kemur lausn Háskólans:
Númer	Námskeið	Fjöldi	Dagsetning
EFN205G	Efnafræði II (EFN214G)	22	Mán. 25 apr. 2016 kl. 09:00 - 12:00
EFN214G	Lífræn efnafræði L (EFN205G)	54	Mán. 25 apr. 2016 kl. 09:00 - 12:00
HBV401G	Þróun hugbúnaðar	122	Mán. 25 apr. 2016 kl. 09:00 - 12:00
LEF406G	Lífefnafræði 2	43	Mán. 25 apr. 2016 kl. 09:00 - 12:00
STA202G	Mengi og firðrúm	21	Mán. 25 apr. 2016 kl. 09:00 - 12:00
VEL601G	Varmaflutningsfræði	53	Mán. 25 apr. 2016 kl. 09:00 - 12:00
BYG603G	Framkvæmdafræði 1	18	Mán. 25 apr. 2016 kl. 13:30 - 16:30
FER603M	Nýsköpun í ferðaþjónustu	62	Mán. 25 apr. 2016 kl. 13:30 - 16:30
JAR418G	Jöklafræði	22	Mán. 25 apr. 2016 kl. 13:30 - 16:30
RAF403G	Rafeindatækni 1	14	Mán. 25 apr. 2016 kl. 13:30 - 16:30
IDN209F	Slembin ferli og ákvarðanafræði	15	Þri. 26 apr. 2016 kl. 09:00 - 12:00
JAR253F	Jarðefnafræði hinnar föstu jarðar	10	Þri. 26 apr. 2016 kl. 09:00 - 12:00
LEF617M	Efnafræði ensíma	6	Þri. 26 apr. 2016 kl. 09:00 - 12:00
LIF412M	Sameindaerfðafræði	15	Þri. 26 apr. 2016 kl. 09:00 - 12:00
TOL203F	Reiknirit, rökfræði og reiknanleiki	10	Þri. 26 apr. 2016 kl. 09:00 - 12:00
UMV213F	Vatnsaflsvirkjanir	10	Þri. 26 apr. 2016 kl. 09:00 - 12:00
LAN203G	Tölfræði (STÆ209G)	106	Þri. 26 apr. 2016 kl. 13:30 - 16:30
STA209G	Tölfræði og gagnavinnsla (LAN203G)	130	Þri. 26 apr. 2016 kl. 13:30 - 16:30
STA405G	Töluleg greining	169	Þri. 26 apr. 2016 kl. 13:30 - 16:30
TOL203G	Tölvunarfræði 2	279	Mið. 27 apr. 2016 kl. 09:00 - 12:00
UAU214M	Verndunarlíffræði	22	Mið. 27 apr. 2016 kl. 09:00 - 12:00
BYG201G	Greining burðarvirkja 1	19	Mið. 27 apr. 2016 kl. 13:30 - 16:30
EDL403G	Frumeinda- og ljósfræði	13	Mið. 27 apr. 2016 kl. 13:30 - 16:30
LAN604M	Borgalandfræði	25	Mið. 27 apr. 2016 kl. 13:30 - 16:30
LIF401G	Þroskunarfræði	44	Mið. 27 apr. 2016 kl. 13:30 - 16:30
VEL202G	Burðarþolsfræði	88	Mið. 27 apr. 2016 kl. 13:30 - 16:30
EFN410G	Eðlisefnafræði B	23	Fim. 28 apr. 2016 kl. 09:00 - 12:00
JAR211G	Steindafræði	20	Fim. 28 apr. 2016 kl. 09:00 - 12:00
JAR417G	Eldfjallafræði	57	Fim. 28 apr. 2016 kl. 09:00 - 12:00
RAF401G	Greining og uppbygging rása	15	Fim. 28 apr. 2016 kl. 09:00 - 12:00
RAF616M	Þráðlaus fjarskipti	8	Fim. 28 apr. 2016 kl. 09:00 - 12:00
STA403M	Algebra III	14	Fim. 28 apr. 2016 kl. 09:00 - 12:00
TOL401G	Stýrikerfi	117	Fim. 28 apr. 2016 kl. 09:00 - 12:00
IDN403G	Varma- og varmaflutningsfræði	28	Fim. 28 apr. 2016 kl. 13:30 - 16:30
LIF201G	Örverufræði	90	Fim. 28 apr. 2016 kl. 13:30 - 16:30
REI202M	Ólínuleg bestun	36	Fim. 28 apr. 2016 kl. 13:30 - 16:30
REI201G	Stærðfræði og reiknifræði	97	Fös. 29 apr. 2016 kl. 09:00 - 12:00
STA207G	Stærðfræðigreining IIA	20	Fös. 29 apr. 2016 kl. 09:00 - 12:00
STA401G	Stærðfræðigreining IV	100	Fös. 29 apr. 2016 kl. 09:00 - 12:00
FER210F	Kenningar í ferðamálafræði (FER409G)	4	Fös. 29 apr. 2016 kl. 13:30 - 16:30
FER409G	Kenningar í ferðamálafræði (FER210F)	61	Fös. 29 apr. 2016 kl. 13:30 - 16:30
HBV601G	Hugbúnaðarverkefni 2	91	Fös. 29 apr. 2016 kl. 13:30 - 16:30
LIF227F	Skordýr (LÍF633G)	1	Fös. 29 apr. 2016 kl. 13:30 - 16:30
LIF633G	Skordýr (LÍF227F)	17	Fös. 29 apr. 2016 kl. 13:30 - 16:30
STA205G	Stærðfræðigreining II	262	Fös. 29 apr. 2016 kl. 13:30 - 16:30
BYG401G	Reiknileg aflfræði 1	17	Mán. 02 mai. 2016 kl. 09:00 - 12:00
EDL402G	Varmafræði 1	38	Mán. 02 mai. 2016 kl. 09:00 - 12:00
EFN406G	Lífræn efnafræði 2	76	Mán. 02 mai. 2016 kl. 09:00 - 12:00
IDN603G	Iðnaðartölfræði	43	Mán. 02 mai. 2016 kl. 09:00 - 12:00
JED201G	Almenn jarðeðlisfræði	37	Mán. 02 mai. 2016 kl. 09:00 - 12:00
LIF635G	Atferlisfræði	10	Mán. 02 mai. 2016 kl. 09:00 - 12:00
MAS201F	Líkindareikningur og tölfræði (HAG206G,STÆ203G)	15	Mán. 02 mai. 2016 kl. 13:30 - 16:30
STA203G	Líkindareikningur og tölfræði (HAG206G,MAS201F)	307	Mán. 02 mai. 2016 kl. 13:30 - 16:30
TOV602M	Verkfræði ígreyptra kerfa	7	Mán. 02 mai. 2016 kl. 13:30 - 16:30
BYG601G	Húsagerð	22	Þri. 03 mai. 2016 kl. 09:00 - 12:00
EDL204G	Eðlisfræði allt umkring	4	Þri. 03 mai. 2016 kl. 09:00 - 12:00
EFN404G	Ólífræn efnafræði 2	10	Þri. 03 mai. 2016 kl. 09:00 - 12:00
JAR617G	Jöklajarðfræði	41	Þri. 03 mai. 2016 kl. 09:00 - 12:00
LAN205G	Listin að ferðast	101	Þri. 03 mai. 2016 kl. 09:00 - 12:00
LIF243F	Dýralífeðlisfræði fyrir framhaldsnema (LÍF410G)	2	Þri. 03 mai. 2016 kl. 09:00 - 12:00
LIF410G	Dýralífeðlisfræði (LÍF243F)	26	Þri. 03 mai. 2016 kl. 09:00 - 12:00
RAF601G	Rafmagnsvélar 1	7	Þri. 03 mai. 2016 kl. 09:00 - 12:00
UAU206M	Umhverfishagfræði	22	Þri. 03 mai. 2016 kl. 09:00 - 12:00
VEL218F	Bein nýting jarðhita	23	Þri. 03 mai. 2016 kl. 09:00 - 12:00
EDL612M	Stærðfræðileg eðlisfræði	3	Þri. 03 mai. 2016 kl. 13:30 - 16:30
IDN401G	Aðgerðagreining	113	Þri. 03 mai. 2016 kl. 13:30 - 16:30
LIF214G	Dýrafræði - hryggleysingjar	49	Þri. 03 mai. 2016 kl. 13:30 - 16:30
HBV201G	Viðmótsforritun	216	Mið. 04 mai. 2016 kl. 09:00 - 12:00
JAR202G	Ytri öfl jarðar	25	Mið. 04 mai. 2016 kl. 09:00 - 12:00
LEF616M	Bygging og eiginleikar próteina	10	Mið. 04 mai. 2016 kl. 09:00 - 12:00
LIF615M	Gróðurríki Íslands og jarðvegur	19	Mið. 04 mai. 2016 kl. 09:00 - 12:00
RAF201G	Greining rása	38	Mið. 04 mai. 2016 kl. 09:00 - 12:00
UMV203G	Jarðfræði fyrir verkfræðinga	23	Mið. 04 mai. 2016 kl. 09:00 - 12:00
VEL402G	Vélhlutafræði	26	Mið. 04 mai. 2016 kl. 09:00 - 12:00
EDL401G	Rafsegulfræði 1 (RAF402G)	24	Mið. 04 mai. 2016 kl. 13:30 - 16:30
EFN202G	Almenn efnafræði 2	151	Mið. 04 mai. 2016 kl. 13:30 - 16:30
LAN209F	Ferðamennska og umhverfi (LAN410G)	4	Mið. 04 mai. 2016 kl. 13:30 - 16:30
LAN219G	Inngangur að veður-og veðurfarsfræði	14	Mið. 04 mai. 2016 kl. 13:30 - 16:30
LAN410G	Ferðamennska og umhverfi (LAN209F)	62	Mið. 04 mai. 2016 kl. 13:30 - 16:30
RAF402G	Rafsegulfræði (EÐL401G)	12	Mið. 04 mai. 2016 kl. 13:30 - 16:30
TOL202M	Þýðendur	42	Mið. 04 mai. 2016 kl. 13:30 - 16:30
FER208G	Fyrirtæki og stofnanir ferðaþjónustunnar	99	Fös. 06 mai. 2016 kl. 09:00 - 12:00
JAR212G	Almenn jarðefnafræði	24	Fös. 06 mai. 2016 kl. 09:00 - 12:00
JAR415G	Auðlindir og umhverfisjarðfræði	20	Fös. 06 mai. 2016 kl. 09:00 - 12:00
LIF403G	Þróunarfræði	64	Fös. 06 mai. 2016 kl. 09:00 - 12:00
TOL403G	Greining reiknirita	141	Fös. 06 mai. 2016 kl. 09:00 - 12:00
UMV203M	Vatns- og fráveitur	11	Fös. 06 mai. 2016 kl. 09:00 - 12:00
BYG202M	Steinsteypuvirki 1	9	Fös. 06 mai. 2016 kl. 13:30 - 16:30
BYG203M	Vegagerð	4	Fös. 06 mai. 2016 kl. 13:30 - 16:30
EDL201G	Eðlisfræði 2 V (EÐL206G)	142	Fös. 06 mai. 2016 kl. 13:30 - 16:30
EDL206G	Eðlisfræði 2 R (EÐL201G)	26	Fös. 06 mai. 2016 kl. 13:30 - 16:30
EDL402M	Inngangur að stjarneðlisfræði	5	Fös. 06 mai. 2016 kl. 13:30 - 16:30
EFN207G	Notkun stærðfræði og eðlisfræði í efnafræði	10	Fös. 06 mai. 2016 kl. 13:30 - 16:30
HBV203F	Gæðastjórnun í hugbúnaðargerð	11	Fös. 06 mai. 2016 kl. 13:30 - 16:30
STA418M	Grundvöllur líkindafræðinnar	13	Fös. 06 mai. 2016 kl. 13:30 - 16:30
EFN208G	Efnagreining	88	Mán. 09 mai. 2016 kl. 09:00 - 12:00
IDN402G	Hermun	35	Mán. 09 mai. 2016 kl. 09:00 - 12:00
JAR619G	Hafið á tímum hnattrænna breytinga	12	Mán. 09 mai. 2016 kl. 09:00 - 12:00
LIF215G	Lífmælingar I	50	Mán. 09 mai. 2016 kl. 09:00 - 12:00
TOV201G	Greining og hönnun stafrænna rása	219	Mán. 09 mai. 2016 kl. 09:00 - 12:00
VEL401G	Sveiflufræði	25	Mán. 09 mai. 2016 kl. 09:00 - 12:00
BYG201M	Stálvirki 1	7	Mán. 09 mai. 2016 kl. 13:30 - 16:30
EDL205G	Eðlisfræði rúms og tíma	22	Mán. 09 mai. 2016 kl. 13:30 - 16:30
EFN408G	Efnagreiningartækni	51	Mán. 09 mai. 2016 kl. 13:30 - 16:30
FER211F	Skipulag og stefnumótun í ferðamennsku (FER609G)	4	Mán. 09 mai. 2016 kl. 13:30 - 16:30
FER609G	Skipulag og stefnumótun í ferðamennsku (FER211F)	14	Mán. 09 mai. 2016 kl. 13:30 - 16:30
HBV402G	Þróun hugbúnaðar A	51	Mán. 09 mai. 2016 kl. 13:30 - 16:30
JAR611G	Umhverfisjarðefnafræði	18	Mán. 09 mai. 2016 kl. 13:30 - 16:30
LAN401G	Sjónarhorn landfræðinnar	8	Mán. 09 mai. 2016 kl. 13:30 - 16:30
LIF614M	Frumulíffræði II	21	Mán. 09 mai. 2016 kl. 13:30 - 16:30
RAF404G	Líkindaaðferðir	14	Mán. 09 mai. 2016 kl. 13:30 - 16:30
STA411G	Grannfræði	20	Mán. 09 mai. 2016 kl. 13:30 - 16:30
UMV201G	Vatnafræði	16	Mán. 09 mai. 2016 kl. 13:30 - 16:30
EFN612M	Litrófsgreiningar sameinda og hvarfgangur efnahvarfa	9	Þri. 10 mai. 2016 kl. 09:00 - 12:00
TOL203M	Tölvugrafík	94	Þri. 10 mai. 2016 kl. 09:00 - 12:00
VEL201G	Tölvuteikning og framsetning	89	Þri. 10 mai. 2016 kl. 09:00 - 12:00
VEL215F	Tölvuvædd varma- og straumfræði	13	Þri. 10 mai. 2016 kl. 09:00 - 12:00
EDL203G	Eðlisfræði 2a	16	Þri. 10 mai. 2016 kl. 13:30 - 16:30
VEL405G	Orkuferli	7	Þri. 10 mai. 2016 kl. 13:30 - 16:30
*/
