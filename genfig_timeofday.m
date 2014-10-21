function genfig_timeofday(d_t)
grp = [11:22; 23:34; 35:46; [47:48, 1:10]];
nm = {'Morning'; 'Midday'; 'Evening'; 'Night'};
for i=1:size(grp,1)
    subplot(2,2,i)
    imagesc(sum(d_t(:,:,grp(i,:)),3));
    colorbar; caxis([0 0.01]);
    xlabel(nm{i},'FontSize',16)
end
end