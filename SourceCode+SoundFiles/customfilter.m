%function customfilter
%Inputs:---------------------------
%   x (array) -the signal to filter
%   technology (string) -the technology of filter butterworth, elliptic,
%                           least-squares or window
%   type (string)  -the type of filter bandpass or lowpass
%   varargin (int (expected)) -the center frequency (1=3khz, 2=9khz, 3=15kHz,
%                               4=21kHz) if type is bandpass
%Returns:--------------------------
%   y (array) -the filtered signal
%
%Additional Notes:-------------------
%   This function uses filter models created using the FDA toolbox. The
%   required filter function files must be present in the same directory as
%   this function's .m file. This function simply provides an interface to
%   easily access all the filters from one convenient place


function [y]=customfilter(x,technology,type,varargin) 


switch technology    %switch case on the basis of technology of filters
    
    case 'butterworth' %case of real filter butterworth--------------------------------------------------------
        switch type  % switch case on the basis of types of filters - lowpass or bandpass
            case 'lowpass' %case of lowpass filter of 3 kHz
                a0 = butterworth_lpf;  % calls the specific filter function
                y = filter(a0,x);  %filter function that filters based on filter and data input
             
            case 'bandpass' %case of bandpass filters
                
                    switch (varargin{1}) % switch case on the basis of bandwidth of bandpass filters
                       case 1  % for 3 kHz
                               a1 = butterworth_bpf1;
                               y = filter(a1,x);
                       case 2  % for 9 kHz
                               a2 = butterworth_bpf2;
                               y = filter(a2,x);
                       case 3  % for 15 kHz  
                               a3 = butterworth_bpf3;
                               y = filter(a3,x);
                       case 4  % for 21 kHz 
                               a4 = butterworth_bpf4;
                               y = filter(a4,x);
                 
                    end  %end of switchcase varargin
        end %end of switchcase of type of filters
        
    case 'elliptic' %case of real filter elliptic-------------------------------------------------------
        
         switch type % switch case on the basis of types of filters - lowpass or bandpass
            case 'lowpass' %case of lowpass filter of 3 kHz
                b0 = elliptic_lpf; % calls the specific filter function
                y = filter(b0,x); %filter function that filters based on filter and data input
             
            case 'bandpass' %case of bandpass filters
                
                    switch (varargin{1}) % switch case on the basis of bandwidth of bandpass filters
                       case 1 % for 3 kHz
                               b1 = elliptic_bpf1;
                               y = filter(b1,x);  
                       case 2 % for 9 kHz 
                               b2 = elliptic_bpf2;
                               y = filter(b2,x);
                       case 3 % for 15 kHz  
                               b3 = elliptic_bpf3;
                               y = filter(b3,x);
                       case 4  % for 21 kHz
                               b4 = elliptic_bpf4;
                               y = filter(b4,x);
                 
                    end %end of switchcase varargin
         end %end of switchcase of type of filters
        

    case 'leastsquares' %case of real filter leastsquares-----------------------------------------------------
        
         switch type % switch case on the basis of types of filters - lowpass or bandpass
            case 'lowpass' %case of lowpass filter of 3 kHz
                c0 = leastsquares_lpf; % calls the specific filter function
                y = filter(c0,x); %filter function that filters based on filter and data input
             
            case 'bandpass' %case of bandpass filters
                
                    switch (varargin{1})  % switch case on the basis of bandwidth of bandpass filters
                       case 1  % for 3 kHz
                               c1 = leastsquares_bpf1;
                               y = filter(c1,x);
                       case 2  % for 9 kHz
                               c2 = leastsquares_bpf2;
                               y = filter(c2,x);
                       case 3  % for 15 kHz  
                               c3 = leastsquares_bpf3;
                               y = filter(c3,x);
                       case 4  % for 21 kHz
                               c4 = leastsquares_bpf4;
                               y = filter(c4,x);
                 
                    end %end of switchcase varargin
         end %end of switchcase of type of filters

        
      case 'window' %case of real filter window--------------------------------------------------------
        
         switch type % switch case on the basis of types of filters - lowpass or bandpass
            case 'lowpass' %case of lowpass filter of 3 kHz
                d0 = window_lpf; % calls the specific filter function
                y = filter(d0,x); %filter function that filters based on filter and data input
             
            case 'bandpass' %case of bandpass filters
                
                    switch (varargin{1})  % switch case on the basis of bandwidth of bandpass filters
                       case 1  % for 3 kHz
                               d1 = window_bpf1;
                               y = filter(d1,x);
                       case 2  % for 9 kHz
                               d2 = window_bpf2;
                               y = filter(d2,x);
                       case 3  % for 15 kHz  
                               d3 = window_bpf3;
                               y = filter(d3,x);
                       case 4  % for 21 kHz
                               d4 = window_bpf4;
                               y = filter(d4,x);
                 
                    end %end of switchcase varargin
         end %end of switchcase of type of filters


end  %end of switchcase of technology of filters
end %end of function