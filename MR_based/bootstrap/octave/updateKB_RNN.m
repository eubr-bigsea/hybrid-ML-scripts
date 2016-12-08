  % Update function implemented with the RNN algorithm considering the euclidian distance.

  function [updated, new_weight]  = updateKB_RNN (current_kb, sample_to_add, old_weight, weight_value)
  
  %% Assign weights to new samples. 

  
  for ii = 1 : size(sample_to_add, 1)
    current_distance = Inf;
    e_new = sample_to_add(ii,:);
    %disp(e_new);
    
    for jj = 1 : size(current_kb, 1)
      e_old = current_kb(jj, :);
      % EHSAN: distance is computed based on feature value
      new_distance  = abs(e_new(2) - e_old(2));
      if(new_distance < current_distance)
          current_distance = new_distance;
          idx = jj;
      endif
    endfor
    %printf("index ========== %d", idx);
    current_kb(idx, :) = e_new;
    old_weight(idx) = weight_value;
  endfor

  updated = current_kb;
  new_weight = old_weight;
  
  endfunction