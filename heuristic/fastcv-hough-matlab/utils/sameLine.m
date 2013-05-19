function res = sameLine( line1, line2, error )
%SAMELINE given two segments and a distance tollerance, it returns if the two
%segments are on the same line or not
%
%   line1: first lines
%   line2: second line
%   error: distance tollerance
%
%   res: true if the distance of line2 points respect to line1 is less than
%   error, false otherwise
%

m = (line1(1,4)-line1(1,2))/(line1(1,3)-line1(1,1));
q = line1(1,2) - m*line1(1,1);

d1 = abs(m*line2(1,1) - line2(1,2) + q)/sqrt(m^2 + (-1)^2);
d2 = abs(m*line2(1,3) - line2(1,4) + q)/sqrt(m^2 + (-1)^2);

if(d1<=error && d2<=error)
    res = true;
else
    res = false;
end

end
