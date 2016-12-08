function [total]  = costFuncIntr (j, conf, avg)

sum = 0;
if (j==3) 
  sum = avg(1)*conf(1) + avg(5)*conf(5) + avg(10)*conf(10);
elseif (j==5)
  sum = avg(1)*conf(1) + avg(3)*conf(3) + avg(5)*conf(5) + avg(8)*conf(8) + avg(10)*conf(10);
elseif (j==7)
  sum = avg(1)*conf(1) + avg(2)*conf(2) + avg(3)*conf(3) + avg(5)*conf(5) + avg(6)*conf(6) + avg(8)*conf(8) + avg(10)*conf(10);
endif
total = sum;

endfunction