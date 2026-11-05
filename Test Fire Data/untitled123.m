clc
clear
syms y(x)
dy = diff(y,x);
ddy = diff(dy,x);
ODE = ddy + 16*y == exp(3*x)
ODEh = ddy + 16*y == 0;
yh = dsolve(ODEh)
y1 = cos(4*x);
y2 = sin(4*x);
dy1 = diff(y1, x);
dy2 = diff(y2, x);
W = simplify(y1*dy2 - y2*dy1)
f = exp(3*x);
yp = simplify(-y1*int((y2*f)/W, x) + y2*int((y1*f)/W, x))
y = yh + yp

%%
clc
clear
syms q(t)
dq = diff(q,t);
ddq = diff(dq,t);
R = 0;
L = 0.005;
C = 0.75;
ODE = L*ddq + R*dq + (1/C)*q == 0;
q(t) = simplify(dsolve(ODE, q(0) == 0.03, dq(0) == 0))

(solve(q(t) == 0, t));


%% solve for the work of a harmonic ocillator (SMD)
clc
clear
syms u(t) m c k E(t)
Du(t) = diff(u,t);
DDu = diff(Du, t);
m = 1;
c = 4;
k = 8;
E(t) = 10*sin(2*t);
ODE1 = m*DDu + c*Du + k*u == E(t)
GenSoln = simplify(dsolve(ODE1))
IC = u(0) == 0;
IC2 = Du(0) == 0;
SpecSoln = simplify(dsolve(ODE1, IC, IC2))

%%
m=1; c=1; k=4;
syms omega
G(omega) = 1/sqrt((m*omega^2 - k)^2 + c^2*omega^2)
fplot(G)
xlim([0,10])
ylim([0,3])

% natfreq = sqrt(k/m)

%%
clc
clear
syms u(t) s U
du = diff(u,t);
H(t) = heaviside(t);
ode = du == -3*u(t) + 3*H(t-3) - 6*H(t-5)
L = laplace(ode, t, s)
ODE = subs(L, [laplace(u(t),t,s), u(0)], [U,1])
Usol = solve(ODE, U)
u(t) = ilaplace(Usol, s, t)

%%
clc
clear
syms u(t) s U 
du = diff(u)
ddu = diff(du)
ode = 4*ddu + 16*du + 116*u == 20*dirac(t - 5)
ODE = laplace(ode,t,s)
ODE = subs(ODE,[laplace(u(t),t,s),u(0),du(0)],[U,0,0])
Usol = solve(ODE,U)
u(t) = ilaplace(Usol,s,t)

%%
clc
clear all

h = 0.2;
t = 0:h:2;
u = zeros(size(t));
u(1) = 1;

for i = 1:length(u)-1
    dudt = -u(i) + 4*t(i)^2 - t(i);
    u(i+1) = u(i) + dudt*h;
end

%%
clc
clear all

h = 0.2;
t = 0:h:2;
u = zeros(size(t));
u(1) = 3;

for i = 1:length(u)-1
    du1 = -2*u(i) + 4*(t(i)^2) - t(i);
    du2 = -2*(u(i)+h*du1) + 4*(t(i)+h)^2 - (t(i)+h);
    u(i+1) = u(i) + ((du1+du2)/2)*h;
end

%%
% You invested $10000 at 2% interest rate, compounded continuously. If additional deposits are made at a rate  then the account balance  follows the ODE . Suppose you made a lump sum deposit of $5000 at time . Solve the ODE for  and estimate the principal when t = 8.
syms p(t) s P % we need symbolic p(t) s and P for our work below
% set up the ODE
dp = diff(p)
ode = dp == 0.02*p + 5000*dirac(t - 3);
% take the laplace transform
ODE = laplace(ode);
% substitute (if you want, let's talk about this Monday)
ODE = subs(ODE,[laplace(p(t),t,s),p(0)],[P,10000])
% Algebra is easier than calculus
Psol = solve(ODE,P)
% inverse laplace transform
p(t) = ilaplace(Psol)
% don't forget to answer the question
vpa(p(8),7)

%%
syms x1(t) x2(t) s X1 X2
ode1 = diff(x1)==t*x1 - x2;
ode2 = diff(x2)==4;
ODE1 = laplace(ode1) % look closely at this one...
ODE2 = laplace(ode2)

[x1(t),x2(t)] = dsolve(ode1,ode2,x1(0)==1,x2(0)==1)
vpa(x1(10))
vpa(x2(10))

%%
clc
clear
syms x1(t) x2(t) s X1 X2
ode1 = diff(x1)==x1 + x2;
ode2 = diff(x2)==x1 - 2*x2 + t^2;
ODE1 = laplace(ode1);
ODE2 = laplace(ode2);
ODE1 = subs(ODE1,[laplace(x1(t),t,s),laplace(x2(t),t,s),x1(0)],[X1,X2,1])
ODE2 = subs(ODE2,[laplace(x1(t),t,s),laplace(x2(t),t,s),x2(0)],[X1,X2,1])
[X1,X2] = solve(ODE1,ODE2,[X1,X2])
x1(t) = ilaplace(X1)
x2(t) = ilaplace(X2)
vpa(x1(10))
vpa(x2(10))

%%
clc
clear
syms r
solve(r^3 + 8*r^2 + 20*r + 16 == 0)

%%
clc
clear
syms x y c1 c2 t

A = [7, -4; 20, -11]
[eigvecs, eigvals] = jordan(A)

z1 = exp(-3*t) * [2/5; 1]
z2 = exp(-1*t) * [1/2; 1]

zcomp = c1*z1 + c2*z2

% form the fundamental matrix
phi = [z1, z2]
% find particular soluiton
f = [1; exp(t)]
zpart = phi*int(inv(phi)*f, t)

zsol = zcomp + zpart


%%
clc
clear
syms c1 c2 t real
f = sym([0; exp(-t)])
A = sym([3, 2; 2, -1])
[vec,val] = jordan(A)
z1(t) = exp(val(1,1)*t)*vec(:,1)
z2(t) = exp(val(2,2)*t)*vec(:,2)
zh = simplify(c1*z1 + c2*z2)
Phi = sym([z1 z2])
zp = Phi*int(inv(Phi)*f,t)
z = zh + zp
B = [z1(0) z2(0)]
d = zp(0)
IC = [1; 1]
RHS = IC - d
c = B\RHS
z = subs(z,[c1,c2],[c(1),c(2)])

%%
