function [total]  = costFuncRight (j, conf, avg)

sum = 0;
for k = j+1 : 12
 sum += avg(k)*conf(k);
endfor
total = sum;

endfunction