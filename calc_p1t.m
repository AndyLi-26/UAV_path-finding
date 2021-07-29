function [p1,t]=calc_p1t(obs,po1,eta)
global uav wp
% set up vars
tho=obs.h;thv=true_heading(uav.pos,wp);
axo=sind(tho)*obs.v;ayo=cosd(tho)*obs.v;bxo=po1(1,1);byo=po1(1,2);
axv=sind(thv)*uav.v;ayv=cosd(thv)*uav.v;bxv=uav.pos(1);byv=uav.pos(2);
%calc first point
A1=[axv,-axo;ayv,-ayo];B1=[bxo-bxv;byo-byv];
t1=linsolve(A1,B1);t_uav1=t1(1);t_obs1=t1(2);
x1=bxv+axv*t_uav1;y1=byv+ayv*t_uav1;
%calc second point
bxo=po1(2,1);byo=po1(2,2);
A2=[axv,-axo;ayv,-ayo];B2=[bxo-bxv;byo-byv];
t2=linsolve(A2,B2);t_uav2=t2(1);t_obs2=t2(2);
x2=bxv+axv*t_uav2;y2=byv+ayv*t_uav2;

% pick a point
if t_obs1<0 && t_obs2<0 %obs pass the path already
    t=-10;p1=[0,0];
    return
elseif t_obs1<0 %obs is on the path (one point pass the path, one not)
    if t_uav2<t_obs2 && t_uav2>0
        t=t_uav2;
        p1=[x2,y2];
    else
        t=-10;p1=[0,0];
    end
    return
elseif t_obs2<0 %obs is on the path (one point pass the path, one not)
    if t_uav1<t_obs1 && t_uav1>0
        t=t_uav1;
        p1=[x1,y1];
    else
        t=-10;p1=[0,0];
    end
    return
end
% if obs has not touched path yet
if t_uav1<0 || t_uav1>eta % pick the point will collides
    t=t_uav2;
    x=x2;y=y2;
elseif t_uav2<0||t_uav2>eta % pick the point will collides
    t=t_uav1;
    x=x1;y=y1;
else %return the point will collide first, doubt this will happen due to the calculation
    if t_uav1<t_uav2
        t=t_uav1;
        x=x1;y=y1;
    else
        t=t_uav2;
        x=x2;y=y2;
    end
end
p1=[x,y];
end