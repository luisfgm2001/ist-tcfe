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

format short e;
output_precision(16);

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

fprintf(file, "I1 & %0.15E  \\\\ \\hline\nI2 & %0.15E \\\\ \\hline\nI3 & %0.15E \\\\ \\hline\nI4 & %0.15E \\\\ \\hline\n", I1, I2, I3, I4);

fclose(file);

file = fopen("node.tex", "w");

fprintf(file, "V1 & %0.15E  \\\\ \\hline\nV2 & %0.15E \\\\ \\hline\nV3 & %0.15E \\\\ \\hline\nV4 & %0.15E \\\\ \\hline\nV5 & %0.15E  \\\\ \\hline\nV6 & %0.15E \\\\ \\hline\nV7 & %0.15E \\\\ \\hline\n", V1, V2, V3, V4, V5, V6, V7);

fclose(file);

syms n1;
syms n2;
syms n3;
syms n4;
syms n5;
syms n6;
syms n7;

n5 = -I3*Kc;
n7 = -R7*I3;
n4 = n7-R6*I3;
n1 = n4 + Va;
n2 = n1-R1*I1;
n3 = n2+R2*I2;
n6 = n5-(I2-I4)*R5;

file = fopen("meshtab.tex", "w");

fprintf(file, "@gb[i] & %0.15E \\\\ \\hline\n", I2);
fprintf(file, "@id[current] & %0.15E \\\\ \\hline\n", Id);
fprintf(file, "@r1[i] & %0.15E \\\\ \\hline\n", I1);
fprintf(file, "@r2[i] & %0.15E \\\\ \\hline\n", -I2);
fprintf(file, "@r3[i] & %0.15E \\\\ \\hline\n", I1+I2);
fprintf(file, "@r4[i] & %0.15E \\\\ \\hline\n", I3-I1);
fprintf(file, "@r5[i] & %0.15E \\\\ \\hline\n", I2-I4);
fprintf(file, "@r6[i] & %0.15E \\\\ \\hline\n", -I3);
fprintf(file, "@r7[i] & %0.15E \\\\ \\hline\n", -I3);
fprintf(file, "n1 & %0.15E \\\\ \\hline\n", n1);
fprintf(file, "n2 & %0.15E \\\\ \\hline\n", n2);
fprintf(file, "n3 & %0.15E \\\\ \\hline\n", n3);
fprintf(file, "n4 & %0.15E \\\\ \\hline\n", n4);
fprintf(file, "n5 & %0.15E \\\\ \\hline\n", n5);
fprintf(file, "n6 & %0.15E \\\\ \\hline\n", n6);
fprintf(file, "n7 & %0.15E \\\\ \\hline\n", n7);

fclose(file);

file = fopen("nodetab.tex", "w");

fprintf(file, "@gb[i] & %0.15E \\\\ \\hline\n", Kb*(V2-V5));
fprintf(file, "@id[current] & %0.15E \\\\ \\hline\n", Id);
fprintf(file, "@r1[i] & %0.15E \\\\ \\hline\n", (V1-V2)/R1);
fprintf(file, "@r2[i] & %0.15E \\\\ \\hline\n", -(V3-V2)/R2);
fprintf(file, "@r3[i] & %0.15E \\\\ \\hline\n", (V2-V5)/R3);
fprintf(file, "@r4[i] & %0.15E \\\\ \\hline\n", -(V5-V4)/R4);
fprintf(file, "@r5[i] & %0.15E \\\\ \\hline\n", (V5-V6)/R5);
fprintf(file, "@r6[i] & %0.15E \\\\ \\hline\n", (V4-V7)/R6);
fprintf(file, "@r7[i] & %0.15E \\\\ \\hline\n", V7/R7);
fprintf(file, "n1 & %0.15E \\\\ \\hline\n", V1);
fprintf(file, "n2 & %0.15E \\\\ \\hline\n", V2);
fprintf(file, "n3 & %0.15E \\\\ \\hline\n", V3);
fprintf(file, "n4 & %0.15E \\\\ \\hline\n", V4);
fprintf(file, "n5 & %0.15E \\\\ \\hline\n", V5);
fprintf(file, "n6 & %0.15E \\\\ \\hline\n", V6);
fprintf(file, "n7 & %0.15E \\\\ \\hline\n", V7);

fclose(file);

file = fopen("datatab.tex", "w");

fprintf(file, "R1 & %0.11f k$\\Omega$ \\\\ \\hline\n", R1);
fprintf(file, "R2 & %0.11f k$\\Omega$ \\\\ \\hline\n", R2);
fprintf(file, "R3 & %0.11f k$\\Omega$ \\\\ \\hline\n", R3);
fprintf(file, "R4 & %0.11f k$\\Omega$ \\\\ \\hline\n", R4);
fprintf(file, "R5 & %0.11f k$\\Omega$ \\\\ \\hline\n", R5);
fprintf(file, "R6 & %0.11f k$\\Omega$ \\\\ \\hline\n", R6);
fprintf(file, "R7 & %0.11f k$\\Omega$ \\\\ \\hline\n", R7);
fprintf(file, "Va & %0.11f V \\\\ \\hline\n", Va);
fprintf(file, "Id & %0.11f mA \\\\ \\hline\n", Id);
fprintf(file, "Kb & %0.11f mS \\\\ \\hline\n", Kb);
fprintf(file, "Kc & %0.11f k$\\Omega$ \\\\ \\hline\n", Kc);

fclose(file);
