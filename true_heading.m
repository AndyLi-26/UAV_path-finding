function h=true_heading(a,b)
%function to calc the ideal heading angle between 2 points
% input:
% a: starting point
% b: destination point
% output:
% h: angle start from a to b
temp=b-a;
h=atand(temp(2)/temp(1));
if temp(1)<0 && temp(2)<0 %third quadrant
    h=h-180;
elseif temp(1) <0 && temp(2)>0 % second quadrant
    h=h-180;
end    
% convert to true bearing angle
h=mod(90-h,360);
end