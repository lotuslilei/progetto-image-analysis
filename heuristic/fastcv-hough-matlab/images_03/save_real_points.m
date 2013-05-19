for n = 1:12
    close all
    
    imname = strcat('test', num2str(n));
    impath = strcat(imname, '.jpg');
    matpath = strcat(imname, '.mat');
    
    img = imread(impath);
    imshow(img);
    [x y] = getpts;
    
    pts.name = impath;
    pts.x = x;
    pts.y = y;
    
    save(matpath, 'pts')
end