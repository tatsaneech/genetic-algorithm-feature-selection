% % % % % % load data here % % % % % %
% set this to your base path in which the files were extracted
%basepath='C:\Users\Alistair\Documents\MATLAB\';
clc;

% if you save raw to a .mat file, can load it directly
% with this and avoid using the excel files/routine

if isunix
    bpath='/home/alistair/code/';
else
    bpath='C:\Users\Alistair\Documents\MATLAB\';
end

% first load data
if exist('raw','var')
    if exist('tr_raw','var') && exist('t_raw','var') && exist('v_raw','var')
        clearvars -except raw tr_raw t_raw v_raw bpath;
    else
        clearvars -except raw bpath;
    end
else
    clearvars -except bpath;
    [ raw ] = loadmatdata('data_180k.mat',bpath);
end

% remove data with missing outcomes
out=cell2mat(raw(2:end,strcmp('icudead',raw(1,:))));

out_nan=isnan(out);
if sum(out_nan)>0
    out_nan=[false;out_nan];
    raw=raw(~out_nan,:);
end
clearvars out out_nan;

% % % % % % train algorithm here % % % % % %
% choose which parameters to use in the PSO
% these must be identical to those stored in the header row
% also must be a cell array of strings

lbl1={'abg_pco2','abg_pao2','ph','wbc','creat','gluc','hcrit','bun','hr','map','temp','rr','pafi','PRELOS2','urine','gcs'};
lbl2={'hr','map','temp','rr','pafi','PRELOS2','urine','gcs'};
lbl_sml={'hr','gcs','pafi'};
% sorted by % missing


% train direct model comparisons
% k=1;
if matlabpool('size')<=0
    matlabpool 8
end

fprintf('Beginning training LR \n');
tic
lrCELL=train_alg(raw,lbl1,'fun','mylr','rand',1,...
    'R',0,'lr',0,'N',50,'mv',0,'qf',1,'norm',1,'balance',0,...
    'write',1,'write_str',['_17lbl_mv0b0n1']);
lrCELL2=train_alg(raw,lbl2,'fun','mylr','rand',1,...
    'R',0,'lr',0,'N',50,'mv',0,'qf',1,'norm',1,'balance',0,...
    'write',1,'write_str',['_8lbl_mv0b0n1']);
toc
fprintf('Beginning training SVM \n');
tic
svmCELL3=train_alg(raw,lbl,'fun','libsvm','rand',1,...% 'opt','-w0 1 -w1 10 -b 1',
    'R',0,'lr',0,'N',42,'mv',0,'qf',1,'norm',1,'balance',1,...
    'write',1,'write_str',['_28lbl_mv0b1n1']);
svmCELL2=train_alg(raw,lbl2,'fun','libsvm','rand',1,...
    'R',0,'lr',0,'N',1,'mv',0,'qf',1,'norm',1,'balance',1,...
    'write',0,'write_str',['_8lbl_mv0b1n1']);
toc
fprintf('Beginning training PSO \n');
psoCELL=train_alg(raw,lbl1,'fun','mypso','rand',1,...
    'R',0,'lr',1,'N',8,'mv',0,'qf',1,'norm',1,'balance',0,...
    'write',1,'write_str',['_17lbl_mv0b0n1']);
tic
psoCELL=train_alg(raw,lbl2,'fun','mypso','rand',1,...
    'R',0,'lr',1,'N',8,'mv',0,'qf',10,'norm',1,'balance',0,...
    'write',1,'write_str',['_8lbl_qf10_mv0b0n1']);
lbl={'age','aps','female','white','black','latino',...
    'thromrx','unable','vent','elect','emerg','floor',...
    'chi','aids','cirrhosis','hepfail','immunosup','lymphoma','myeloma','tumorwm'};
lbl=[lbl2,lbl];
psoCELL2=train_alg(raw,lbl,'fun','mypso','rand',1,...
    'R',0,'lr',1,'N',8,'mv',0,'qf',1,'norm',1,'balance',0,...
    'write',1,'write_str',['_30lbl_mv0b0n1']);
psoCELL3=train_alg(raw,lbl,'fun','mypso','rand',1,...
    'R',0,'lr',1,'N',8,'mv',0,'qf',1,'norm',1,'balance',1,...
    'write',1,'write_str',['_30lbl_mv0b1n1']);
toc
if matlabpool('size')>0
    matlabpool close;
end
