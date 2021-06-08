% HOLE COUNTER
% This function counts the number of holes (unused nodes) in a design,
% accounting for repeatability
function holes = holeCounter(sidenum,CA,NC,sel)
    % Add up counters based on nodal connectivities (sans repeatability)
    [N,~] = histcounts(CA,size(NC,1));

end