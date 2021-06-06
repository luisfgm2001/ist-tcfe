clear all

R1 = 1000
R2 = 1000
R3 = 110000
R4 = 1000
C1 = 220e-9
C2 = 110e-9


freq = logspace(1,8,1000);

Tf = (R1*C1*2*pi*freq*j)./(1+R1*C1*2*pi*freq*j)*(1+R3/R4).*(1./(1+R2*C2*2*pi*freq*j));

gaindbv = 20*log10(abs((R1*C1*2*pi*freq*j)./(1+R1*C1*2*pi*freq*j)*(1+R3/R4).*(1./(1+R2*C2*2*pi*freq*j))));


f1 = figure();
semilogx(freq, gaindbv);
xlabel("Frequency [Hz]");
ylabel("Gain [dB]");
title("Gain");
print(f1, "gainoctave.eps", "-depsc");


f2 = figure();
semilogx(freq, 180*angle(Tf)/pi);
xlabel("Frequency [Hz]");
ylabel("Phase [Deg]");
title("Phase");
print(f2, "phaseoctave.eps", "-depsc");

maxgaindb = max(gaindbv)

test=0;

for i=1:length(gaindbv)
	if (gaindbv(i) >= maxgaindb-3 && test==0)
		lcf=freq(i);
		test=1;
	endif
	if (gaindbv(i) <= maxgaindb-3 && test==1)
		hcf=freq(i);
		test=2;
	endif
endfor

lcf
hcf
fc = sqrt(lcf*hcf)

gain = abs((R1*C1*2*pi*fc*j)/(1+R1*C1*2*pi*fc*j)*(1+R3/R4)*(1/(1+R2*C2*2*pi*fc*j)))
gain_db = 20*log10(abs(gain))

Z_in = abs(R1 + 1/(j*2*pi*fc*C1))
Z_out = abs(1/(j*2*pi*fc*C2+1/R2))

gain2 = abs((R1*C1*2000*pi*j)/(1+R1*C1*2000*pi*j)*(1+R3/R4)*(1/(1+R2*C2*2000*pi*j)))

Cost = (R1+R2+R3+R4)/1000 + (C1+C2)*1000000 + 13323.29204
gain_deviation = abs(100-gain2)
frequency_deviation = abs(fc-1000)
Merit = 1/(Cost*(gain_deviation*frequency_deviation+1e-6))
