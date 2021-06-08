% FUNCTION TO TEST 3D TRUSS STABILITY 
% This function evaluates whether a design is mechanically stable
% -------------------------------------------------------------------------
% stabilityScore is on [0,1] in increments of 0.1
% stabilityBool = false for stabilityScore < 1, true for stabilityScore = 1
% -------------------------------------------------------------------------
% Case 1 Test Values (stabilityBool = 1, stabilityScore = 1):
%{
NC = [0,0,0;0,0,0.025;0,0,0.05;0,0.025,0;0,0.025,0.025;0,0.025,0.05;
      0,0.05,0;0,0.05,0.025;0,0.05,0.05;
      0.025,0,0;0.025,0,0.025;0.025,0,0.05;
      0.025,0.025,0;0.025,0.025,0.025;0.025,0.025,0.05;
      0.025,0.05,0;0.025,0.05,0.025;0.025,0.05,0.05;
      0.05,0,0;0.05,0,0.025;0.05,0,0.05;
      0.05,0.025,0;0.05,0.025,0.025;0.05,0.025,0.05;
      0.05,0.05,0;0.05,0.05,0.025;0.05,0.05,0.05];
CA = [1,2;2,3;3,6;6,9;8,9;7,8;4,7;1,4;2,5;5,8;4,5;5,6;1,5;5,9;3,5;5,7;
      10,11;11,12;12,15;15,18;17,18;16,17;13,16;10,13;11,14;14,17;13,14;
      14,15;10,14;14,18;12,14;14,16;
      19,20;20,21;21,24;24,27;26,27;25,26;22,25;19,22;20,23;23,26;22,23;
      23,24;19,23;23,27;21,23;23,25;
      1,10;10,19;2,11;11,20;3,12;12,21;4,13;13,22;5,14;14,23;6,15;15,24;
      7,16;16,25;8,17;17,26;9,18;18,27;
      7,17;17,27;9,17;17,25;4,14;14,24;6,14;14,22;1,11;11,21;3,11;11,19;
      7,13;13,19;1,13;13,25;8,14;14,20;2,14;14,26;9,15;15,21;3,15;15,27;
      1,14;3,14;7,14;9,14;14,19;14,21;14,25;14,27];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
% Modified Case 1 Test Values (stabilityBool = 1, stabilityScore = 0.9):
%{
NC = [0,0,0;0,0,0.025;0,0,0.05;0,0.025,0;0,0.025,0.025;0,0.025,0.05;
      0,0.05,0;0,0.05,0.025;0,0.05,0.05;
      0.025,0,0;0.025,0,0.025;0.025,0,0.05;
      0.025,0.025,0;0.025,0.025,0.025;0.025,0.025,0.05;
      0.025,0.05,0;0.025,0.05,0.025;0.025,0.05,0.05;
      0.05,0,0;0.05,0,0.025;0.05,0,0.05;
      0.05,0.025,0;0.05,0.025,0.025;0.05,0.025,0.05;
      0.05,0.05,0;0.05,0.05,0.025;0.05,0.05,0.05];
CA = [1,2;2,3;3,6;6,9;8,9;7,8;4,7;1,4;2,5;5,8;4,5;5,6;1,5;5,9;3,5;5,7;
      10,11;11,12;12,15;15,18;17,18;16,17;13,16;10,13;11,14;14,17;13,14;
      14,15;10,14;14,18;12,14;14,16;
      19,20;20,21;21,24;24,27;26,27;25,26;22,25;19,22;20,23;23,26;22,23;
      23,24;19,23;23,27;21,23;23,25;
      1,10;10,19;2,11;11,20;3,12;12,21;4,13;13,22;5,14;14,23;6,15;15,24;
      7,16;16,25;8,17;17,26;9,18;18,27;
      17,27;17,25;14,24;14,22;11,21;11,19;
      7,13;13,19;1,13;13,25;8,14;14,20;2,14;14,26;9,15;15,21;3,15;15,27;
      14,19;14,21;14,25;14,27];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
function [stabilityBool,stabilityScore] = ...
                                   stabilityTester_3D_V1(sidenum,CA,NC,sel)
    % Initialize stability score, boolean
    stabilityScore = 1; 
    stabilityBool = true;
    
    %%% First stability check: checking for connectivity at each node by
    %%% presence of stiffness components in x,y,z
    holecounter = 0;
    
    % Add up counters based on nodal connectivities
    [N,~] = histcounts(CA,size(NC,1));
    
    % Loop through each node
    for i = 1:1:size(NC,1)
        % Isolate elements originating/ending at a given node
        indione = CA(:,1) == i; inditwo = CA(:,2) == i;
        mCAone = CA(indione,:); mCAtwo = CA(inditwo,:);
        mCA = ...
            [setdiff(mCAone,mCAtwo,'rows');setdiff(mCAtwo,mCAone,'rows')];
        xsum = 0; ysum = 0; zsum = 0;
        
        % Find sums of element components in x,y,z of elements originating
        % from the current node
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            z1 = NC(mCA(j,1),3); z2 = NC(mCA(j,2),3);
            xsum = xsum + abs(x2-x1);
            ysum = ysum + abs(y2-y1);
            zsum = zsum + abs(z2-z1);
        end
        
        % Determine whether node has sufficient connectivity components, 
        % and that the presence of holes is below threshold
        if (xsum == 0) || (ysum == 0) || (zsum == 0)
            % Node is an unstable connection point
            stabilityScore = stabilityScore - 0.1;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        elseif (xsum == 0) && (ysum == 0) && (zsum == 0)
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
            if N(i) < 3
                % Node is an unstable connection point
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
        xyblocker = false; xzblocker = false;
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            z1 = NC(mCA(j,1),3); z2 = NC(mCA(j,2),3);
            if (abs(x2-x1) > 0) && (abs(y2-y1) > 0)
                xyblocker = true;
            elseif (abs(x2-x1) > 0) && (abs(z2-z1) > 0)
                xzblocker = true;
            elseif (abs(x2-x1) > 0) && (abs(y2-y1) > 0) && (abs(z2-z1) > 0)
                xyblocker = true; xzblocker = true;
            end
        end
        
        % Check logical operators for stability pass/fail
        if (xyblocker == false) && (xzblocker == false)
            stabilityScore = stabilityScore - 0.2;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        elseif (xyblocker == true) && (xzblocker == false)
            stabilityScore = stabilityScore - 0.1;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        elseif (xyblocker == false) && (xzblocker == true)
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
        nodeslower = find(ND(:,2) == lowerbound); 
        nodesupper = find(ND(:,2) == upperbound); 
        allnodes = [nodeslower;nodesupper];
        
        % Isolate all elements connecting to/from all these nodes
        mCAone = CA(ismember(CA(:,1),allnodes),:);
        mCAtwo = CA(ismember(CA(:,2),allnodes),:);
        mCA = intersect(mCAone,mCAtwo,'rows');
        
        % Isolate and test diagonal elements for feasibility
        yzblocker = false; xyblocker = false;
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            z1 = NC(mCA(j,1),3); z2 = NC(mCA(j,2),3);
            if (abs(x2-x1) > 0) && (abs(y2-y1) > 0)
                xyblocker = true;
            elseif (abs(y2-y1) > 0) && (abs(z2-z1) > 0)
                yzblocker = true;
            elseif (abs(x2-x1) > 0) && (abs(y2-y1) > 0) && (abs(z2-z1) > 0)
                xyblocker = true; yzblocker = true;
            end
        end
        
        % Check logical operators for stability pass/fail
        if (xyblocker == false) && (yzblocker == false)
            stabilityScore = stabilityScore - 0.2;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        elseif (xyblocker == true) && (yzblocker == false)
            stabilityScore = stabilityScore - 0.1;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        elseif (xyblocker == false) && (yzblocker == true)
            stabilityScore = stabilityScore - 0.1;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        end
    end
    
    % Iterate through slices in z-direction
    for iz = 1:1:(sidenum-1)
        % Identify nodes on the surface of the current slice
        lowerbound = (iz-1)*(1/(sidenum-1));
        upperbound = (iz)*(1/(sidenum-1));
        nodeslower = find(ND(:,3) == lowerbound); 
        nodesupper = find(ND(:,3) == upperbound); 
        allnodes = [nodeslower;nodesupper];
        
        % Isolate all elements connecting to/from all these nodes
        mCAone = CA(ismember(CA(:,1),allnodes),:);
        mCAtwo = CA(ismember(CA(:,2),allnodes),:);
        mCA = intersect(mCAone,mCAtwo,'rows');
        
        % Isolate and test diagonal elements for feasibility
        yzblocker = false; xzblocker = false;
        for j = 1:1:size(mCA,1)
            x1 = NC(mCA(j,1),1); x2 = NC(mCA(j,2),1);
            y1 = NC(mCA(j,1),2); y2 = NC(mCA(j,2),2);
            z1 = NC(mCA(j,1),3); z2 = NC(mCA(j,2),3);
            if (abs(x2-x1) > 0) && (abs(z2-z1) > 0)
                xzblocker = true;
            elseif (abs(y2-y1) > 0) && (abs(z2-z1) > 0)
                yzblocker = true;
            elseif (abs(x2-x1) > 0) && (abs(y2-y1) > 0) && (abs(z2-z1) > 0)
                xzblocker = true; yzblocker = true;
            end
        end
        
        % Check logical operators for stability pass/fail
        if (xzblocker == false) && (yzblocker == false)
            stabilityScore = stabilityScore - 0.2;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        elseif (xzblocker == true) && (yzblocker == false)
            stabilityScore = stabilityScore - 0.1;
            if stabilityScore < 0.1
                stabilityBool = false;
                return
            end
        elseif (xzblocker == false) && (yzblocker == true)
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