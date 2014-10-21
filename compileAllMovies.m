%movie_path = '/Volumes/Data_Disk2/multi_species_brady5/';
movie_path = '/Volumes/Big_Guy/BradyMovies2/';

frameRate = 25;
bitRate = 1600;
codec = 'libx264';
%codec = 'mpeg4';
outputType = 'mp4';

speciesFolders = findAllFoldersInFolders(movie_path);
L = length(speciesFolders);

bitRate = num2str(bitRate);
frameRate = num2str(frameRate);

for i=1:L
    
    fprintf(1,[speciesFolders{i} '\n']);
    
    currentPath = [movie_path speciesFolders{i} '/'];
    currentFolders = findAllFoldersInFolders(currentPath);
    
    K = length(currentFolders);
    
    for j=1:K
        
        imagePath = [currentPath currentFolders{j} '/'];
        
        q1 = findImagesInFolder(imagePath,'mp4');
        
        if isempty(q1)
            
            fprintf(1,['\t ' currentFolders{j} '\n']);
            
            movieName = [speciesFolders{i} '_' currentFolders{j} '.mp4'];
            
            cd(imagePath);
            
            q = findImagesInFolder(imagePath,'tif');
            q = q{end};
            idx = find(q == '/',1,'last');
            q = q(idx+1:end-4);
            
            numInts = num2str(length(q));
            a = findImagesInFolder(imagePath,'tif');
            a = imread(a{1});
            s = size(a);
            %aspectR = s(1)/s(2);
            %[num,dem] = rat(aspectR);
            
            [~,~] = unix(['/opt/local/bin/ffmpeg -b:v ' bitRate ' -r ' frameRate ' -i %' numInts 'd.tif -vcodec ' codec ...
                ' -y ' movieName]);
            
            %[~,~] = unix(['/opt/local/bin/ffmpeg -b:v ' bitRate ' -r ' frameRate ' -i %' numInts 'd.tif -vcodec ' codec ...
            %    ' -s ' num2str(s(1)) 'x' num2str(s(2)) ' -aspect ' num2str(dem) ':' num2str(num) ' -y ' movieName]);
        
        end
        
    end
    
    unix('purge');
    
    
    movies2 = findAllImagesInFolders(currentPath,'mp4');
    for j=1:length(movies2)
        [~,~] = unix(['mv ' movies2{j} ' ' currentPath]);
    end
    
end




