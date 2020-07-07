%function custommodulate
%Inputs:---------------------------
%   x (array) -input signal;
%   time (array) -the time domain to which x is mapped
%   fm (float)  -the modulation frequency in Hz
%Outputs:--------------------------
%   x_mod (array) -the modulated signal
%Notes:----------------------------
%   This function modulates the input signal with a carrier signal of
%   frequency fm. The time array is expected as an input. The prefix
%   'custom' is to avoid clash with the built-in modulate function in
%   MATLAB
function x_mod = custommodulate(x,time,fm)

%creating the carrier signal
carrier_signal = cos(2*pi*fm*time);

%modulating the signal
x_mod = x.*carrier_signal;

%function end
end
