
clear all
close all hidden
clc
warning("off")

query = "R1";
ssize = "250";

conf = [20 40 48 60 72 80 90 100 108 120];
base_dir = "../source_data/";

query_analytical_data = ["analyt/" query "/" ssize "/dataAM_4step.csv"];
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
sim_results = analytical_data(5:end, 1);
sim_results = sim_results(:)';
sim_conf = analytical_data(5:end, 2);
sim_conf = sim_conf(:)';

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

    
    hold on;
    plot(conf, avg_time_query_vector, 'ob') 
    hold on;
    plot(sim_conf, sim_results, '-*r'); 

    
    %{

    h1 = plotyy(x, ml_err, x, ml_itr);
    h2 = plotyy(x, hy_err, x, hy_itr);
    [ax3,h31,h32] = plotyy(x, ml_err, x, ml_act);
    [ax4,h41,h42] = plotyy(x, hy_err, x, hy_act);

    set(h32,'color','red');
    set(h42,'color','red');
    

    xlabel("Missing Data Starts From / nCores");
    ylabel(h1(1), "Mean Relative Error on Missing Points");
    ylabel(h1(2), "No. of Iterations / Loops");
    title("Formula-based AM; Right Extrapolation; (hyItrThr, hyStopThr, mlItrThr, mlStopThr) = (35, 20, 30, 19)");
    txt = ["avg rel. error of formula with regard to expected values: ", num2str(diff/5) ];
    text(90, 39, txt);
    text(100, 16, "ML error");
    text(100, 12, "Hybrid error");

    text(97, 23, "ML itrs");
    text(96, 18, "Hybrid itrs");

    text(92, 34, "ML loops");
    text(92, 21, "Hybrid loops");
%}
  
    firstPath = ["../plots/", query, "/", ssize, "/linear/missing_120/"];

    opt = ["-djpg"];
    filepath  = [firstPath "/dataAM_4step.jpg"];
    print(filepath, opt);
