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
  for i = 0 : 4
      b_midPath = [base_dir b_firstPath num2str(conf(12-i))];
      ml_midPath = [base_dir ml_firstPath num2str(conf(12-i))];
      midPath = [base_dir firstPath num2str(conf(12-i))];

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

      b_err(i+1) = avg(11);
      ml_err(i+1) = avg(8);
      hy_err(i+1) = avg(3);
      
      b_itr(i+1) = avg(12);
      ml_itr(i+1) = avg(9);
      hy_itr(i+1) = avg(4);
      
      b_act(i+1) = avg(10);
      ml_act(i+1) = avg(10);
      hy_act(i+1) = avg(5);
      diff += 100*abs(am_results(12-i) - avg_time_query_vector(12-i))/avg_time_query_vector(12-i) ;
      
      output = [midPath, "/extrapolate_right_", num2str(conf(12-i)), ".csv"];
      dlmwrite(output, avg);
      
      hy_point(i+1) = 100 / (hy_err(i+1)*hy_itr(i+1));
      ml_point(i+1) = 100 / (ml_err(i+1)*ml_itr(i+1));
      b_point(i+1) = 100 / (b_err(i+1)*b_itr(i+1));
      
      cost = costFuncRight(i+1, conf, avg_time_query_vector);
      hy_cost(i+1) = ceil(hy_itr(i+1))*cost;
      ml_cost(i+1) = ceil(ml_itr(i+1))*cost;
      b_cost(i+1) = ceil(b_itr(i+1))*cost;

    endfor
    
    hold on;
    x = [20 16 15 12 10];
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
    %text(12, 38, txt);
    text(12, 29, "IML error");
    text(12, 40, "BML error");
    text(12, 15, "Hybrid error");

    text(15, 56, "IML iterations");
    text(12.3, 21.7, "Hybrid & BML iterations");

    opt = ["-djpg"];
    filepath  = [firstPath "/extrapolate_right.jpg"];
    print(filepath, opt);
    opt = ["-depsc"];
    filepath  = [firstPath "/extrapolate_right.eps"];
    print(filepath, opt);
    
        
    hold off;
    plot(x, hy_cost, 'r', x, ml_cost, 'b');
    set(gca, 'XTick', x);
    xlabel("Missing Points Starting From (Number of Cores)");
    ylabel("Cost");
    legend("Hybrid & BML", "IML");
    opt = ["-djpg"];
    filepath  = [firstPath "/cost_right.jpg"];
    print(filepath, opt);
    opt = ["-depsc"];
    filepath  = [firstPath "/cost_right.eps"];
    print(filepath, opt);
    
    
    
%{    
    hold off;
    plot(x, hy_point, 'r', x, ml_point, 'b', x, b_point, 'g');
    set(gca, 'XTick', x);
    xlabel("Missing Points Starting From (Number of Cores)");
    ylabel("EffCo");
    legend("Hybrid", "Pure ML", "Basic ML");
    filepath  = [firstPath "/effCo_right.jpg"];
    print(filepath, opt);
    %}
