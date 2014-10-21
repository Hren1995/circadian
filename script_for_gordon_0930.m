% for Gordon, 9/30/14: run this code to load the variables from processing
% with sigma = 1.5 and sigma = 2 respectively

lookAtSigma1_5 = true; % set this to false to see the data for sigma = 2

if lookAtSigma1_5
    load('bsm_07_processing_s1_5.mat')
else
    load('bsm_07_processing_s2_0.mat')
end

plot_unclustered_behaviors(dm,ds,dpts,beginds);
% generates two sets of time series, one with all data points shown and one
% with mean +/- SEM

t = 0:0.5:24;

[ii,jj] = find(L == 0);
figure;
for i=1:size(d_t,3) % shows time series of density map
    imagesc(xx,xx,d_t(:,:,i))
    axis equal tight off xy
    hold on;
    plot(xx(jj),xx(ii),'w.');
    hold off;
    xlabel([num2str(t(i)) ' to ' num2str(i+1) ' hours after midnight'])
    pause(0.5)
end

% density map for entire 24 hours
imagesc(xx,xx,sum(d_t,3))
axis equal tight off xy
hold on;
plot(xx(jj),xx(ii),'w.');
hold off;

