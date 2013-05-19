function cLines = cleanLines( lines )
%CLEANLINES given a vector of lines, it removes the useless lines
%(those ones with flag=1) from the vector
%
%   lines: vector of lines
%
%   cLines: vector of cleaned lines
%

cleanIndex = 1;
for i = 1:length(lines)
    if(lines(i).flag==0)
        cLines(cleanIndex)=lines(i);
        cleanIndex = cleanIndex + 1;
    end
end


end

