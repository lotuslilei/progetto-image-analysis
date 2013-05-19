function [imagePoints badImages] = hCombo( imagesPath, numImages, flagPlot )

badImages = zeros(numImages, 1);
imagePoints.pts = zeros(numImages, 1);
imagePoints.id = zeros(numImages, 1);

for i = 1:numImages
    %% ------- CALC -------
    
    msg = ['hCombo: processing image ', num2str(i)];
    disp(msg);
    
    imagePtsCombo = hComboSingle(strcat(imagesPath, '/test', num2str(i), '.jpg'), flagPlot);
    
    if (imagePtsCombo(1,1) == -1)
        imagePoints(i).pts = [];
        imagePoints(i).id = strcat(num2str(i));
        badImages(i) = 1;
        continue;
    end    
    
    imagePoints(i).pts = imagePtsCombo;
    imagePoints(i).id = strcat(num2str(i));
    
end

save(strcat(imagesPath, '/imagePointshCombo'), 'imagePoints');
save(strcat(imagesPath, '/badImageshCombo'), 'badImages');

end
