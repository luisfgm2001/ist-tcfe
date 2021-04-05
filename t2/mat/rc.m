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
syms Vs
syms C
syms Kb
syms Kd

syms V1
syms V2
syms V3
syms V5
syms V6
syms V7
syms V8

file = fopen("../data.txt", "r");

syms count
syms errmsg

[data, count, errmsg] = fscanf(file, "%f");

fclose(file);

R1 = data(1)*1e3;
R2 = data(2)*1e3;
R3 = data(3)*1e3;
R4 = data(4)*1e3;
R5 = data(5)*1e3;
R6 = data(6)*1e3;
R7 = data(7)*1e3;
Vs = data(8);
C = data(9)*1e-6;
Kb = data(10)*1e-3;
Kd = data(11)*1e3;

file = fopen("../sim/data1.txt", "w");

fprintf(file, "Vs n1 0 %f\nR1 n1 n2 %f\nR2 n2 n3 %f\nR3 n2 n5 %f\nGb n6 n3 n2 n5 %f\nR4 0 n5 %f\nR5 n5 n6 %f\nR6 0 n7 %f\nVHd n7 nex 0\nHd n5 n8 VHd %f\nC n6 n8 %f\nR7 nex n8 %f\n", Vs, R1, R2, R3, Kb, R4, R5, R6, Kd, C, R7);

fclose(file);

file = fopen("../sim/data2.txt", "w");

fprintf(file, "Vs n1 0 0\nR1 n1 n2 %f\nR2 n2 n3 %f\nR3 n2 n5 %f\nGb n6 n3 n2 n5 %f\nR4 0 n5 %f\nR5 n5 n6 %f\nR6 0 n7 %f\nVHd n7 nex 0\nHd n5 n8 VHd %f\nR7 nex n8 %f\n", R1, R2, R3, Kb, R4, R5, R6, Kd, R7);

fclose(file);

file = fopen("../sim/data3.txt", "w");

fprintf(file, "Vs n1 0 0\nR1 n1 n2 %f\nR2 n2 n3 %f\nR3 n2 n5 %f\nGb n6 n3 n2 n5 %f\nR4 0 n5 %f\nR5 n5 n6 %f\nR6 0 n7 %f\nVHd n7 nex 0\nHd n5 n8 VHd %f\nR7 nex n8 %f\nC n6 n8 %f\n", R1, R2, R3, Kb, R4, R5, R6, Kd, R7, C);

fclose(file);

file = fopen("../sim/data4.txt", "w");

fprintf(file, "Vs n1 0 0.0 ac 1.0 sin(0 1 1k)\nR1 n1 n2 %f\nR2 n2 n3 %f\nR3 n2 n5 %f\nGb n6 n3 n2 n5 %f\nR4 0 n5 %f\nR5 n5 n6 %f\nR6 0 n7 %f\nVHd n7 nex 0\nHd n5 n8 VHd %f\nR7 nex n8 %f\nC n6 n8 %f\n", R1, R2, R3, Kb, R4, R5, R6, Kd, R7, C);

fclose(file);


A = [1,0,0,0,0,0,0;-1/R1,1/R1+1/R2+1/R3,-1/R2,-1/R3,0,0,0;0,1/R2+Kb,-1/R2,-Kb,0,0,0;0,Kb,0,-1/R5-Kb,1/R5,0,0;0,0,0,0,0,1/R6+1/R7,-1/R7;0,0,0,1,0,Kd/R6,-1;-1/R1,1/R1,0,1/R4,0,1/R6,0];

B = [Vs;0;0;0;0;0;0];

printf("\n\nMétodo dos nós (t<0)\n");

V1 = (A\B)(1)
V2 = (A\B)(2)
V3 = (A\B)(3)
V5 = (A\B)(4)
V6 = (A\B)(5)
V7 = (A\B)(6)
V8 = (A\B)(7)

syms V6men0
V6men0 = V6



file = fopen("node1.tex", "w");

