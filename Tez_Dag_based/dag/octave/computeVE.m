function [ve] = computeVE (pred, sigma, mu, operational_vector, conf_to_predict)

       ve = 100 * abs(pred(12) * sigma + mu - operational_vector(12))/operational_vector(12);

endfunction