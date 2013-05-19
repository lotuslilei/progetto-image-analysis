function res = insideImage( points, r, c )
%INSIDEIMAGE given a vector of four points and the dimensions of the image, it
%returns if the points are inside the image space or not
%
%   points: vector of four points
%   r: image's rows number
%   c: image's columns number
%
%   res: true if all the points are inside the image space, false otherwise
%

res = true;

to = size(points);

for p = 1:to
    
    if(points(p,1)<0 || points(p,1)>c)
        res = false;
    elseif(points(p,2)<0 || points(p,2)>r)
        res = false;
    end
    
end

end

