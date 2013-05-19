function res = arePropA4( points, distToll, r, c )
%AREPROPA4 checks if points fits to A4 proportion within distToll
%
%   points: the 4 extracted points
%   distToll: tollerance
%   r: image rows
%   c: imge columns
%
%   res: true if the points fit A4 proportion, false otherwise
%

sPoints = sortPoints(points);

lines(1,:) = [sPoints(1,:) sPoints(2,:)];
lines(2,:) = [sPoints(3,:) sPoints(4,:)];

[x y] = lineIntersect(sPoints(1,:), sPoints(4,:), sPoints(2,:), sPoints(3,:));

point = [x y];

if(insideImage(point, r, c))
    lines(3,:) = [sPoints(1,:) sPoints(3,:)];
    lines(4,:) = [sPoints(2,:) sPoints(4,:)];
else
    lines(3,:) = [sPoints(2,:) sPoints(3,:)];
    lines(4,:) = [sPoints(1,:) sPoints(4,:)];
end

sLines = sortLines(lines);

longEdgeMedian = (norm(sLines(1).l(1:2) - sLines(1).l(3:4)) + norm(sLines(2).l(1:2) - sLines(2).l(3:4))) / 2;
shortEdgeMedian = (norm(sLines(3).l(1:2) - sLines(3).l(3:4)) + norm(sLines(4).l(1:2) - sLines(4).l(3:4))) / 2;
ratioSheet = longEdgeMedian/shortEdgeMedian;

longEdgeA4 = 297;
shortEdgeA4 = 210;
ratioA4 = longEdgeA4/shortEdgeA4;

if(abs(ratioSheet - ratioA4)<=distToll)
    res = true;
else
    res = false;
end

end
