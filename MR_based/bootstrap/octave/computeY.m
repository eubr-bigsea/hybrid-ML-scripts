
function [m, r, s] = computeY (x1, x, x2, m1, r1, s1, m2, r2, s2)
   
   m = ( (x-x1)*m2 + (x2-x)*m1 ) / (x2-x1);
   r = ( (x-x1)*r2 + (x2-x)*r1 ) / (x2-x1);
   s = ( (x-x1)*s2 + (x2-x)*s1 ) / (x2-x1);
   
endfunction