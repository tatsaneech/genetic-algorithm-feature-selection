function [ children ] = crsov_SP( repro )
%crsov_SP Computes the resulting genomes from a single point crossover
%using maximal genetic distance as the matching criterion

POP_xover=size(repro,1);
VAR_NUM=size(repro,2);
% compute genetic distance between genomes
gen_dist = zeros(POP_xover,POP_xover);
for i = 1:POP_xover
    for j = 1:(i-1)
        gen_dist(i,j) = sqrt( sum( (repro(i,:) - repro(j,:)).^2 ) ) ;
    end
end

% Match couples with big genetical difference
for i = 1:POP_xover
    father = repro( i , : ) ;
    [dist j] = max(gen_dist(i,:)) ;
    mother = repro( j , : ) ;
    % random crossing point
    Xpoint = floor(rand(1,1)*VAR_NUM) ;
    children(i,:) = [ father(1:Xpoint) mother((Xpoint+1):end) ] ;
    children(POP_xover + i,:) = [ mother(1:Xpoint) father((Xpoint+1):end) ] ;
end


end

