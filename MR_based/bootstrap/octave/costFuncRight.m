function [total]  = costFuncRight (j, conf, avg)

sum = 0;
for k = 1 : 10-j
 sum += avg(k)*conf(k);
endfor
total = sum;

endfunction