function  res  = areOrthogonal( alpha, betha, thetaToll )
%AREOTHOGONAL checks if two lines are orthogonal with respect to an angle
%tolerance
%
%   alpha: first angle
%   betha: second angle
%   thetaToll: angle tollerance
%
%   res: true if the two lines are orthogonal, false otherwise
%

if ((abs(abs(alpha)-abs(betha))<=(90+thetaToll) && abs(abs(alpha)-abs(betha))>=(90-thetaToll)) || (abs(abs(180-alpha)-abs(betha))<=(90+thetaToll) && abs(abs(180-alpha)-abs(betha))>=(90-thetaToll)) || (abs(abs(alpha)-abs(180-betha))<=(90+thetaToll) && abs(abs(alpha)-abs(180-betha))>=(90-thetaToll)))
    res=true;
else
    res=false;
end 

end

