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
% Modified Case 1 Test Values to check crossing (feasibilityScore = 0.9):
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
      1,14;3,14;7,14;9,14;14,19;14,21;14,25;14,27;2,13];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
function [feasibilityScore] = constChecker_3D_V2(NC,CA,sel)
    % Initialize values
    feasibilityScore = 1;
    SortedCA = sortrows(CA);
    ND = NC./sel;

    %%% FIRST CONSTRAINT: members only intersect at nodes (no crossing)
    
    % Develop 6xM matrix of line segment endpoint coordinates, where M is 
    % the number of truss members. Each row of format (x1,y1,z1,x2,y2,z2),
    % where point 1 is leftmost, point 2 is rightmost
    PosA = [ND(CA(:,1),1),ND(CA(:,1),2),ND(CA(:,1),3)...
            ND(CA(:,2),1),ND(CA(:,2),2),ND(CA(:,2),3)];
    
    % Loop through each pair of elements
    for i = 1:1:size(PosA,1)
        for j = 1:1:size(PosA,1)
            % Determine whether the given pair of elements intersects
            A = PosA(i,1:3);
            B = PosA(i,4:6);
            C = PosA(j,1:3);
            D = PosA(j,4:6);
            
            if (A==B)
            elseif (A==C)
            elseif (A==D)
            elseif (B==C)
            elseif (C==D)
            elseif (B==D)
                % Do nothing for any of the above cases-- the 2 elements 
                % being considered share either a start- or endpoint
            else
                % Check for an intersection
                intersect = findLineSegIntersection(A,B,C,D);
            
                % Throw an error, given an intersection
                if intersect == true
                    feasibilityScore = feasibilityScore - 0.05;
                    if feasibilityScore < 0.05
                        return
                    end
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
                    if feasibilityScore < 0.05
                        return
                    end
                end
            end
        end
    end
end

% FUNCTION TO DETERMINE PRESENCE OF INTERSECTION (FOR CONSTRAINT #1)
% (source: http://paulbourke.net/geometry/pointlineplane/)
% This boolean function determines whether two line segments intersect,
% given their endpoints (x,y,z) as inputs
function intersect = findLineSegIntersection(A,B,C,D)
    d_ACDC = ((A(1)-C(1))*(D(1)-C(1)))+((A(2)-C(2))*(D(2)-C(2)))+...
             ((A(3)-C(3))*(D(3)-C(3)));
    d_DCBA = ((D(1)-C(1))*(B(1)-A(1)))+((D(2)-C(2))*(B(2)-A(2)))+...
             ((D(3)-C(3))*(B(3)-A(3)));
    d_ACBA = ((A(1)-C(1))*(B(1)-A(1)))+((A(2)-C(2))*(B(2)-A(2)))+...
             ((A(3)-C(3))*(B(3)-A(3)));
    d_DCDC = ((D(1)-C(1))*(D(1)-C(1)))+((D(2)-C(2))*(D(2)-C(2)))+...
             ((D(3)-C(3))*(D(3)-C(3)));
    d_BABA = ((B(1)-A(1))*(B(1)-A(1)))+((B(2)-A(2))*(B(2)-A(2)))+...
             ((B(3)-A(3))*(B(3)-A(3)));

    mua = ((d_ACDC*d_DCBA)-(d_ACBA*d_DCDC))/((d_BABA*d_DCDC)-(d_DCBA*d_DCBA));
    mub = (d_ACDC+(mua*d_DCBA))/d_DCDC;
    Pa = A + (mua.*(B-A));
    Pb = C + (mub.*(D-C));
    if (Pa == Pb)
        if (((Pa(1)>=A(1))&&(Pa(1)<=B(1)))||((Pa(1)>=B(1))&&(Pa(1)<=A(1)))) &&...
           (((Pa(2)>=A(2))&&(Pa(2)<=B(2)))||((Pa(2)>=B(2))&&(Pa(2)<=A(2)))) &&...
           (((Pa(3)>=A(3))&&(Pa(3)<=B(3)))||((Pa(3)>=B(3))&&(Pa(3)<=A(3)))) &&...
           (((Pb(1)>=C(1))&&(Pb(1)<=D(1)))||((Pb(1)>=D(1))&&(Pb(1)<=C(1)))) &&...
           (((Pb(2)>=C(2))&&(Pb(2)<=D(2)))||((Pb(2)>=D(2))&&(Pb(2)<=C(2)))) &&...
           (((Pb(3)>=C(3))&&(Pb(3)<=D(3)))||((Pb(3)>=D(3))&&(Pb(3)<=C(3)))) 
            if (Pa==A)
                intersect = false;
            elseif (Pa==B)
                intersect = false;
            elseif (Pb==C)
                intersect = false;
            elseif (Pb==D)
                intersect = false;
            else
                intersect = true;
            end
        else
            intersect = false;
        end
    else
        intersect = false;
    end
end




