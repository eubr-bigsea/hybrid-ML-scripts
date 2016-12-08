function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

       ve = 100 * ( abs(pred(1) * sigma + mu - operational_vector(1))/operational_vector(1) +
                    abs(pred(2) * sigma + mu - operational_vector(2))/operational_vector(2) +
                    abs(pred(3) * sigma + mu - operational_vector(3))/operational_vector(3) +
                    abs(pred(4) * sigma + mu - operational_vector(4))/operational_vector(4) +
                    abs(pred(5) * sigma + mu - operational_vector(5))/operational_vector(5) ) / 5;

endfunction