% FEASIBILITY CHECKER FOR 3D DESIGNS
% This function determines whether a design is feasible, i.e. it can be
% physically produced
% -------------------------------------------------------------------------
% feasibilityScore is on [0,1] in minimum increments of 0.05
% stabilityBool = false for feasibilityScore < 1, true for 
% feasibilityScore = 1
% -------------------------------------------------------------------------
% Case 1 Test Values (feasibilityScore = 1):
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
% Modified Case 1 Test Values to check overlap (feasibilityScore = 0.8):
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
      1,14;3,14;7,14;9,14;14,19;14,21;14,25;14,27;1,27];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
% Modified Case 1 Test Values to check crossing (feasibilityScore = 0.8):
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
      1,14;3,14;7,14;9,14;14,19;14,21;14,25;14,27;4,11];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
function [feasibilityScore] = constChecker_3D_V1(NC,CA)
    % Initialize output
    feasibilityScore = 1;

    %%% FIRST CONSTRAINT: members only intersect at nodes (no crossing)
    % Sort points from left to right by x-position
    SortedCA = sortrows(CA);
    
    % Develop 6xM matrix of line segment endpoint coordinates, where M is 
    % the number of truss members. Each row of format (x1,y1,z1,x2,y2,z2),
    % where point 1 is leftmost, point 2 is rightmost
    PosA = [NC(SortedCA(:,1),1),NC(SortedCA(:,1),2),NC(SortedCA(:,1),3)...
            NC(SortedCA(:,2),1),NC(SortedCA(:,2),2),NC(SortedCA(:,2),3)];
    
    % Loop through each pair of elements
    for i = 1:1:size(PosA,1)
        for j = 1:1:size(PosA,1)
            % Determine whether the given pair of elements intersects
            intersect = findLineSegIntersection(...
      [PosA(i,1),PosA(i,2),PosA(i,3)],[PosA(i,4),PosA(i,5),PosA(i,6)],...
      [PosA(j,1),PosA(j,2),PosA(j,3)],[PosA(j,4),PosA(j,5),PosA(j,6)]);
            
            % Throw an error, given an intersection
            if intersect == true
                feasibilityScore = feasibilityScore - 0.1;
                disp('intersection');
                if feasibilityScore < 0.1
                    return
                end
            end
        end
    end
    
    %%% SECOND CONSTRAINT: Elements (of either the same or different 
    %%% lengths) cannot overlap
    % Loop through each element
    for k = 1:1:size(SortedCA,1)
        % Loop through each element again, to consider each possible pair 
        %   of elements
        for q = 1:1:size(SortedCA,1)
            % Define startpoint of first element
            xks = NC(SortedCA(k,1),1); yks = NC(SortedCA(k,1),2); 
            zks = NC(SortedCA(k,1),3);
            
            % Define endpoint of first element
            xke = NC(SortedCA(k,2),1); yke = NC(SortedCA(k,2),2); 
            zke = NC(SortedCA(k,2),3);
            
            % Define startpoint of second element
            xqs = NC(SortedCA(q,1),1); yqs = NC(SortedCA(q,1),2); 
            zqs = NC(SortedCA(q,1),3);
            
            % Define endpoint of second element
            xqe = NC(SortedCA(q,2),1); yqe = NC(SortedCA(q,2),2); 
            zqe = NC(SortedCA(q,2),3);
            
            % Check for overlap if two elements start/end at the same point
            if k == q
                % The same element is being considered, move on
                continue
            % Check if both elements share a common startpoint
            elseif (xks == xqs) && (yks == yqs) && (zks == zqs)
                % Find the directional slopes of the first element
                lk = sqrt(((xke-xks)^2)+((yke-yks)^2)+((zke-zks)^2));
                mk_yz = (xke-xks)/lk;
                mk_xz = (yke-yks)/lk;
                mk_xy = (zke-zks)/lk;
                
                % Find the directional slopes of the second element
                lq = sqrt(((xqe-xqs)^2)+((yqe-yqs)^2)+((zqe-zqs)^2));
                mq_yz = (xqe-xqs)/lq;
                mq_xz = (yqe-yqs)/lq;
                mq_xy = (zqe-zqs)/lq;
                
                % Compare the directional slopes of the two elements
                if (mk_yz == mq_yz) && (mk_xz == mq_xz) && ...
                       (mk_xy == mq_xy)
                    % The elements have the same slope
                    feasibilityScore = feasibilityScore - 0.05;
                    disp('overlap, same startpoint');
                    if feasibilityScore < 0.05
                        return
                    end
                end
            % Check if both elements share a common endpoint    
            elseif (xke == xqe) && (yke == yqe) && (zke == zqe)   
                % Find the directional slopes of the first element
                lk = sqrt(((xke-xks)^2)+((yke-yks)^2)+((zke-zks)^2));
                mk_yz = (xke-xks)/lk;
                mk_xz = (yke-yks)/lk;
                mk_xy = (zke-zks)/lk;
                
                % Find the directional slopes of the second element
                lq = sqrt(((xqe-xqs)^2)+((yqe-yqs)^2)+((zqe-zqs)^2));
                mq_yz = (xqe-xqs)/lq;
                mq_xz = (yqe-yqs)/lq;
                mq_xy = (zqe-zqs)/lq;
                
                % Compare the directional slopes of the two elements
                if (mk_yz == mq_yz) && (mk_xz == mq_xz) && ...
                       (mk_xy == mq_xy)
                    % The elements have the same slope
                    feasibilityScore = feasibilityScore - 0.05;
                    disp('overlap, same endpoint');
                    if feasibilityScore < 0.05
                        return
                    end
                end
            end
        end
    end
end

% FUNCTION TO DETERMINE PRESENCE OF INTERSECTION (FOR CONSTRAINT #1)
% (source: https://www.geeksforgeeks.org/check-if-two-given-line-segments
% -intersect/)
% This boolean function determines whether two line segments intersect,
% given their endpoints (x,y,z) as inputs
function intersect = findLineSegIntersection(p1,q1,p2,q2)
    if (findOrientation(p1,q1,p2) ~= findOrientation(p1,q1,q2))&&...
            (findOrientation(p2,q2,p1) ~= findOrientation(p2,q2,q1)) 
        if isequal(p1,p2) || isequal(q1,q2) || ...
                isequal(p1,q2) || isequal(q1,p2)
            intersect = false; 
        else
            intersect = true;
        end
    else
        intersect = false;
    end
end

% FUNCTION TO CALCULATE ORIENTATION FROM 3 POINTS (FOR CONSTRAINT #1)
% (source: https://www.geeksforgeeks.org/orientation-3-ordered-points/)
% This function finds the orientation of an ordered triplet (p, q, r)
% The function returns one of three following values:
% 0 --> p, q and r are colinear 
% 1 --> Clockwise 
% 2 --> Counterclockwise 
function orientation = findOrientation(p,q,r)
    xval = ((q(2)-p(2))*(r(3)-p(3)))-((q(3)-p(3))*(r(2)-p(2)));
    yval = ((q(3)-p(3))*(r(1)-p(1)))-((q(1)-p(1))*(r(3)-p(3)));
    zval = ((q(1)-p(1))*(r(2)-p(2)))-((q(2)-p(2))*(r(1)-p(1)));
    val = sqrt((xval^2)+(yval^2)+(zval^2));
    
    %%%INCOMPLETE  
end


