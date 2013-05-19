function [ imagePoints ] = hHOLSingle( image, flagPlot )
%HHOL given the image it tries to extract the four corner points of the
%sheet in the image, according to the Hough Close Orthogonal Lines heuristic
%
%   imagesPath: path where images are located
%   numImages: number of images that will be processed
%   flagPlot: true for plotting images, lines and corner points, false
%   otherwise
%
%   imagePoints: extracted corner points for each image
%   badImages: cointains 1 in correspondence of intractable images, 0
%   otherwise
%

addpath('../utils');
addpath('../my_matlab_fastcv');

imagePoints = [];

%% ------- CALC -------

% Read the image and put it into RGB
RGB = imread(image);

% Get image's dimensions
[ri ci] = size(RGB);

% Remove croma components and leave just the luminance, store the
% gray scale image into I
I  = rgb2gray(RGB);


% Find lines:

% Default values [50 200] for low and high Canny threshold
cannyThresh = [50 200];

% Default value of houghpeaks threshold (default value = 100)
peakThresh = 100;

% We want to find at least 4 lines
numLinesMin = 4;

% For computational issues images with too many lines are considered
% not meaningful
numLinesMax = 200;

% Houghlines default distance in pixels for joining two segments into
% a single line (default value = 10, desired value = 30)
lineGap = ceil(0.013*(ri + ci)/2);

% Line gap increment (desired value = 5)
lineGapInc = ceil(0.0022*(ri + ci)/2);

% Maximum allowed distance (in pixels) for joining two segments into a
% single line (desired value = 200)
lineGapMax = ceil(0.09*(ri + ci)/2);

% Houghlines default minimum length in pixels for considering a sequence of
% pixels as line (default value = 50, desired value = 80)
lineMinLength = ceil(0.035*(ri + ci)/2);

% Line minimum lenght increment (desired value = 5)
lineMinLenInc = ceil(0.0022*(ri + ci)/2);

% Maximum line minimum length allowed (in pixels) for considering a
% sequence of pixels as line
lineMinLenMax = 1;

lines = 0;

% It tries to find in the image at least 4 lines relaxing the
% constraints lineGap and lineMinLength
while length(lines)<numLinesMin
    
    lines = fastcv_hough(image, cannyThresh(1,1), cannyThresh(1,2), peakThresh, lineMinLength, lineGap);
    
    if(lineGap>=lineGapMax && lineMinLength<=lineMinLenMax)
        break;
    end
    
    if(lineGap+lineGapInc>=lineGapMax)
        lineGap = lineGapMax;
    else
        lineGap = lineGap + lineGapInc;
    end
    
    if(lineMinLength-lineMinLenInc<=lineMinLenMax)
        lineMinLength = lineMinLenMax;
    else
        lineMinLength = lineMinLength - lineMinLenInc;
    end
    
end

if (exist('lines', 'var')==0)
    imagePoints = -1;
    clear lines sLines candLines
    return;
end

if (length(lines)<numLinesMin || length(lines)>numLinesMax)
    imagePoints = -1;
    clear lines sLines candLines
    return;
end

% Sort lines from longer to shorther
sLines = sortLines(lines);
clear lines

% Minimum distance of a segment from a line because it is considered
% part of that line (desired value = 30)
distToll = ceil(0.013*(ri + ci)/2);
% Join segments belonging to the same line
sLines = joinLines(sLines, distToll);

% Remove useless lines after the joining
sLines = cleanLines(sLines);

% Sort lines from longer to shorther
sLines = sortLines2(sLines);

% Compute candidated lines:

% Angle tollerance for having 2 orthogonal lines (in degrees)
thetaToll = 25;
% Angle increment (in degrees)
thetaTollInc = 5;
% Maximum angle tollerance (in degrees)
thetaTollMax = 36;

% Distance tollerance for having 2 close lines (desired value = 40)
distToll = ceil(0.018*(ri + ci)/2);
% Distance tollerance increment (desired value = 10)
distTollInc = ceil(0.0044*(ri + ci)/2);
% Maximum distance tollerance (desired value = 2000)
distTollMax = ceil(0.9*(ri + ci)/2);

to = length(sLines);
candIndex = 1;

candLines.l1.l = 0;
candLines.l1.id = 0;
candLines.l2.l = 0;
candLines.l2.id = 0;

numLinesMin = 2;

% It tries to find at least 4 lines that respects the constraints (thetaToll, distToll), relaxing them by their increments (thetaTollInc, distTollInc), till they reach thetaTollMax and distTollMax
while(length(candLines)<numLinesMin)
    
    if(distToll>=distTollMax && thetaToll>=thetaTollMax)
        break;
    end
    
    for h = 1:to
        from = h+1;
        if(from<=length(sLines) && sLines(h).flag == 0)
            for k = from:length(sLines)
                if(sLines(h).id ~= sLines(k).id) && (sLines(k).flag == 0)
                    if(areOrthogonal(getAngle(sLines(h).l), getAngle(sLines(k).l), thetaToll) && areClose(sLines(h).l, sLines(k).l, distToll))
                        candLines(candIndex).l1.l = sLines(h).l;
                        candLines(candIndex).l2.l = sLines(k).l;
                        candLines(candIndex).l1.id = sLines(h).id;
                        candLines(candIndex).l2.id = sLines(k).id;
                        candIndex = candIndex + 1;
                        sLines(k).flag = 1;
                        break;
                    end
                end
            end
        end
    end
    
    thetaToll = thetaToll + thetaTollInc;
    distToll = distToll + distTollInc;
    
end

clear sLines

if (exist('candLines', 'var')==0)
    imagePoints = -1;
    clear lines sLines candLines
    return;
end

if (length(candLines)<numLinesMin)
    imagePoints = -1;
    clear lines sLines candLines
    return;
end

thetaToll = thetaToll - thetaTollInc;

% Extract the corner points
imagePoints = getPointsOrt(candLines, thetaToll);

if(~insideImage(imagePoints, ri, ci))
    imagePoints = -1;
    clear lines sLines candLines
    return;
end

%% ------- PLOT -------

if(flagPlot)
    % Show the gray scale image I
    figure, imshow(I);
    hold on;
    
    % Plot all the candidated lines that respect the contraints
    for k = 1:(length(candLines))
        line = candLines(k).l1.l;
        plot([line(1,1) line(1,3)], [line(1,2) line(1,4)], 'LineWidth', 2, 'Color', 'green');
        plot(line(1,1), line(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
        plot(line(1,3), line(1,4), 'x', 'LineWidth', 2, 'Color', 'red');
        text(line(1,1), line(1,2), num2str(candLines(k).l1.id), 'BackgroundColor', [.6 .6 .6]);
    end
    
    for k = 1:(length(candLines))
        line = candLines(k).l2.l;
        plot([line(1,1) line(1,3)], [line(1,2) line(1,4)], 'LineWidth', 2, 'Color', 'green');
        plot(line(1,1), line(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
        plot(line(1,3), line(1,4), 'x', 'LineWidth', 2, 'Color', 'red');
        text(line(1,1), line(1,2), num2str(candLines(k).l2.id), 'BackgroundColor', [.6 .6 .6]);
    end
    
    % Plot the selected points
    for k = 1:4
        xy = imagePoints(k,:);
        plot(xy(1,1), xy(1,2), '*', 'LineWidth', 2, 'Color', 'white');
    end
end

clear lines sLines candLines

end
