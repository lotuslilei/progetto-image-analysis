function [ sortedLines ] = sortLines( lines )
%SORTLINES sort lines according to their length (from longer to shorter)
%   
%   lines: vector of lines
%
%   sortedLines: vector of sorted lines
%



for l1 = 1:length(lines)
    
    for l2 = l1:length(lines)
        
        if(norm(lines(l2, 1:2) - lines(l2, 3:4))>norm(lines(l1, 1:2) - lines(l1, 3:4)))
            tmp=lines(l1, :);
            lines(l1, :) = lines(l2, :);
            lines(l2, :) = tmp;
        end
        
    end
    
end

for s = 1:length(lines)
    
    sortedLines(s).l = lines(s, :);
    sortedLines(s).id = s;
    sortedLines(s).flag = 0;
    
end

end
