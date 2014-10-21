function s_movie = embedding_to_movie(emfile)
% [pos_dir idx '/Images' g{i}(end-17:end-16) '.avi'];
C = strsplit(emfile,'/'); 
% 1'' 2'scratch' 3'gpfs' 4'dmossing' 5'projections' 6'072414_124238' 7'00' 8'1'
% 9'embedding.mat'
C{5} = 'movies';
C{7} = ['Images' C{7} '.avi'];
C(8:end) = [];
s_movie = strjoin(C,'/');
% s_movie = s(2:end);
end