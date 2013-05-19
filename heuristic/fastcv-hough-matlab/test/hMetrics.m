function [minDist ok] = hMetrics( myPoints, rPoints, distToll )
%HMETRICS given two vectors of four points each, it returns the sum of the minimum square distance between them, and whether such distances are greater than the threshold distToll
%
%   myPoints: points extracted by an heuristic
%   rPoints: real points of the sheet corners, ground truth
%   distToll: threshold, in pixels, to distinguish between success and fail
%
%   minDist: minimum square distance between the two vectors of points
%   ok: true if some distance is greater than distToll, false otherwise
%

minDist = norm(myPoints(1)-rPoints(1))^2 + norm(myPoints(2)-rPoints(2))^2 + norm(myPoints(3)-rPoints(3))^2 + norm(myPoints(4)-rPoints(4))^2;
minPerm = [1 2 3 4];

permIndex = perms(1:length(myPoints));

ok = true;

for p = 1:length(permIndex)
    
    perm = permIndex(p,:);
    
    tmpDist = norm(myPoints(1)-rPoints(perm(1,1)))^2 + norm(myPoints(2)-rPoints(perm(1,2)))^2 + norm(myPoints(3)-rPoints(perm(1,3)))^2 + norm(myPoints(4)-rPoints(perm(1,4)))^2;
    
    if(tmpDist<minDist)
        minDist = tmpDist;
        minPerm = perm;
    end
    
end

if(nargin==3)
    if(distToll<norm(myPoints(1)-rPoints(minPerm(1,1))))
        ok = false;
    elseif(distToll<norm(myPoints(2)-rPoints(minPerm(1,2))))
        ok = false;
    elseif(distToll<norm(myPoints(3)-rPoints(minPerm(1,3))))
        ok = false;
    elseif(distToll<norm(myPoints(4)-rPoints(minPerm(1,4))))
        ok = false;
    end
end

end
