function [ imagePoints ] = hHarrisSingle( image, flagPlot )
%hHarrisSingle try to extract the four corner points of the
%sheet in the image, according to the Harris heuristic
%
%   image: path where image is located
%   flagPlot: true for plotting images, lines and corner points, false
%   otherwise
%   
%   imagePoints: extracted corner points for the image
%

%% ------- CALC -------
    
try
    % Read the image and put it into RGB
    RGB = imread(image);
        
    % Remove croma components and leave just the luminance, store the
    % gray scale image into I
    I  = rgb2gray(RGB);
    
    % With an empty cannyThresh, edge uses its default low and high
    % threshold
    cannyThresh=[50/256, 200/256];
        
    % Default value of Canny edge
    cannySigma=3;
        
    % Perform Canny Filter on the gray scale image I and return a
    % binary image (black and white image)
    BW = edge(I, 'canny', cannyThresh, cannySigma);
        
    % Calculate corners using Harris and set starting level of
    % function parameters
    numCorners=200;
    qualityLevel = 1;
    sensivityFactor = 0.2;
    C=[];
    [rC,cC]=size(C);
    CxMin=[];
    CxMax=[];
    CyMin=[];
    CyMax=[];
    ok = 1;
        
    %Loop until 4 different point are found and on each iteration
    %decrease the quality level and the sensitivity factor of the
    %filter
    while(ok)
        %Decrease quality level
        qualityLevel = qualityLevel - 0.1;
            
        %If the decrease of quality level is not sufficient
        %decrease sensitivity factor
        if(qualityLevel <=0)
            sensivityFactor = sensivityFactor - 0.05;
            qualityLevel = 0.9;
        end
            
        %Calculate corners with Harris method
        C = corner(BW, 'Harris', numCorners, 'QualityLevel', qualityLevel, 'SensitivityFactor', sensivityFactor);
        [rC,cC]=size(C);
        
        %Initialize the value of the 4 points
        CxMin=C(1,:);
        CxMax=C(1,:);
        CyMin=C(1,:);
        CyMax=C(1,:);
        
        %Find the 4 points with x maximum, x minimum, y maximum
        %and y minimum
        for j = 1:rC
            if(CxMin(1,1)>C(j,1))
                CxMin=C(j,:);
            end
                
            if(CxMax(1,1)<C(j,1))
                CxMax=C(j,:);
            end
                
            if(CyMin(1,2)>C(j,2))
                CyMin=C(j,:);
            end
                
            if(CyMax(1,2)<C(j,2))
                CyMax=C(j,:);
            end
        end
            
        %Boolean value to find if numbers of corners are less of 4
        ok = rC < 4;
            
        %Control the difference of the points
        if(ok == 0 && ((CyMin(1,1)==CxMin(1,1) && CyMin(1,2)==CxMin(1,2)) || (CyMin(1,1)==CxMax(1,1) && CyMin(1,2)==CxMax(1,2))))
            ok = 1;
        end
            
        %Control the difference of the points
        if(ok == 0 && ((CyMax(1,1)==CxMin(1,1) && CyMax(1,2)==CxMin(1,2)) || (CyMax(1,1)==CxMax(1,1) && CyMax(1,2)==CxMax(1,2))))
            ok = 1;
        end
    end
        
    imagePoints = [CxMin(1,1) CxMin(1,2); CxMax(1,1) CxMax(1,2); CyMin(1,1) CyMin(1,2); CyMax(1,1) CyMax(1,2)];

    %% ------- PLOT -------
        
    if(flagPlot)
        % Show the binary image BW
        figure, imshow(RGB);
        hold on;
            
        % Plot Harris corner points
                   
        %Plot the corner on the image
        plot(CxMin(1,1),CxMin(1,2),'x','LineWidth',2,'Color','yellow');
        plot(CxMax(1,1),CxMax(1,2),'x','LineWidth',2,'Color','yellow');
        plot(CyMin(1,1),CyMin(1,2),'x','LineWidth',2,'Color','yellow');
        plot(CyMax(1,1),CyMax(1,2),'x','LineWidth',2,'Color','yellow');
    end
        
catch err
    %Error if impossibile to find 4 different corners
    imagePoints = -1;
end
    
end