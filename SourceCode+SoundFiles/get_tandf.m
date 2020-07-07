%function get_tandf
%Inputs:---------------------------
%   a (array) -the signal corresponding to which time and frequency domains
%               will be generated
%   fs (float) -the sampling frequency of a
%Returns:--------------------------
%   t (array) -the time domain/axis
%   f (array) -the frequency domain/axis
%Additional Notes:-------------------
%   This function produces the t and f vectors from a.
function [t,f] = get_tandf(a,fs)


N  = length(a);                % Column Length of  given signal

Ts = 1/fs;                     % Sampling time

t_end=N*Ts;                    % Time length of signal

t = 0:Ts:t_end-Ts;                % Time Vector

f = (t-t(end)/2) * fs/t(end);   %frequency vector
%function end
end

