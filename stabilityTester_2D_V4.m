% FUNCTION TO TEST 2D TRUSS STABILITY 
% This function evaluates whether a design is mechanically stable
% -------------------------------------------------------------------------
% stabilityScore is on [0,1] in increments of 0.1
% stabilityBool = false for stabilityScore < 1, true for stabilityScore = 1
% -------------------------------------------------------------------------
% Case 1 Test Values (stabilityBool = 1, stabilityScore = 1):
%{
NC = [0,0;0,0.025;0,0.05;
      0.025,0;0.025,0.025;0.025,0.05;
      0.05,0;0.05,0.025;0.05,0.05];
CA = [1,2;2,3;3,6;6,9;8,9;7,8;4,7;1,4;1,5;2,5;3,5;4,5;5,6;5,7;5,8;5,9];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
% Modified Case 1 Test Values (stabilityBool = 1, stabilityScore = 0.8):
%{
NC = [0,0;0,0.025;0,0.05;
      0.025,0;0.025,0.025;0.025,0.05;
      0.05,0;0.05,0.025;0.05,0.05];
CA = [1,2;2,3;3,6;6,9;8,9;7,8;4,7;1,4;1,5;2,5;4,5;5,6;5,8];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
function [stabilityBool,stabilityScore] = ...
                                   stabilityTester_2D_V4(sidenum,CA,NC,sel)
    % Initialize stability score, boolean
    stabilityScore = 1; 
    stabilityBool = true;
    
    %%% First stability check: checking for connectivity at each node by
    %%% presence of stiffness components in x and y
    holecounter = 0;
    
    % Add up counters based on nodal connectivities
    [N,~] = histcounts(CA,size(NC,1));
    
    % Identify corner, side node numbers
    cornernodes = [1,sidenum,((sidenum^2)-sidenum + 1),(sidenum^2)];
    allindices = (1:1:size(NC,1));
    noncornernodes = setdiff(allindices,cornernodes);
    
    % Loop through each node
    for i = 1:1:size(NC,1)
        % Isolate elements originating/ending at a given node
        indione = CA(:,1) == i; inditwo = CA(:,2) == i;
        mCAone = CA(indione,:); mCAtwo = CA(inditwo,:);
        mCA = ...
            [setdiff(mCAone,mCAtwo,'rows');setdiff(mCAtwo,mCAone,'rows')];
        xsum = 0; ysum = 0;
        
        % Find sums of element components in x,y of elements originating
        % from the current node
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            xsum = xsum + abs(x2-x1);
            ysum = ysum + abs(y2-y1);
        end
        
        % Determine whether node has sufficient connectivity components, 
        % and that the presence of holes is below threshold
        if (xsum == 0) || (ysum == 0) 
            % Node is an unstable connection point
            stabilityScore = stabilityScore - 0.1;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        elseif (xsum == 0) && (ysum == 0)
            % Node is a hole
            holecounter = holecounter + 1;
            if holecounter > (sidenum-2)
                stabilityScore = stabilityScore - 0.1;
                if stabilityScore < 0.1
                    stabilityBool = false;
                    return
                end
            end
        else % Node has sufficient connectivity components; must now check 
             % for sufficient number of members
            if (N(i) < 3) && (ismember(i,noncornernodes))
                % Non-corner node is an unstable connection point
                stabilityScore = stabilityScore - 0.1;
                if stabilityScore < 0.1
                    stabilityBool = false;
                    return
                end
            elseif (N(i) < 2) && (ismember(i,cornernodes))
                % Corner node is an unstable connection point
                stabilityScore = stabilityScore - 0.1;
                if stabilityScore < 0.1
                    stabilityBool = false;
                    return
                end
            end 
        end
    end
    
    %%% Second stability check: checking for sufficient presence of 
    %%% diagonals to avoid partial or full instability
    ND = NC./sel;
    
    % Iterate through slices in x-direction
    for ix = 1:1:(sidenum-1)
        % Identify nodes on the surface of the current slice
        lowerbound = (ix-1)*(1/(sidenum-1));
        upperbound = (ix)*(1/(sidenum-1));
        nodeslower = find(ND(:,1) == lowerbound); 
        nodesupper = find(ND(:,1) == upperbound); 
        allnodes = [nodeslower;nodesupper];
        
        % Isolate all elements connecting to/from all these nodes
        mCAone = CA(ismember(CA(:,1),allnodes),:);
        mCAtwo = CA(ismember(CA(:,2),allnodes),:);
        mCA = intersect(mCAone,mCAtwo,'rows');
        
        % Isolate and test diagonal elements for feasibility
        xyblocker = false;
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            if (abs(x2-x1) > 0) && (abs(y2-y1) > 0)
                xyblocker = true;
            end
        end
        
        % Check logical operator for stability pass/fail
        if xyblocker == false
            stabilityScore = stabilityScore - 0.1;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        end
    end
    
    % Iterate through slices in y-direction
    for iy = 1:1:(sidenum-1)
        % Identify nodes on the surface of the current slice
        lowerbound = (iy-1)*(1/(sidenum-1));
        upperbound = (iy)*(1/(sidenum-1));
        nodeslower = find(ND(:,1) == lowerbound); 
        nodesupper = find(ND(:,1) == upperbound); 
        allnodes = [nodeslower;nodesupper];
        
        % Isolate all elements connecting to/from all these nodes
        mCAone = CA(ismember(CA(:,1),allnodes),:);
        mCAtwo = CA(ismember(CA(:,2),allnodes),:);
        mCA = intersect(mCAone,mCAtwo,'rows');
        
        % Isolate and test diagonal elements for feasibility
        yxblocker = false;
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            if (abs(x2-x1) > 0) && (abs(y2-y1) > 0)
                yxblocker = true;
            end
        end
        
        % Check logical operator for stability pass/fail
        if yxblocker == false
            stabilityScore = stabilityScore - 0.1;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        end
    end
    
    % Assign value to stability boolean
    if stabilityScore < 1
        stabilityBool = false;
    end
end