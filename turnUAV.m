function turnUAV(P)
% function to turn uav
% input:
% P: destination point
% output:
% uav.h will be updated for next second
global uav
h=true_heading(uav.pos,P);% get ideal heading angle if there is no yaw constrain
% calc heading angle difference
dif=abs(h-uav.h);
if dif>180
    dif=360-dif;
end
% if dif is larger, turn in max yaw rate, if not, turn to ideal heading
if dif>uav.yaw
    temp=uav.yaw*(h-uav.h)/abs(h-uav.h)+uav.h;
    uav.h=temp;
else
    uav.h=h;
end
end