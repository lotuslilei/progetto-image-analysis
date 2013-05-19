function sPoints = sortPoints( points )
%SORTPOINTS sort points wrt x-axis
%
%   points: the 4 extracted points
%
%   sPoints: sorted points
%

for p1 = 1:length(points)
    
    for p2 = 1:length(points)
        
        if(points(p1,1)>points(p2,1))
           tmp = points(p1,:);
           points(p1,:) = points(p2,:);
           points(p2,:) = tmp;
        end
        
    end
    
end

sPoints = points;

end
