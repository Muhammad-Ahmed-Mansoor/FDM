%function saveaudio
%Inputs:---------------------------
%   save_path (string) -the path for storing signals
%   namefolder (string) -the name of the new folder created
%   samplefreq (float)  -the sampling frequency
%   arra(array) -the first signal to store
%   varargin (array/s (expected)) -any number of additional arrays to store
%Returns:--------------------------
%   y (array) -the filtered signal
%
%Additional Notes:-------------------
%   Example usage: save_audio('C:\','faisal',freqsamp,w,x,y,z) 
%creates a folder 'faisal' with files "faisal1.wav,faisal2.wav,faisal3.wav and faisal4.wav"
%in it
function save_audio(save_path,namefolder,samplefreq,arra,varargin) 


curr_dir=cd;       %saving address of parent folder for future use

if ~isempty(save_path)
    cd(save_path)
end

mkdir(namefolder); %creating a folder of specified name
cd(namefolder);    %changing path to folder just created

if nargin==4
    ext = '.wav'; %for making replicas of filenames
else
    ext = sprintf('%d.wav', 1); %for making replicas of filenames
end
s = strcat(namefolder,ext); %concatenating strings
audiowrite(s,arra,samplefreq); %saving audio file for mandatory argument
    
for k=1:(nargin-4) %saving optional files upto many
    ext = sprintf('%d.wav', k+1); %same procedure as adopted above
    s = strcat(namefolder,ext);
    audiowrite(s,varargin{k},samplefreq); 
end

cd(curr_dir) %changing path to parent folder from which function was called
%function end
end
