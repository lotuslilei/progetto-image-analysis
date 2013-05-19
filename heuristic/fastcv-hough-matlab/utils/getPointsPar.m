function [ points ] = getPointsPar( lines )
%GETPOINTS given four lines, it intersects the four lines
%(taking them orthogonal two by two) to extract four points that are returned
%
%   lines: four lines in the format ( lines(1).l1.l, lines(1).l2.l, lines(2).l1.l, lines(2).l2.l )
%
%   points: four points obtained by the intersection of the four previous
%   lines
%

[x1 y1] = lineIntersect(lines(1).l1.l(1,1:2), lines(1).l1.l(1,3:4), lines(2).l1.l(1,1:2), lines(2).l1.l(1,3:4));
points(1,1) = x1;
points(1,2) = y1;
[x2 y2] = lineIntersect(lines(1).l1.l(1,1:2), lines(1).l1.l(1,3:4), lines(2).l2.l(1,1:2), lines(2).l2.l(1,3:4));
points(2,1) = x2;
points(2,2) = y2;
[x3 y3] = lineIntersect(lines(1).l2.l(1,1:2), lines(1).l2.l(1,3:4), lines(2).l1.l(1,1:2), lines(2).l1.l(1,3:4));
points(3,1) = x3;
points(3,2) = y3;
[x4 y4] = lineIntersect(lines(1).l2.l(1,1:2), lines(1).l2.l(1,3:4), lines(2).l2.l(1,1:2), lines(2).l2.l(1,3:4));
points(4,1) = x4;
points(4,2) = y4;

end