fprintf(file, "V1 & %0.15E  \\\\ \\hline\nV2 & %0.15E \\\\ \\hline\nV3 & %0.15E \\\\ \\hline\nV5 & %0.15E \\\\ \\hline\nV6 & %0.15E  \\\\ \\hline\nV7 & %0.15E \\\\ \\hline\nV8 & %0.15E \\\\ \\hline\n", V1, V2, V3, V5, V6, V7, V8);

fclose(file);

file = fopen("nodetab1.tex", "w");

fprintf(file, "@gb[i] & %0.15E \\\\ \\hline\n", Kb*(V2-V5));
fprintf(file, "@r1[i] & %0.15E \\\\ \\hline\n", (V1-V2)/R1);
fprintf(file, "@r2[i] & %0.15E \\\\ \\hline\n", -(V3-V2)/R2);
fprintf(file, "@r3[i] & %0.15E \\\\ \\hline\n", (V2-V5)/R3);
fprintf(file, "@r4[i] & %0.15E \\\\ \\hline\n", -V5/R4);
fprintf(file, "@r5[i] & %0.15E \\\\ \\hline\n", (V5-V6)/R5);
fprintf(file, "@r6[i] & %0.15E \\\\ \\hline\n", -V7/R6);
fprintf(file, "@r7[i] & %0.15E \\\\ \\hline\n", (V7-V8)/R7);
fprintf(file, "n1 & %0.15E \\\\ \\hline\n", V1);
fprintf(file, "n2 & %0.15E \\\\ \\hline\n", V2);
fprintf(file, "n3 & %0.15E \\\\ \\hline\n", V3);
fprintf(file, "n5 & %0.15E \\\\ \\hline\n", V5);
fprintf(file, "n6 & %0.15E \\\\ \\hline\n", V6);
fprintf(file, "n7 & %0.15E \\\\ \\hline\n", V7);
fprintf(file, "n8 & %0.15E \\\\ \\hline\n", V8);

fclose(file);

file = fopen("datatab.tex", "w");

fprintf(file, "R1 & %0.11f $\\Omega$ \\\\ \\hline\n", R1);
fprintf(file, "R2 & %0.11f $\\Omega$ \\\\ \\hline\n", R2);
fprintf(file, "R3 & %0.11f $\\Omega$ \\\\ \\hline\n", R3);
fprintf(file, "R4 & %0.11f $\\Omega$ \\\\ \\hline\n", R4);
fprintf(file, "R5 & %0.11f $\\Omega$ \\\\ \\hline\n", R5);
fprintf(file, "R6 & %0.11f $\\Omega$ \\\\ \\hline\n", R6);
fprintf(file, "R7 & %0.11f $\\Omega$ \\\\ \\hline\n", R7);
fprintf(file, "Vs & %0.11f V \\\\ \\hline\n", Vs);
fprintf(file, "C & %0.11f F \\\\ \\hline\n", C);
fprintf(file, "Kb & %0.11f S \\\\ \\hline\n", Kb);
fprintf(file, "Kd & %0.11f $\\Omega$ \\\\ \\hline\n", Kd);

fclose(file);

printf("\n\nMétodo dos nós (to determine Req)\n");

syms Vx
Vx = V6-V8;



file = fopen("../sim/voltages68_2.txt", "w");

fprintf(file, "Vc n6 n8 %f", Vx);

fclose(file);

A = [1,0,0,0,0,0,0;-1/R1,1/R1+1/R2+1/R3,-1/R2,-1/R3,0,0,0;0,1/R2+Kb,-1/R2,-Kb,0,0,0;0,0,0,0,0,1/R6+1/R7,-1/R7;0,0,0,1,0,Kd/R6,-1;0,0,0,0,1,0,-1;-1/R1,1/R1,0,1/R4,0,1/R6,0];

B = [0;0;0;0;0;Vx;0];

V1 = (A\B)(1)
V2 = (A\B)(2)
V3 = (A\B)(3)
V5 = (A\B)(4)
V6 = (A\B)(5)
V7 = (A\B)(6)
V8 = (A\B)(7)

file = fopen("../sim/voltages68_3.txt", "w");

fprintf(file, ".ic V(n6)=%f V(n8)=%f", V6, V8);

fclose(file);

syms Ix
syms Req
syms tau

