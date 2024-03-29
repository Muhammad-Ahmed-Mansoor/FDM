function Hd = elliptic_bpf3
%ELLIPTIC_BPF3 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the Signal Processing Toolbox 7.0.
% Generated on: 21-May-2020 21:15:57

% Elliptic Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 48000;  % Sampling Frequency

Fstop1 = 12001;   % First Stopband Frequency
Fpass1 = 12100;   % First Passband Frequency
Fpass2 = 18000;   % Second Passband Frequency
Fstop2 = 18100;   % Second Stopband Frequency
Astop1 = 100;     % First Stopband Attenuation (dB)
Apass  = 1;       % Passband Ripple (dB)
Astop2 = 100;     % Second Stopband Attenuation (dB)
match  = 'both';  % Band to match exactly

% Construct an FDESIGN object and call its ELLIP method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'ellip', 'MatchExactly', match);

% [EOF]
