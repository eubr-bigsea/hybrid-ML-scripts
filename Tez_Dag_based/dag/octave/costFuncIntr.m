function [total]  = costFuncIntr (j, conf, avg)

sum = 0;
if (j==4) 
  sum = avg(1)*conf(1) + avg(4)*conf(4) + avg(8)*conf(8) + avg(12)*conf(12);
elseif (j==6)
  sum = avg(1)*conf(1) + avg(2)*conf(2) + avg(6)*conf(6) + avg(7)*conf(7) + avg(11)*conf(11) + avg(12)*conf(12);
elseif (j==8)
  sum = avg(1)*conf(1) + avg(2)*conf(2) + avg(4)*conf(4) + avg(5)*conf(5) + avg(8)*conf(8) + avg(9)*conf(9) + avg(11)*conf(11) + avg(12)*conf(12);
endif
disp(sum);

total = sum;

endfunction