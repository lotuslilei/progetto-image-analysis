function sortedLines = sortLines2( lines )
%SORTLINES2 sort lines according to their length (from longer to shorter)
%   
%   lines: vector of lines
%
%   sortedLines: vector of sorted lines
%

for l1 = 1:length(lines)
    
    for l2 = l1:length(lines)
        
        if(norm(lines(l2).l(1:2) - lines(l2).l(3:4))>norm(lines(l1).l(1:2) - lines(l1).l(3:4)))
            tmp=lines(l1).l;
            lines(l1).l = lines(l2).l;
            lines(l2).l = tmp;
        end
        
    end
    
end

for s = 1:length(lines)
    
    sortedLines(s).l = lines(s).l;
    sortedLines(s).id = s;
    sortedLines(s).flag = 0;
    
end

end

