function plot_ROC(img,AUC)


x = (0:(size(img,1)))/size(img,1) ;
y = [img ; 1 1 1] ;
t = find_best_model( y(:,2) , x );
plot( x , y(:, 1 ) , '--k', x , y(:,2) , 'b', x(t)  , y(t,2) , 'or' , x , y(:,3) , '--k'   );
hold on
plot(0:1,0:1,'g')

title(['AUC = ' num2str(mean(AUC),'%.2f') '%'],'FontSize',16);
legend('5-percentiles','Mean ROC curve','Selected model','Location','SouthEast');
xlabel('1-Specificity','FontSize',16);
ylabel('Sensitivity','FontSize',16);
hold off
