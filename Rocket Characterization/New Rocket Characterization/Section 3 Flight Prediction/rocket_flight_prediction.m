% rocket_prediction
% Predicts rocket flight path using calculated atmospheric conditions,
% calculated force of drag on the rocket, and thrust data of the
% engine being used.

% ## author
% C2C Jacob Peay, USAFA
% 2026-11
% 
% ## version
% 1.0
% 
% ## inputs
% None. While a lot of constants could be changed, this model was made
% with specific conditions in mind.
%
% ## outputs
% A plot that shows how acceleration, speed, and altitude change over time
% 
% ## constants
% gravity: -9.81 m/s^2
% parachuteC_D: 0.72
% parachute_area: 0.292 m^2
% rocketbody_m: 27.2155 kg
% rocketmotor_m: 0 kg
% parachute_m: 0 kg
% flight_comp_m: 0 kg
% batt_m: 0 kg
% accel_m: 0 kg
% barom_m: 0 kg
% rocket_area: pi*((0.0762/2)^2) m^2
% rocket_ejection_delay: 4 seconds
%
% ## coupling
% Used atmosphere_model.m to calculate rho
% Will eventually use drag_coefficient.m to calculate the C_D of the rocket at different speeds
% Used drag.m to calculate the force of drag on the rocket
% 
% ## references
% Drag Coefficient of a Model Rocket Recovery Parachute by Lt Col Jordan
% Firth USSF
% 
% ## process

clearvars; clc; 

%%%% FIX MATLAB DEFAULT COLORS
% IF you created a matlab startup script, delete this code block
% OTHERWISE, this code block must be run once per session (matlab restart) 
%   (but repeating isn't harmful--you can leave it in your script)
BHR_make_colors_accessible()


%%%% end FIX MATLAB DEFAULT COLORS

%%%% CONSTANTS
gravity = -9.81; % m/s^2
parachuteC_D = 0.72; 
total_m = 27.2155; % kg

rocket_area = pi*((0.0574/2)^2);
rocket_C_D = 0;
rocket_ejection_delay = 70; % seconds
parachute_area = 0.292; % m^2


%%%% PROCEDURE

% Thrust of 725 lbs for 4.9 seconds with steps of 0.1 seconds
time = (0:0.1:4.9)';
thrust = 3224.96 * ones(size(time)); % newtons
motor_data = [time, thrust];

%%% calculate values for each time step in thrust data

% initialize variables at time t=0
accel(1) = 0; 
speed(1) = 0.1; 
altitude(1) = 2133.6; % meters at stillman field
F_avg_thrust(1) = 0;
F_drag(1) = 0;

for ii = 2:length(time) % ii is time step index
	% thrust
    F_avg_thrust(ii) = (motor_data(ii,2) + motor_data(ii-1,2))/2;
	
    % drag
    [T, P, rho, a] = BHR_atmosphere_model(altitude(ii-1)); % calculate rho
    % rocket_C_D = drag_coefficient(speed(ii-1)); % calculate C_D
    rocket_C_D = 0.3; % replace with C_D function once we have data
    F_drag(ii) = BHR_drag(rho, speed(ii-1), rocket_C_D, rocket_area); 
	
    % acceleration
    accel(ii, 1) = F_avg_thrust(ii)/total_m - F_drag(ii)/total_m + gravity;
    % don't accelerate below launch pad before liftoff
    if accel(ii)<0 && altitude(ii-1) <= altitude(1)
        accel(ii) = 0; 
    end % if (don't accelerate below launch pad before liftoff)
    
    dt = time(ii) - time(ii-1); 
    speed(ii, 1) = speed(ii-1) + accel(ii)*dt;
    altitude(ii, 1) = altitude(ii-1) +speed(ii)*dt;
    total_m = total_m - 1.2644*0.1; %mass flow rate times step time
end % for ii = 2:length(time)
clear ii



%%% calculate values from burnout to parachute deployment
rocket_ejection_time = time(end) + rocket_ejection_delay; 
dt = 0.1; 
% total_m = total_m - 6.237; % new mass after fuel has burned

while time(end) < (rocket_ejection_time) % while parachute not deployed
    % drag
    [T, P, rho, a] = BHR_atmosphere_model(altitude(end)); % calculate rho
    % rocket_C_D = drag_coefficient(speed(end)); % calculate C_D
    rocket_C_D = 0.3; % replace with C_D function once we have data
    F_drag(end+1) = BHR_drag(rho, speed(end), rocket_C_D, rocket_area); 
	
    % acceleration
    accel(end+1) = -F_drag(end)/total_m + gravity;
	
    % speed
    speed(end+1) =  speed(end) + accel(end)*dt; 
	
    % altitude
    altitude(end+1) = altitude(end) + speed(end)*dt;
	
    % time
    time(end+1) = time(end) + dt;
end % while parachute not deployed

%%% calculate values from parachute deployment to landing
while altitude(end) > altitude(1) % while rocket is not below the ground
    [T, P, rho, a] = BHR_atmosphere_model(altitude(end)); % calculate rho
    F_drag(end+1) = BHR_drag(rho, speed(end), parachuteC_D, parachute_area); % calculate C_D
    
    % acceleration
    accel(end+1) = -F_drag(end)/total_m + gravity;
	
    % speed
    speed(end+1) =  speed(end) + accel(end)*dt; 
	
    % altitude
    altitude(end+1) = altitude(end) + speed(end)*dt;
	
    % time
    time(end+1) = time(end) + dt;
end % rocket hits the ground

disp("Flight time")
disp(time(end))
disp("Max altitude")
disp(max(altitude)-altitude(1))
disp("Max acceleration")
disp(max(accel))
disp("Landing speed")
disp(speed(end))
disp("Final mass")
disp(total_m)
%% plot

h1 = figure(1); clf; 
subfig = tiledlayout(1,2); % create two subfigures
    theme(h1, "light") % get out of dark mode


    nexttile % plot for acceleration and speed
    hold on
    plot(time, accel, 'DisplayName', 'accel, m/s^2'); 
    plot(time, speed, 'DisplayName', 'speed, m/s'); 
    yline(0); % add line at y=0
    xlabel('time, s')
    ylabel('accel, speed')
    title('Acceleration and Speed')
    % xlim([0,13]) % stop after rocket lands
    legend({'accel, m/s^2', 'speed, m/s'}, 'FontSize', 8, 'Box', 'off')
   
    altitude_plot(1) = 0;
    for ii = 1:length(altitude)
        altitude_plot(ii) = altitude(ii) - 2156;
    end

    nexttile % plot for altitude
    hold on
    plot(time, altitude_plot, 'DisplayName', 'altitude, m')
    xlabel('time, s')
    ylabel('altitude, m')
    title('Altitude')
    % xlim([0,13]) % stop after rocket lands
    % ylim([altitude_plot(1), 70]) % stop just above apogee
    legend
sgtitle('Rocket Performance')


saveas(h1, 'rocket_performance.svg')
savefig(h1,'rocket_performance.fig')

