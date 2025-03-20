
clc;
clear;
close all;
% Load the CSV file (clck signal)
 data1 = readmatrix('FET_in32bps.csv');
time0 = data1(:,1);
 fet_in = data1(:,2);
 % Load the CSV file (Tx signal)
 data = readmatrix('Tx_in.csv');
time1 = data(:,1);
 Tx_in = data(:,2);
 % fet_in = fet_in / max(abs(fet_in)); % Normalize
  % received_signal = data1(:,3);
 % received_signal = received_signal / max(abs(received_signal));
% interference_signal = data1(:,4);
 % interference_signal = interference_signal / max(abs(interference_signal));
fc = 900e6;
phase_shift = 2*pi/3;
% Load the CSV file (noisy AM signal)
data = readmatrix("combined_co_simulation_TxRxUA32bpsLMS.csv"); % Skip the first row (headers) 
time = data(:,1);                  % Time in seconds
 received_signal = data(:,2);        % Received signal (AM + interference)
 interference_signal = data(:,3);
% Load the CSV file (Interference signal)
% data1 = readmatrix('combined_co_simulation_TxRxPCB_SIC.csv');
% time1 = data1(:,3);
% interference_signal = data1(:,4);  % Reference interference signal from Tx
% Generate interference
 % v1 = (225*sin(2*pi*fc*time + phase_shift));
 %Generate noisy signal
 % x = fet_in + v1;
 %Generate reference signal
 % v2 = 0.5*sin(2*pi*fc*time0 + 2*pi/3);
% %create a uniform time-step
% fixed_dt = 20e-9; % Fixed time step size (0.05 ns)
% time_uniform = min(time):fixed_dt:max(time); % Create a uniform time vector
% % Interpolating the signal
% received_signal_uniform = interp1(time, received_signal, time_uniform, 'linear'); % Linear interpolation
% interference_signal_uniform = interp1(time, interference_signal, time_uniform, 'linear'); % Linear interpolation
% Normalize and remove DC offset from the received signal
% received_signal= received_signal- mean(received_signal); % Remove DC offset
% received_signal = received_signal / max(abs(received_signal)); % Normalize
% Normalize and remove DC offset from the interference signal 
% interference_signal = interference_signal - mean(interference_signal);
% interference_signal = interference_signal / max(abs(interference_signal));
% LMS Filter Setup
L = 1; % Filter order
 mu = 0.0000001; % Step size mu = 5.0379e-04
%Generate LMS filter
          lmsFilter = dsp.LMSFilter('Length', L, 'StepSize', mu);
       % lms= dsp.LMSFilter('Length', L );
         % lms = dsp.LMSFilter(L,'Method','LMS');
% Choose the Step Size
        % [mumaxlms,mumaxmselms] = maxstep(lms,received_signal) % choose step size
% Set the Adapting Filter Step Size
      % lms.StepSize  = mumaxmselms/30   
% Apply LMS filter
         % [~,elms,wlms] = lms(interference_signal,received_signal);  
          % elms =elms / max(abs(elms));
           [filter_out,err] = lmsFilter(interference_signal, received_signal);
% Estimate the autocorrelation of the interference signal
 % R = xcorr(interference_signal, L, 'unbiased');
 % R = R(L+1:end);              % Take only positive lags for autocorrelation matrix
 % R = xcorr(v2, L-1, 'unbiased');
 % R = toeplitz(R(L:end)); 

 % Estimate the cross-correlation between the interference and received
 % signal     
 % p = xcorr(received_signal, interference_signal,L, 'unbiased');
 % p = p(L+1:end);              % Take positive lags for cross-correlation vector
 % p = xcorr(x, v2,L-1, 'unbiased');
 % p = p(L:end); 

 % Step 3: Calculate Wiener filter coefficients
% wiener_coefficients = R\p;          % Solves for optimal filter coefficients
% Display the Wiener filter coefficients
% disp('Optimum Wiener filter coefficients:');
 % disp(wiener_coefficients);
