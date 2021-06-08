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
% Modified Case 1 Test Values (stabilityBool = 1, stabilityScore = 0.9)
% (Failure due to one shearing slice in one direction):
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
% Modified Case 1 Test Values (stabilityBool = 1, stabilityScore = 0.8)
% (Failure due to no face node connectivity in one instance (repeated)):
%{
NC = [0,0,0;0,0,0.025;0,0,0.05;0,0.025,0;0,0.025,0.025;0,0.025,0.05;
      0,0.05,0;0,0.05,0.025;0,0.05,0.05;
      0.025,0,0;0.025,0,0.025;0.025,0,0.05;
      0.025,0.025,0;0.025,0.025,0.025;0.025,0.025,0.05;
      0.025,0.05,0;0.025,0.05,0.025;0.025,0.05,0.05;
      0.05,0,0;0.05,0,0.025;0.05,0,0.05;
      0.05,0.025,0;0.05,0.025,0.025;0.05,0.025,0.05;
      0.05,0.05,0;0.05,0.05,0.025;0.05,0.05,0.05];
CA = [1,2;2,3;3,6;6,9;8,9;7,8;4,7;1,4;2,4;4,8;2,6;6,8;
      10,11;11,12;12,15;15,18;17,18;16,17;13,16;10,13;11,14;14,17;13,14;
      14,15;10,14;14,18;12,14;14,16;
      19,20;20,21;21,24;24,27;26,27;25,26;22,25;19,22;
      20,22;22,26;24,26;20,24;
      1,10;10,19;2,11;11,20;3,12;12,21;4,13;13,22;5,14;14,23;6,15;15,24;
      7,16;16,25;8,17;17,26;9,18;18,27;
      7,17;17,27;9,17;17,25;4,14;14,24;6,14;14,22;1,11;11,21;3,11;11,19;
      7,13;13,19;1,13;13,25;8,14;14,20;2,14;14,26;9,15;15,21;3,15;15,27;
      1,14;3,14;7,14;9,14;14,19;14,21;14,25;14,27];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
% Modified Case 1 Test Values (stabilityBool = 1, stabilityScore = 0.7)
% (Failure due to no face node connectivity in one instance, plus one 
%  shearing slice in one direction):
%{
NC = [0,0,0;0,0,0.025;0,0,0.05;0,0.025,0;0,0.025,0.025;0,0.025,0.05;
      0,0.05,0;0,0.05,0.025;0,0.05,0.05;
      0.025,0,0;0.025,0,0.025;0.025,0,0.05;
      0.025,0.025,0;0.025,0.025,0.025;0.025,0.025,0.05;
      0.025,0.05,0;0.025,0.05,0.025;0.025,0.05,0.05;
      0.05,0,0;0.05,0,0.025;0.05,0,0.05;
      0.05,0.025,0;0.05,0.025,0.025;0.05,0.025,0.05;
      0.05,0.05,0;0.05,0.05,0.025;0.05,0.05,0.05];
CA = [1,2;2,3;3,6;6,9;8,9;7,8;4,7;1,4;2,4;4,8;2,6;6,8;
      10,11;11,12;12,15;15,18;17,18;16,17;13,16;10,13;11,14;14,17;13,14;
      14,15;10,14;14,18;12,14;14,16;
      19,20;20,21;21,24;24,27;26,27;25,26;22,25;19,22;
      20,22;22,26;24,26;20,24;
      1,10;10,19;2,11;11,20;3,12;12,21;4,13;13,22;5,14;14,23;6,15;15,24;
      7,16;16,25;8,17;17,26;9,18;18,27;
      17,27;17,25;14,24;14,22;11,21;11,19;
      7,13;13,19;1,13;13,25;8,14;14,20;2,14;14,26;9,15;15,21;3,15;15,27;
      14,19;14,21;14,25;14,27];
sidenum = 3; sel = 0.05;
%}
% -------------------------------------------------------------------------
function [stabilityBool,stabilityScore] = ...
                                   stabilityTester_3D_V2(sidenum,CA,NC,sel)
    % Initialize variables
    stabilityScore = 1; 
    stabilityBool = true;
    ND = NC./sel;
    
    %%% First stability check: checking for connectivity at each node by
    %%% presence of stiffness components in x,y,z
    holecounter = 0;
    
    % Add up counters based on nodal connectivities (without repeatability)
    [N,~] = histcounts(CA,size(NC,1));
    
    % Loop through each node
    for i = 1:1:size(NC,1)
        % Isolate elements originating/ending at a given node
        indione = CA(:,1) == i; inditwo = CA(:,2) == i;
        mCAone = CA(indione,:); mCAtwo = CA(inditwo,:);
        mCA = ...
            [setdiff(mCAone,mCAtwo,'rows');setdiff(mCAtwo,mCAone,'rows')];
        xsum = 0; ysum = 0; zsum = 0;
        
        % Consider elements present due to repeatability
        %
        % NOTES:
        % 1 if-case for 6 faces 
        % 1 if-case for 8 corner nodes
        % 1 if-case for 12 edges
        %
        if ismember(ND(i,1),[0,1]) && ismember(ND(i,2),[0,1]) &&...
           ismember(ND(i,3),[0,1]) % NODE IS AT A CORNER
            
            % Identify positions of other corner nodes relative to current
            % corner node (below is the identification of corner nodes):
            % 7 nodes: corner-opposite (x1), edge-opposite (x1),
            % face-opposite (x1), edge-adjacent (x2), face-adjacent
            % (x2)
            if (ND(i,1) == 0) && (ND(i,2) == 0) && (ND(i,3) == 0) %1
                % Corner-opposite node
                conode = i+((sidenum^3)-1);
                % Face-opposite node
                fonode = i+(sidenum-1);
                % Edge-opposite node
                eonode = i+((sidenum^3)-sidenum);
                % Edge-adjacent nodes
                aeanode = i+((sidenum^2)-sidenum);
                beanode = i+((sidenum^3)-(sidenum^2)+sidenum-1);
                % Face-adjacent nodes
                afanode = i+((sidenum^2)-i);
                bfanode = i+((sidenum^3)-(sidenum^2));
                
            elseif (ND(i,1) == 0) && (ND(i,2) == 0) && (ND(i,3) == 1) %3
                % Corner-opposite node
                conode = i+((sidenum-1)*((sidenum^2)+sidenum-1));
                % Face-opposite node
                fonode = i-(sidenum-1);
                % Edge-opposite node
                eonode = i+((sidenum^3)-sidenum);
                % Edge-adjacent nodes
                aeanode = i+((sidenum-1)^2);
                beanode = i+(((sidenum-1)*(sidenum^2))-sidenum+2);
                % Face-adjacent nodes
                afanode = i+((sidenum^2)-i);
                bfanode = i+((sidenum-1)*(sidenum^2));
                
            elseif (ND(i,1) == 0) && (ND(i,2) == 1) && (ND(i,3) == 0) %7
                % Corner-opposite node
                conode = i+((sidenum-2)*((sidenum^2)+(2*sidenum)-1));
                % Face-opposite node
                fonode = i+(sidenum-1);
                % Edge-opposite node
                eonode = i+((sidenum-2)*((sidenum^2)+sidenum+1));
                % Edge-adjacent nodes
                aeanode = i-((sidenum-1)^2);
                beanode = i+((sidenum^3)-i);
                % Face-adjacent nodes
                afanode = i-(sidenum*(sidenum-1));
                bfanode = i+((sidenum-1)*(sidenum^2));
                
            elseif (ND(i,1) == 0) && (ND(i,2) == 1) && (ND(i,3) == 1) %9
                % Corner-opposite node
                conode = i+(((sidenum-2)*(sidenum^2))+1);
                % Face-opposite node
                fonode = i-(sidenum-1);
                % Edge-opposite node
                eonode = i+((sidenum^2)+sidenum);
                % Edge-adjacent nodes
                aeanode = i-((sidenum^2)-1);
                beanode = i+((sidenum^3)-i-sidenum+1);
                % Face-adjacent nodes
                afanode = i-(sidenum*(sidenum-1));
                bfanode = i+(2*(sidenum^2));
                
            elseif (ND(i,1) == 1) && (ND(i,2) == 0) && (ND(i,3) == 0) %19
                % Corner-opposite node
                conode = i-(((sidenum-2)*(sidenum^2))+1);
                % Face-opposite node
                fonode = i+(sidenum-1);
                % Edge-opposite node
                eonode = i-((sidenum-2)*((sidenum^2)+sidenum+1));
                % Edge-adjacent nodes
                aeanode = i+((sidenum^2)-1);
                beanode = i-(((sidenum-1)*(sidenum^2))-sidenum+2);
                % Face-adjacent nodes
                afanode = i+(sidenum*(sidenum-1));
                bfanode = i-((sidenum^3)-(sidenum^2));
                
            elseif (ND(i,1) == 1) && (ND(i,2) == 0) && (ND(i,3) == 1) %21
                % Corner-opposite node
                conode = i-((sidenum-2)*((sidenum^2)+(2*sidenum)-1));
                % Face-opposite node
                fonode = i-(sidenum-1);
                % Edge-opposite node
                eonode = i-((sidenum^2)+sidenum);
                % Edge-adjacent nodes
                aeanode = i+((sidenum*(sidenum-1))-(sidenum-1));
                beanode = i-((sidenum^3)-(sidenum^2)+sidenum-1);
                % Face-adjacent nodes
                afanode = i+(sidenum*(sidenum-1));
                bfanode = i-((sidenum-1)*(sidenum^2));
                
            elseif (ND(i,1) == 1) && (ND(i,2) == 1) && (ND(i,3) == 0) %25
                % Corner-opposite node
                conode = i-((sidenum-1)*((sidenum^2)+sidenum-1));
                % Face-opposite node
                fonode = i+(sidenum-1);
                % Edge-opposite node
                eonode = i-((sidenum^3)-sidenum);
                % Edge-adjacent nodes
                aeanode = i-((sidenum*(sidenum-1))-(sidenum-1));
                beanode = i-(((sidenum^2)*(sidenum-1))-(sidenum-1));
                % Face-adjacent nodes
                afanode = i-(sidenum*(sidenum-1));
                bfanode = i-((sidenum-1)*(sidenum^2));
                
            elseif (ND(i,1) == 1) && (ND(i,2) == 1) && (ND(i,3) == 1) %27
                % Corner-opposite node
                conode = i-((sidenum^3)-1);
                % Face-opposite node
                fonode = i-(sidenum-1);
                % Edge-opposite node
                eonode = i-((sidenum^3)-sidenum);
                % Edge-adjacent nodes
                aeanode = i-((sidenum^2)-1);
                beanode = i-(((sidenum-1)*(sidenum^2))-(sidenum-1));
                % Face-adjacent nodes
                afanode = i-(sidenum*(sidenum-1));
                bfanode = i-((sidenum-1)*(sidenum^2));
                
            end
            
            % Find all elements connecting to/from the other corner nodes
            % Corner-opposite node
            coione = CA(:,1) == conode; coitwo = CA(:,2) == conode;
            cnCAone = CA(coione,:); cnCAtwo = CA(coitwo,:);
            cnCA = [setdiff(cnCAone,cnCAtwo,'rows');...
                   setdiff(cnCAtwo,cnCAone,'rows')];
            % Face-opposite node
            foione = CA(:,1) == fonode; foitwo = CA(:,2) == fonode;
            fnCAone = CA(foione,:); fnCAtwo = CA(foitwo,:);
            fnCA = [setdiff(fnCAone,fnCAtwo,'rows');...
                   setdiff(fnCAtwo,fnCAone,'rows')];
            % Edge-opposite node
            eoione = CA(:,1) == eonode; eoitwo = CA(:,2) == eonode;
            enCAone = CA(eoione,:); enCAtwo = CA(eoitwo,:);
            enCA = [setdiff(enCAone,enCAtwo,'rows');...
                   setdiff(enCAtwo,enCAone,'rows')];
            % Edge-adjacent nodes
            aeaione = CA(:,1) == aeanode; aeaitwo = CA(:,2) == aeanode;
            aeanCAone = CA(aeaione,:); aeanCAtwo = CA(aeaitwo,:);
            aeanCA = [setdiff(aeanCAone,aeanCAtwo,'rows');...
                   setdiff(aeanCAtwo,aeanCAone,'rows')];
            beaione = CA(:,1) == beanode; beaitwo = CA(:,2) == beanode;
            beanCAone = CA(beaione,:); beanCAtwo = CA(beaitwo,:);
            beanCA = [setdiff(beanCAone,beanCAtwo,'rows');...
                   setdiff(beanCAtwo,beanCAone,'rows')];
            % Face-adjacent nodes
            afaione = CA(:,1) == afanode; afaitwo = CA(:,2) == afanode;
            afanCAone = CA(afaione,:); afanCAtwo = CA(afaitwo,:);
            afanCA = [setdiff(afanCAone,afanCAtwo,'rows');...
                   setdiff(afanCAtwo,afanCAone,'rows')];
            bfaione = CA(:,1) == bfanode; bfaitwo = CA(:,2) == bfanode;
            bfanCAone = CA(bfaione,:); bfanCAtwo = CA(bfaitwo,:);
            bfanCA = [setdiff(bfanCAone,bfanCAtwo,'rows');...
                   setdiff(bfanCAtwo,bfanCAone,'rows')];
            
            % Based on location of other corner nodes, eliminate duplicate
            % elements
            % Corner-opposite node
            mCA = [mCA;cnCA];
            % Face-opposite node
            for q = 1:1:size(fnCA,1)
                if (ND(fnCA(q,1),3) ~= ND(fnCA(q,2),3))
                    if ((ND(fnCA(q,1),1) ~= ND(fnCA(q,2),1))) ||...
                       ((ND(fnCA(q,1),2) ~= ND(fnCA(q,2),2)))
                        % This element is NOT a duplicate
                        mCA = [mCA;fnCA(q,:)];
                        N(i) = N(i) + 1;
                    end
                end
            end
            % Edge-opposite node
            for q = 1:1:size(enCA,1)
                if (ND(enCA(q,1),3) ~= ND(enCA(q,2),3))
                    if ((ND(enCA(q,1),1) ~= ND(enCA(q,2),1))) ||...
                       ((ND(enCA(q,1),2) ~= ND(enCA(q,2),2)))
                        % This element is NOT a duplicate
                        mCA = [mCA;enCA(q,:)];
                        N(i) = N(i) + 1;
                    end
                end
            end
            % All adjacent nodes
            adjCA = [aeanCA;beanCA;afanCA;bfanCA];
            for q = 1:1:size(adjCA,1)
                if ((ND(adjCA(q,1),1) ~= ND(adjCA(q,2),1))) &&...
                   ((ND(adjCA(q,1),2) ~= ND(adjCA(q,2),2))) &&...
                   ((ND(adjCA(q,1),3) ~= ND(adjCA(q,2),3)))
                    % This element is NOT a duplicate
                    mCA = [mCA;adjCA(q,:)];
                    N(i) = N(i) + 1;
                end
            end
            
        elseif ((ismember(ND(i,1),[0,1])) && (ismember(ND(i,2),[0,1]))... 
               && (~ismember(ND(i,3),[0,1]))) ||...
               ((~ismember(ND(i,1),[0,1])) && (ismember(ND(i,2),[0,1]))... 
               && (ismember(ND(i,3),[0,1]))) ||...
               ((ismember(ND(i,1),[0,1])) && (~ismember(ND(i,2),[0,1]))... 
               && (ismember(ND(i,3),[0,1]))) % NODE IS ON AN EDGE
           
           % Identify opposite and adjacent nodes
           idtag = 0;
           if ((~ismember(ND(i,1),[0,1])) && (ismember(ND(i,2),[0,1]))... 
               && (ismember(ND(i,3),[0,1]))) % Edges running in x-direction
               idtag = 1; v = ND(i,2); w = ND(i,3);
               oppnode = i+(abs(v-1)*abs(w-1)*((sidenum^2)-1))+...
                         (abs(v-1)*w*((sidenum^2)-((sidenum-1)*sidenum)+1))-...
                         (v*w*((sidenum^2)-1))-...
                         (v*abs(w-1)*((sidenum^2)-((sidenum-1)*sidenum)+1));
               aadjnode = i+(abs(w-1)*(sidenum-1))-(w*(sidenum-1));
               badjnode = i+(abs(v-1)*(sidenum*(sidenum-1)))-...
                          (v*(sidenum*(sidenum-1)));
               
           elseif ((ismember(ND(i,1),[0,1])) && (~ismember(ND(i,2),[0,1]))... 
               && (ismember(ND(i,3),[0,1]))) % Edges running in y-direction
               idtag = 2; v = ND(i,1); w = ND(i,3);
               oppnode = i+(abs(v-1)*abs(w-1)*(((sidenum-1)*(sidenum^2))+sidenum-1))+...
                         (abs(v-1)*w*(((sidenum-1)*(sidenum^2))-sidenum+1))-...
                         (v*w*(((sidenum-1)*(sidenum^2))+sidenum-1))-...
                         (v*abs(w-1)*(((sidenum-1)*(sidenum^2))-sidenum+1));
               aadjnode = i+(abs(w-1)*(sidenum-1))-(w*(sidenum-1));
               badjnode = i+(abs(v-1)*((sidenum-1)*(sidenum^2)))-...
                          (v*((sidenum-1)*(sidenum^2)));
                      
           elseif ((ismember(ND(i,1),[0,1])) && (ismember(ND(i,2),[0,1]))... 
              && (~ismember(ND(i,3),[0,1]))) % Edges running in z-direction
               idtag = 3; v = ND(i,2); w = ND(i,1);
               oppnode = i+(abs(v-1)*abs(w-1)*((sidenum^3)-sidenum+1))+...
                         (abs(v-1)*w*(((sidenum-2)*(sidenum^3))+sidenum))-...
                         (v*w*((sidenum^3)-sidenum+1))-...
                         (v*abs(w-1)*(((sidenum-2)*(sidenum^3))+sidenum));
               aadjnode = i+(abs(w-1)*(sidenum*(sidenum-1)))-...
                          (w*(sidenum*(sidenum-1)));
               badjnode = i+(abs(v-1)*((sidenum-1)*(sidenum^2)))-...
                          (v*(2*(sidenum^2)));
                      
           end
           
           % Find elements connecting to/from opposite, adjacent nodes
           indone = CA(:,1) == oppnode; indtwo = CA(:,2) == oppnode;
           onCAone = CA(indone,:); onCAtwo = CA(indtwo,:);
           onCA = [setdiff(onCAone,onCAtwo,'rows');...
                   setdiff(onCAtwo,onCAone,'rows')];
           bindone = CA(:,1) == badjnode; bindtwo = CA(:,2) == badjnode;
           bnCAone = CA(bindone,:); bnCAtwo = CA(bindtwo,:);
           bnCA = [setdiff(bnCAone,bnCAtwo,'rows');...
                   setdiff(bnCAtwo,bnCAone,'rows')];
           aindone = CA(:,1) == aadjnode; aindtwo = CA(:,2) == aadjnode;
           anCAone = CA(aindone,:); anCAtwo = CA(aindtwo,:);
           anCA = [setdiff(anCAone,anCAtwo,'rows');...
                   setdiff(anCAtwo,anCAone,'rows')];
                
           % Based on location of opposite nodes, eliminate
           % duplicate elements
           for q = 1:1:size(onCA,1)
               if (idtag == 1) && ((ND(onCA(q,1),1) ~= ND(onCA(q,2),1)))
                   % For an edge running in the x-direction, this element
                   % is NOT a duplicate
                   mCA = [mCA;onCA(q,:)];
                   N(i) = N(i) + 1;
               elseif (idtag == 2) && ((ND(onCA(q,1),2) ~=ND(onCA(q,2),2)))
                   % For an edge running in the y-direction, this element
                   % is NOT a duplicate
                   mCA = [mCA;onCA(q,:)];
                   N(i) = N(i) + 1;
               elseif (idtag == 3) && ((ND(onCA(q,1),3) ~=ND(onCA(q,2),3)))
                   % For an edge running in the z-direction, this element
                   % is NOT a duplicate
                   mCA = [mCA;onCA(q,:)];
                   N(i) = N(i) + 1;
               end
           end
           
           % Based on location of adjacent nodes, eliminate
           % duplicate elements
           for q = 1:1:size(anCA,1)
               if ((ND(anCA(q,1),1) ~= ND(anCA(q,2),1))) &&...
                  ((ND(anCA(q,1),2) ~= ND(anCA(q,2),2))) &&...
                  ((ND(anCA(q,1),3) ~= ND(anCA(q,2),3)))
              
                   % For an edge running in any direction, this element
                   % is NOT a duplicate
                   mCA = [mCA;anCA(q,:)];
                   N(i) = N(i) + 1;
               end
           end
           for q = 1:1:size(bnCA,1)
               if ((ND(bnCA(q,1),1) ~= ND(bnCA(q,2),1))) &&...
                  ((ND(bnCA(q,1),2) ~= ND(bnCA(q,2),2))) &&...
                  ((ND(bnCA(q,1),3) ~= ND(bnCA(q,2),3)))
              
                   % For an edge running in any direction, this element
                   % is NOT a duplicate
                   mCA = [mCA;bnCA(q,:)];
                   N(i) = N(i) + 1;
               end
           end
            
        elseif ((~ismember(ND(i,1),[0,1])) && (~ismember(ND(i,2),[0,1]))... 
               && (ismember(ND(i,3),[0,1]))) ||...
               ((ismember(ND(i,1),[0,1])) && (~ismember(ND(i,2),[0,1]))... 
               && (~ismember(ND(i,3),[0,1]))) ||...
               ((~ismember(ND(i,1),[0,1])) && (ismember(ND(i,2),[0,1]))... 
               && (~ismember(ND(i,3),[0,1]))) % NODE IS ON A FACE
            
            % Identify opposite node
            idtag = 0;
            if (~ismember(ND(i,1),[0,1])) && (~ismember(ND(i,2),[0,1]))... 
               && (ismember(ND(i,3),[0,1]))
               % Oppnode is on xy-plane
               idtag = 3; 
               w = ND(i,3);
               oppnode = i+(abs(w-1)*(sidenum-1))-(w*(sidenum-1));
               
            elseif (ismember(ND(i,1),[0,1])) &&...
                   (~ismember(ND(i,2),[0,1])) && (~ismember(ND(i,3),[0,1]))
               % Oppnode is on yz-plane
               idtag = 1;
               w = ND(i,1);
               oppnode = i+(abs(w-1)*((sidenum-1)*(sidenum^2)))-...
                         (w*((sidenum-1)*(sidenum^2)));
               
            elseif (~ismember(ND(i,1),[0,1])) &&...
                   (ismember(ND(i,2),[0,1])) && (~ismember(ND(i,3),[0,1]))
               % Oppnode is on xz-plane
               idtag = 2;
               w = ND(i,2);
               oppnode = i+(abs(w-1)*((sidenum^2)-sidenum))-...
                         (w*((sidenum^2)-sidenum));  
                     
            end
            
            % Find elements connecting to/from opposite node
            indone = CA(:,1) == oppnode; indtwo = CA(:,2) == oppnode;
            onCAone = CA(indone,:); onCAtwo = CA(indtwo,:);
            onCA = [setdiff(onCAone,onCAtwo,'rows');...
                    setdiff(onCAtwo,onCAone,'rows')];
            
            % Based on location of opposite node, eliminate duplicate
            % elements
            for q = 1:1:size(onCA,1)
                if ((idtag == 1) && ((ND(onCA(q,1),2) ~=ND(onCA(q,2),2))...
           || (ND(onCA(q,1),3) ~= ND(onCA(q,2),3)))) ||...
           ((idtag == 1) && ((ND(onCA(q,1),2) ~=ND(onCA(q,2),2))...
           && (ND(onCA(q,1),3) ~= ND(onCA(q,2),3))))
       
                    % Element in yz-plane is NOT a duplicate
                    mCA = [mCA;onCA(q,:)];
                    N(i) = N(i) + 1;
                    
                elseif ((idtag == 2) &&...
           ((ND(onCA(q,1),1) ~= ND(onCA(q,2),1))...
           || (ND(onCA(q,1),3) ~= ND(onCA(q,2),3)))) ||...
           ((idtag == 2) && ((ND(onCA(q,1),1) ~= ND(onCA(q,2),1))...
           && (ND(onCA(q,1),3) ~= ND(onCA(q,2),3))))
                    
                    % Element in xz-plane is NOT a duplicate
                    mCA = [mCA;onCA(q,:)];
                    N(i) = N(i) + 1;
                    
                elseif ((idtag == 3) &&...
           ((ND(onCA(q,1),1) ~= ND(onCA(q,2),1))...
           || (ND(onCA(q,1),2) ~= ND(onCA(q,2),2)))) ||...
           ((idtag == 3) && ((ND(onCA(q,1),1) ~= ND(onCA(q,2),1))...
           && (ND(onCA(q,1),2) ~= ND(onCA(q,2),2))))
                    
                    % Element in xy-plane is NOT a duplicate
                    mCA = [mCA;onCA(q,:)];
                    N(i) = N(i) + 1;
                    
                end
            end
        end
        
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
        
        % Also include diagonal elements starting on the slice but ending
        % elsewhere on the grid
        for ib = 1:1:size(nodeslower,1) % For nodeslower
            tCAone = CA(ismember(CA(:,1),nodeslower(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),1) >= ((2/(sidenum-1))+ND(ib,1))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodeslower(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),1) >= ((2/(sidenum-1))+ND(ib,1))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end
        for ib = 1:1:size(nodesupper,1) % For nodesupper
            tCAone = CA(ismember(CA(:,1),nodesupper(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),1) <= (ND(ib,1)-(2/(sidenum-1)))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodesupper(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),1) <= (ND(ib,1)-(2/(sidenum-1)))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end
        
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
        
        % Also include diagonal elements starting on the slice but ending
        % elsewhere on the grid
        for ib = 1:1:size(nodeslower,1) % For nodeslower
            tCAone = CA(ismember(CA(:,1),nodeslower(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),2) >= ((2/(sidenum-1))+ND(ib,2))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodeslower(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),2) >= ((2/(sidenum-1))+ND(ib,2))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end
        for ib = 1:1:size(nodesupper,1) % For nodesupper
            tCAone = CA(ismember(CA(:,1),nodesupper(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),2) <= (ND(ib,2)-(2/(sidenum-1)))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodesupper(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),2) <= (ND(ib,2)-(2/(sidenum-1)))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end
        
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
        
        % Also include diagonal elements starting on the slice but ending
        % elsewhere on the grid
        for ib = 1:1:size(nodeslower,1) % For nodeslower
            tCAone = CA(ismember(CA(:,1),nodeslower(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),3) >= ((2/(sidenum-1))+ND(ib,3))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodeslower(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),3) >= ((2/(sidenum-1))+ND(ib,3))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end
        for ib = 1:1:size(nodesupper,1) % For nodesupper
            tCAone = CA(ismember(CA(:,1),nodesupper(ib)),:);
            for io = 1:1:size(tCAone,1)
                if ND(tCAone(io,2),3) <= (ND(ib,3)-(2/(sidenum-1)))
                    mCA = [mCA;tCAone(io,:)];
                end
            end
            tCAtwo = CA(ismember(CA(:,2),nodesupper(ib)),:);
            for io = 1:1:size(tCAtwo,1)
                if ND(tCAtwo(io,1),3) <= (ND(ib,3)-(2/(sidenum-1)))
                    mCA = [mCA;tCAtwo(io,:)];
                end
            end
        end
        
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