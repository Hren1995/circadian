function score = findProjectionScores(testImage,loopImage,coeffs,mu,thetas,pixels,scale)
% returns projection scores given aligned image. All inputs are analogous
% to findRadonValues_pca_bin, except that loopImage, the aligned image,
% replaces the file names to be read in.

    
    s = size(testImage);
    scaledSize = round(s ./ scale);

    b = loopImage;
    a = double(imresize(b,scaledSize));
    lowVal = min(a(a>0));
    highVal = max(a(a>0));
    size(a)
    size(lowVal)
    size(highVal)
    size(lowVal)
    a = (a - lowVal) / (highVal - lowVal);
    z = radon(a,thetas);
    z = z(pixels) - mu';
    
    score = z' * coeffs;