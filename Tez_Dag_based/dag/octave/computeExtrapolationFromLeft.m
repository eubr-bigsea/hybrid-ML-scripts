% This piece of code computes extrapolation capability of Hybrid and pure ML from left side
% starting from 20 as the sole missing point and go right-ward until it suppose to miss all
% the points in the rang of (20..72).

% the mean relative error, the number of iterations, and the actual number of loops are 
% plotted for each of the two approach

% sim_results and avg_time_query_vector can also be plotted easily because the required code exists.

clear all
close all hidden
clc
warning("off")

query = "Q1";
ssize = "30";

conf = [2 3 4 5 6 8 9 10 12 15 16 20];
configuration_to_predict = 12;
base_dir = "../source_data/";

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

b_firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/BaseExtrapolate/"];
ml_firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/MLExtrapolate/"];
firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/HyExtrapolate/"];

  itrThr = 34;
  stopThr = 23;
  avg(1) = itrThr;
  avg(2) = stopThr;
  
  ml_itrThr = 26;
  ml_stopThr = 15;
  avg(6) = ml_itrThr;
  avg(7) = ml_stopThr;

  diff = 0;
  %hy_point = 0;
  %ml_point = 0;
  for i = 1 : 5
      b_midPath = [base_dir b_firstPath num2str(conf(i))];
      ml_midPath = [base_dir ml_firstPath num2str(conf(i))];
      midPath = [base_dir firstPath num2str(conf(i))];

      b_outPath = [b_midPath, "/base_out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
      ml_outPath = [ml_midPath, "/ml_out_", num2str(ml_itrThr), "_", num2str(ml_stopThr), ".csv"];
      outPath = [midPath, "/out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
      
      b_outData = read_data([b_outPath]);
      ml_outData = read_data([ml_outPath]);
      outData = read_data([outPath]);
      
      b_avgOutData = mean(b_outData);
      ml_avgOutData = mean(ml_outData);
      avgOutData = mean(outData);
      
      avg(11) = b_avgOutData(4);
      avg(8) = ml_avgOutData(4);
      avg(3) = avgOutData(4);
      
      avg(12) = b_avgOutData(5);
      avg(13) = b_avgOutData(6);
      avg(9) = ml_avgOutData(5);
      avg(10) = ml_avgOutData(6);
      avg(4) = avgOutData(5);
      avg(5) = avgOutData(6);

      b_err(i) = avg(11);
      ml_err(i) = avg(8);
      hy_err(i) = avg(3);
      
      b_itr(i) = avg(12);
      ml_itr(i) = avg(9);
      hy_itr(i) = avg(4);
      
      b_act(i) = avg(10);
      ml_act(i) = avg(10);
      hy_act(i) = avg(5);
      diff += 100*abs(am_results(i) - avg_time_query_vector(i))/avg_time_query_vector(i) ;
      
      output = [midPath, "/extrapolate_left_", num2str(conf(i)), ".csv"];
      dlmwrite(output, avg);
      
      hy_point(i) = 100 / (hy_err(i)*hy_itr(i));
      ml_point(i) = 100 / (ml_err(i)*ml_itr(i));
      b_point(i) = 100 / (b_err(i)*b_itr(i));
      
      cost = costFuncLeft(i, conf, avg_time_query_vector);
      hy_cost(i) = ceil(hy_itr(i))*cost;
      ml_cost(i) = ceil(ml_itr(i))*cost;
      b_cost(i) = ceil(b_itr(i))*cost;

    endfor
    
    hold on;
    x = [2 3 4 5 6];
    set(gca, 'XTick', x);
    [ax1,h11,h12] = plotyy(x, ml_err, x, ml_itr);
    set(ax1, 'XTick', x);
    
    [ax2,h21,h22] = plotyy(x, hy_err, x, hy_itr);
    set(ax2, 'XTick', x);

    [ax3,h31,h32] = plotyy(x, b_err, x, b_itr);
    set(ax3, 'XTick', x);

    
    set(h11,"linestyle","-");
    set(h21,"linestyle","-");
    set(h31,"linestyle","-");
    
    set(h12,"linestyle","-.");
    %set(h12,"color","red");
    set(h22,"linestyle","-.");
    %set(h22,"color","red");
    set(h32,"linestyle","-.");
    

    xlabel("Missing Points Starting From (Number of Cores)");
    ylabel(ax1(1), "MAPE on Missing Points");
    ylabel(ax1(2), "Number of Iterations");
    %title("Formula-based AM; Right Extrapolation; (hyItrThr, hyStopThr, mlItrThr, mlStopThr) = (34, 23, 30, 19)");
    txt = ["avg rel. error of formula with regard to expected values: ", num2str(diff/5) ];
    %text(3, 47, txt);
    text(2.18, 43, "IML error");
    text(2.05, 35, "BML\nerror");
    text(5, 16.8, "Hybrid error");

    text(5.1, 34.8, "IML iterations");
    text(2.1, 18, "Hybrid & BML iterations");

    %orient("portrait");
    opt = ["-djpg"];
    filepath  = [firstPath "/extrapolate_left.jpg"];
    print(filepath, opt);
   opt = ["-depsc"];
    filepath  = [firstPath "/extrapolate_left.eps"];
    print(filepath, opt);
    
    
    hold off;
    plot(x, hy_cost, 'r'); %, x, ml_cost, 'b');
    set(gca, 'XTick', x);
    xlabel("Missing Points Starting From (Number of Cores)");
    ylabel("Cost");
    legend("Hybrid & BML & IML");
    opt = ["-djpg"];
    filepath  = [firstPath "/cost_left.jpg"];
    print(filepath, opt);
    opt = ["-depsc"];
    filepath  = [firstPath "/cost_left.eps"];
    print(filepath, opt);

%{    
    hold off;
    plot(x, hy_point, 'r', x, ml_point, 'b', x, b_point, 'g');
    set(gca, 'XTick', x);
    xlabel("Missing Points Starting From (Number of Cores)");
    ylabel("EffCo");
    legend("Hybrid", "Pure ML", "Basic ML");
    filepath  = [firstPath "/effCo_left.jpg"];
    print(filepath, opt);
    %}