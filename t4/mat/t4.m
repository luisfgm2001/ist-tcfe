VT=25e-3
BFN=178.7
BFP=227.3
VAFN=69.7
VAFP=37.2
RE=200
Rout=52
RC=860
R1=90000
R2=20000
VBEON=0.7
VCC=12
Rin=100
VEBON = 0.7






%%%%% OPERATING POINT %%%%%%

A=[R1+R2,-R1,-R2,0,0,0,0,0;
-R1,R1+RC,0,-RC,0,1,0,0;
-R2,0,RE+R2,0,-RE,0,0,0;
0,-RC,0,RC+Rout,0,0,0,0;
0,0,-RE,0,RE,0,1,1;
0,0,0,-BFP,1+BFP,0,0,0;
0,1+BFN,-BFN,0,-1,0,0,0;
0,0,0,0,0,1,1,0];

B=[VCC;0;-VBEON;-VEBON;0;0;0;-VBEON];

X=A\B

Vbase = (X(1)-X(3))*R2;
Vcoll = VCC-(X(2)-X(4))*RC;
Vemit = (X(3)-X(5))*RE;
Vemit2 = VCC-X(4)*Rout;


file = fopen("opteor.tex", "w");

fprintf(file, "$base$ & %0.6E V \\\\ \\hline\n$coll$ & %0.6E V \\\\ \\hline\n$emit$ & %0.6E V \\\\ \\hline\n$emit2$ & %0.6E V \\\\ \\hline\n$in$ & 0 V \\\\ \\hline\n$in2$ & 0 V \\\\ \\hline\n$out$ & 0 V \\\\ \\hline\n$Vbe1$ & %0.6E V \\\\ \\hline\n$vcc$ & %0.6E V \\\\ \\hline\n$Vce1$ & %0.6E V \\\\ \\hline\n$Veb2$ & %0.6E V \\\\ \\hline\n$Vec2$ & %0.6E V \\\\ \\hline\n", Vbase, Vcoll, Vemit, Vemit2, Vbase-Vemit, VCC, Vcoll-Vemit, Vemit2-Vcoll, Vemit2);

fclose(file);


%%%%% GAIN STAGE %%%%%%


RB=1/(1/R1+1/R2)
VEQ=R2/(R1+R2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE*IE1
VO1=VCC-RC*IC1
VCE=VO1-VE1

gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

RinB=RB*Rin/(RB+Rin)

RE=0
AV1 = RinB/Rin * RC*(RE-gm1*rpi1*ro1)/((ro1+RC+RE)*(RinB+rpi1+RE)+gm1*RE*ro1*rpi1 - RE^2)
AVI_DB = 20*log10(abs(AV1))


ZI1 = 1/(1/RB+1/(((ro1+RC+RE)*(rpi1+RE)+gm1*RE*ro1*rpi1 - RE^2)/(ro1+RC+RE)))
ZO1 = 1/(1/ro1+1/RC)

file = fopen("gaintab.tex", "w");

fprintf(file, "$Gain$ & %0.6E V \\\\ \\hline\n$Gain (dB)$ & %0.6E V \\\\ \\hline\n$Input impedance$ & %0.6E V \\\\ \\hline\n$Output impedance$ & %0.6E V \\\\ \\hline", AV1, AVI_DB, ZI1, ZO1);

fclose(file);

%ouput stage
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/Rout
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - Rout*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/Rout

AV2 = gm2/(gm2+gpi2+go2+ge2)
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)

file = fopen("outputtab.tex", "w");

fprintf(file, "$Gain$ & %0.6E V \\\\ \\hline\n$Gain (dB)$ & %0.6E V \\\\ \\hline\n$Input impedance$ & %0.6E V \\\\ \\hline\n$Output impedance$ & %0.6E V \\\\ \\hline", AV2, 20*log10(AV2), ZI2, ZO2);

fclose(file);

%total
gB = 1/(1/gpi2+ZO1)
AV = (gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1
AV_DB = 20*log10(abs(AV))
ZI=ZI1
ZO=1/(go2+gm2/gpi2*gB+ge2+gB)

file = fopen("totaltab.tex", "w");

fprintf(file, "$Gain$ & %0.6E V \\\\ \\hline\n$Gain (dB)$ & %0.6E V \\\\ \\hline\n$Input impedance$ & %0.6E V \\\\ \\hline\n$Output impedance$ & %0.6E V \\\\ \\hline", AV, 20*log10(AV), ZI, ZO);

fclose(file);






Cin = 102e-6
Cb = 2185e-6
Cout = 1466e-6
RE = 200
rpi2 = 1/gpi2
ro2 = 1/go2
RL = 8
vin = 0.01

i=1;



for t=1:0.1:8
	w = 2*pi*power(10,t);
	Zin = Rin+1/(j*w*Cin);
	Zeb=1/(1/RE+j*w*Cb);
	Rcpi2 = 1/(1/RC+1/rpi2);
	Ro2out = 1/(1/ro2+1/Rout);
	Zcout=1/(j*w*Cout);
	
	A=[Zin+RB,-RB,0,0,0,0;
	-RB,RB+rpi1+Zeb,-Zeb,0,0,0;
	0,gm1*rpi1,1,0,0,0;
	0,-Zeb,-ro1,Rcpi2+Zeb+ro1,0,0;
	0,0,0,gm2*Rcpi2,1,0;
	0,0,0,0,-Ro2out,Zcout+RL+Ro2out];
	
	B=[vin;0;0;0;0;0];
	
	X=A\B;
	
	freq(i)=t;
	gain(i) = 20*log10(X(6)*RL/vin);
	
	i=i+1;

endfor

gainfreqfig1 = figure();
plot(freq, gain, "b");

xlabel("log(f) ([f] = Hz)");
ylabel("Gain (dB)");

print(gainfreqfig1, "gainfreq.eps", "-depsc");
