function [ imgPtsCombo ] = hComboSingle( image, flagPlot )

addpath('../hHarris');
addpath('../hProportion');
addpath('../hHoughCloseOrtLines');
addpath('../hHoughParallelLines');

%% ------- CALC -------
% Read the image and put it into RGB
RGB = imread(image);

[ri ci] = size(RGB);
tollR = ri*0.1;
tollC = ci*0.1;
flag = 1;

imgPtsCombo = [];
imgPtsHarris = sortrows(hHarrisSingle(image, 0));
imgPtsProportion = sortrows(hProportionSingle(image, 0));
imgPtsHOL = sortrows(hHOLSingle(image, 0));
imgPtsHPL = sortrows(hHPLSingle(image, 0));

if imgPtsHarris(1,1) == -1 && imgPtsHOL(1,1) == -1 && imgPtsHPL(1,1) == -1 && imgPtsProportion(1,1) == -1
    imgPtsCombo = -1;
elseif imgPtsHarris(1,1) == -1 && imgPtsHOL(1,1) == -1 && imgPtsProportion(1,1) == -1
    imgPtsCombo = imgPtsHPL;
elseif imgPtsHOL(1,1) == -1 && imgPtsHPL(1,1) == -1 && imgPtsProportion(1,1) == -1
    imgPtsCombo = imgPtsHarris;
elseif imgPtsHarris(1,1) == -1 && imgPtsHPL(1,1) == -1 && imgPtsProportion(1,1) == -1
    imgPtsCombo = imgPtsHOL;
elseif imgPtsHarris(1,1) == -1 && imgPtsHPL(1,1) == -1 && imgPtsHOL(1,1) == -1
    imgPtsCombo = imgPtsProportion;
elseif imgPtsHarris(1,1) == -1 && imgPtsProportion(1,1) == -1
    for i=1:4
        if (~ nearPoints(imgPtsHPL, imgPtsHOL, tollR, tollC))
            %((imgPtsHPL(i,1) <= imgPtsHOL(i,1)+tollR && imgPtsHPL(i,1) >= imgPtsHOL(i,1)-tollR) && (imgPtsHPL(i,2) <= imgPtsHOL(i,2)+tollC && imgPtsHPL(i,2) >= imgPtsHOL(i,2)-tollC)))
            flag = 0;
        end
    end
    
    if(flag)
        imgPtsCombo = imgPtsHOL;
    else
        imgPtsCombo = -1;
    end
elseif imgPtsHPL(1,1) == -1 && imgPtsProportion(1,1) == -1
    for i=1:4
        if(~ nearPoints(imgPtsHarris, imgPtsHOL, tollR, tollC))
            flag = 0;
        end
    end
    
    if(flag)
        imgPtsCombo = imgPtsHOL;
    else
        imgPtsCombo = -1;
    end
elseif imgPtsHOL(1,1) == -1 && imgPtsProportion(1,1) == -1
    for i=1:4
        if(~ nearPoints(imgPtsHarris, imgPtsHPL, tollR, tollC))
            flag = 0;
        end
    end
    
    if(flag)
        imgPtsCombo = imgPtsHPL;
    else
        imgPtsCombo = -1;
    end
elseif imgPtsHOL(1,1) == -1 && imgPtsHarris(1,1) == -1
    for i=1:4
        if(~ nearPoints(imgPtsProportion, imgPtsHPL, tollR, tollC))
            flag = 0;
        end
    end
    
    if(flag)
        imgPtsCombo = imgPtsHPL;
    else
        imgPtsCombo = -1;
    end
elseif imgPtsHPL(1,1) == -1 && imgPtsHarris(1,1) == -1
    for i=1:4
        if(~ nearPoints(imgPtsProportion, imgPtsHOL, tollR, tollC))
            flag = 0;
        end
    end
    
    if(flag)
        imgPtsCombo = imgPtsHOL;
    else
        imgPtsCombo = -1;
    end
elseif imgPtsHPL(1,1) == -1 && imgPtsHOL(1,1) == -1
    for i=1:4
        if(~ nearPoints(imgPtsHarris, imgPtsProportion, tollR, tollC))
            flag = 0;
        end
    end
    
    if(flag)
        imgPtsCombo = imgPtsProportion;
    else
        imgPtsCombo = -1;
    end
elseif imgPtsProportion(1,1) == -1
    for i=1:4
        if (~ nearPoints(imgPtsHPL, imgPtsHOL, tollR, tollC))
        	flag = 0;
        end
    end

    if(flag)
    	imgPtsCombo = imgPtsHOL;
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHarris, imgPtsHOL, tollR, tollC))
                flag = 0;
            end
        end
    
        if(flag)
            imgPtsCombo = imgPtsHOL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHarris, imgPtsHPL, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHPL;
        end
    end
    
    if(flag == 0)
        imgPtsCombo = -1;
    end
