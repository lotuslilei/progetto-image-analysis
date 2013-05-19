function res = areClose( l1, l2, closeDistToll )
%ARECLOSE checks if two lines are close with respect to a distance
%tollerance
%
%   l1: first line
%   l2: second line
%   closeDistToll: distance tollerance
%
%   res: true if the two lines are close, false otherwise
%

if (norm(l1(1:2)-l2(1:2))<=closeDistToll)
    res = true;
elseif (norm(l1(1:2)-l2(3:4))<=closeDistToll)
    res = true;
elseif (norm(l1(3:4)-l2(1:2))<=closeDistToll)
    res = true;
elseif (norm(l1(3:4)-l2(3:4))<=closeDistToll)
    res = true;
else   
    res = false;
end

end
