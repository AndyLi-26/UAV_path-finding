function bool=collide(obs,wp)
%set up vars
global uav
r=max(obs.r);temph=true_heading(uav.pos,wp);
axo=sind(obs.h)*obs.v;ayo=cosd(obs.h)*obs.v;bxo=obs.pos(1);byo=obs.pos(2);
axv=sind(temph)*uav.v;ayv=cosd(temph)*uav.v;bxv=uav.pos(1);byv=uav.pos(2);%bxv=uav.pos(1)+axv;byv=uav.pos(2)+ayv;

%set up vars for linear sys
AX=axv-axo;BX=bxv-bxo;
AY=ayv-ayo;BY=byv-byo;

%set up vars for quadratic
a=AX^2+AY^2;b=2*(AX*BX+AY*BY);c=BX^2+BY^2-r^2;
del=b^2-4*a*c;
%check if there is a root
bool=false;
if (del>=0)
    sol1=(-b+sqrt(del))/(2*a);
    sol2=(-b-sqrt(del))/(2*a);
    eta=distance(wp,uav.pos)/uav.v;
    if sol1*sol2<0
        display("inside of obs");
    end
    bool=(sol1>0 && sol2>0 && (sol1<eta || sol2<eta));
end
end