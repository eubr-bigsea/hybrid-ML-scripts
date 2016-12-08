function [re] = computeRE (pred, sigma, mu, operational_vector, conf_to_predict)

     if ( conf_to_predict == 10 )
       re = 100 * ( abs(pred(1) * sigma + mu - operational_vector(1))/operational_vector(1) +
                    abs(pred(3) * sigma + mu - operational_vector(3))/operational_vector(3) +
                    abs(pred(5) * sigma + mu - operational_vector(5))/operational_vector(5) +
                    abs(pred(8) * sigma + mu - operational_vector(8))/operational_vector(8) +
                    abs(pred(10) * sigma + mu - operational_vector(10))/operational_vector(10) ) / 5;
     endif

endfunction