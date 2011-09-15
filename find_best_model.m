function t = find_best_model(Sen,Spe)

L = length(Sen);
t = 50;
dmin = sqrt(2) ;
for thres=1:L
    d_tmp = sqrt((1-Sen(thres))^2+(Spe(thres))^2);
    if d_tmp < dmin
        dmin = d_tmp;
        t = thres ;        
    end
end