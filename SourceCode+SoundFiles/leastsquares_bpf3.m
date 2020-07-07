function Hd = leastsquares_bpf3
%LEASTSQUARES_BPF3 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the Signal Processing Toolbox 7.0.
% Generated on: 22-May-2020 23:18:45

% FIR least-squares Bandpass filter designed using the FIRLS function.

% All frequency values are in Hz.
Fs = 48000;  % Sampling Frequency

N      = 100;    % Order
Fstop1 = 12000;  % First Stopband Frequency
Fpass1 = 12100;  % First Passband Frequency
Fpass2 = 18000;  % Second Passband Frequency
Fstop2 = 18100;  % Second Stopband Frequency
Wstop1 = 1;      % First Stopband Weight
Wpass  = 1;      % Passband Weight
Wstop2 = 1;      % Second Stopband Weight

% Calculate the coefficients using the FIRLS function.
b  = firls(N, [0 Fstop1 Fpass1 Fpass2 Fstop2 Fs/2]/(Fs/2), [0 0 1 1 0 ...
           0], [Wstop1 Wpass Wstop2]);
Hd = dfilt.dffir(b);

% [EOF]
