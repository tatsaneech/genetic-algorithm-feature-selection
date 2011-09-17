% demo1
% This demo shows the user how to perform feature selection with the GA
% toolbox using all default parameters.
% loaddata;
% matlabpool;
% First, load the data
% load arrhythmia;
% disp(Description)
% 
% % Next, instantiate the GA options
% % A full list of options is available in the help file
% opts=ga_opt_set('Parallelize',1,'CostFcn',@cost_AUROC,'OptDir',1,...
%     'ErrorIterations',20,'ErrorGradient',0.005,...
%     'PopulationSize', 48,'FitnessFcn','fit_LR','NumActiveFeatures',30,...
%     'Repetitions', 50,'MaxIterations',200,'Display','none');
% 
% % Run the GA
% [ga_out, ga_options] =  AlgoGen(data,outcome,opts);
% 
% % matlabpool close;
% 
% % % test aoife's results
% % load aoife50rep300it.mat
% % tmp=GA_plot_repetitions(ga_out);
% % imagesc(tmp.MeanGenomePlot);
% % colormap([zeros(64,1),(1:64)'/64*204/256,zeros(64,1)]);
% 
% % Calculate frequency of last feature being selected
% xaxis=1:size(tmp.MeanGenomePlot,2);
% bestGenomeFreq=tmp.MeanGenomePlot(end,:);
% figure(4);
% %stem(xaxis(bestGenomeFreq>0.1),bestGenomeFreq(bestGenomeFreq>0.1))
% stem(xaxis,bestGenomeFreq)
% title('Average feature frequency selected at termination');
% xlabel('Feature #'); ylabel('Frequency of selection');
% 
% 
% % Calculate frequency of feature being selected in last 100 it
% figure(5);
% bestHGenomeFreq=mean(tmp.MeanGenomePlot(end-100:end,:),1);
% % stem(xaxis(bestHGenomeFreq>0.1),bestHGenomeFreq(bestHGenomeFreq>0.1))
% stem(xaxis,bestHGenomeFreq)
% title('Average feature frequency selected during final 100 iterations');
% xlabel('Feature #'); ylabel('Frequency of selection');
% 
% figure(6);
% stem(xaxis(bestHGenomeFreq>0.1 & bestGenomeFreq>0.1),bestGenomeFreq(bestHGenomeFreq>0.1 & bestGenomeFreq>0.1))
% title('Final feature frequency selected, at least >0.1 in final 100 iterations AND termination');
% xlabel('Feature #'); ylabel('Frequency of selection');
% 
% genomeKStest=zeros(1,size(tmp.MeanGenomePlot,2));
% genomeRandSamp=tmp.MeanGenomePlot(end-100:end,:);
% for q=1:size(tmp.MeanGenomePlot,2)
%     genomeKStest(q)=kstest(genomeRandSamp(:,q));
% end