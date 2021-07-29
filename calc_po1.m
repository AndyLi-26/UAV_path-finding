function p1=calc_po1(obs,wp)
%set up vars
global uav
thv=true_heading(uav.pos,wp);
r=obs.r(1);a=obs.x(0);b=obs.y(0);
m=1/tand(thv);
% calc 2 points
x1=m*r/sqrt(1+m^2)+a;    
y1=-sqrt(r^2-(x1-a)^2)+b;
x2=-m*r/sqrt(1+m^2)+a;
y2=sqrt(r^2-(x2-a)^2)+b;
p1=[x1,y1;x2,y2];
end