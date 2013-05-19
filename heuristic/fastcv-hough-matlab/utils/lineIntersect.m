function [ x y ] = lineIntersect( a, b, c, d )
%LINEINTERSECT given four points (of two lines), it returns the
%intersection point of them
%
%   a: first point of line1
%   b: second point of line1
%   c: first point of line2
%   d: second point of line2
%
%   [x y]: intersection point
%

numX = det([det([a; b]) det([a(1,1) 1; b(1,1) 1]); det([c; d]) det([c(1,1) 1; d(1,1) 1])]);

numY = det([det([a; b]) det([a(1,2) 1; b(1,2) 1]); det([c; d]) det([c(1,2) 1; d(1,2) 1])]);

den = det([det([a(1,1) 1; b(1,1) 1]) det([a(1,2) 1; b(1,2) 1]); det([c(1,1) 1; d(1,1) 1]) det([c(1,2) 1; d(1,2) 1])]);

x = numX/den;

y=  numY/den;

end

