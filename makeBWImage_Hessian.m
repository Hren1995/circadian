function [bw,eigs,bw2] = makeBWImage_Hessian(image,dilateSize,cannyParameter,threshold)

    if nargin < 2 || isempty(dilateSize) == 1
        dilateSize = 3;
    end
    
    if nargin < 3 || isempty(cannyParameter) == 1
        cannyParameter = .1;
    end
    
    if nargin < 4 || isempty(threshold) == 1
        threshold = 40;
    end
    
    %image(image<40) = nan;
    %image = fillnan(image);
    
    m = mean(image(:));
    if m > 100
        image = imcomplement(image);
    end
        
    
    [gxx,gyy,gxy] = derivative7(image,'xx','yy','xy');
    eig2 = .5*(gxx + gyy + sqrt((gxx-gyy).^2-4*gxy.^2));
    eig2(1:4,:) = 0;eig2(:,1:4) = 0;eig2((end-3):end,:) =0;eig2(:,(end-3):end)=0;
    eig1 = .5*(gxx + gyy - sqrt((gxx-gyy).^2-4*gxy.^2));
    eig1(1:4,:) = 0;eig1(:,1:4) = 0;eig1((end-3):end,:) =0;eig1(:,(end-3):end)=0;
    
    h2 = fspecial('average');
    eigs = imfilter(real(eig2+eig1),h2);
    %eigs = eig2 + eig1;
    %eigs = real(eig1+eig2);
    %eigs(eigs<0) = 0;
    
    %E = edge(eigs,'log',cannyParameter,'nothinning');
    %imshow(E)
    E = edge(eigs,'canny',cannyParameter,'nothinning');
    E(1,:) = 0; E(:,1) = 0; E(end,:) = 0; E(:,end) = 0;
    intenseEdges = immultiply(E,imcomplement(image));
    %intenseEdges = immultiply(E,abs(eig1+eig2));
    
    if threshold > 0
        idx = find(intenseEdges>threshold);
        CC = bwconncomp(E);
        cleanImages = logical(zeros(size(E)));
        Y = [];
        for j=1:length(CC.PixelIdxList)
            if length(intersect(CC.PixelIdxList{j},idx)) > 0
                Y = [Y CC.PixelIdxList{j}'];
            end
        end
        cleanImages(Y) = 1;
    else
        cleanImages = E;
    end
    
    
    
    se = strel('square',dilateSize);
    E2 = imerode(imfill(imdilate(cleanImages,se),'holes'),se);
    E3 = imfill(E2,'holes');
    
    
    CC = bwconncomp(E3);
    L = length(CC.PixelIdxList);
    lengths = zeros(1,L);
    for i=1:L
        lengths(i) = length(CC.PixelIdxList{i});
    end
    [aaa,CCidx] = sort(lengths);
    CCidx = CCidx(end);
    
    E4 = E3;
    E4(:) = 0;
    E4(CC.PixelIdxList{CCidx}) = 1;
    
    out = imerode(E4,se);
    out = imdilate(out,se);
    
    CC = bwconncomp(out);
    L = length(CC.PixelIdxList);
    lengths = zeros(1,L);
    for i=1:L
        lengths(i) = length(CC.PixelIdxList{i});
    end
    [aaa,CCidx] = sort(lengths);
    if ~isempty(CCidx)
        CCidx = CCidx(end);
    
        
        E4(:) = 0;
        E4(CC.PixelIdxList{CCidx}) = 1;
        
        bw = E4;
        bw2 = bw;
        
    else
        
        bw = false(size(image));
        bw2 = false(size(image));
        
    end
    %eigs = eig1+eig2;
    
    %     figure
    %     subplot(1,3,1)
    %     imagesc(real(eig2));colormap('jet');
    %     axis equal
    %     axis off
    %     subplot(1,3,2)
    %          imagesc((eig1+eig2).*out)
    %          axis equal
    %          axis off
    %          hold on
    %     B = bwboundaries(bw);
    %     B = B{1};
    %     plot(B(:,2),B(:,1),'r-','linewidth',2)
    %
    %
    %     E2 = E;
    %     idx = sub2ind(size(E),B(:,1),B(:,2));
    %     E2(idx) = 0;
    %     out3 = imerode(imfill(imdilate(E2,se),'holes'),se);
    %     CC = bwconncomp(out3);
    %     L = length(CC.PixelIdxList);
    %     lengths = zeros(1,L);
    %     for i=1:L
    %         lengths(i) = length(CC.PixelIdxList{i});
    %     end
    %     [aaa,CCidx] = sort(lengths);
    %     CCidx = CCidx(end);
    %
    %     bw2 = logical(zeros(size(out3)));
    %     bw2(CC.PixelIdxList{CCidx}) = 1;
    
    %subplot(1,3,3)
    %imshow(immultiply(out4,image))
    
    