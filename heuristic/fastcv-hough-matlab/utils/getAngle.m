function angledeg = getAngle( line )
%GETANGLE given a line (as two points), it returns the angle (in degrees
%format) between the line and the x-axis
%   
%   line: line as vector of 2 points
%
%   angledeg: angle of the line with respect to the x-axis in degrees
%

anglerad = mod(atan2(abs(line(1,4))-abs(line(1,2)), abs(line(1,1))-abs(line(1,3))), 2*pi);

angledeg = (anglerad/pi)*180;

end

