function dis=total_dis(total)
%function: calculate the total distance traveled (debug purpose)
%input: the total traveled path
%output: total distance
dis=0;
for i=1:length(total)-1
    dis=dis+distance(total(i,:),total(i+1,:));
end