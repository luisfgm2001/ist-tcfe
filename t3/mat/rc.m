close all 
clear all

pkg load symbolic


C = 420e-6;
A = 0.70609*230;
w = 2*pi*50;
V_on = 0.63;
R = 369982;
eta = 1;
Vt = 25.9e-3;
Vd = V_on;
Is = 1e-14;
rd = 56.79666793;


function absv = absv(t)
  A = 0.70609*230;
  w = 2*pi*50;
  
  absv = 0;

  if(sin(w*t) >= 0)
    absv = A*sin(w*t);
  else
    absv = -A*sin(w*t);
  endif
  
endfunction



function absv_d = absv_d(t)
  A = 0.70609*230;
  w = 2*pi*50;
  
  if(sin(w*t) >= 0)
    absv_d = A*w*cos(w*t);
  else
    absv_d = -A*w*cos(w*t);
  endif
  
endfunction



function f = f(t)
C = 420e-6;
A = 0.70609*230;
w = 2*pi*50;
V_on = 0.63;
R = 369982;
eta = 1;
Vt = 25.9e-3;
Vd = V_on;
Is = 1e-14;
rd = 56.79666793;
Req = R+19*rd;

f = (A-19*V_on)*exp(-(t-1/(4*50))/(Req*C))+19*V_on - absv(t);
endfunction

function fd = fd(t)
C = 420e-6;
A = 0.70609*230;
w = 2*pi*50;
V_on = 0.63;
R = 369982;
eta = 1;
Vt = 25.9e-3;
Vd = V_on;
Is = 1e-14;
rd = 56.79666793;
Req = R + 19*rd;

fd = -(A-19*V_on)/R/C*exp(-(t-1/(4*50))/(Req*C)) - absv_d(t);
endfunction

t=linspace(0, 100e-3, 1000);
y=zeros(1, 1000);

for i=1:length(t)
  y(i) = f(t(i));
endfor



delta = 1e-9;
x_next = 14.8e-3;


do 
  x=x_next;
  x_next = x  - f(x)/fd(x);
  printf("%.10f \n", x);
until (abs(x_next-x) < delta)

ton_root = x_next;

printf("%.10f \n", ton_root);

function fdec = fdec(t, ton_root)
  fdec = f(t)+absv(t);
  
  modt = t*50 - floor(t*50);
  
  if(modt<=ton_root*50-0.5 || (modt>=ton_root*50 && modt<=0.75))
    fdec = absv(t);
  endif
endfunction


t=linspace(0, 100e-3, 1000);
y1=zeros(1, 1000);
y2=zeros(1,100);
y3=zeros(1,1000);
y2d=zeros(1,100);
y3d=zeros(1,1000);
y4=zeros(1,1000);

for i=1:length(t)
  y1(i) = absv(t(i));
endfor

for i=1:100
  if(t(i)+1/4/50 < ton_root)
    y2(i) = f(t(i)+1/4/50)+absv(t(i)+1/4/50);
    y2d(i) = fd(t(i)+1/4/50)+absv_d(t(i)+1/4/50);
  else
    y2(i) = absv(t(i)+1/4/50);
    y2d(i) = absv_d(t(i)+1/4/50);
  endif
endfor

for i=1:length(t)
  y3(i) = y2(mod(i+50,100)+1);
  y3d(i) = y2d(mod(i+50,100)+1);
endfor

for i=1:length(t)
  y4(i) = 19*V_on-19*rd*C*y3d(i)-0.40875;
endfor

figure
plot(t*1000, y3)
hold on
plot(t*1000, y4)
xlabel ("t[ms]")
ylabel ("v[V]")
axis([0,100,0,170]);
print ("y.eps", "-depsc");

figure
plot(t*1000, y4-12);
xlabel ("t[ms]")
ylabel ("vo-12[V]")
print ("diff.eps", "-depsc");

dclevel = 0;
maxvo = y4(1);
minvo = y4(1);

for i=1:1000
  dclevel = dclevel + y4(i);
  
  if(y4(i)>maxvo)
    maxvo = y4(i);
  endif
  
  if(y4(i)<minvo)
    minvo = y4(i);
  endif
endfor

dclevel = dclevel/1000;

ripple = maxvo-minvo;

printf("%.10f \n", dclevel);
printf("%.10f \n", ripple);


file = fopen("teor.tex", "w");

fprintf(file, "%.10f & %.10f \\\\ \\hline \n", dclevel, ripple);

fclose(file);

file = fopen("../sim/op_tab.txt", "r");

syms count
syms errmsg

[data, count, errmsg] = fscanf(file, "%s %c %f");

fclose(file);

printf("%f \n", data(15));

file = fopen("simtab.tex", "w");

fprintf(file, " & Theoretical Analysis & Simulation \\\\ \n\\hline \navg(vo-12) & %.10f & %.10f \\\\ \n\\hline \nRipple & %.10f & %.10f \\\\ \n\\hline", dclevel-12, data(7)-12, ripple, data(15));

fclose(file);

file = fopen("merit.tex", "w");

cost = 420 + 2.3 + 369.982;

merit = 1/cost/(data(15)+data(7)-12+1e-6);

fprintf(file, "avg(vo-12) & %.5f \\\\ \n\\hline \nRipple & %.5f \\\\ \n\\hline \nCost & %.3f \\\\ \n\\hline \nMerit & %.2f \\\\ \n\\hline", data(7)-12, data(15), cost, merit);

fclose(file);


