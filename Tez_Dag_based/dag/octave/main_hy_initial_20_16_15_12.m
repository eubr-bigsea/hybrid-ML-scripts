clear all
close all hidden
clc
warning("off")

%% Input data parameters: path to folder containing 
%% the analytical data and to folder containing 
%% the operational data.
query = "Q1";
ssize = "30";
configuration_to_predict = 12;

preTextPosition = 70000;
pveTextPosition = 2*preTextPosition/3;
%errorCoef = 40;

%for R1:
opr_configurations =    [2 3 4 5 6 8 9 10 12 15 16 20];
full_configurations =   [2 3 4 5 6 8 9 10 12 15 16 20];
simple_configurations = [2 3 4 5 6 8 9 10 12 15 16 20];
full_scaled = [1 1 1 1 1 1 1 1 1 1 1 1];

oper_weight_value = 5;
analyt_weight_value = 1;
%----------------------------------------------------------------------------------------------

conf_linear = "-s 3 -t 0 -q -h 0 ";

query_analytical_data = ["full/" query "/" ssize "/estimatedResTimes.csv"];
query_operational_data_2 = ["oper/" query "/" ssize "/2.csv"];
query_operational_data_3 = ["oper/" query "/" ssize "/3.csv"];
query_operational_data_4_1 = ["oper/" query "/" ssize "/4_1.csv"];
query_operational_data_4_2 = ["oper/" query "/" ssize "/4_2.csv"];
query_operational_data_5 = ["oper/" query "/" ssize "/5.csv"];
query_operational_data_6_1 = ["oper/" query "/" ssize "/6_1.csv"];
query_operational_data_6_2 = ["oper/" query "/" ssize "/6_2.csv"];
query_operational_data_8_1 = ["oper/" query "/" ssize "/8_1.csv"];
query_operational_data_8_2 = ["oper/" query "/" ssize "/8_2.csv"];
query_operational_data_9 = ["oper/" query "/" ssize "/9.csv"];
query_operational_data_10 = ["oper/" query "/" ssize "/10.csv"];
query_operational_data_12_1 = ["oper/" query "/" ssize "/12_1.csv"];
query_operational_data_12_2 = ["oper/" query "/" ssize "/12_2.csv"];
query_operational_data_15 = ["oper/" query "/" ssize "/15.csv"];
query_operational_data_16 = ["oper/" query "/" ssize "/16.csv"];
query_operational_data_20 = ["oper/" query "/" ssize "/20.csv"];

base_dir = "../source_data/";

analytical_data = read_data([base_dir query_analytical_data]);
am_results = analytical_data(:, 1);
am_results = am_results(:)';

am_conf = analytical_data(:, 2);
am_conf = am_conf(:)';

operational_data_2 = read_data([base_dir query_operational_data_2]);
operational_data_3 = read_data([base_dir query_operational_data_3]);
operational_data_4_1 = read_data([base_dir query_operational_data_4_1]);
operational_data_4_2 = read_data([base_dir query_operational_data_4_2]);
operational_data_5 = read_data([base_dir query_operational_data_5]);
operational_data_6_1 = read_data([base_dir query_operational_data_6_1]);
operational_data_6_2 = read_data([base_dir query_operational_data_6_2]);
operational_data_8_1 = read_data([base_dir query_operational_data_8_1]);
operational_data_8_2 = read_data([base_dir query_operational_data_8_2]);
operational_data_9 = read_data([base_dir query_operational_data_9]);
operational_data_10 = read_data([base_dir query_operational_data_10]);
operational_data_12_1 = read_data([base_dir query_operational_data_12_1]);
operational_data_12_2 = read_data([base_dir query_operational_data_12_2]);
operational_data_15 = read_data([base_dir query_operational_data_15]);
operational_data_16 = read_data([base_dir query_operational_data_16]);
operational_data_20 = read_data([base_dir query_operational_data_20]);

