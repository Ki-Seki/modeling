% Dynamic CDS Calculator

clc;
clear;
close all;

%% Initialization

rng(0, 'v5uniform');  % Control random number generator
observing_duration = 125;  % Observing years
d = gen_norm_age_distrib(10, 100, 100000);  % Distribution of tree's age
d_without_logging = d;
original = d;  % Save the original distribution of tree's age

cds_hist = zeros(1, observing_duration);  % Annual total CDS
hwp_cds_hist = zeros(1, observing_duration);  % Annual HWP CDS
cds_without_logging_hist = zeros(1,...
    observing_duration);  % Annual total CDS under no-logging circumstance

%% Main loop

for T = 1 : observing_duration
    d = d + 1;  % All trees are aged by one year
    d_without_logging = d_without_logging + 1;
    
    [cut, uncut] = logging(d, T);
    planted = planting(d, T);
    [total_cds, hwp_cds] = cal_total_cds(uncut, cut, planted, sum(hwp_cds_hist));
    cds_without_logging = cal_total_cds(d_without_logging, [], [], 0);
    
    d = [uncut, planted];
    cds_hist(T) = total_cds;
    hwp_cds_hist(T) = hwp_cds;
    cds_without_logging_hist(T) = cds_without_logging;
end

%% Ouput

figure(1);
histfit(original);
title('Distribution of tree''s age (1st observing year)');
xlabel('Age');
ylabel('Frequency');
legend('Histogram of Frequency', 'Distribution fit');

figure(2);
histfit(d);
title(['Distribution of tree''s age (',...
      mat2str(observing_duration), 'th observing year)']);
xlabel('Age');
ylabel('Frequency');
legend('Histogram of Frequency', 'Distribution fit');

figure(3);
plot(cds_hist, 'r');
hold on, scatter(1:observing_duration, cds_without_logging_hist, 'g.'), hold off;
title('Annual Carbon Dioxide Sequestration');
xlabel('Observing year');
ylabel('CDS (pounds)');
legend('With logging', 'Without logging');

fprintf('The CDS in the %dth observing year is %.10f.\n',...
        observing_duration, total_cds(end));