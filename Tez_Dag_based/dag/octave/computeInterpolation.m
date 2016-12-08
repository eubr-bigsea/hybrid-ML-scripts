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


ml_firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/MLInterpolate/"];
b_firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/BaseInterpolate/"];
firstPath = ["../plots/", query, "/", ssize, "/linear/missing_", num2str(conf(configuration_to_predict)), "/HyInterpolate/"];

  itrThr = 34;
  stopThr = 23;
  avg(1) = itrThr;
  avg(2) = stopThr;
  
  ml_itrThr = 26;
  ml_stopThr = 15;
  avg(6) = ml_itrThr;
  avg(7) = ml_stopThr;
  
    diff = 0;
    for i = 2 : 4
      a = 2*i;   
      b = "_points";
      c = [num2str(a) b];
      ml_outPath = [ml_firstPath, c, "/ml_out_", num2str(ml_itrThr), "_", num2str(ml_stopThr), ".csv"];
      b_outPath = [b_firstPath, c, "/base_out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
      outPath = [firstPath, c, "/out_", num2str(itrThr), "_", num2str(stopThr), ".csv"];
      
      ml_outData = read_data([ml_outPath]);
      b_outData = read_data([b_outPath]);
      outData = read_data([outPath]);
      
      ml_avgOutData = mean(ml_outData);
      b_avgOutData = mean(b_outData);
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

      b_err(i-1) = avg(11);
      ml_err(i-1) = avg(8);
      hy_err(i-1) = avg(3);
      
      b_itr(i-1) = avg(12);
      ml_itr(i-1) = avg(9);
      hy_itr(i-1) = avg(4);
      
      b_act(i-1) = avg(10);
      ml_act(i-1) = avg(10);
      hy_act(i-1) = avg(5);
      
      cost = costFuncIntr(2*i, conf, avg_time_query_vector);
      hy_cost(i-1) = ceil(hy_itr(i-1))*cost;
      ml_cost(i-1) = ceil(ml_itr(i-1))*cost;
      b_cost(i-1) = ceil(b_itr(i-1))*cost;
      
      output = [firstPath, "/interpolate_", num2str(a), ".csv"];
      dlmwrite(output, avg);
    endfor

    
    hold on;
    x = [8 6 4];
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
    

    xlabel("Number of Missing Points");
    ylabel(ax1(1), "MAPE on Missing Points");
    ylabel(ax1(2), "Number of Iterations");
    %title("Formula-based AM; Right Extrapolation; (hyItrThr, hyStopThr, mlItrThr, mlStopThr) = (34, 23, 30, 19)");
    %txt = ["avg rel. error of formula with regard to expected values: ", num2str(diff/5) ];
    %text(12, 38, txt);
    text(4.7, 12.3, "IML error");
    text(4.7, 17, "BML error");
    text(4.7, 9.8, "Hybrid error");

    text(5.3, 21.5, "IML iterations");
    text(5.3, 8, "Hybrid & BML iterations");

    opt = ["-djpg"];
    filepath  = [firstPath "/interpolation.jpg"];
    print(filepath, opt);
    opt = ["-depsc"];
    filepath  = [firstPath "/interpolation.eps"];
    print(filepath, opt);
    
        
    hold off;
    plot(x, hy_cost, 'r', x, ml_cost, 'b'); %, x, b_cost, 'g');
    set(gca, 'XTick', x);
    xlabel("Number of Missing Points");
    ylabel("Cost");
    legend("Hybrid & BML", "IML");
    opt = ["-djpg"];
    filepath  = [firstPath "/cost_interpolate.jpg"];
    print(filepath, opt);
    opt = ["-depsc"];
    filepath  = [firstPath "/cost_interpolate.eps"];
    print(filepath, opt);
    
      
    
    Q4 = 100 * ( abs(am_results(2) - avg_time_query_vector(2)) / avg_time_query_vector(2) +
            abs(am_results(3) - avg_time_query_vector(3)) / avg_time_query_vector(3) +
            abs(am_results(5) - avg_time_query_vector(5)) / avg_time_query_vector(5) +
            abs(am_results(6) - avg_time_query_vector(6)) / avg_time_query_vector(6) +
            abs(am_results(7) - avg_time_query_vector(7)) / avg_time_query_vector(7) +
            abs(am_results(9) - avg_time_query_vector(9)) / avg_time_query_vector(9) +
            abs(am_results(10) - avg_time_query_vector(10)) / avg_time_query_vector(10) +
            abs(am_results(11) - avg_time_query_vector(11)) / avg_time_query_vector(11) );
    
    Q6 = 100 * ( abs(am_results(3) - avg_time_query_vector(3)) / avg_time_query_vector(3) +
            abs(am_results(4) - avg_time_query_vector(4)) / avg_time_query_vector(4) +
            abs(am_results(5) - avg_time_query_vector(5)) / avg_time_query_vector(5) +
            abs(am_results(8) - avg_time_query_vector(8)) / avg_time_query_vector(8) +
            abs(am_results(9) - avg_time_query_vector(9)) / avg_time_query_vector(9) +
            abs(am_results(10) - avg_time_query_vector(10)) / avg_time_query_vector(10) );
            
    Q8 = 100 * ( abs(am_results(3) - avg_time_query_vector(3)) / avg_time_query_vector(3) +
            abs(am_results(6) - avg_time_query_vector(6)) / avg_time_query_vector(6) +
            abs(am_results(7) - avg_time_query_vector(7)) / avg_time_query_vector(7) +
            abs(am_results(10) - avg_time_query_vector(10)) / avg_time_query_vector(10) );
    
    printf("\n Q4 = %f\n", Q4/8);        
    printf("\n Q6 = %f\n", Q6/6); 
    printf("\n Q8 = %f\n", Q8/4); 
   
