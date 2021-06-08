% Constraint Checker
% This function is intended to check that a given truss design is
% legitimate (not necessarily stable, but legitimate within the standard
% nodal framework and related assumptions)
function constVerified = constChecker(CA,sidenum)
    constVerified = true;

    % First constraint: members only intersect at nodes (no crossing)
    for i = 1:1:size(CA,1)
        if CA(i,1)+sidenum+1 == CA(i,2)
            row = [CA(i,1)+1,CA(i,1)+sidenum];
            [crossed,where] = ismember(row,CA,'rows');
            if crossed == true
                constVerified = false;
                D = ['Element (',num2str(CA(i,1)),',',num2str(CA(i,2)),...
                     ') intersects with element (',num2str(CA(where,1)),...
                     ',',num2str(CA(where,2)),')'];
                disp(D);
                return
            end
        elseif CA(i,1)+sidenum-1 == CA(i,2)
            row = [CA(i,1)-1,CA(i,1)+sidenum];
            [crossed,where] = ismember(row,CA,'rows');
            if crossed == true
                constVerified = false;
                D = ['Element (',num2str(CA(i,1)),',',num2str(CA(i,2)),...
                     ') intersects with element (',num2str(CA(where,1)),...
                     ',',num2str(CA(where,2)),')'];
                disp(D);
                return
            end
        end
    end
end
