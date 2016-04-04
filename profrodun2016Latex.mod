# Usage:
#  glpsol --check -m profrodun2016.mod -d profrodun2016.dat
#  glpsol -m profrodun2016.mod -d profrodun2016.dat --wlp proftafla.lp
#  gurobi_cl TimeLimit=3600 ResultFile=proftafla.sol proftafla.lp

set cidExam; # Set of courses
set group{1..61} within cidExam; # Defined programs (namsbrautir/leidir)
#set noExamDays;

param n := 16; # Number of days in the exam period
set examSlots := 1..(2*n); # Exam-slots (profstokkar)
set offSlots; #Set of slots that belong to off Days

param sumCount := 2274; # Total numnber of exams taken during this exam period
param cidExamslot2016{cidExam}; # Solution of the University of Iceland, for comparison
param ourBasicSolution{cidExam}; # Calculated solution with 3 basic constraint
param solutionWithoutSeats{cidExam}; # Calculated solution without seat constraint
param cidDifficulty{cidExam}; # Percentage of students that did not pass the exam last year

param cidCount{cidExam} default 0; # Amount of students in each course
param cidCommon{cidExam, cidExam} default 0; # Amount of students that take co-taught courses
param conjoinedCourses{cidExam, cidExam} default 0; # Vector containing courses that are taught jointly

# Parameters to indicate how many students have to be in an exam-clash for constraints to work
param studentsTolerance := 2;
param studentsTolerance2 := 9;
param studentsTolerance3 := 15;
#param studentsTolerance4 := 13;


var slot{cidExam, examSlots} binary; # Variable

# This constraint is used to coerce the solution to be the same as the one of the University
#subject to lookAtSolution{e in examSlots, c in cidExam:
                          #cidExamslot2016[c] == e}:  slot[c,e] = 1;

# This constraint its used to coerce the solution to be one of our own solutions
# subject to coerceSolution{e in examSlots, c in cidExam:
#  solutionWithoutSeats[c] == e}: slot[c,e] = 1;

# Objective function to place all exams as early as possible in exam-table
#minimize totalSlots: sum{c in cidExam, e in examSlots} slot[c,e]*(e^8);

# Courses with the most students have exams in the beginning of exam period
#minimize totalSlots: sum{c in cidExam, e in examSlots} slot[c,e]*(cidCount[c]*(e^2))^4;

# Our best solution: Difficult exams early
minimize totalSlots: sum{c in cidExam, e in examSlots} slot[c,e]*((cidCount[c]*((cidDifficulty[c] + 1)^4))/ sumCount)*(e^0.25);

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

#Ensure that a student is not in exam slots e and e+2
subject to examSpace2{e in examSlots, c1 in cidExam, c2 in cidExam: cidCommon[c1, c2] >= studentsTolerance2 && e+2 in examSlots}: slot[c1,e]+slot[c2, e+2] <= 1;

#Ensure that a student is not in exam slots e and e+3
subject to examSpace3{e in examSlots, c1 in cidExam, c2 in cidExam: cidCommon[c1, c2] >= studentsTolerance3 && e+3 in examSlots}: slot[c1,e]+slot[c2, e+3] <= 1;

#Ensure that a student is not in exam slots e and e+4
#subject to examSpace4{e in examSlots, c1 in cidExam, c2 in cidExam: cidCommon[c1, c2] >= studentsTolerance4 && e+4 in examSlots}: slot[c1,e]+slot[c2, e+4] <= 1;

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