Ix = Kb*(V2-V5)+(V6-V5)/R5
Req = Vx/Ix
tau = Req*C

file = fopen("node2.tex", "w");

fprintf(file, "V1 & %0.15E  \\\\ \\hline\nV2 & %0.15E \\\\ \\hline\nV3 & %0.15E \\\\ \\hline\nV5 & %0.15E \\\\ \\hline\nV6 & %0.15E  \\\\ \\hline\nV7 & %0.15E \\\\ \\hline\nV8 & %0.15E \\\\ \\hline\nIx & %0.15E \\\\ \\hline\nReq & %0.15E \\\\ \\hline\ntau & %0.15E \\\\ \\hline\n", V1, V2, V3, V5, V6, V7, V8, Ix, Req, tau);

fclose(file);

file = fopen("nodetab2.tex", "w");

fprintf(file, "@gb[i] & %0.15E \\\\ \\hline\n", Kb*(V2-V5));
fprintf(file, "@r1[i] & %0.15E \\\\ \\hline\n", (V1-V2)/R1);
fprintf(file, "@r2[i] & %0.15E \\\\ \\hline\n", -(V3-V2)/R2);
fprintf(file, "@r3[i] & %0.15E \\\\ \\hline\n", (V2-V5)/R3);
fprintf(file, "@r4[i] & %0.15E \\\\ \\hline\n", -V5/R4);
fprintf(file, "@r5[i] & %0.15E \\\\ \\hline\n", (V5-V6)/R5);
fprintf(file, "@r6[i] & %0.15E \\\\ \\hline\n", -V7/R6);
fprintf(file, "@r7[i] & %0.15E \\\\ \\hline\n", (V7-V8)/R7);
fprintf(file, "n1 & %0.15E \\\\ \\hline\n", V1);
fprintf(file, "n2 & %0.15E \\\\ \\hline\n", V2);
fprintf(file, "n3 & %0.15E \\\\ \\hline\n", V3);
fprintf(file, "n5 & %0.15E \\\\ \\hline\n", V5);
fprintf(file, "n6 & %0.15E \\\\ \\hline\n", V6);
fprintf(file, "n7 & %0.15E \\\\ \\hline\n", V7);
fprintf(file, "n8 & %0.15E \\\\ \\hline\n", V8);

fclose(file);


t=0:1e-5:20e-3;

syms V6nat
V6nat = V6

v6n = V6nat*exp(-t/tau);



nat6fig = figure();
plot(t*1000, v6n, "r");

xlabel("t [ms]");
ylabel("v6n(t) [V]");

print(nat6fig, "natural6.eps", "-depsc");

printf("\n\nMétodo dos nós (phasors)\n");

w = 2*pi*1000;

A = [1,0,0,0,0,0,0;-1/R1,1/R1+1/R2+1/R3,-1/R2,-1/R3,0,0,0;0,1/R2+Kb,-1/R2,-Kb,0,0,0;0,0,0,0,0,1/R6+1/R7,-1/R7;0,0,0,1,0,Kd/R6,-1;-1/R1,1/R1,0,1/R4,0,1/R6,0;0,Kb,0,-Kb-1/R5,1/R5+j*C*w,0,-j*C*w];

B = [exp(-i*pi/2);0;0;0;0;0;0];

fV1 = (A\B)(1)
fV2 = (A\B)(2)
fV3 = (A\B)(3)
fV5 = (A\B)(4)
fV6 = (A\B)(5)
fV7 = (A\B)(6)
fV8 = (A\B)(7)

fVx = fV6-fV8

V1 = norm(fV1)
V2 = norm(fV2)
V3 = norm(fV3)
V5 = norm(fV5)
V6 = norm(fV6)
V7 = norm(fV7)
V8 = norm(fV8)
Vx = norm(fVx)

phi1 = -angle(fV1)*180/pi
phi2 = -angle(fV2)*180/pi
phi3 = -angle(fV3)*180/pi
phi5 = -angle(fV5)*180/pi
phi6 = -angle(fV6)*180/pi
phi7 = -angle(fV7)*180/pi
phi8 = -angle(fV8)*180/pi
phix = -angle(fVx)*180/pi

