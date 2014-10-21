function playSegment(images,frames,pauseTime)

    frameImages = cell(length(frames),1);
    for i=1:length(frames)
        frameImages{i} = imread(images{frames(i)});
    end

    %figure
    for i=1:length(frames)
        imshow(frameImages{i});
        title(num2str(frames(i)))
        pause(pauseTime)
    end