[operational_data_2_cleaned, ~] = clear_outliers (operational_data_2);
[operational_data_3_cleaned, ~] = clear_outliers (operational_data_3);
[operational_data_4_1_cleaned, ~] = clear_outliers (operational_data_4_1);
[operational_data_4_2_cleaned, ~] = clear_outliers (operational_data_4_2);
[operational_data_5_cleaned, ~] = clear_outliers (operational_data_5);
[operational_data_6_1_cleaned, ~] = clear_outliers (operational_data_6_1);
[operational_data_6_2_cleaned, ~] = clear_outliers (operational_data_6_2);
[operational_data_8_1_cleaned, ~] = clear_outliers (operational_data_8_1);
[operational_data_8_2_cleaned, ~] = clear_outliers (operational_data_8_2);
[operational_data_9_cleaned, ~] = clear_outliers (operational_data_9);
[operational_data_10_cleaned, ~] = clear_outliers (operational_data_10);
[operational_data_12_1_cleaned, ~] = clear_outliers (operational_data_12_1);
[operational_data_12_2_cleaned, ~] = clear_outliers (operational_data_12_2);
[operational_data_15_cleaned, ~] = clear_outliers (operational_data_15);
[operational_data_16_cleaned, ~] = clear_outliers (operational_data_16);
[operational_data_20_cleaned, ~] = clear_outliers (operational_data_20);

% EHSAN: recomputing avg_time_query_vector at runtime to be sure of the old values
avg_time_query_vector = [(mean(operational_data_2_cleaned))(1) (mean(operational_data_3_cleaned))(1) ((mean(operational_data_4_1_cleaned))(1)+(mean(operational_data_4_2_cleaned))(1))/2 (mean(operational_data_5_cleaned))(1) ((mean(operational_data_6_1_cleaned))(1)+(mean(operational_data_6_2_cleaned))(1))/2  ((mean(operational_data_8_1_cleaned))(1)+(mean(operational_data_8_2_cleaned))(1))/2  (mean(operational_data_9_cleaned))(1) (mean(operational_data_10_cleaned))(1)  ((mean(operational_data_12_1_cleaned))(1)+(mean(operational_data_12_2_cleaned))(1))/2  (mean(operational_data_15_cleaned))(1) (mean(operational_data_16_cleaned))(1) (mean(operational_data_20_cleaned))(1)];
%avg_time_query_vector = [(mean(operational_data_2_cleaned))(1) (mean(operational_data_3_cleaned))(1) (mean(operational_data_4_1_cleaned))(1) (mean(operational_data_4_2_cleaned))(1) (mean(operational_data_5_cleaned))(1) (mean(operational_data_6_1_cleaned))(1) (mean(operational_data_6_2_cleaned))(1)  (mean(operational_data_8_1_cleaned))(1) (mean(operational_data_8_2_cleaned))(1)  (mean(operational_data_9_cleaned))(1) (mean(operational_data_10_cleaned))(1)  (mean(operational_data_12_1_cleaned))(1) (mean(operational_data_12_2_cleaned))(1)  (mean(operational_data_15_cleaned))(1) (mean(operational_data_16_cleaned))(1) (mean(operational_data_20_cleaned))(1)];

%% Splitting parameters
train_frac = 0.6;
test_frac = 0.2

%% Ranges to be used to the identification
%% of the optimal "C" and "epsilon" parameter of the SVR
%% when using epsilon-SVR ( the SVR type used by Eugenio.
%% we could investigate if it makes sense to try nu-SVR too ).
C_range = linspace (0.1, 5, 20);
E_range = linspace (0.1, 5, 20);

