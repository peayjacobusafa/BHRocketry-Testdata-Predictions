function make_colors_accessible(varargin)
% make_colors_accessible()
% sets a new default matlab colororder suitable for colorblind people
% colororder persists for this matlab session (until restart)
%
% make_colors_accessible('demo')
% also produces a demo plot

% color blind accessible palette from:
%   Okabe, Masataka, and Kei Ito. "How to make figures and 
%   presentations that are friendly to color blind people." 
%   University of Tokyo (2002). 
% retrieved 2024-11-16 from https://jfly.uni-koeln.de/html/color_blind/

newcolors = [0, 0, 0	    % black
            230, 159, 0	    % Orange
			86, 180, 233	% Sky blue
			0, 158, 115		% Bluish green
			240, 228, 66	% Yellow
			0, 114, 178		% Blue
			213, 94, 0		% Vermilion
			204, 121, 167];	% Reddish purple

set(0,'DefaultAxesColorOrder',newcolors/256); 
set(0,'DefaultLineLineWidth',1.2)

% demo the colors
if nargin>=1 && strcmp(varargin{1},'demo')

% Define coordinates
x = linspace(0,10); x = x'; 
y = sin(x- (0:7)/4);

plot(x, y, 'LineWidth', 2)

legend('black','orange','sky blue', 'bluish green', 'yellow',...
    'blue', 'vermilion', 'reddish purple', ...
    'Location','southeast')

title('Okabe-Ito colorblind accessible palette')

end % if

end % function