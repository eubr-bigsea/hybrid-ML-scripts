function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

     if ( conf_to_predict == 10 )
       ve = 100 * ( abs(pred(9) * sigma + mu - operational_vector(9))/operational_vector(9) +
                    abs(pred(7) * sigma + mu - operational_vector(7))/operational_vector(7) +
                    abs(pred(6) * sigma + mu - operational_vector(6))/operational_vector(6) +
                    abs(pred(4) * sigma + mu - operational_vector(4))/operational_vector(4) +
                    abs(pred(2) * sigma + mu - operational_vector(2))/operational_vector(2) ) / 5;

     endif

endfunction