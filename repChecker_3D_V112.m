% FUNCTION TO TEST REPEATABILITY IN 3D
% This function is intended to check whether a given truss design can be
% used as a repeatable unit cell-- that is, whether opposing sides of the
% unit cell cube are the same
function repeatabilityBool = repChecker_3D_V1(CA,sidenum)
    % Comparing x = 0, x = sel sides
    
    % Comparing y = 0, y = sel sides
    
    % Comparing z = 0, z = sel sides
    
    % OLD ITEMS BELOW 
    
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