for itrThr = 34:34
  out(1) = itrThr;
  ml_out(1) = itrThr;
  for stopThr = 23:23
    out(2) = stopThr; 
    ml_out(2) = stopThr; 

    outPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(opr_configurations(configuration_to_predict)), "/HyExtrapolate/12/out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
    
    header(1) = 1;
    header(2) = 1;
    header(3) = 1;
    header(4) = 1;
    header(5) = 1;
    header(6) = 1;
    header(7) = 1;
    header(8) = 1;
    header(9) = 1;
    header(10) = 1;
    dlmwrite(outPath, header, "-append");

    for seed = 101 : 150
          out(3) = seed;
          rand ("seed", "reset");
          rand ("seed", seed);
          
          %% Initializing the Knowledge Base sampling the analytical data
          analytical_sample = initKB (analytical_data);
          weight = ones( size (analytical_sample, 1), 1) * analyt_weight_value;
          permutation = randperm (size (analytical_sample, 1));
          analytical_shuffled_NotScaled = analytical_sample(permutation, :);
          weight_shuffled = weight(permutation);
          %% =============== SCALING ================
          [analytical_shuffled, mu, sigma] = zscore(analytical_shuffled_NotScaled);
          mu_y = mu(1);
          mu_X = mu(2);
          sigma_y = sigma(1);
          sigma_X = sigma(2);

          %% Separating prediction variables from target variable in the analytical dataset get first column in y and second in X. 
          y = analytical_shuffled(:, 1);
          X = analytical_shuffled(:, 2);

          %% Splitting the analytical datasets
          % EHSAN: CV is also catched
          [ytr, ytst, ycv] = split_sample (y, train_frac, test_frac);
          [Xtr, Xtst, Xcv] = split_sample (X, train_frac, test_frac);
          [Wtr, Wtst, Wcv] = split_sample (weight_shuffled, train_frac, test_frac);

          %% ======================================== NOW SELECTING THE MODEL, TRAINING IT, AND PREDICTING OUTPUTS =======================
          %% ========== Linear kernel model =========
          printf("Training the SVR from on analytical model (linear kernel).")
          [C, eps] = modelSelection_weighted (Wtr, ytr, Xtr, ycv, Xcv, conf_linear, C_range, E_range);
          options = [conf_linear, " -p ", num2str(eps), " -c ", num2str(C)];
          model = svmtrain (Wtr, ytr, Xtr, options);
          %% ================================== End of First Iteration ======================================

          %% ================================== Start of Subsequent Iterations ======================================
          % EHSAN: edited
          current_KB = analytical_sample; 
          current_weight = weight;
          
          % EHSAN: inversing the X values while SHUFFLING IS BEING APPLIED **********************
          permutation = randperm (size (operational_data_2_cleaned, 1));
          operational_data_2_cleaned_inverted = operational_data_2_cleaned(permutation, :);
          operational_data_2_cleaned_inverted(:, 2) = 1 ./ operational_data_2_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_3_cleaned, 1));
          operational_data_3_cleaned_inverted = operational_data_3_cleaned(permutation, :);
          operational_data_3_cleaned_inverted(:, 2) = 1 ./ operational_data_3_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_4_1_cleaned, 1));
          operational_data_4_1_cleaned_inverted = operational_data_4_1_cleaned(permutation, :);
          operational_data_4_1_cleaned_inverted(:, 2) = 1 ./ operational_data_4_1_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_4_2_cleaned, 1));
          operational_data_4_2_cleaned_inverted = operational_data_4_2_cleaned(permutation, :);
          operational_data_4_2_cleaned_inverted(:, 2) = 1 ./ operational_data_4_2_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_5_cleaned, 1));
          operational_data_5_cleaned_inverted = operational_data_5_cleaned(permutation, :);
          operational_data_5_cleaned_inverted(:, 2) = 1 ./ operational_data_5_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_6_1_cleaned, 1));
          operational_data_6_1_cleaned_inverted = operational_data_6_1_cleaned(permutation, :);
          operational_data_6_1_cleaned_inverted(:, 2) = 1 ./ operational_data_6_1_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_6_2_cleaned, 1));
          operational_data_6_2_cleaned_inverted = operational_data_6_2_cleaned(permutation, :);
          operational_data_6_2_cleaned_inverted(:, 2) = 1 ./ operational_data_6_2_cleaned_inverted(:, 2);

          permutation = randperm (size (operational_data_8_1_cleaned, 1));
          operational_data_8_1_cleaned_inverted = operational_data_8_1_cleaned(permutation, :);
          operational_data_8_1_cleaned_inverted(:, 2) = 1 ./ operational_data_8_1_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_8_2_cleaned, 1));
          operational_data_8_2_cleaned_inverted = operational_data_8_2_cleaned(permutation, :);
          operational_data_8_2_cleaned_inverted(:, 2) = 1 ./ operational_data_8_2_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_9_cleaned, 1));
          operational_data_9_cleaned_inverted = operational_data_9_cleaned(permutation, :);
          operational_data_9_cleaned_inverted(:, 2) = 1 ./ operational_data_9_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_10_cleaned, 1));
          operational_data_10_cleaned_inverted = operational_data_10_cleaned(permutation, :);
          operational_data_10_cleaned_inverted(:, 2) = 1 ./ operational_data_10_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_12_1_cleaned, 1));
          operational_data_12_1_cleaned_inverted = operational_data_12_1_cleaned(permutation, :);
          operational_data_12_1_cleaned_inverted(:, 2) = 1 ./ operational_data_12_1_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_12_2_cleaned, 1));
          operational_data_12_2_cleaned_inverted = operational_data_12_2_cleaned(permutation, :);
          operational_data_12_2_cleaned_inverted(:, 2) = 1 ./ operational_data_12_2_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_15_cleaned, 1));
          operational_data_15_cleaned_inverted = operational_data_15_cleaned(permutation, :);
          operational_data_15_cleaned_inverted(:, 2) = 1 ./ operational_data_15_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_16_cleaned, 1));
          operational_data_16_cleaned_inverted = operational_data_16_cleaned(permutation, :);
          operational_data_16_cleaned_inverted(:, 2) = 1 ./ operational_data_16_cleaned_inverted(:, 2);
          
          permutation = randperm (size (operational_data_20_cleaned, 1));
          operational_data_20_cleaned_inverted = operational_data_20_cleaned(permutation, :);
          operational_data_20_cleaned_inverted(:, 2) = 1 ./ operational_data_20_cleaned_inverted(:, 2);
          
          no_of_iterations = min([length(operational_data_2_cleaned_inverted) length(operational_data_3_cleaned_inverted) length(operational_data_4_1_cleaned_inverted) length(operational_data_4_2_cleaned_inverted) length(operational_data_5_cleaned_inverted) length(operational_data_6_1_cleaned_inverted) length(operational_data_6_2_cleaned_inverted) length(operational_data_8_1_cleaned_inverted) length(operational_data_8_2_cleaned_inverted) length(operational_data_9_cleaned_inverted) length(operational_data_10_cleaned_inverted) length(operational_data_12_1_cleaned_inverted) length(operational_data_12_2_cleaned_inverted) length(operational_data_15_cleaned_inverted) length(operational_data_16_cleaned_inverted) length(operational_data_20_cleaned_inverted) ]);
          loop = 0;
          count = 0;
          for ii = 1: no_of_iterations
            innerCount = 0;
            %if ( configuration_to_predict == 12 )
              current_chunk = [operational_data_2_cleaned_inverted(ii, :) ; operational_data_3_cleaned_inverted(ii, :) ; (operational_data_4_1_cleaned_inverted(ii, :) + operational_data_4_2_cleaned_inverted(ii, :))/2 ; operational_data_5_cleaned_inverted(ii, :) ; (operational_data_6_1_cleaned_inverted(ii, :) + operational_data_6_2_cleaned_inverted(ii, :))/2 ; (operational_data_8_1_cleaned_inverted(ii, :) + operational_data_8_2_cleaned_inverted(ii, :))/2 ; operational_data_9_cleaned_inverted(ii, :) ; operational_data_10_cleaned_inverted(ii, :) ;  ];
            %endif
           
            % =============================== second: ML Approach based on AM data =================================
            % ======================================================================================================            
            [current_KB, current_weight] = updateKB_merge_weighted(current_KB, current_chunk, current_weight, oper_weight_value); 
                
            theBestTrErrors = Inf;
            do
                permutation = randperm (size(current_KB, 1));
                current_KB_shuffled_NotScaled = current_KB(permutation, :);
                current_weight_shuffled = current_weight(permutation);

                %% =============== SCALING ================
                [current_KB_shuffled, mu, sigma] = zscore(current_KB_shuffled_NotScaled);
                mu_y = mu(1);
                mu_X = mu(2);
                sigma_y = sigma(1);
                sigma_X = sigma(2);
                
                full_configurations_scaled = ((1 ./ full_configurations) - mu_X) / sigma_X;

                y = current_KB_shuffled(:, 1);
                X = current_KB_shuffled(:, 2);
                [ytr, ytst, ycv] = split_sample (y, train_frac, test_frac);
                [Xtr, Xtst, Xcv] = split_sample (X, train_frac, test_frac);
                [Wtr, Wtst, Wcv] = split_sample (current_weight_shuffled, train_frac, test_frac);

                %% =========== retraining Linear kernel model =========
                [C, eps] = modelSelection_weighted (Wtr, ytr, Xtr, ycv, Xcv, conf_linear, C_range, E_range);
                options = [conf_linear, " -p ", num2str(eps), " -c ", num2str(C)];
                model = svmtrain (Wtr, ytr, Xtr, options);
                
               [predictions_linear{ii+1}, ~, ~] = svmpredict (full_scaled.', full_configurations_scaled.', model);
               
               availableErrors = computeRE_20_16_15_12(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
               missingErrors = computeVE_20_16_15_12(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
               
               %{
               plot(am_conf, am_results, '-ob');
               hold on;
               plot(full_configurations, avg_time_query_vector, '-^r');
               hold on;
               plot(full_configurations, predictions_linear{ii+1}*sigma_y+mu_y, '-*g');
               hold off;
               %}
               [cvPred, ~, ~] = svmpredict (ycv, Xcv, model);
               cvIterationErrors = 0;
               for jj = 1: length(Xcv)
                  cvIterationErrors += 100*abs((cvPred(jj)*sigma_y+mu_y) - (ycv(jj)*sigma_y+mu_y))/(ycv(jj)*sigma_y+mu_y);
               endfor
               cvErrors = cvIterationErrors/length(Xcv);

               [trPred, ~, ~] = svmpredict (ytr, Xtr, model);
               trIterationErrors = 0;
               for jj = 1: length(Xtr)
                  trIterationErrors += 100*abs((trPred(jj)*sigma_y+mu_y) - (ytr(jj)*sigma_y+mu_y))/(ytr(jj)*sigma_y+mu_y);
               endfor
               trErrors = trIterationErrors/length(Xtr);
               
               [tstPred, ~, ~] = svmpredict (ytst, Xtst, model);
               tstIterationErrors = 0;
               for jj = 1: length(Xtst)
                  tstIterationErrors += 100*abs((tstPred(jj)*sigma_y+mu_y) - (ytst(jj)*sigma_y+mu_y))/(ytst(jj)*sigma_y+mu_y);
               endfor
               tstErrors = tstIterationErrors/length(Xtst);

               
               if (trErrors < theBestTrErrors) 
                  theBestModel = model;
                  theBestCvErrors = cvErrors;
                  theBestTrErrors = trErrors;
                  theBestTstErrors = tstErrors;
                  theBestAvailableErrors = availableErrors
                  theBestMissingErrors = missingErrors
               endif
               
               innerCount += 1;
               if (innerCount > 10)
                  cvErrors = theBestCvErrors;
                  trErrors = theBestTrErrors;
                  tstErrors = theBestTstErrors;
                  availableErrors = theBestAvailableErrors;
                  missingErrors = theBestMissingErrors;
                  loop = 1;
                  break;
               endif
   
            until (trErrors < itrThr && tstErrors < itrThr) 
            count += innerCount;
            
            if (trErrors < stopThr && tstErrors < stopThr)  
              stop = 1;
              break;
            else
              stop = 0;
            endif
          endfor
          
          out(4) = missingErrors;
          out(5) = ii;
          out(6) = count;
          out(7) = trErrors;
          out(8) = cvErrors;
          out(9) = tstErrors;
          out(10) = loop;
          dlmwrite(outPath, out, "-append");
    endfor
  endfor    
endfor