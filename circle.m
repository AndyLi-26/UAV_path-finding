% function out = circle(x0,y0,radius)
% 
% ang = -pi:pi/20:pi+pi/20;
% 
% x = x0 + radius*cos(ang);
% y = y0 + radius*sin(ang);
% 
% out = plot(x,y);

function out = circle(x0,y0,radius,color)

pos = [[x0,y0]-radius 2*radius 2*radius];
out = rectangle('Position',pos,'Curvature',[1 1], 'FaceColor', color, 'Edgecolor','none');
