function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

     if ( conf_to_predict == 10 )
       ve = 100 * ( abs(pred(1) * sigma + mu - operational_vector(1))/operational_vector(1) +
                    abs(pred(2) * sigma + mu - operational_vector(2))/operational_vector(2) +
                    abs(pred(3) * sigma + mu - operational_vector(3))/operational_vector(3) ) / 3;
     endif

endfunction