elseif imgPtsHPL(1,1) == -1
    for i=1:4
        if (~ nearPoints(imgPtsProportion, imgPtsHOL, tollR, tollC))
        	flag = 0;
        end
    end

    if(flag)
    	imgPtsCombo = imgPtsHOL;
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHarris, imgPtsHOL, tollR, tollC))
                flag = 0;
            end
        end
    
        if(flag)
            imgPtsCombo = imgPtsHOL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHarris, imgPtsProportion, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsProportion;
        end
    end
    
    if(flag == 0)
        imgPtsCombo = -1;
    end
elseif imgPtsHOL(1,1) == -1
    for i=1:4
        if (~ nearPoints(imgPtsHPL, imgPtsProportion, tollR, tollC))
        	flag = 0;
        end
    end

    if(flag)
    	imgPtsCombo = imgPtsHPL;
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHarris, imgPtsProportion, tollR, tollC))
                flag = 0;
            end
        end
    
        if(flag)
            imgPtsCombo = imgPtsProportion;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHarris, imgPtsHPL, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHPL;
        end
    end
    
    if(flag == 0)
        imgPtsCombo = -1;
    end
elseif imgPtsHarris(1,1) == -1
    for i=1:4
        if (~ nearPoints(imgPtsHPL, imgPtsHOL, tollR, tollC))
        	flag = 0;
        end
    end

    if(flag)
    	imgPtsCombo = imgPtsHOL;
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsProportion, imgPtsHOL, tollR, tollC))
                flag = 0;
            end
        end
    
        if(flag)
            imgPtsCombo = imgPtsHOL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsProportion, imgPtsHPL, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHPL;
        end
    end
    
    if(flag == 0)
        imgPtsCombo = -1;
    end
else
    for i=1:4
        if (~ (nearPoints(imgPtsProportion, imgPtsHarris, tollR, tollC) && nearPoints(imgPtsProportion, imgPtsHOL, tollR, tollC)))
        	flag = 0;
        end
    end

    if(flag)
    	imgPtsCombo = imgPtsHOL;
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ (nearPoints(imgPtsHarris, imgPtsHPL, tollR, tollC) && nearPoints(imgPtsProportion, imgPtsHPL, tollR, tollC)))
                flag = 0;
            end
        end
    
        if(flag)
            imgPtsCombo = imgPtsHPL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ (nearPoints(imgPtsProportion, imgPtsHPL, tollR, tollC) && nearPoints(imgPtsHOL, imgPtsHPL, tollR, tollC)))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHPL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ (nearPoints(imgPtsHarris, imgPtsHPL, tollR, tollC) && nearPoints(imgPtsHOL, imgPtsHPL, tollR, tollC)))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHPL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsProportion, imgPtsHarris, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsProportion;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsProportion, imgPtsHOL, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHOL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsProportion, imgPtsHPL, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHPL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHOL, imgPtsHarris, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHOL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHPL, imgPtsHarris, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHPL;
        end
    end
    
    if(flag == 0)
        flag = 1;
        
        for i=1:4
            if(~ nearPoints(imgPtsHPL, imgPtsHOL, tollR, tollC))
                flag = 0;
            end
        end

        if(flag)
            imgPtsCombo = imgPtsHOL;
        end
    end
    
    if(flag == 0)
        imgPtsCombo = -1;
    end
end


%% ------- PLOT -------

if(flagPlot && imgPtsCombo(1,1) ~= -1)
    % Show the binary image BW
    figure, imshow(RGB);
    hold on;
    
    % Plot Harris corner points
    
    %Plot the corner on the image
    plot(imgPtsCombo(1,1),imgPtsCombo(1,2),'x','LineWidth',2,'Color','yellow');
    plot(imgPtsCombo(2,1),imgPtsCombo(2,2),'x','LineWidth',2,'Color','yellow');
    plot(imgPtsCombo(3,1),imgPtsCombo(3,2),'x','LineWidth',2,'Color','yellow');
    plot(imgPtsCombo(4,1),imgPtsCombo(4,2),'x','LineWidth',2,'Color','yellow');
end

end

function [ near ] = nearPoints( setPts1, setPts2, tollX, tollY )
    near = ((setPts1(1,1) <= setPts2(1,1)+tollX && setPts1(1,1) >= setPts2(1,1)-tollX) && (setPts1(1,2) <= setPts2(1,2)+tollY && setPts1(1,2) >= setPts2(1,2)-tollY));
end