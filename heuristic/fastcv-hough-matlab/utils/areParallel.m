function  res  = areParallel( alpha, betha, thetaToll )
%AREPARALLEL checks if two lines are parallel with respect to an angle
%tolerance
%
%   alpha: first angle
%   betha: second angle
%   thetaToll: angle tollerance
%
%   res: true if the two lines are parallel, false otherwise
%

if (abs(abs(alpha)-abs(betha))<=thetaToll || abs(abs(180-alpha)-abs(betha))<=thetaToll || abs(abs(alpha)-abs(180-betha))<=thetaToll)
    res=true;
else
    res=false;
end 

end

