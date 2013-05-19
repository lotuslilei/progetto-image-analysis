function res = getLinesExtremes( line1, line2 )
%GETLINESEXTREMES given two lines (as two points format), it returns the
%farest extremes of them as new line
%   
%   line1: first line
%   line2: second line
%
%   res: new line formed by the previous two lines extremes
%

lin1 = [line1(1:2); line1(3:4)];
lin2 = [line2(1:2); line2(3:4)];

dismax = 0;
dis = norm(lin1(1,:)-lin1(2,:));
if(dis>dismax)
    dismax = dis;
    x1 = lin1(1,1);
    y1 = lin1(1,2);
    x2 = lin1(2,1);
    y2 = lin1(2,2);
    res = [x1 y1 x2 y2];
end

dis = norm(lin2(1,:)-lin2(2,:));
if(dis>dismax)
    dismax = dis;
    x1 = lin2(1,1);
    y1 = lin2(1,2);
    x2 = lin2(2,1);
    y2 = lin2(2,2);
    res = [x1 y1 x2 y2];
end

for l1 = 1:2
    for l2 = 1:2
        dis = norm(lin1(l1,:) - lin2(l2,:));
        if(dis>dismax)
            dismax = dis;
            x1 = lin1(l1,1);
            y1 = lin1(l1,2);
            x2 = lin2(l2,1);
            y2 = lin2(l2,2);
            res = [x1 y1 x2 y2];
        end
    end
end

end

