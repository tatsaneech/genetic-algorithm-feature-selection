function p=Ztest(Z)
% From statbag pnorm.m (Steve Roberts)
% Return probability of z > Z if z is distributed as N(0,1)
root2=sqrt(2);
x=-1*Z/root2;
p=1-0.5*erfc(x);