close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

syms R1
syms R2
syms R3
syms R4
syms R5
syms R6
syms R7
syms Va
syms Id
syms Kb
syms Kc
syms I1
syms I2

R1 = 1.00455407009;
R2 = 2.04596274404;
R3 = 3.09144622662;
R4 = 4.11831176554;
R5 = 3.01223930062;
R6 = 2.09613044241;
R7 = 1.04911840913;
Va = 5.24627171439;
Id = 1.01890083211;
Kb = 7.12576427883;
Kc = 8.23427638445;

A = [Kb*R3,Kb*R3-1,0,0;0,0,0,1;R1+R3+R4,R3,-R4,0;-R4,0,R4+R6+R7-Kc,0];

B = [0;Id;Va;0];

printf("Método das malhas\n");

output_precision(12);

I1 = (A\B)(1)
I2 = (A\B)(2)
I3 = (A\B)(3)
I4 = (A\B)(4)

C = [1,0,0,-1,0,0,0;0,0,0,-Kc/R6,1,0,Kc/R6;1/R1,-1/R1-1/R2-1/R3,1/R2,0,1/R3,0,0;0,-1/R2-Kb,1/R2,0,Kb,0,0;0,-Kb,0,0,1/R5+Kb,-1/R5,0;0,0,0,1/R6,0,0,-1/R6-1/R7;0,1/R3,0,1/R4,-1/R3-1/R4-1/R5,1/R5,1/R7];

D = [Va;0;0;0;-Id;0;Id];

printf("\n\nMétodo dos nós\n");

V1 = (C\D)(1)
V2 = (C\D)(2)
V3 = (C\D)(3)
V4 = (C\D)(4)
V5 = (C\D)(5)
V6 = (C\D)(6)
V7 = (C\D)(7)

file = fopen("mesh.tex", "w");

fprintf(file, "I1 & %f  \\\\ \\hline\nI2 & %f \\\\ \\hline\nI3 & %f \\\\ \\hline\nI4 & %f \\\\ \\hline\n", I1, I2, I3, I4);

fclose(file);

file = fopen("node.tex", "w");

fprintf(file, "V1 & %f  \\\\ \\hline\nV2 & %f \\\\ \\hline\nV3 & %f \\\\ \\hline\nV4 & %f \\\\ \\hline\nV5 & %f  \\\\ \\hline\nV6 & %f \\\\ \\hline\nV7 & %f \\\\ \\hline\n", V1, V2, V3, V4, V5, V6, V7);

fclose(file);

