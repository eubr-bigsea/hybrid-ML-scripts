function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

       ve = 100 * ( abs(pred(12) * sigma + mu - operational_vector(12))/operational_vector(12) +
                    abs(pred(11) * sigma + mu - operational_vector(11))/operational_vector(11) +
                    abs(pred(10) * sigma + mu - operational_vector(10))/operational_vector(10) +
                    abs(pred(9) * sigma + mu - operational_vector(9))/operational_vector(9) +
                    abs(pred(8) * sigma + mu - operational_vector(8))/operational_vector(8) ) / 5;

endfunction