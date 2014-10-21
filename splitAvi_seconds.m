function N = splitAvi_seconds(fileName,savePath,splitLength,ffmpegPath)

    if nargin < 4 || isempty(ffmpegPath)
        fprintf('No ffmpeg path provided. Using /opt/local/bin/');
        ffmpegPath = '/opt/local/bin/';
    end
	fprintf(fileName)
	fprintf(savePath)
    %split length is in minutes
    splitLength = round(splitLength*100)/100;
    if splitLength <= 0
        splitLength = 1;
    end
    
    if isempty(savePath)
        [dir,name,~] = fileparts(fileName);
        dir = [dir '/' name '/splitMovies/'];
        fprintf(['No savePath, making dir ' dir '\n']);
    else
        dir = [savePath 'splitMovies/'];
        fprintf(['Saving to ' dir '\n']);
    end
        
    [status,~]=unix(['ls ' dir]);
    if status ~= 0
        [~,~] = unix(['mkdir ' dir]);
        fprintf(['New directory made: ' dir '\n']);
    else
        fprintf(['New directory not made' '\n']);
    end
    exist '/scratch/gpfs/dmossing/movies/'
    vidObj = VideoReader(fileName);
    t = vidObj.Duration;
    N = ceil(t / splitLength);
    numZeros = ceil(log(N)./log(10)+1e-10);
    
    readout = 1;
   fprintf(num2str(N))
    parfor i=1:N
        
        if mod(i,readout) == 0
            fprintf(1,['\t Splitting into File #' num2str(i) ' out of ' num2str(N) '\n']);
        end
            
        q = num2str(i);
        q = [repmat('0',1,numZeros-length(q)) q];
        
        startTime = (i-1)*splitLength;
        hours = num2str(floor(startTime/(60*60)));
        hours = [repmat('0',1,2-length(hours)) hours];
        currentTime = 60*60*str2double(hours);
        minutes = num2str(floor((startTime - currentTime)/60));
        minutes = [repmat('0',1,2-length(minutes)) minutes];
        currentTime = currentTime + str2double(minutes)*60;
        seconds  = num2str(floor(startTime - currentTime));
        seconds = [repmat('0',1,2-length(seconds)) seconds];
        currentTime = currentTime + str2double(seconds);
        dec = num2str(100*(startTime - currentTime));
        
        sL = num2str(splitLength);
        %s = num2str(floor(splitLength));
        %r = num2str(100*mod(splitLength,1));
        %sL = [repmat('0',1,2-length(s)) s '.' r];
        
        %fprintf(1,[hours ':' minutes ':' seconds '.' dec ' -t 00:00:' sL '\n']);
        
        if i < N
  
            [status,output] = unix([ffmpegPath 'ffmpeg -r 1 -ss ' hours ':' minutes ':' seconds '.' dec ' -t ' sL ' -i ' fileName...
               ' -vcodec copy -acodec copy -r 1 ' dir 'split_' q '.avi']);
            fprintf([status ' '  output])
		fprintf([dir 'split_' q '.avi \n'])
        else
      
            [status,output] = unix([ffmpegPath 'ffmpeg -r 1 -ss ' hours ':' minutes ':' seconds '.' dec ' -i ' fileName...
 ' -vcodec copy -acodec copy -r 1 ' dir 'split_' q '.avi']);
	fprintf([status ' ' output])
	fprintf(['ffmpeg -r 1 -ss ' hours ':' minutes ':' seconds '.' dec ' -i ' fileName...
                ' -report -vcodec copy -acodec copy -r 1 ' dir 'split_' q '.avi \n'])
        end
        
    end