% % Step 4: Apply Wiener filter to cancel interference
 % filter_output = filter(wiener_coefficients, 1, interference_signal);
 % yw = filter_output();
%  compute the optimal FIR Wiener filter.
% bw = firwiener(L-1,interference_signal,received_signal); % Optimal FIR Wiener filter
% MAfilt = dsp.FIRFilter('Numerator',bw);
% yw = MAfilt(interference_signal); % Estimate of x using Wiener filter
% ew = received_signal- yw; % Estimate of desired signal
 % ew =ew / max(abs(ew));
% Step 5: Subtract estimated interference from the received signal
 % error_signal = x - filteredSignal;
% final_output =final_output / max(abs(final_outp)
 % n = (1:1e04)';
 %  Compute Auto-correlation and Cross-correlation
Rax = xcorr(interference_signal, interference_signal, 'biased'); % Auto-correlation of reference
pxx = xcorr(interference_signal, received_signal, 'biased');     % Cross-correlation between reference and noisy

% Step 3: Define Filter Parameters
 midPoint = length(interference_signal); % Midpoint for symmetric correlations

% Extract necessary sections for the filter
RaxMatrix = toeplitz(Rax(midPoint:midPoint+L-1));
pxxVector = pxx(midPoint:midPoint+L-1);

% Step 4: Compute Wiener Filter Coefficients
wienerCoefficients = RaxMatrix\pxxVector; % Solve for Wiener filter coefficients

% Step 5: Apply Wiener Filter to Estimate Noise
filteredSignal = filter(wienerCoefficients, 1, interference_signal);

% Step 6: Recover Desired Signal (Error Signal)
ew = received_signal - filteredSignal;
% Plot Results
figure;
% subplot(4,1,1); 
% plot(time1, Tx_in); 
% title('Tx. Antenna. Input');
% xlabel('(a)');
% ylabel('Amplitude (V)');
%  % xlim([65 250])
%    ylim([-70 70])
subplot(3,1,1); 
plot(time0, fet_in*1e-3); 
title('FET (HT) Input');
xlabel('  Time (ns)');
ylabel(' (V)');
   xlim([230 780])
  % ylim([-2 2])
 subplot(3,1,2); 
plot(time, received_signal); 
title('Noisy signal (Rx. Antenna output)');  
xlabel(' Time (ns)');
ylabel(' (mV)');
     xlim([230 780])
%      % ylim([-250 250])
subplot(3,1,3);  
  % plot(time,(received_signal-interference_signal));
   plot(time, ew);
title('Filtered signal (AM signal)');
xlabel('Time (ns)');
ylabel(' (mV)');
  xlim([230 780])
  % ylim([-0.5 0.5])
 %export ploted data
% h = findobj(gca, 'Type', 'line'); % Finds all line objects in the figure
% % Extract data from the plot
% x_data = get(h, 'XData'); % Get X data
% y_data = get(h, 'YData'); % Get Y data
% 
% % Combine data into a matrix
% data = [x_data(:), y_data(:)]; % Combine as two columns (X, Y)
% 
% % Save data to CSV
% writematrix(data, 'D:\matlab\LMS_filter\plot_data.csv'); % Save as CSV file
% disp('Data has been exported to plot_data.csv');
% 
% % Assume 'time' and 'err' are the variables plotted
% time_ns = time; % Ensure 'time' is in nanoseconds as the label suggests
% err_mv = ew;   % Ensure 'err' is in millivolts as the label suggests
% 
% % Combine the data into a table
% data = table(time_ns(:), err_mv(:), 'VariableNames', {'Time_ns', 'Err_mV'});
% 
% % Export the table to a CSV file
% writetable(data, 'D:\matlab\LMS_filter\FilteredSignalData.csv');
% 
% % Display a message
% disp('Data has been exported to FilteredSignalData.csv');
