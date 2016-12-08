function [re] = computeRE (pred, sigma, mu, operational_vector, conf_to_predict)

       re = 100 * ( abs(pred(1) * sigma + mu - operational_vector(1))/operational_vector(1) +
                    abs(pred(2) * sigma + mu - operational_vector(2))/operational_vector(2) +
                    abs(pred(6) * sigma + mu - operational_vector(6))/operational_vector(6) +
                    abs(pred(7) * sigma + mu - operational_vector(7))/operational_vector(7) +
                    abs(pred(11) * sigma + mu - operational_vector(11))/operational_vector(11) +
                    abs(pred(12) * sigma + mu - operational_vector(12))/operational_vector(12) ) / 6;

endfunction