% FUNCTION TO TEST REPEATABILITY IN 2D
% This function is intended to check whether a given truss design can be
% used as a repeatable unit cell-- that is, whether the top and left sides 
% contain the same elements as the bottom and right sides, respectively
function repeatabilityBool = repChecker_2D_V1(CA,sidenum)
    % Checking left & right sides for match
    leftside = [];
    for i = 1:1:(sidenum-1)
        elem = [i,i+1];
        leftside = [leftside,ismember(elem,CA,'row')];
    end
    rightside = [];
    for i = ((sidenum^2)-sidenum+1):1:((sidenum^2)-1)
        elem = [i,i+1];
        rightside = [rightside,ismember(elem,CA,'row')];
    end
    if leftside == rightside
        repeatabilityBool = 1;
    else
        repeatabilityBool = 0;
        return
    end
    
    % Checking top & bottom sides for match
    topside = [];
    for i = sidenum:sidenum:((sidenum^2)-sidenum)
        elem = [i,i+sidenum];
        topside = [topside,ismember(elem,CA,'row')];
    end
    bottomside = [];
    for i = 1:sidenum:((sidenum^2)-(2*sidenum)+1)
        elem = [i,i+sidenum];
        bottomside = [bottomside,ismember(elem,CA,'row')];
    end
    if topside == bottomside
        repeatabilityBool = 1;
    else
        repeatabilityBool = 0;
    end
end
