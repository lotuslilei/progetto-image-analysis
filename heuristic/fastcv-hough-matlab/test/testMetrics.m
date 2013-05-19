function res = testMetrics(imagesPath, numImages, myPointsPath, realPointsPath)
%TESTMETRICS tests a set of images, returning the sum of the square distances of the real points wrt the points extracted by the heuristics for all the images in the set
%
%	imagesPath: relative path of the images' set
%	numImages: number of images in the set
%	myPointsPath: relative path of already computed points
%       realPointsPath: relative path of ground truth
%
%	res: structure containing the sum of the square distances of the real points wrt the points extracted by the heuristics for all the images in the set
%

addpath('../hHarris');
addpath('../hProportion');
addpath('../hHoughCloseOrtLines');
addpath('../hHoughParallelLines');
addpath('../hCombo');

if(exist(strcat(myPointsPath, 'imagePointshHarris.mat'), 'file')==0 || exist(strcat(myPointsPath, 'badImageshHarris.mat'), 'file')==0)
    [phHarris bhHarris] = hHarris(imagesPath, numImages, false);
else
    phHarris = load(strcat(myPointsPath, 'imagePointshHarris.mat'));
    phHarris = phHarris.imagePoints;
    bhHarris = load(strcat(myPointsPath, 'badImageshHarris.mat'));
    bhHarris = bhHarris.badImages;
end

if(exist(strcat(myPointsPath, 'imagePointshProportion.mat'), 'file')==0 || exist(strcat(myPointsPath, 'badImageshProportion.mat'), 'file')==0)
    [phProportion bhProportion] = hProportion(imagesPath, numImages, false);
else
    phProportion = load(strcat(myPointsPath, 'imagePointshProportion.mat'));
    phProportion = phProportion.imagePoints;
    bhProportion = load(strcat(myPointsPath, 'badImageshProportion.mat'));
    bhProportion = bhProportion.badImages;
end

if(exist(strcat(myPointsPath, 'imagePointshHPL.mat'), 'file')==0 || exist(strcat(myPointsPath, 'badImageshHPL.mat'), 'file')==0)
    [phHPL bhHPL] = hHPL(imagesPath, numImages, false);
else
    phHPL = load(strcat(myPointsPath, 'imagePointshHPL.mat'));
    phHPL = phHPL.imagePoints;
    bhHPL = load(strcat(myPointsPath, 'badImageshHPL.mat'));
    bhHPL = bhHPL.badImages;
end

if(exist(strcat(myPointsPath, 'imagePointshHOL.mat'), 'file')==0 || exist(strcat(myPointsPath, 'badImageshHOL.mat'), 'file')==0)
    [phHOL bhHOL] = hHOL(imagesPath, numImages, false);
else
    phHOL = load(strcat(myPointsPath, 'imagePointshHOL.mat'));
    phHOL = phHOL.imagePoints;
    bhHOL = load(strcat(myPointsPath, 'badImageshHOL.mat'));
    bhHOL = bhHOL.badImages;
end

if(exist(strcat(myPointsPath, 'imagePointshCombo.mat'), 'file')==0 || exist(strcat(myPointsPath, 'badImageshCombo.mat'), 'file')==0)
    [phCombo bhCombo] = hCombo(imagesPath, numImages, false);
else
    phCombo = load(strcat(myPointsPath, 'imagePointshCombo.mat'));
    phCombo = phCombo.imagePoints;
    bhCombo = load(strcat(myPointsPath, 'badImageshCombo.mat'));
    bhCombo = bhCombo.badImages;
end

commonDistQuadrhHarris = 0;
commonDistQuadrhHPL = 0;
commonDistQuadrhHOL = 0;
commonDistQuadrhProportion = 0;
commonDistQuadrhCombo = 0;

figure, hold on;

for i = 1:numImages
     %% ------- CALC -------
     
    pts = load(strcat(realPointsPath, num2str(i), '.mat'));
    pts = pts.pts;
    rpts = [pts.x; pts.y];
    
    flagAllH = false;
    
    if bhHPL(i)==0 && bhHOL(i)==0 && bhHarris(i)==0 && bhProportion(i)==0 && bhCombo(i)==0
        disthHarris = hMetrics(phHarris(i).pts, rpts);
        commonDistQuadrhHarris = commonDistQuadrhHarris + disthHarris;
        
        disthHPL = hMetrics(phHPL(i).pts, rpts);
        commonDistQuadrhHPL = commonDistQuadrhHPL + disthHPL;
        
        disthHOL = hMetrics(phHOL(i).pts, rpts);
        commonDistQuadrhHOL = commonDistQuadrhHOL + disthHOL;
        
        disthProportion = hMetrics(phProportion(i).pts, rpts);
        commonDistQuadrhProportion = commonDistQuadrhProportion + disthProportion;
        
        disthCombo = hMetrics(phCombo(i).pts, rpts);
        commonDistQuadrhCombo = commonDistQuadrhCombo + disthCombo;
        
        flagAllH = true;
    end
    
    
    %% ------- PLOT -------
  
    dev = 0.1;
    if(flagAllH==true)
        plot(i-2*dev, disthHarris, 'x', 'LineWidth', 1, 'Color', 'green');
        plot([i-2*dev i-2*dev], [0 disthHarris], 'LineWidth', 1, 'Color', 'green');
        
        plot(i-dev, disthHPL, 'x', 'LineWidth', 1, 'Color', 'black');
        plot([i-dev i-dev], [0 disthHPL], 'LineWidth', 1, 'Color', 'black');
        
        plot(i, disthHOL, 'x', 'LineWidth', 1, 'Color', 'red');
        plot([i i], [0 disthHOL], 'LineWidth', 1, 'Color', 'red');
        
        plot(i+dev, disthProportion, 'x', 'LineWidth', 1, 'Color', 'cyan');
        plot([i+dev i+dev], [0 disthProportion], 'LineWidth', 1, 'Color', 'cyan');
        
        plot(i+2*dev, disthCombo, 'x', 'LineWidth', 1, 'Color', 'blue');
        plot([i+2*dev i+2*dev], [0 disthCombo], 'LineWidth', 1, 'Color', 'blue');
    end
    
end

res.commonDistQuadrhHarris = commonDistQuadrhHarris;
res.commonDistQuadrhHPL = commonDistQuadrhHPL;
res.commonDistQuadrhHOL = commonDistQuadrhHOL;
res.commonDistQuadrhProportion = commonDistQuadrhProportion;
res.commonDistQuadrhCombo = commonDistQuadrhCombo;

end