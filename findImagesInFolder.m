function images = findImagesInFolder(folder,fileType,frontConstraint)

if nargin == 1
    fileType = '.tif';
end

if nargin < 3 || isempty(frontConstraint) == 1
    frontConstraint = '';
end

%[status,files]=unix(['ls ' folder '*' fileType]);

%['ls ' folder '*' fileType]
%status
if nargin < 3 || isempty(frontConstraint) == 1
    [status,files] = unix(['find ' folder ' -name "*' fileType '"']);
else
    [status,files] = unix(['find ' folder ' -name "' frontConstraint '*' fileType '"']);
end


if status == 0
    filesOut = regexp(regexp(files,'\t','split'),'\n','split');
    images = filesOut{1}';
    for i=2:length(filesOut)
        images = [images ;filesOut{i}'];
    end
    images = sort(images);
    while isempty(images{1}) == 1
        images = images(2:end);
        if isempty(images)
            break;
        end
    end
    
else
    images = [];
end