function min_dis=Colide(obs_list)
global uav
all_dis=zeros(1,length(obs_list));
for i=1:length(obs_list)
    all_dis(i)=distance(uav.pos,obs_list(i).pos)-300;
end
min_dis=min(all_dis);
end