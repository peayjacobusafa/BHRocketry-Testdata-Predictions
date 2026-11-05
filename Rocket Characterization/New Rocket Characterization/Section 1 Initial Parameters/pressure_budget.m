clc
clear
% Calculating the pressure budget and chamber pressure of the new rocket
% C2C Jacob Peay

% Assumptions
% Tank pressure is 6894.76 kPa (1000 psi or 68.046 atm)
% Pressure change from the tank to the injector is equal to the pressure
% gain due to gravity minus the dynamic pressure loss minus the friction
% pressure loss
% Pressure loss through the injector is equal to 20% of the chamber
% pressure
% Propellant density is constant
% Bottom of the tank is 0.2 meters above the injector

% Set up variables
% P_0 is chamber pressure
% V is speed of the propellant flowing through the pipes
P_tank = 6894.76; %kPa
Ploss_fric = 35; %kPa
V = 0; %m/s (assume for starting calculation)
h = 0.2; %m
g_0 = 9.81; %m/s^2
F = 3224.96; %N (725 lbs)

OF = 6.591; %oxidizer to fuel ratio by weight
rho_oxidizer = 907; %kg/m^3 for N2O
rho_fuel = 785; %kg/m^3 for IPA
rho = (OF + 1)/(OF/rho_oxidizer + 1/rho_fuel); %kg/m^3 average density
syms P_0

% Set up equations
Ploss_dynamic = (0.5*V^2*rho)/1000; %kPa
Pgain_grav = (h*g_0*rho)/1000; %kPa
% P_injector_in = P_tank + Pgain_grav - Ploss_dynamic - Ploss_fric
% P_0 = P_injector_in - 0.2*P_0

eq = 1.2*P_0 == P_tank + Pgain_grav - Ploss_dynamic - Ploss_fric;
vpa(solve(eq, P_0)) %805.62 kPa

% Find V if the chamber pressure is 805.62 kPa
% V = mass flow rate/rho*A
Isp = 200; %seconds (assumed from preliminary CEA runs)
m = F/(Isp*g_0);
A = 0.01; %m^2, pipe flow area
V = m/(rho*A); %m/s
Ploss_dynamic = (0.5*V^2*rho)/1000; %kPa
eq = 1.2*P_0 == P_tank + Pgain_grav - Ploss_dynamic - Ploss_fric;
vpa(solve(eq, P_0))

% Changing velocity of the propellant changes the chamber pressure by 0.1
% kPa, so it will not be iterated
P_0 = 5717.91; %kPa