file = fopen("phasortab.tex", "w");

fprintf(file, "1 & %s & %0.15E & %0.15E  \\\\ \\hline\n2 & %s & %0.15E & %0.15E  \\\\ \\hline\n3 & %s & %0.15E & %0.15E  \\\\ \\hline\n5 & %s & %0.15E & %0.15E  \\\\ \\hline\n6 & %s & %0.15E & %0.15E  \\\\ \\hline\n7 & %s & %0.15E & %0.15E  \\\\ \\hline\n8 & %s & %0.15E & %0.15E  \\\\ \\hline\n", num2str(fV1), V1, phi1, num2str(fV2), V2, phi2, num2str(fV3), V3, phi3, num2str(fV5), V5, phi5, num2str(fV6), V6, phi6, num2str(fV7), V7, phi7, num2str(fV8), V8, phi8);

fclose(file);

t=0:1e-5:20e-3;

v6f = V6*cos(2*pi*1000*t-phi6*pi/180);


forced6fig = figure();
plot(t*1000, v6f, "r");

xlabel("t [ms]");
ylabel("v6f(t) [V]");

print(forced6fig, "forced6.eps", "-depsc");

t=-5e-3:1e-5:20e-3;

ramo1 = t<0;
ramo2 = t>=0;

v6(ramo1) = V6men0;
v6(ramo2) = V6nat*exp(-t(ramo2)/tau)+V6*cos(2*pi*1000*t(ramo2)-phi6*pi/180);

ramo3 = t<=0;
ramo4 = t>0;

vs(ramo3) = Vs;
vs(ramo4) = sin(2*pi*1000*t(ramo4));

	
alinea5fig = figure();
plot(t*1000, v6, "r");
hold on;
plot(t*1000, vs, "b");

xlabel("t [ms]");
ylabel("v6(t), vs(t) [V]");

print(alinea5fig, "alinea5.eps", "-depsc");

f = 0.1;
mult = power(10, 0.2);

vetorv6 = ones(1, 7*5+1);
vetorvs = zeros(1, 7*5+1);
vetorvc = ones(1, 7*5+1);
vetorlogf = ones(1, 7*5+1);
vetorfase6 = ones(1, 7*5+1);
vetorfases = ones(1, 7*5+1);
vetorfasec = ones(1, 7*5+1);

for i = 1:7*5+1
	A = [1,0,0,0,0,0,0;-1/R1,1/R1+1/R2+1/R3,-1/R2,-1/R3,0,0,0;0,1/R2+Kb,-1/R2,-Kb,0,0,0;0,0,0,0,0,1/R6+1/R7,-1/R7;0,0,0,1,0,Kd/R6,-1;-1/R1,1/R1,0,1/R4,0,1/R6,0;0,Kb,0,-Kb-1/R5,1/R5+j*C*2*pi*f,0,-j*C*2*pi*f];
	vetorv6(i) = 20*log10(norm((A\B)(5)));
	vetorvc(i) = 20*log10(norm((A\B)(5)-(A\B)(7)));
	vetorlogf(i) = log10(f);
	f = f*mult;
	vetorfase6(i) = angle((A\B)(5)*j)*180/pi;
	vetorfases(i) = 0;
	vetorfasec(i) = angle(((A\B)(5)-(A\B)(7))*j)*180/pi;
endfor



alinea6fig1 = figure();
plot(vetorlogf, vetorv6, "r");
hold on;
plot(vetorlogf, vetorvc, "g");
hold on;
plot(vetorlogf, vetorvs, "b");

xlabel("log(f) ([f] = Hz)");
ylabel("v6(f), vs(f), vc(f) [dB]");

print(alinea6fig1, "alinea6_1.eps", "-depsc");



alinea6fig2 = figure();
plot(vetorlogf, vetorfase6, "r");
hold on;
plot(vetorlogf, vetorfasec, "g");
hold on;
plot(vetorlogf, vetorfases, "b");

xlabel("log(f) ([f] = Hz)");
ylabel("phase_6(f), phase_s(f), phase_c(f) [dB]");

print(alinea6fig2, "alinea6_2.eps", "-depsc");


