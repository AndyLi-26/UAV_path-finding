function [M,obs]=t3d_obs_gen(path)
%read file
%path="obss/";
temp=strcat(path,'*.txt');
files = dir (temp);
L = length (files); 
M=struct([]);
obs=struct([]);
for i=1:L
    fid = fopen(strcat(path,files(i).name));
    tline = fgetl(fid);
    tlines = cell(0,1);
    while ischar(tline)
        tlines{end+1,1} = str2num(tline);
        tline = fgetl(fid);
    end
    obs(i).oid=i;
    obs(i).start=tlines{1};
    obs(i).end=tlines{2};
    d.x=tlines{3};
    d.y=tlines{4};
    d.z=tlines{5};
    obs(i).pos=d;
    obs(i).r=tlines{6};
    obs(i).id=tlines{7};
    
    %%generate
    M(i).oid=i;
    M(i).t=obs(i).start:obs(i).end;
    n=length(M(i).t);
    %calc xyz
    M(i).x=polyval(obs(i).pos.x,M(i).t);
    M(i).y=polyval(obs(i).pos.y,M(i).t);
    M(i).z=polyval(obs(i).pos.z,M(i).t);
    %gen rf acc id
    %rf stands for radius function
    switch obs(i).id
        case {1,2,3}
            temp=[300,200,100];
            rf=temp(obs(i).id);
        case 4
            rf=obs(i).r;
        otherwise
            error("wrong obs id");
    end
    obs(i).r=rf;
    M(i).r=polyval(obs(i).r,M(i).t);
    M(i).id=obs(i).id;
    
    %gen dx dy dz
    fvx=polyder(obs(i).pos.x);
    v.x=polyval(fvx,M(i).t);
    
    fvy=polyder(obs(i).pos.y);
    v.y=polyval(fvy,M(i).t);

    fvz=polyder(obs(i).pos.z);
    v.z=polyval(fvz,M(i).t);
    %append v into output
    M(i).ROC=v.z;
    M(i).v=sqrt(v.x.^2+v.y.^2);
    ori=atan(v.x./v.y)*180/pi;
    M(i).H=ori;
    %expand heading from (-90,90) to (-180,180)
    temp1=v.x(:)>=0;
    temp2=v.y(:)<0;
    temp=(temp1&temp2)'*180;
    M(i).H=M(i).H+temp;
    
    temp1=v.x(:)<0;
    temp2=v.y(:)<0;
    temp=(temp1&temp2)'*180;
    M(i).H=M(i).H-temp;
    % True bearing
    M(i).H=M(i).H+360;
    M(i).H=rem(M(i).H,360);
end





