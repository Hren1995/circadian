D = sum(d_t,3);
D(L==7) = 1;
imagesc(D)
caxis([0 0.018])