function [ itrain, itest ] = myholdout( N, P )
%MYHOLDOUT holds out P (0 to 1) indices for testing

    if (length(N) > 1)
        N = length(N);
    end
    
%     random indices from 1:N
    temp = randperm(N)';
    
    test1 = (temp(1:floor(N*P)));
    train1=temp(floor(N*P)+1:end);
%   test and train now contain P and 1-P portion of the randomized indices
    itest=zeros(N,1); itrain=itest;
    itest(test1) = 1; itrain(train1)=1;
    itest=logical(itest); itrain=logical(itrain);


end

