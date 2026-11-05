% 10/7/2025 Liquid Rocket Test Data Analysis
% C3C Jacob Peay
% Create .mat file
% Open windaq file and export to excel
% Save excel as CSV
% Open CSV with import wizzard
% Import as table and name the table "table"
save("RocketTestData050626.mat")

%% Create variables
clc
clear all

load("RocketTestData050626.mat");

time = table.RelativeTime;
thrust = table.Lbs_En;
chamber_pressure = table.PSI_En;
tank_weight = table.Lbs_Ta;
ox_pressure = table.PSI_Ox;
fuel_presure = table.PSI_Fu;
source_pressure = table.PSI_Ni;

%% plot event

f1 = figure;
theme(f1, "light")
sgtitle('05/06/2026 Rocket Static Fire')

% Plot thrust over time
subplot(4, 1, 1);
plot(time, thrust, 'LineWidth', 1.5);
title('Thrust Over Time');
xlabel('Time (s)');
ylabel('Thrust (Lbs)');
xlim([140,225]);
ylim([-3,70])
grid on;

% Plot tank weight over time
subplot(4, 1, 2);
plot(time, tank_weight, 'LineWidth', 1.5);
title('Tank Weight Over Time');
xlabel('Time (s)');
ylabel('Weight (Lbs)');
% Add a horizontal line at y = 13.5 (empty tank weight)
yline(12.85, 'r--', 'Y = 12.85', 'LineWidth', 1.5);
xlim([140,225]);
ylim([10,20]);
grid on;

% Plot tank pressures over time
subplot(4, 1, 3);
% plot(time, ox_pressure, 'LineWidth', 1.5); hold on
plot(time, fuel_presure, 'LineWidth', 1.5);
title('Tank Pressures Over Time');
xlabel('Time (s)');
ylabel('Pressure (PSI)');
xlim([140,225]);
ylim([0,500]);
legend('Fuel Pressure');
grid on;

% Plot chamber pressure over time
subplot(4, 1, 4);
plot(time, chamber_pressure, 'LineWidth', 1.5);
title('Chamber Pressure Over Time');
xlabel('Time (s)');
ylabel('Pressure (PSI)');
xlim([140,225]);
ylim([0,250]);
grid on;
%%
saveas(f1, ['050626_Rocket_Test_Data_Plot.svg'])

%% Data analysis
% Calculate the average thrust from the time 189 to 194
time_range = time(time >= 191 & time <= 197);
thrust_range = thrust(time >= 191 & time <= 197);
average_thrust = mean(thrust_range);

fprintf('The average thrust from 191 to 197 seconds is %.2f Lbs.\n', average_thrust);

%% plot thrust

f1 = figure;
theme(f1, "light")
sgtitle('05/06/2026 Rocket Static Fire (Zoom on Thrust)')

% Plot thrust over time
subplot(4, 1, 1);
plot(time, thrust, 'LineWidth', 1.5);
title('Thrust Over Time');
xlabel('Time (s)');
ylabel('Thrust (Lbs)');
xlim([190,200]);
ylim([-3,70])
grid on;

% Plot tank weight over time
subplot(4, 1, 2);
plot(time, tank_weight, 'LineWidth', 1.5);
title('Tank Weight Over Time');
xlabel('Time (s)');
ylabel('Weight (Lbs)');
% Add a horizontal line at y = 13.5 (empty tank weight)
yline(10.75, 'r--', 'Y = 10.75', 'LineWidth', 1.5);
xlim([190,200]);
ylim([10,20]);
grid on;

% Plot tank pressures over time
subplot(4, 1, 3);
% plot(time, ox_pressure, 'LineWidth', 1.5); hold on
plot(time, fuel_presure, 'LineWidth', 1.5);
title('Tank Pressures Over Time');
xlabel('Time (s)');
ylabel('Pressure (PSI)');
xlim([190,200]);
ylim([0,500]);
legend('Fuel Pressure');
grid on;

% Plot chamber pressure over time
subplot(4, 1, 4);
plot(time, chamber_pressure, 'LineWidth', 1.5);
title('Chamber Pressure Over Time');
xlabel('Time (s)');
ylabel('Pressure (PSI)');
xlim([190,200]);
ylim([0,250]);
grid on;

%%
saveas(f1, ['050626_Rocket_Test_Data_Plot_(Zoom_on_Thrust).svg'])
