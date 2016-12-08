clear all
close all hidden
clc
warning("off")

%% Input data parameters: path to folder containing 
%% the analytical data and to folder containing 
%% the operational data.
query = "R1";
ssize = "250";
configuration_to_predict = 10;

preTextPosition = 70000;
pveTextPosition = 2*preTextPosition/3;
%errorCoef = 40;

%for R1:
opr_configurations = [20 40 48 60 72 80 90 100 108 120];
sim_configurations = [20 40 48 60 72 80 90 100 108 120];

full_configurations = [20 40 48 60 72 80 90 100 108 120];
full_scaled = [1 1 1 1 1 1 1 1 1 1];
%----------------------------------------------------------------------------------------------

conf_linear = "-s 3 -t 0 -q -h 0 ";

query_analytical_data = ["analyt/" query "/" ssize "/dataAM.csv"];
query_operational_data_20 = ["oper/" query "/" ssize "/dataOper_20.csv"];
query_operational_data_40 = ["oper/" query "/" ssize "/dataOper_40.csv"];
query_operational_data_48 = ["oper/" query "/" ssize "/dataOper_48.csv"];
query_operational_data_60 = ["oper/" query "/" ssize "/dataOper_60.csv"];
query_operational_data_72 = ["oper/" query "/" ssize "/dataOper_72.csv"];
query_operational_data_80 = ["oper/" query "/" ssize "/dataOper_80.csv"];
query_operational_data_90 = ["oper/" query "/" ssize "/dataOper_90.csv"];
query_operational_data_100 = ["oper/" query "/" ssize "/dataOper_100.csv"];
query_operational_data_108 = ["oper/" query "/" ssize "/dataOper_108.csv"];
query_operational_data_120 = ["oper/" query "/" ssize "/dataOper_120.csv"];

base_dir = "../source_data/";

analytical_data = read_data([base_dir query_analytical_data]);
sim_results = analytical_data(:, 1);
sim_results = sim_results(:)';

operational_data_20 = read_data([base_dir query_operational_data_20]);
operational_data_40 = read_data([base_dir query_operational_data_40]);
operational_data_48 = read_data([base_dir query_operational_data_48]);
operational_data_60 = read_data([base_dir query_operational_data_60]);
operational_data_72 = read_data([base_dir query_operational_data_72]);
operational_data_80 = read_data([base_dir query_operational_data_80]);
operational_data_90 = read_data([base_dir query_operational_data_90]);
operational_data_100 = read_data([base_dir query_operational_data_100]);
operational_data_108 = read_data([base_dir query_operational_data_108]);
operational_data_120 = read_data([base_dir query_operational_data_120]);

[operational_data_20_cleaned, ~] = clear_outliers (operational_data_20);
[operational_data_40_cleaned, ~] = clear_outliers (operational_data_40);
[operational_data_48_cleaned, ~] = clear_outliers (operational_data_48);
[operational_data_60_cleaned, ~] = clear_outliers (operational_data_60);
[operational_data_72_cleaned, ~] = clear_outliers (operational_data_72);
[operational_data_80_cleaned, ~] = clear_outliers (operational_data_80);
[operational_data_90_cleaned, ~] = clear_outliers (operational_data_90);
[operational_data_100_cleaned, ~] = clear_outliers (operational_data_100);
[operational_data_108_cleaned, ~] = clear_outliers (operational_data_108);
[operational_data_120_cleaned, ~] = clear_outliers (operational_data_120);

% EHSAN: recomputing avg_time_query_vector at runtime to be sure of the old values
avg_time_query_vector = [(mean(operational_data_20_cleaned))(1) (mean(operational_data_40_cleaned))(1) (mean(operational_data_48_cleaned))(1) (mean(operational_data_60_cleaned))(1) (mean(operational_data_72_cleaned))(1) (mean(operational_data_80_cleaned))(1) (mean(operational_data_90_cleaned))(1) (mean(operational_data_100_cleaned))(1) (mean(operational_data_108_cleaned))(1) (mean(operational_data_120_cleaned))(1)];

%% Splitting parameters
train_frac = 0.6;
test_frac = 0.2

oper_weight_value = 10;
analyt_weight_value = 1;

