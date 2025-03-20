clc;
clear;
close all;

% Load the CSV file (clock signal)
data1 = readmatrix("100Hz_clock.csv");
time0 = data1(:,1);
fet_in = data1(:,2);

% Load the CSV file (Tx signal)
data = readmatrix("Tx_in.csv");
time1 = data(:,1);
Tx_in = data(:,2);

% Load the CSV file (noisy AM signal)
data = readmatrix("3.18.0.csv");  
time = data(:,1);  % Time in seconds
received_signal = data(:,2);  % Received signal (AM + interference)
interference_signal = data(:,3); % Interference signal

% Clock period and delay steps
T_clock = 0.01; % Clock period (s)
delay_steps = 100; % Increased to 100 steps
dt = T_clock / delay_steps; % Delay step size

% Extend interference signal by one clock period
samples_per_T = round(T_clock / (time(2) - time(1)));
extended_interference = [interference_signal; interference_signal(1:samples_per_T)];

time_extended = [time; time(end) + (1:samples_per_T)' * (time(2) - time(1))];

% LMS Filter Setup
L = 5; % Increased filter order
mu = 0.00001; % Increased step size
lmsFilter = dsp.LMSFilter('Length', L, 'StepSize', mu);

% Initialize results storage
filter_outputs = zeros(length(interference_signal), delay_steps);
errors = zeros(length(interference_signal), delay_steps);

% Apply LMS filter with incremental delays
for i = 1:delay_steps
    delay_time = dt * i;
    delayed_signal = interp1(time_extended, extended_interference, time + delay_time, 'linear', 'extrap');
    delayed_signal(isnan(delayed_signal)) = 0; % Handle NaN values
    
    [filter_out, err] = lmsFilter(delayed_signal, received_signal);
    filter_outputs(:, i) = filter_out;
    errors(:, i) = err;
end

% Plot Results (Divided into multiple figures for clarity)
num_plots_per_figure = 20; % Number of subplots per figure
num_figures = ceil(delay_steps / num_plots_per_figure);

for fig_idx = 1:num_figures
    figure;
    start_idx = (fig_idx - 1) * num_plots_per_figure + 1;
    end_idx = min(start_idx + num_plots_per_figure - 1, delay_steps);
    
    for i = start_idx:end_idx
        subplot(5, 4, i - start_idx + 1);
        plot(time, filter_outputs(:, i));
        title(sprintf('Filtered Output (Delay = %.5f s)', dt * i));
        xlabel('Time (s)');
        ylabel('(mV)');
        xlim([0 0.04]);
    end
end
