function lines = joinLines( lines, distToll )
%JOINLINES given a vector of lines and a distance tollerance, it joins the
%lines that are closer than distToll
%
%   lines: vector of lines
%   disttoll: distance tollerance
%
%   lines: vector of joined lines
%

for l1 = 1:length(lines)
        
    from = l1 + 1;
        
    if(from <= length(lines) && lines(l1).flag == 0)
        for l2 = from:length(lines)
                
            if(lines(l1).id ~= lines(l2).id) && (lines(l2).flag == 0)
                if(sameLine(lines(l1).l, lines(l2).l, distToll))
                    lines(l2).flag = 1;
                    lines(l1).l = getLinesExtremes(lines(l1).l, lines(l2).l);
                end
            end
                
        end
    end
        
end
    

end
