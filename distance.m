function dis=distance(a,b)
% calc distance between a and b
temp=a-b;
dis=abs(complex(temp(1),temp(2)));