 function res = testPerc(imagesPath, numImages, myPointsPath, realPointsPath, distToll)
%TESTPERC tests a set of images returning the percentage of success, failure and no result for all the heuristics
%
%	imagesPath: relative path of the images' set
%	numImages: number of images in the set
%	myPointsPath: relative path of already computed points
%	realPointsPath: relative path of ground truth
%	distToll: threshold, in pixels, to distinguish between success and fail
%
%	res: structure containing the percentage of success, failure and no result for all the heuristics
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

successPerchHarris = 0;
successPerchProportion = 0;
successPerchHPL = 0;
successPerchHOL = 0;
successPerchCombo = 0;

failPerchHarris = 0;
failPerchProportion = 0;
failPerchHPL = 0;
failPerchHOL = 0;
failPerchCombo = 0;

noreshHarris = find(bhHarris==true);
noresPerchHarris = length(noreshHarris);

noreshProportion = find(bhProportion==true);
noresPerchProportion = length(noreshProportion);

noreshHPL = find(bhHPL==true);
noresPerchHPL = length(noreshHPL);

noreshHOL = find(bhHOL==true);
noresPerchHOL = length(noreshHOL);

noreshCombo = find(bhCombo==true);
noresPerchCombo = length(noreshCombo);

for i = 1:numImages
     %% ------- CALC -------
     
    pts = load(strcat(realPointsPath, num2str(i), '.mat'));
    pts = pts.pts;
    rpts = [pts.x; pts.y];
    
    if(bhHarris(i)==0)
        [disthHarris success] = hMetrics(phHarris(i).pts, rpts, distToll);
        if(success)
           successPerchHarris = successPerchHarris + 1;
        else
            failPerchHarris = failPerchHarris + 1;
        end
    end
    
    if(bhProportion(i)==0)
        [disthProportion success] = hMetrics(phProportion(i).pts, rpts, distToll);
        if(success)
           successPerchProportion = successPerchProportion + 1;
        else
            failPerchProportion = failPerchProportion + 1;
        end
    end
    
    if(bhHPL(i)==0)
        [disthHPL success] = hMetrics(phHPL(i).pts, rpts, distToll);
        if(success)
           successPerchHPL = successPerchHPL + 1;
        else
            failPerchHPL = failPerchHPL + 1;
        end
    end

    if(bhHOL(i)==0)
        [disthHOL success] = hMetrics(phHOL(i).pts, rpts, distToll);
        if(success)
           successPerchHOL = successPerchHOL + 1;
        else
            failPerchHOL = failPerchHOL + 1;
        end
    end
    
    if(bhCombo(i)==0)
        [disthCombo success] = hMetrics(phCombo(i).pts, rpts, distToll);
        if(success)
            successPerchCombo = successPerchCombo + 1;
        else
            failPerchCombo = failPerchCombo + 1;
        end
    end

end

res.successPerchHarris = successPerchHarris/numImages;
res.successPerchProportion = successPerchProportion/numImages;
res.successPerchHPL = successPerchHPL/numImages;
res.successPerchHOL = successPerchHOL/numImages;
res.successPerchCombo = successPerchCombo/numImages;

res.failPerchHarris = failPerchHarris/numImages;
res.failPerchProportion = failPerchProportion/numImages;
res.failPerchHPL = failPerchHPL/numImages;
res.failPerchHOL = failPerchHOL/numImages;
res.failPerchCombo = failPerchCombo/numImages;

res.noresPerchHarris = noresPerchHarris/numImages;
res.noresPerchProportion = noresPerchProportion/numImages;
res.noresPerchHPL = noresPerchHPL/numImages;
res.noresPerchHOL = noresPerchHOL/numImages;
res.noresPerchCombo = noresPerchCombo/numImages;