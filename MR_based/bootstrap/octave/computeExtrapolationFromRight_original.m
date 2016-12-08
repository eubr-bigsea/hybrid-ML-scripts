% This piece of code computes extrapolation capability of Hybrid and pure ML from right side
% starting from 120 as the sole missing point and go left-ward until it suppose to miss all
% the points in the rang of (80..120).

% the mean relative error, the number of iterations, and the actual number of loops are 
% plotted for each of the two approach

% sim_results and avg_time_query_vector can also be plotted easily because the required code exists.

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


ml_firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/MLExtrapolate/"];
firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/HyExtrapolate/"];

  itrThr = 34;
  stopThr = 23;
  avg(1) = itrThr;
  avg(2) = stopThr;
  
  ml_itrThr = 30;
  ml_stopThr = 19;
  avg(6) = ml_itrThr;
  avg(7) = ml_stopThr;

  diff = 0;
  for i = 0 : 4
      ml_midPath = [base_dir ml_firstPath num2str(conf(10-i))];
      midPath = [base_dir firstPath num2str(conf(10-i))];

      ml_outPath = [ml_midPath, "/ml_out_", num2str(ml_itrThr), "_", num2str(ml_stopThr), ".csv"];
      outPath = [midPath, "/out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
      
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

      ml_err(i+1) = avg(3);
      hy_err(i+1) = avg(8);
      
      ml_itr(i+1) = avg(9);
      hy_itr(i+1) = avg(4);
      
      ml_act(i+1) = avg(10);
      hy_act(i+1) = avg(5);
      diff += 100*abs(sim_results(10-i) - avg_time_query_vector(10-i))/avg_time_query_vector(10-i) ;
      
      output = [midPath, "/extrapolate_right_", num2str(conf(10-i)), ".csv"];
      dlmwrite(output, avg);
    endfor
    
    hold on;
    x = [120 108 100 90 80];
%    h1 = plotyy(x, ml, x, fliplr(sim_results(6:10)));
%    h2 = plotyy(x, hy, x, fliplr(avg_time_query_vector(6:10)));

    h1 = plotyy(x, ml_err, x, ml_itr);
    h2 = plotyy(x, hy_err, x, hy_itr);
    [ax3,h31,h32] = plotyy(x, ml_err, x, ml_act);
    [ax4,h41,h42] = plotyy(x, hy_err, x, hy_act);

    set(h32,'color','red');
    set(h42,'color','red');
    

    xlabel("Missing Data Starts From / nCores");
    ylabel(h1(1), "Mean Relative Error on Missing Points");
    ylabel(h1(2), "No. of Iterations / Loops");
    title("Formula-based AM; Right Extrapolation; (hyItrThr, hyStopThr, mlItrThr, mlStopThr) = (34, 23, 30, 19)");
    txt = ["avg rel. error of formula with regard to expected values: ", num2str(diff/5) ];
    text(90, 39, txt);
    text(100, 16, "ML error");
    text(86, 19, "Hybrid error");

    text(97, 23, "ML itrs");
    text(90, 14, "Hybrid itrs");

    text(92, 34, "ML loops");
    text(82, 16, "Hybrid loops");

    
%    text(90, 8, "expected values");
%    text(90, 30, "simulation results");

    opt = ["-djpg"];
    filepath  = [firstPath "/extrapolate_right.jpg"];
    print(filepath, opt);
