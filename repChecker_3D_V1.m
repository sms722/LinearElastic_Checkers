% FUNCTION TO TEST REPEATABILITY IN 3D
% This function is intended to check whether a given truss design can be
% used as a repeatable unit cell-- that is, whether opposing sides of the
% unit cell cube are the same
% -------------------------------------------------------------------------
% repeatabilityBool = true only if all faces are equal to their opposite
% counterpart, repeatabilityBool = false otherwise
% -------------------------------------------------------------------------
% Case 1 Test Values:
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
% Modified Case 1 Test Values:
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
      7,17;17,27;9,17;17,25;4,14;14,24;6,14;14,22;3,11;11,19;
      7,13;13,19;1,13;13,25;8,14;14,20;2,14;14,26;9,15;15,21;3,15;15,27;
      1,14;3,14;7,14;9,14;14,19;14,21;14,25;14,27];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
function repeatabilityBool = repChecker_3D_V1(sel,NC,CA,sidenum)
    % Prepare variables
    ND = NC./sel;

    %%% Comparing x = 0, x = sel sides
    % Identify nodes    
    xeznodes = find(ND(:,1) == 0); 
    xeonodes = find(ND(:,1) == 1);
    
    % Identify face elements
    xezCAone = CA(ismember(CA(:,1),xeznodes),:);
    xezCAtwo = CA(ismember(CA(:,2),xeznodes),:);
    xezCA = intersect(xezCAone,xezCAtwo,'rows');
    xeoCAone = CA(ismember(CA(:,1),xeonodes),:);
    xeoCAtwo = CA(ismember(CA(:,2),xeonodes),:);
    xeoCA = intersect(xeoCAone,xeoCAtwo,'rows');
    
    % Compare faces
    xecCA = xeoCA - ((sidenum-1)*(sidenum^2));
    xfaceeq = isequal(xecCA,xezCA);
    
    %%% Comparing y = 0, y = sel sides
    % Identify nodes    
    yeznodes = find(ND(:,2) == 0); 
    yeonodes = find(ND(:,2) == 1);
    
    % Identify face elements
    yezCAone = CA(ismember(CA(:,1),yeznodes),:);
    yezCAtwo = CA(ismember(CA(:,2),yeznodes),:);
    yezCA = intersect(yezCAone,yezCAtwo,'rows');
    yeoCAone = CA(ismember(CA(:,1),yeonodes),:);
    yeoCAtwo = CA(ismember(CA(:,2),yeonodes),:);
    yeoCA = intersect(yeoCAone,yeoCAtwo,'rows');
    
    % Compare faces
    yecCA = yeoCA - ((sidenum^2)-sidenum);
    yfaceeq = isequal(yecCA,yezCA);
    
    %%% Comparing z = 0, z = sel sides
    % Identify nodes    
    zeznodes = find(ND(:,3) == 0); 
    zeonodes = find(ND(:,3) == 1);
    
    % Identify face elements
    zezCAone = CA(ismember(CA(:,1),zeznodes),:);
    zezCAtwo = CA(ismember(CA(:,2),zeznodes),:);
    zezCA = intersect(zezCAone,zezCAtwo,'rows');
    zeoCAone = CA(ismember(CA(:,1),zeonodes),:);
    zeoCAtwo = CA(ismember(CA(:,2),zeonodes),:);
    zeoCA = intersect(zeoCAone,zeoCAtwo,'rows');
    
    % Compare faces
    zecCA = zeoCA - (sidenum-1);
    zfaceeq = isequal(zecCA,zezCA);
    
    %%% Check repeatability booleans
    if (xfaceeq == false) || (yfaceeq == false) || (zfaceeq == false)
        repeatabilityBool = false;
    else
        repeatabilityBool = true;
    end
end
