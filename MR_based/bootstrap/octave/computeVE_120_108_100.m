function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

     if ( conf_to_predict == 10 )
       ve = 100 * ( abs(pred(10) * sigma + mu - operational_vector(10))/operational_vector(10) +
                    abs(pred(9) * sigma + mu - operational_vector(9))/operational_vector(9) +
                    abs(pred(8) * sigma + mu - operational_vector(8))/operational_vector(8) ) / 3;

     endif

endfunction