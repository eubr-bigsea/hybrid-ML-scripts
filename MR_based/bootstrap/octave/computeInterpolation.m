% This piece of code estimates response time for multi-user scenario 
% according to the formula used in computeAvgResTime.m function and 
% based on R queries.

% right now, the response time is only estimated for R1@250.

% inputs of this piece of code are '.csv' files in 'full' directory which are actually 
% the RUN tables gained from real experiments.

% output of this piece of code is 'estimatedResTimes.csv' file which contains the estimated response times for 
% different nCores, one per row.
clear all
close all hidden
clc
warning("off")

query = "R1";
ssize = "250";

conf = [20 40 48 60 72 80 90 100 108 120];
configuration_to_predict = 10;
base_dir = "../source_data/";

query_analytical_data = ["full/" query "/" ssize "/estimatedResTimes.csv"];
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

avg_time_query_vector = [(mean(operational_data_20_cleaned))(1) (mean(operational_data_40_cleaned))(1) (mean(operational_data_48_cleaned))(1) (mean(operational_data_60_cleaned))(1) (mean(operational_data_72_cleaned))(1) (mean(operational_data_80_cleaned))(1) (mean(operational_data_90_cleaned))(1) (mean(operational_data_100_cleaned))(1) (mean(operational_data_108_cleaned))(1) (mean(operational_data_120_cleaned))(1)];

ml_firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/MLInterpolate/"];
firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/HyInterpolate/"];

  itrThr = 34;
  stopThr = 23;
  avg(1) = itrThr;
  avg(2) = stopThr;
  
  ml_itrThr = 30;
  ml_stopThr = 19;
  avg(6) = ml_itrThr;
  avg(7) = ml_stopThr;
  
    diff = 0;
    for i = 2 : 4
      a = 2*i - 1;   
      b = "_points";
      c = [num2str(a) b];
      ml_outPath = [ml_firstPath, c, "/ml_out_", num2str(ml_itrThr), "_", num2str(ml_stopThr), ".csv"];
      outPath = [firstPath, c, "/out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
      
      ml_outData = read_data([ml_outPath]);
      outData = read_data([outPath]);
      
      ml_avgOutData = mean(ml_outData);
      avgOutData = mean(outData);
      
      avg(8) = ml_avgOutData(4);
      avg(3) = avgOutData(4);
      
      avg(9) = ml_avgOutData(5);
      avg(10) = ml_avgOutData(6);
      avg(4) = avgOutData(5);
      avg(5) = avgOutData(6);

      ml_err(i-1) = avg(3);
      hy_err(i-1) = avg(8);
      
      ml_itr(i-1) = avg(9);
      hy_itr(i-1) = avg(4);
      
      ml_act(i-1) = avg(10);
      hy_act(i-1) = avg(5);
      
      output = [firstPath, "/interpolate_", num2str(a), ".csv"];
      dlmwrite(output, avg);
    endfor

    Q5 = 100 * ( abs(sim_results(2) - avg_time_query_vector(2)) / avg_time_query_vector(2) +
            abs(sim_results(4) - avg_time_query_vector(4)) / avg_time_query_vector(4) +
            abs(sim_results(6) - avg_time_query_vector(6)) / avg_time_query_vector(6) +
            abs(sim_results(7) - avg_time_query_vector(7)) / avg_time_query_vector(7) +
            abs(sim_results(9) - avg_time_query_vector(9)) / avg_time_query_vector(9) );
    Q3 = Q5 + 100 * ( abs(sim_results(3) - avg_time_query_vector(3)) / avg_time_query_vector(3) +
            abs(sim_results(8) - avg_time_query_vector(8)) / avg_time_query_vector(8) );
    
    Q7 = 100 * ( abs(sim_results(4) - avg_time_query_vector(4)) / avg_time_query_vector(4) +
            abs(sim_results(7) - avg_time_query_vector(7)) / avg_time_query_vector(7) +
            abs(sim_results(9) - avg_time_query_vector(9)) / avg_time_query_vector(9) );
            
    printf("\n Q7 = %f\n", Q7/3); 
    printf("\n Q5 = %f\n", Q5/5); 
    printf("\n Q3 = %f\n", Q3/7); 
