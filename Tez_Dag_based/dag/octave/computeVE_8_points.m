function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

       ve = 100 * ( abs(pred(3) * sigma + mu - operational_vector(3))/operational_vector(3) +
                    abs(pred(6) * sigma + mu - operational_vector(6))/operational_vector(6) +
                    abs(pred(7) * sigma + mu - operational_vector(7))/operational_vector(7) +
                    abs(pred(10) * sigma + mu - operational_vector(10))/operational_vector(10) ) / 4
endfunction