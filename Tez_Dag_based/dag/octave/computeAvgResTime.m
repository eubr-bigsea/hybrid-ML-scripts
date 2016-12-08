% input of this function is a matrix in the format of  
% the RUN tables gained from real experiments.

% output of this function is the estimated average response time for input set of experiments based on the formula.

function [avg] = computeAvgResTime (a)

    accResTime = 0;
    for i = 2 : rows(a)
        row = a(i, :); %returns all columns of a row
        act = row(1);
        printf("actual ==== %d \n", act);
        
        nMap = row(2);
        nRed = row(3);
        nCores = row(14);
        mapAvg = row(4);
        redAvg = row(6);
        shAvg = row (8);
        
        accResTime += ceil(nMap / nCores)*mapAvg + ceil(nRed / nCores)*(redAvg + shAvg);
    endfor
    avg = accResTime / (rows(a) - 1);

endfunction