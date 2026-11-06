% drag
% [Fd] = drag(rho,v,C_D,Area)
% Force of drag calculator 
% Returns force of drag based on air density, object velocity, coefficient
% of drag, and object surface area perpendicular to the velocity.

% ## author
% C3C Jacob Peay, USAFA
% 2025-09-04
% 
% ## version
% 1.0
% 
% ## inputs
% 
% | symbol | ASCII | description |  units  |       value/range        |
% | ------ | ----- | ----------- | ------- | ------------------------ |
% | ρ      | rho   | density     | kg/m^3  | 0 < e < infinity         |
% | v      | v     | velocity    | m/s     | -infinity < 0 < infinity |
% | C_D    | C_D   | Coef of drag| unitless| 0 < e < infinity         |
% | A      | Area  | Area        | m^2     | 0 < e < infinity         |
% 
% ## outputs
% 
% | symbol | ASCII | description    | units  |
% | ------ | ----- | -------------- | ------ |
% | F_d    | Fd   | Force of drag  | N      |
% 
% ## constants
% none
% 
% ## coupling
% none
% 
% ## references
% RP2 assignment instructions
% Force of drag equation from RP1
% 
% ## process
function [Fd] = BHR_drag(rho,v,C_D,Area)

    arguments (Input) %Validates that the inputs are numerical real numbers
        rho (:,1) {mustBeReal, mustBeNumeric}
        v (:,1) {mustBeReal, mustBeNumeric}
        C_D (:,1) {mustBeReal, mustBeNumeric}
        Area (:,1) {mustBeReal, mustBeNumeric}
    end

    arguments (Output) %Validates that the outputs are numerical real numbers
        Fd (:,1) {mustBeReal, mustBeNumeric}
    end
if rho<0 %Confirm that rho is positive
    error("Invalid pressure")
end
if C_D<0 %Confirm that C_D is positive
    error("Invalid coefficient of drag")
end
if Area<0 %Confirm that Area is positive
    error("Invalid area")
end
%Calculate force of drag from density, speed, drag coefficient, and area
Fd = (1/2)*rho*v*abs(v)*C_D*Area;

end