%% Ranges to be used to the identification
%% of the optimal "C" and "epsilon" parameter of the SVR
%% when using epsilon-SVR ( the SVR type used by Eugenio.
%% we could investigate if it makes sense to try nu-SVR too ).
C_range = linspace (0.1, 5, 20);
E_range = linspace (0.1, 5, 20);

outPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(opr_configurations(configuration_to_predict)), "/out.csv"];

for itrThr = 39 : 39
  out(1) = itrThr;
  for stopThr = 25 : 25
    out(2) = stopThr; 
    for seed = 1 : 10
          out(3) = seed;
          rand ("seed", "reset");
          rand ("seed", seed);
          
          %% Initializing the Knowledge Base sampling the analytical data
          analytical_sample = initKB (analytical_data);
          weight=ones(size(analytical_sample,1),1) * analyt_weight_value;
          permutation = randperm (size (analytical_sample, 1));
          analytical_shuffled_NotScaled = analytical_sample(permutation, :);
          weight_shuffled = weight(permutation);

          %% Added by EHSAN
          %% =============== SCALING ================
          [analytical_shuffled, mu, sigma] = zscore(analytical_shuffled_NotScaled);
          mu_y = mu(1);
          mu_X = mu(2);
          sigma_y = sigma(1);
          sigma_X = sigma(2);

          avg_time_query_vector_scaled = (avg_time_query_vector - mu_y) / sigma_y;
          opr_configurations_scaled = ((1 ./ opr_configurations) - mu_X) / sigma_X;
          full_configurations_scaled = ((1 ./ full_configurations) - mu_X) / sigma_X;

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
          [C, eps] = modelSelection (Wtr, ytr, Xtr, ycv, Xcv, conf_linear, C_range, E_range);
          options = [conf_linear, " -p ", num2str(eps), " -c ", num2str(C)];
          model_linear = svmtrain (ytr, Xtr, options);
          %% ================================== End of First Iteration ======================================

          %% ================================== Start of Subsequent Iterations ======================================
          % EHSAN: edited
          current_KB = analytical_sample; 
          current_weight = weight

          % EHSAN: inversing the X values
          operational_data_20_cleaned_inverted = operational_data_20_cleaned;
          operational_data_20_cleaned_inverted(:, 2) = 1 ./ operational_data_20_cleaned_inverted(:, 2);
          
          operational_data_40_cleaned_inverted = operational_data_40_cleaned;
          operational_data_40_cleaned_inverted(:, 2) = 1 ./ operational_data_40_cleaned_inverted(:, 2);
          
          operational_data_48_cleaned_inverted = operational_data_48_cleaned;
          operational_data_48_cleaned_inverted(:, 2) = 1 ./ operational_data_48_cleaned_inverted(:, 2);
          
          operational_data_60_cleaned_inverted = operational_data_60_cleaned;
          operational_data_60_cleaned_inverted(:, 2) = 1 ./ operational_data_60_cleaned_inverted(:, 2);
          
          operational_data_72_cleaned_inverted = operational_data_72_cleaned;
          operational_data_72_cleaned_inverted(:, 2) = 1 ./ operational_data_72_cleaned_inverted(:, 2);
          
          operational_data_80_cleaned_inverted = operational_data_80_cleaned;
          operational_data_80_cleaned_inverted(:, 2) = 1 ./ operational_data_80_cleaned_inverted(:, 2);
          
          operational_data_90_cleaned_inverted = operational_data_90_cleaned;
          operational_data_90_cleaned_inverted(:, 2) = 1 ./ operational_data_90_cleaned_inverted(:, 2);
          
          operational_data_100_cleaned_inverted = operational_data_100_cleaned;
          operational_data_100_cleaned_inverted(:, 2) = 1 ./ operational_data_100_cleaned_inverted(:, 2);
          
          operational_data_108_cleaned_inverted = operational_data_108_cleaned;
          operational_data_108_cleaned_inverted(:, 2) = 1 ./ operational_data_108_cleaned_inverted(:, 2);
          
          operational_data_120_cleaned_inverted = operational_data_120_cleaned;
          operational_data_120_cleaned_inverted(:, 2) = 1 ./ operational_data_120_cleaned_inverted(:, 2);
          
          % EHSAN: shuffling is not applied to the operational samples
          no_of_iterations = min([length(operational_data_20_cleaned_inverted) length(operational_data_40_cleaned_inverted) length(operational_data_48_cleaned_inverted) length(operational_data_60_cleaned_inverted) length(operational_data_72_cleaned_inverted) length(operational_data_80_cleaned_inverted) length(operational_data_90_cleaned_inverted) length(operational_data_100_cleaned_inverted) length(operational_data_108_cleaned_inverted) length(operational_data_120_cleaned_inverted)]);
          count = 0;
          loop = 0;
          for ii = 1: no_of_iterations
            innerCount = 0;
            if ( configuration_to_predict == 10 )
              current_chunk = [operational_data_20_cleaned_inverted(ii, :) ; operational_data_40_cleaned_inverted(ii, :) ; operational_data_48_cleaned_inverted(ii, :) ; operational_data_60_cleaned_inverted(ii, :) ; operational_data_72_cleaned_inverted(ii, :) ; operational_data_80_cleaned_inverted(ii, :) ; operational_data_90_cleaned_inverted(ii, :) ; operational_data_100_cleaned_inverted(ii, :) ; operational_data_108_cleaned_inverted(ii, :) ;];
            endif

            [current_KB, current_weight] = updateKB_merge(current_KB, current_chunk, current_weight, oper_weight_value);
            
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

                avg_time_query_vector_scaled = (avg_time_query_vector - mu_y) / sigma_y;
                opr_configurations_scaled = ((1 ./ opr_configurations) - mu_X) / sigma_X;
                full_configurations_scaled = ((1 ./ full_configurations) - mu_X) / sigma_X;

                y = current_KB_shuffled(:, 1);
                X = current_KB_shuffled(:, 2);

                [ytr, ytst, ycv] = split_sample (y, train_frac, test_frac);
                [Xtr, Xtst, Xcv] = split_sample (X, train_frac, test_frac);
                [Wtr, Wtst, Wcv] = split_sample (current_weight_shuffled, train_frac, test_frac);

                %% =========== retraining Linear kernel model =========
                [C, eps] = modelSelection (Wtr, ytr, Xtr, ycv, Xcv, conf_linear, C_range, E_range);
                options = [conf_linear, " -p ", num2str(eps), " -c ", num2str(C)];
                model_linear = svmtrain (ytr, Xtr, options);
                
               [predictions_linear{ii+1}, ~, ~] = svmpredict (full_scaled.', full_configurations_scaled.', model_linear);
               availableErrors = computeRE(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
               missingErrors = computeVE(predictions_linear{ii+1}, sigma_y, mu_y, avg_time_query_vector, configuration_to_predict);
               
               [cvPred, ~, ~] = svmpredict (ycv, Xcv, model_linear);
               cvIterationErrors = 0;
               for jj = 1: length(Xcv)
                  cvIterationErrors += 100*abs((cvPred(jj)*sigma_y+mu_y) - (ycv(jj)*sigma_y+mu_y))/(ycv(jj)*sigma_y+mu_y);
               endfor
               cvErrors = cvIterationErrors/length(Xcv);

               [trPred, ~, ~] = svmpredict (ytr, Xtr, model_linear);
               trIterationErrors = 0;
               for jj = 1: length(Xtr)
                  trIterationErrors += 100*abs((trPred(jj)*sigma_y+mu_y) - (ytr(jj)*sigma_y+mu_y))/(ytr(jj)*sigma_y+mu_y);
               endfor
               trErrors = trIterationErrors/length(Xtr);
               
               [tstPred, ~, ~] = svmpredict (ytst, Xtst, model_linear);
               tstIterationErrors = 0;
               for jj = 1: length(Xtst)
                  tstIterationErrors += 100*abs((tstPred(jj)*sigma_y+mu_y) - (ytst(jj)*sigma_y+mu_y))/(ytst(jj)*sigma_y+mu_y);
               endfor
               tstErrors = tstIterationErrors/length(Xtst);

               innerCount += 1;
               if (innerCount > 10)
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